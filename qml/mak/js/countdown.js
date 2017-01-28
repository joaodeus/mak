.pragma library

function convertMinSecToSec(minutes, seconds) {
    return parseInt(minutes,10) * 60 + parseInt(seconds,10);
}

function convertSecToMinSec(total_seconds, position) {
    //position: value to be returned (1=minutes;0=seconds)
    if (position == 1) {
        return Math.floor(total_seconds/60);
    } else {
        return total_seconds % 60;
    }
}

function convertRadiansToDegrees(x) {
    return x * 180/Math.PI;
}

function getAngle(x_origin, y_origin, x_click, y_click) {
    var x;
    var y;
    x = Math.abs(x_click - x_origin);
    y = Math.abs(y_click - y_origin);
    if ((x_click >= x_origin) && (y_click <= y_origin)) {
        return convertRadiansToDegrees(Math.atan(x/y));
    } else if ((x_click >= x_origin) && (y_click >= y_origin)) {
        return convertRadiansToDegrees(Math.PI/2 + Math.atan(y/x));
    } else if ((x_click <= x_origin) && (y_click >= y_origin)) {
        return convertRadiansToDegrees(Math.PI + Math.atan(x/y));
    } else if ((x_click <= x_origin) && (y_click <= y_origin)) {
        return convertRadiansToDegrees(Math.PI*3/2 + Math.atan(y/x));
    }
}

function getMinutesFromAngle(angle) { //angle in degrees
    return Math.floor(angle/6);
}

function getSecondsFromAngle(angle) { //angle in degrees
    return Math.floor(angle%6 * 10);
}

function getMinutesAngleFromTime(minutes, seconds) {
    if (seconds > 0) minutes++;
    return minutes * 6;// + seconds/10;
}

function getSecondsAngleFromTime(seconds) {
    return seconds * 6;
}
