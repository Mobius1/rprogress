// ease-in
const easeInQuad = (t, b, c, d) =>
    c * (t /= d) * t + b;

const easeInCubic = (t, b, c, d) =>
    c * (t /= d) * t * t + b;

const easeInQuart = (t, b, c, d) =>
    c * (t /= d) * t * t * t + b;

const easeInQuint = (t, b, c, d) =>
    c * (t /= d) * t * t * t * t + b;

const easeInSine = (t, b, c, d) =>
    -c * Math.cos(t / d * (Math.PI / 2)) + c + b;

const easeInExpo = (t, b, c, d) =>
    t == 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;

const easeInCirc = (t, b, c, d) =>
    -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;

const easeInElastic = (t, b, c, d) => {
    var s = 1.70158;
    var p = 0;
    var a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    if (!p) p = d * .3;
    if (a < Math.abs(c)) {
        a = c;
        var s = p / 4;
    } else var s = p / (2 * Math.PI) * Math.asin(c / a);
    return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
};

const easeInBack = (t, b, c, d, s) => {
    if (s == undefined) s = 1.70158;
    return c * (t /= d) * t * ((s + 1) * t - s) + b;
};


// ease-out

const easeOutQuad = (t, b, c, d) =>
    -c * (t /= d) * (t - 2) + b;

const easeOutCubic = (t, b, c, d) =>
    c * ((t = t / d - 1) * t * t + 1) + b;

const easeOutQuart = (t, b, c, d) =>
    -c * ((t = t / d - 1) * t * t * t - 1) + b;

const easeOutQuint = (t, b, c, d) =>
    c * ((t = t / d - 1) * t * t * t * t + 1) + b;

const easeOutSine = (t, b, c, d) =>
    c * Math.sin(t / d * (Math.PI / 2)) + b;

const easeOutExpo = (t, b, c, d) =>
    t == d ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;

const easeOutCirc = (t, b, c, d) =>
    c * Math.sqrt(1 - (t = t / d - 1) * t) + b;

const easeOutElastic = (t, b, c, d) => {
    var s = 1.70158;
    var p = 0;
    var a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    if (!p) p = d * .3;
    if (a < Math.abs(c)) {
        a = c;
        var s = p / 4;
    } else var s = p / (2 * Math.PI) * Math.asin(c / a);
    return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
};

const easeOutBack = (t, b, c, d, s) => {
    if (s == undefined) s = 1.70158;
    return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
};

const easeOutBounce = (t, b, c, d) => {
    if ((t /= d) < (1 / 2.75)) {
        return c * (7.5625 * t * t) + b;
    } else if (t < (2 / 2.75)) {
        return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
    } else if (t < (2.5 / 2.75)) {
        return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
    } else {
        return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
    }
};


// ease-in-out
const easeInOutQuad = (t, b, c, d) => {
    if ((t /= d / 2) < 1) return c / 2 * t * t + b;
    return -c / 2 * ((--t) * (t - 2) - 1) + b;
};

const easeInOutCubic = (t, b, c, d) => {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
    return c / 2 * ((t -= 2) * t * t + 2) + b;
};

const easeInOutQuart = (t, b, c, d) => {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
    return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
};

const easeInOutQuint = (t, b, c, d) => {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
    return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
};

const easeInOutSine = (t, b, c, d) =>
    -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;

const easeInOutExpo = (t, b, c, d) => {
    if (t == 0) return b;
    if (t == d) return b + c;
    if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
    return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
};

const easeInOutCirc = (t, b, c, d) => {
    if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
    return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
};

const easeInOutElastic = (t, b, c, d) => {
    var s = 1.70158;
    var p = 0;
    var a = c;
    if (t == 0) return b;
    if ((t /= d / 2) == 2) return b + c;
    if (!p) p = d * (.3 * 1.5);
    if (a < Math.abs(c)) {
        a = c;
        var s = p / 4;
    } else var s = p / (2 * Math.PI) * Math.asin(c / a);
    if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
};

const easeInOutBack = (t, b, c, d, s) => {
    if (s == undefined) s = 1.70158;
    if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
    return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
};