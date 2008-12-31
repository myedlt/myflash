/*
   worldKitUtil defines global static functions and new instance methods on core actionscript classes

   worldkitUtil.setTimeout: similar to setInterval, but only runs onces
   worldkitUtil.parseDate: given a date String, returns a Date object
   worldkitUtil.dateToString: given a Date object, returns a date String
   worldkitUtil.trimWhite: trim whitepspace from a string
   worldkitUtil.myreplace: replace within a string

   MovieClip.drawArc:

 */

import com.brainoff.RegExp;
import com.brainoff.W3CDateTime;

class com.brainoff.worldkitUtil {
    static private var month2num:Object;
    static private var regex1:RegExp;
    static private var regex2:RegExp;
    static private var tzregex:RegExp;

    public function worldkitUtil() {}

    static public function setTimeout(a,b,c, args){
        // for a basic function call:
        var ID;
        if (typeof arguments[0] == "function"){
            args = arguments.slice(2);
            var func = function(){
                a.apply(null, args);
                clearInterval(ID);
            }
            ID = setInterval(func, b, args);

            // for an object method call:
        }else{
            args = arguments.slice(3);
            var func = function(){
                a[b].apply(a, args);
                clearInterval(ID);
            }
            ID = setInterval(func, c, args);
        }
        return ID;
    }
    static public function clearTimeout(id:Number) {
        clearInterval(id);
    }

    static public function parseDate(dt:String):Number {
        var t;
        if (dt == undefined) { 
            //t = new Date(); 
            //t = Date(Date.UTC(t.getFullYear(), t.getMonth(), t.getDate(), t.getHours(), t.getMinutes(), t.getSeconds()));
            return Date.UTC();
        }

        var s = new String(dt);
        var m = s.match(regex1);
        if (m[7] == undefined) {
            var w:W3CDateTime = new W3CDateTime(s);
            t = w.getTime();
            //m = s.match(regex2);
            //t = Date.UTC(Number(m[1]),Number(m[2])-1,Number(m[3]),Number(m[4]),Number(m[5]),Number(m[6])) + worldkitUtil.tzFromString(m[7]);

        } else {
            t = Date.UTC(Number(m[3]),month2num[ m[2] ],Number(m[1]),Number(m[4]),Number(m[5]),Number(m[6])) + worldkitUtil.tzFromString(m[7]);
        }
        return t;
    }

    static private function tzFromString(tzs:String):Number {
        var s = new String(tzs);
        var tz = s.match(tzregex);
        var offset = 0;
        if (tz[3] != undefined) {
            offset = tz[3] * 60000;
        }
        if (tz[2] != undefined) {
            offset += tz[2] * 3600000;
        }
        if (tz[1] == "+") {
            offset = 0 - offset;
        }
        return offset;
    }
    static public function dateToString(dt:Date):String {
        var m = dt.getMonth() + 1; if (m < 10) { m = "0" + m; };
        var d = dt.getDate(); if (d < 10) { d = "0" + d; };
        var h = dt.getHours(); if (h < 10) { h = "0" + h; };
        var mi = dt.getMinutes(); if (mi < 10) { mi = "0" + mi; };
        var s = dt.getSeconds(); if (s < 10) { s = "0" + s; };
        return (dt.getFullYear()) + "-" + m + "-" + d + "T" + h + ":" + mi + ":" + s;
    }


    static public function trimWhite(s:String):String {
        for (var i = 0; i < s.length; i++) {
            if (s.charCodeAt (i) > 32) {
                s = s.substr (i, s.length);
                break;
            }
        }

        for (var i = s.length; i > 0; i--) {
            if (s.charCodeAt (i) > 32) {
                s = s.substring (0, i + 1);
                break;
            } 
        } 
        return s;
    }
    static public function myreplace(s:String,o:String,n:String):String {
        var tmp = s.split(o);
        return tmp.join(n);
    }

