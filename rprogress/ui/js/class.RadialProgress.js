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
    constructor(r, s, min = 0, max = 360, bg = false, zone = false) {
        this.radius = r;
        this.stroke = s;
        this.minAngle = min;
        this.maxAngle = max;
        this.px = this.radius;
        this.py = this.radius;
        this.bg = bg;
        this.zone = zone;
        this.offset = 0;
        this.progress = 0;

        this.node = document.createElementNS(NS, "circle");

        this.render();
    }

    render() {
        this.setArc();

        this.node.setAttributeNS(null, "r", this.radius - (this.stroke / 2));
        this.node.setAttributeNS(null, "cx", this.px);
        this.node.setAttributeNS(null, "cy", this.py);
        this.node.setAttributeNS(null, "stroke-width", this.stroke);
    }

    setArc() {
        this.arc = 2 * Math.PI * (this.radius - (this.stroke / 2));
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

class RProgress {
    start(to, from, duration) {
        this.frame = false;

        if (from === undefined) {
            from = this.config.progress;
        }

        if (duration === undefined) {
            duration = 5000;
        }

        let st = Date.now();

        // Scroll function
        const animate = () => {
            let progress,
                now = Date.now(),
                ct = now - st;

            // Cancel after allotted interval
            if (ct > duration) {
                cancelAnimationFrame(this.frame);
                this.setProgress(to, false);
                this.config.onChange.call(this, 100, ct, duration);
                this.config.onComplete.call(this, to);
                return;
            }

            progress = easings[this.config.easing](ct, from, to - from, duration);

            this.setProgress(progress, false);

            this.config.onChange.call(this, progress, ct, duration);

            // requestAnimationFrame
            this.frame = requestAnimationFrame(animate);
        };

        this.config.onStart.call(this);
        animate();
    }	
	
    pause() {
        cancelAnimationFrame(this.frame);
    }

    stop() {
        cancelAnimationFrame(this.frame);
        this.remove();
    }	

    render(element) {
        if (!this.rendered) {
            element =
                typeof element === "string" ? document.querySelector(element) : element;

            element.appendChild(this.container);
			
            this.setPosition();

            this.rendered = true;
        }
    }

    remove() {
        const parent = this.container.parentNode;
        if (this.rendered && parent) {
            parent.removeChild(this.container);

            this.rendered = false;
        }
    }

    show() {
        this.container.classList.remove("done");
    }

    hide() {
        this.container.classList.add("done");
    }    
}

/**
* RadialProgress Class
*/
class RadialProgress extends RProgress {
    constructor(config) {
        super();


        const defaultConfig = {
            r: 50,
            s: 10,
            x: 0,
            y: 0,
            cap: "butt",
            padding: 0,
            progress: 0,
            minAngle: 0,
            maxAngle: 360,
            rotation: 0,
            color: "rgba(255, 255, 255, 1.0)",
            bgColor: "rgba(0, 0, 0, 0.4)",
            easing: "easeLinear",
            onStart: () => {},
            onChange: () => {},
            onComplete: () => {},
            onTimeout: () => {},
        };

        this.config = Object.assign({}, defaultConfig, config);

        this.init();

        return this;
    }

    init() {
        const arc = this.config.maxAngle - this.config.minAngle;

        this.config.padding *= 2;
				
        this.config.w = (this.config.r * 2) + this.config.padding;
        this.config.h = (this.config.r * 2) + this.config.padding;

        this.svg = new Svg(this.config.w, this.config.h);

        this.dials = {
            bg: new Circle(
                this.config.r + (this.config.padding / 2),
                this.config.s + this.config.padding,
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

        if ( this.config.zone ) {
            this.zoneArc = (this.config.zone / 100) * arc;
            this.zonePos = getRandomInt(0, arc - this.zoneArc);

            const startPos = (this.zonePos / arc) * 100;
            this.zoneMin = startPos;
            this.zoneMax = startPos + this.config.zone;

            this.dials.zone = new Circle(
                this.config.r,
                this.config.s,
                0,
                this.zoneArc,
                true
            )
        }        

        this.svg.getNode().appendChild(this.dials.bg.getNode());
        this.svg.getNode().appendChild(this.dials.fg.getNode());

        if ( this.dials.zone ) {

            this.svg.getNode().appendChild(this.dials.zone.getNode());
            this.dials.zone.getNode().setAttributeNS(null, "stroke", "rgba(51, 105, 30, 1)"); 

            this.dials.zone.getNode().style.transform = `rotate(${
                this.zonePos
            }deg)`;

            this.dials.zone.getNode().style.transformOrigin = `50% 50% 0`;
        }


        const fgNode = this.dials.fg.getNode();
        fgNode.setAttributeNS(null, "cx", (this.config.w / 2));
        fgNode.setAttributeNS(null, "cy", (this.config.h / 2));
        fgNode.setAttributeNS(null, "stroke-linecap", this.config.cap);
        fgNode.setAttributeNS(null, "stroke", this.config.color);   
         
        this.dials.bg.getNode().setAttributeNS(null, "stroke", this.config.bgColor);


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

        const size = (this.config.r * 2);

        this.container.style.width = `${(this.config.r * 2) + this.config.padding}px`;
        this.container.style.height = `${(this.config.r * 2) + this.config.padding}px`;
        this.container.style.left = `${
            (this.config.x * window.innerWidth) - (size / 2) - (this.config.padding / 2)
        }px`;
        this.container.style.top = `${
            (this.config.y * window.innerHeight) - (size / 2) - (this.config.padding / 2)
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

        this.progress = progress;

        if (e === undefined) {
            this.config.onChange.call(this, progress);
        }
    }
}

class LinearProgress extends RProgress {
    constructor(config) {
        super();
		
        const defaultConfig = {
            w: 300,
            h: 10,
            s: 10,
            x: 0,
            y: 0,
            cap: "butt",
            padding: 0,
            progress: 0,
            color: "rgba(255, 255, 255, 1.0)",
            bgColor: "rgba(0, 0, 0, 0.4)",
            easing: "easeLinear",
            onStart: () => {},
            onChange: () => {},
            onComplete: () => {}
        };

        this.config = Object.assign({}, defaultConfig, config);
        this.progress = 0;

        this.init();

        return this;
    }

    init() {
        this.container = document.createElement("div");
        this.container.classList.add("linear-progress");

        this.bg = document.createElement("div");
        this.fg = document.createElement("div");
		
        this.bg.classList.add("linear-progress-bg");
        this.fg.classList.add("linear-progress-fg");

        this.label = document.createElement("div");
        this.label.classList.add("linear-progress-label");
		
        this.container.appendChild(this.bg);
        this.container.appendChild(this.fg);
        this.container.appendChild(this.label);
    }
	
    setPosition() {
        let contCss = `width:${this.config.w}px;height:${this.config.h}px;left:${this.config.x * window.innerWidth - this.config.w / 2}px;top:${this.config.y * window.innerHeight - this.config.h / 2}px;`;
        let bgCss = `background-color:${this.config.bgColor};padding:${this.config.padding}px;left:${-this.config.padding}px;top:${-this.config.padding}px;`;
		
        this.container.style.cssText = contCss;
		
        this.fg.style.backgroundColor = this.config.color;
		
        if ( this.config.cap == 'round' ) {
            this.fg.style.borderRadius = `${this.config.h / 2}px`
            this.fg.style.transform = "scale(1, 1)";
			
            bgCss += `border-radius:${this.config.h / 2 + this.config.padding}px;`;
        } else {
            this.fg.style.width = "100%";
        }
		

        this.bg.style.cssText = bgCss;
    }
	
    setProgress(progress, e) {
        if (progress === undefined) {
            progress = this.config.progress;
        }
		
        const p = (progress / 100);
		
        if ( this.config.cap == 'round' ) {
            this.fg.style.width = `${progress}%`;
        } else {
            this.fg.style.transform = `scale(${p}, 1)`;
        }
		
        this.progress = progress;

        if (e === undefined) {
            this.config.onChange.call(this, progress);
        }
    }
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min);
}