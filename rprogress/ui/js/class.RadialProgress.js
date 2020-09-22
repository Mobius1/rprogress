const NS = "http://www.w3.org/2000/svg";

/**
* Svg Class
*/
class Svg {
    constructor(w, h) {
        this.width = w;
        this.height = h;

        this.node = document.createElementNS(NS, "svg");

        this.render();
    }

    render() {
        this.node.setAttributeNS(null, "width", this.width);
        this.node.setAttributeNS(null, "height", this.height);
    }

    getNode() {
        return this.node;
    }
}

/**
* Circle Class
*/
class Circle {
    constructor(r, s, min = 0, max = 360, bg = false) {
        this.radius = r;
        this.stroke = s;
        this.minAngle = min;
        this.maxAngle = max;
        this.px = this.radius;
        this.py = this.radius;
        this.bg = bg;
        this.offset = 0;
        this.progress = 0;

        this.node = document.createElementNS(NS, "circle");

        this.render();
    }

    render() {
        this.setArc();

        this.node.setAttributeNS(null, "r", this.radius);
        this.node.setAttributeNS(null, "cx", this.px + this.stroke * 0.5);
        this.node.setAttributeNS(null, "cy", this.py + this.stroke * 0.5);
        this.node.setAttributeNS(null, "stroke-width", this.stroke);
    }

    setArc() {
        this.arc = 2 * Math.PI * this.radius;
        this.gap = this.arc - this.arc * ((this.maxAngle - this.minAngle) / 360);

        this.node.setAttributeNS(
            null,
            "stroke-dasharray",
            this.bg ? `${this.arc - this.gap}, ${this.gap}` : this.arc
        );

        this.setProgress();
    }

    getNode() {
        return this.node;
    }

    setProgress(progress) {
        if (progress === undefined) {
            progress = this.progress;
        }

        let offset = this.arc - this.arc * progress;

        if (!this.bg) {
            offset = this.arc - (this.arc - this.gap) * progress;
        }

        this.node.setAttributeNS(null, "data-progress", progress);
        this.node.setAttributeNS(null, "stroke-dashoffset", offset);

        this.progress = progress;
        this.offset = offset;
    }
}

/**
* RadialProgress Class
*/
class RadialProgress {
    constructor(config) {
        const defaultConfig = {
            r: 50,
            s: 10,
            x: 0,
            y: 0,
            progress: 0,
            minAngle: 0,
            maxAngle: 360,
            rotation: 0,
            color: "rgba(255, 255, 255, 1.0)",
            bgColor: "rgba(0, 0, 0, 0.4)",
            onStart: () => {},
            onChange: () => {},
            onComplete: () => {}
        };

        this.config = Object.assign({}, defaultConfig, config);

        this.config.w = this.config.s + this.config.r * 2;
        this.config.h = this.config.s + this.config.r * 2;

        this.init();

        return this;
    }

    init() {
        this.svg = new Svg(this.config.w, this.config.h);

        this.dials = {
            bg: new Circle(
                this.config.r,
                this.config.s,
                this.config.minAngle,
                this.config.maxAngle,
                true
            ),
            fg: new Circle(
                this.config.r,
                this.config.s,
                this.config.minAngle,
                this.config.maxAngle
            )
        };

        this.svg.getNode().appendChild(this.dials.bg.getNode());
        this.svg.getNode().appendChild(this.dials.fg.getNode());

        this.dials.bg.getNode().setAttributeNS(null, "stroke", this.config.bgColor);
        this.dials.fg.getNode().setAttributeNS(null, "stroke", this.config.color);

        const container = document.createElement("div");
        container.classList.add("ui-dial");
			
        const indicator = document.createElement("div");
        indicator.classList.add("ui-indicator");
			
        const label = document.createElement("div");
        label.classList.add("ui-label");			

        this.setRotation(this.config.rotation);

        container.appendChild(this.svg.getNode());
        container.appendChild(indicator);
        container.appendChild(label);

        this.container = container;
        this.indicator = indicator;
        this.label = label;

        this.setPosition(this.config.x, this.config.y);
        this.setProgress();
    }

    setPosition(x, y) {
        this.config.x = x;
        this.config.y = y;

        const size = (this.config.r * 2) + this.config.s;
		
        this.container.style.width = `${size}px`;
        this.container.style.height = `${size}px`;
        this.container.style.left = `${
            (this.config.x * window.innerWidth) - (size / 2)
        }px`;
        this.container.style.top = `${
            (this.config.y * window.innerHeight) - (size / 2)
        }px`;
    }

    setEndAngle(angle) {
        this.config.maxAngle = angle;

        this.dials.bg.maxAngle = angle;
        this.dials.bg.setArc();

        this.dials.fg.maxAngle = angle;
        this.dials.fg.setArc();

        this.dials.bg.setProgress();
        this.dials.fg.setProgress();
    }

    setRotation(angle) {
        this.config.rotation = angle;
        this.svg.getNode().style.transform = `rotate(${
            this.config.rotation - 90
        }deg)`;
    }

    setProgress(progress, e) {
        if (progress === undefined) {
            progress = this.config.progress;
        }

        this.dials.fg.setProgress(progress / 100);

        if (e === undefined) {
            this.config.onChange.call(this, progress);
        }
    }

    render(element) {
        if ( !this.rendered ) {
            element =
                typeof element === "string" ? document.querySelector(element) : element;

            element.appendChild(this.container);

            this.rendered = true;
        }
    }

    remove() {
        const parent = this.container.parentNode;
        if ( this.rendered && parent ) {
            parent.removeChild(this.container);

            this.rendered = false;
        }
    }

    start(to, from, duration, easing) {
        if (from === undefined) {
            from = this.config.progress;
        }

        this.frame = false;

        // Duration of scroll
        if (duration === undefined) {
            duration = 5000;
        }

        var st = Date.now();

        // Scroll function
        var animate = () => {
            let progress, now = Date.now(),
                ct = now - st;

            // Cancel after allotted interval
            if (ct > duration) {
                cancelAnimationFrame(this.frame);
                this.setProgress(100, false);
                this.config.onChange.call(this, progress, duration, duration);
                this.config.onComplete.call(this);
                return;
            }

            if ( easing === undefined ) {
                progress = (ct / duration) * to;
            } else {
                progress = easing(ct, from, to - from, duration);
            }
			
            this.setProgress(progress, false);
			
            this.config.onChange.call(this, progress, ct, duration);

            // requestAnimationFrame
            this.frame = requestAnimationFrame(animate);
        };

        this.config.onStart.call(this);
        this.frame = animate();
    }

    stop() {
        cancelAnimationFrame(this.frame);
        this.remove();
    }
}