    static public function setUp() {
        /*
           initialize static variables
         */
        month2num = new Object();
        month2num["Jan"] = 0;
        month2num["Feb"] = 1;
        month2num["Mar"] = 2;
        month2num["Apr"] = 3;
        month2num["May"] = 4;
        month2num["Jun"] = 5;
        month2num["Jul"] = 6;
        month2num["Aug"] = 7;
        month2num["Sep"] = 8;
        month2num["Oct"] = 9;
        month2num["Nov"] = 10;
        month2num["Dec"] = 11;
        regex1 = new RegExp("(\\d+)\\s+(\\w+)\\s+(\\d+)\\s+(\\d+):(\\d+):(\\d+)\\s+(.+)","" );
        regex2 = new RegExp("(\\d+)-(\\d+)-(\\d+)T(\\d+):(\\d+):(\\d+)(.+)","");
        tzregex = new RegExp("(.)(\\d+)(\\d+)","");

        /*-------------------------------------------------------------
          mc.drawArc is a method for drawing regular and eliptical 
          arc segments. This method replaces one I originally 
          released to the Flash MX beta group titled arcTo and contains
          several optimizations based on input from the following 
          people: Robert Penner, Eric Mueller and Michael Hurwicz.
          -------------------------------------------------------------*/
        MovieClip.prototype.drawArc = function(x, y, radius, arc, startAngle, yRadius) {
            // ==============
            // mc.drawArc() - by Ric Ewing (ric@formequalsfunction.com) - version 1.5 - 4.7.2002
            // 
            // x, y = This must be the current pen position... other values will look bad
            // radius = radius of Arc. If [optional] yRadius is defined, then r is the x radius
            // arc = sweep of the arc. Negative values draw clockwise.
            // startAngle = starting angle in degrees.
            // yRadius = [optional] y radius of arc. Thanks to Robert Penner for the idea.
            // ==============
            // Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
            // ==============
            if (arguments.length<5) {
                return;
            }
            // if yRadius is undefined, yRadius = radius
            if (yRadius == undefined) {
                yRadius = radius;
            }
            // Init vars
            var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
            // no sense in drawing more than is needed :)
            if (Math.abs(arc)>360) {
                arc = 360;
            }
            // Flash uses 8 segments per circle, to match that, we draw in a maximum
            // of 45 degree segments. First we calculate how many segments are needed
            // for our arc.
            segs = Math.ceil(Math.abs(arc)/45);
            // Now calculate the sweep of each segment
            segAngle = arc/segs;
            // The math requires radians rather than degrees. To convert from degrees
            // use the formula (degrees/180)*Math.PI to get radians. 
            theta = -(segAngle/180)*Math.PI;
            // convert angle startAngle to radians
            angle = -(startAngle/180)*Math.PI;
            // find our starting points (ax,ay) relative to the secified x,y
            ax = x-Math.cos(angle)*radius;
            ay = y-Math.sin(angle)*yRadius;
            // if our arc is larger than 45 degrees, draw as 45 degree segments
            // so that we match Flash's native circle routines.
            if (segs>0) {
                // Loop for drawing arc segments
                for (var i = 0; i<segs; i++) {
                    // increment our angle
                    angle += theta;
                    // find the angle halfway between the last angle and the new
                    angleMid = angle-(theta/2);
                    // calculate our end point
                    bx = ax+Math.cos(angle)*radius;
                    by = ay+Math.sin(angle)*yRadius;
                    // calculate our control point
                    cx = ax+Math.cos(angleMid)*(radius/Math.cos(theta/2));
                    cy = ay+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
                    // draw the arc segment
                    this.curveTo(cx, cy, bx, by);
                }
            }
            // In the native draw methods the user must specify the end point
            // which means that they always know where they are ending at, but
            // here the endpoint is unknown unless the user calculates it on their 
            // own. Lets be nice and let save them the hassle by passing it back. 
            return {x:bx, y:by};
        };
    }
}
