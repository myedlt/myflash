/*
   worldkitInteraction
   sets up interface elements, handles UI events, etc
   and manages most of worldKit's dynamic state after load (may be best to seperate into seperate class REVISIT)

 */

import com.brainoff.worldkitMain;
import com.brainoff.worldkitConfig;
import com.brainoff.worldkitImages;
import com.brainoff.worldkitGPX;
import com.brainoff.worldkitRSS;
import com.brainoff.worldkitUtil;
import flash.external.*;

class com.brainoff.worldkitInteraction {
    private var main:worldkitMain;
    private var conf:worldkitConfig;
    private var img:worldkitImages;
    private var rss:worldkitRSS;
    private var mc:MovieClip;

    private var zoompan:String; 
    private var acceptInput:Boolean;
    private var keylistener:Object;
    private var timenavplay:Boolean;

    var centery:Number;
    var centerx:Number;
    var initeastx:Number;
    var initwestx:Number;
    var initnorthy:Number;
    var initsouthy:Number;
    var ratio:Number;
    var scale:Number;
    var cnorth:Number;
    var cwest:Number;
    var csouth:Number;
    var ceast:Number;
    var ctop:Number;
    var cbottom:Number;
    var cleft:Number;
    var cright:Number;
    var maxtime:Date;


    static private var grabberdepth:Number = 20;
    static private var zoomboxdepth:Number = 19;
    static private var mouselayerdepth = 18;
    static private var toolbardepth = 10000;
    static private var timenavdepth = 10001;
    static private var dialogdepth = 10003;
    static private var crosshairdepth = 10004;

    function worldkitInteraction(main:worldkitMain) {
        this.main = main;

        this.main.parent.createEmptyMovieClip("worldkitComponents",4);
        mc = this.main.parent.worldkitComponents;
        mc.parent = this;

        zoompan = "";
        acceptInput = false;
    }

    /*
       Called by worldkitConfig
       sets up some app wide parameters
     */
    public function afterConf():Void {
        rss = main.getRSS(); 
        conf = main.getConfig();
        img = main.getImages();

        scale = conf.initialzoom;

        var xy;
        xy = geo2xy(conf.initiallat,conf.initiallong);

        if (conf.initiallat == undefined) { centery = conf.h / 2; }
        else { centery = xy[1]; }

        if (conf.initiallong == undefined) { centerx = conf.w / 2; }
        else { centerx = xy[0]; }

        setCurrentBbox();

        if (conf.maxzoom) {
            xy = geo2xy(conf.north,conf.west+0.000001); //REVIST why add this small offset
            initeastx = xy[0]; initsouthy = xy[1];

            xy = geo2xy(conf.south,conf.east);
            initwestx = xy[0]; initnorthy = xy[1];   
        }

        ratio = conf.w / conf.h;

        if (conf.inputonly) {
            acceptInput = true;
        }

        mc.attachMovie("worldkitCrosshair", "crosshair", crosshairdepth);
        mc.crosshair.parent = this;
        mc.crosshair._xscale =  100 * 100 * 2/conf.w;
        mc.crosshair._yscale = 100 * 100 * 2/conf.w;
        if (! conf.inputonly) {
            mc.crosshair._alpha = 0;
        }

        //proxy = new JavaScriptProxy();
    }

    public function SetupInput():Void {
        if (conf.ascomponent == true) {
            SetupAsComponent();
        }

        SetupToolbar(); 

        if (conf.timenav != false) {
            SetupTimenav();
        }

        Key.addListener(this);
        Mouse.addListener(this);

        SetupJavascript();

        Zoom();

        mc.onEnterFrame = function() { this.parent.onEnterFrame(); }
    }

    /*
       for when worldKit loads into movieClip in another swf
       this can be sloooww. not currently working REVISIT
     */
    public function SetupAsComponent():Void {

        /*
           when as a component, must mask off map imagery
         */
        main.parent.createEmptyMovieClip("worldkitMask",5);
        main.parent.setMask(main.parent.worldkitMask);

        var maskx = 100;
        var masky = 100;
        if (ratio >= 1) {
            main.parent._xscale = conf.w/ratio;
            main.parent._yscale = conf.h;
            var x = (100*ratio-100)/2;

            //REVISIT
            //this.imagelayer._x = x;
            //this.datalayer._x = x;
            //this.components._x = x;

            maskx = 100 * ratio;
        } else {
            main.parent._xscale = conf.w;
            main.parent._yscale = conf.h*ratio;
            var y = 0;

            //REVISIT
            //this.imagelayer._y = y;
            //this.datalayer._y = y;
            //this.components._y = y;

            masky = 100 * ratio;
        }


        main.parent.worldkitMask.beginFill(0x000000);
        main.parent.worldkitMask.moveTo(0,0);
        main.parent.worldkitMask.lineTo(maskx,0);
        main.parent.worldkitMask.lineTo(maskx,masky);
        main.parent.worldkitMask.lineTo(0,masky);
        main.parent.worldkitMask.lineTo(0,0);
        main.parent.worldkitMask.endFill();
    }

    public function SetupToolbar():Void {
        mc.attachMovie("worldkitControlBar","toolbar", toolbardepth);
        mc.toolbar.parent = this;

        componentScaleAndPosition("toolbar",conf.controlscale,0);

        if (conf.toolbar == true) {
            var b = new Array("Up","In","Out","Down","Left","Right");
            for (var i=0; i<b.length; i++) {
                mc.toolbar[ b[i] ].parent = this;
                mc.toolbar[ b[i] ].action = b[i];
                mc.toolbar[ b[i] ].onPress = function () {
                    this.parent.zoompan = this.action; if (this.parent.components["zoombox"] != undefined) {this.parent.components["zoombox"].removeMovieClip(); }
                }
                mc.toolbar[ b[i] ].onRelease = function () { this.parent.zoompan = "Over"; }
                mc.toolbar[ b[i] ].onDragOut = function () { this.parent.zoompan = ""; }
                mc.toolbar[ b[i] ].onRollOver = function () { this.parent.zoompan = "Over"; this._alpha = 100; }
                mc.toolbar[ b[i] ].onRollOut = function() { this.parent.zoompan = ""; this._alpha = this.parent.conf.controlalpha; }
                mc.toolbar[ b[i] ].onReleaseOutside = function() { this.parent.zoompan = ""; this._alpha = this.parent.conf.controlalpha; }
                mc.toolbar[ b[i] ]._alpha = conf.controlalpha;
            }
            mc.toolbar["DragOn"].parent = this;
            mc.toolbar["DragOff"].parent = this;
            mc.toolbar["PanOn"].parent = this;
            mc.toolbar["PanOff"].parent = this;
            mc.toolbar["DragOff"].onPress = function() {
                this.parent.conf.zoomselect = true;
                this.parent.conf.grabber = false;
                this.parent.mc.toolbar["PanOn"]._visible = 0;
                this.parent.mc.toolbar["DragOn"]._visible = 1;
            }
            mc.toolbar["PanOff"].onPress = function() {
                this.parent.conf.zoomselect = false;
                this.parent.conf.grabber = true;
                this.parent.mc.toolbar["PanOn"]._visible = 1;
                this.parent.mc.toolbar["DragOn"]._visible = 0;
            }
            if (conf.zoomselect) {
                mc.toolbar["PanOn"]._visible = 0;
            } else {
                mc.toolbar["DragOn"]._visible = 0;
                conf.grabber = true;
            }
        } else {
            mc.toolbar._visible = 0;
        }
    }

    public function onKeyDown():Void {
        if (Key.getCode() == Key.UP) {
            zoompan = "Up";
        } else if (Key.getCode() == Key.DOWN) {
            zoompan = "Down";
        } else if (Key.getCode() == Key.LEFT) {
            zoompan = "Left";
        } else if (Key.getCode() == Key.RIGHT) {
            zoompan = "Right";
        } else if (String.fromCharCode(Key.getAscii()) == "z") {
            zoompan = "In";
        } else if (String.fromCharCode(Key.getAscii()) == "a") {
            zoompan = "Out";
        } else if (String.fromCharCode(Key.getAscii()) == "v") {
            LoadingDialog("worldkit ver. " + worldkitMain.version, true);
        } else if (String.fromCharCode(Key.getAscii()) == "p") {
            timenavplay = true;
        } else if (String.fromCharCode(Key.getAscii()) == "s") {
            timenavplay = false;
        } else if (String.fromCharCode(Key.getAscii()) == "r") {
            timenavplay = false;
            mc.timenav.scrollbar.setScrollPosition(0);
        }
    }

    public function onKeyUp():Void {
        if (String.fromCharCode(Key.getAscii()) == "i") {
            if (conf.inputonly != true) { 
                if (acceptInput == true) {
                    acceptInput = false;
                    rss.inputToggle(acceptInput);
                    Mouse.show();
                    mc.crosshair._alpha = 0;
                } else {
                    acceptInput = true;
                    rss.inputToggle(acceptInput); 
                    Mouse.hide();
                    mc.crosshair._alpha = 100;
                }
            }
        } else if (String.fromCharCode(Key.getAscii()) == "v") {
            LoadingDialog(undefined, true);
            /*    } else if (String.fromCharCode(Key.getAscii()) == "p") {
                  print();*/
    }
    if (zoompan != "" && conf.onzoompan) {
        var args = "extent=" + cwest + "," + csouth + "," + ceast + "," + cnorth;
        //getURL( conf.onzoompan + "(\"" + args + "\");" );
        ExternalInterface.call( conf.onzoompan.substr(11), args);
    }
    zoompan = "";
    }

    public function onMouseDown():Void {
        if (zoompan != "") { return; }

        if (acceptInput == true) {

            if (conf.inputonly != true) { 
                acceptInput = false;
                mc.crosshair._alpha = 0;
                Mouse.show();
            }
            rss.inputToggle(false);
            annotate(_root._xmouse, _root._ymouse);

        } else if (conf.zoomselect == true) {

            mc.createEmptyMovieClip("zoombox",zoomboxdepth);
            mc.zoombox.origx = mc.zoombox._xmouse;
            mc.zoombox.origy = mc.zoombox._ymouse;

        } else if (conf.grabber == true) {

            mc.createEmptyMovieClip("grabber",grabberdepth);
            mc.grabber.origx = mc.grabber._xmouse;
            mc.grabber.origy = mc.grabber._ymouse;
            if (conf.w > conf.h) {
                mc.grabber.origwidth = (conf.w/conf.h) * 100;
                mc.grabber.origheight = 100;
            } else {
                mc.grabber.origwidth = 100;
                mc.grabber.origheight = (conf.h/conf.w) * 100;
            }

        }
    }

    public function onMouseMove():Void {
        mc.crosshair._x = _root._xmouse;
        mc.crosshair._y = _root._ymouse;

        if (mc.zoombox != undefined) {
            mc.zoombox.clear();
            mc.zoombox.lineStyle(0,0xff0000);
            mc.zoombox.moveTo( mc.zoombox.origx, mc.zoombox.origy);
            mc.zoombox.lineTo( mc.zoombox.origx, mc.zoombox._ymouse);
            mc.zoombox.lineTo( mc.zoombox._xmouse, mc.zoombox._ymouse);
            mc.zoombox.lineTo( mc.zoombox._xmouse, mc.zoombox.origy);
            mc.zoombox.lineTo( mc.zoombox.origx, mc.zoombox.origy);
        } else if (mc.grabber != undefined) {
            centerx -= (conf.w / scale ) *((mc.grabber._xmouse - mc.grabber.origx) / mc.grabber.origwidth);
            centery -= (conf.h / scale ) *((mc.grabber._ymouse - mc.grabber.origy) / mc.grabber.origheight);
            mc.grabber.origx = mc.grabber._xmouse;
            mc.grabber.origy = mc.grabber._ymouse;
            Pan();
        }
    }

    public function onMouseUp():Void {
        if (mc.zoombox != undefined) {

            var zoomboxw = conf.w;
            var zoomboxh = conf.h;
            var offsetx = 0;
            var offsety = 0;
            if (ratio > 1) {
                zoomboxw = 100 * ratio; zoomboxh = 100;
            } else {
                zoomboxw = 100; zoomboxh = 100 / ratio;
            }
            offsetx = (zoomboxw - 100);
            offsety = (zoomboxh - 100);

            var zoomxscale = scale * ( zoomboxw / Math.abs(mc.zoombox.origx - mc.zoombox._xmouse));
            var zoomyscale = scale * ( zoomboxh / Math.abs(mc.zoombox.origy - mc.zoombox._ymouse));

            if (zoomxscale < scale * 10 || zoomyscale < scale * 10) {
                var newscale = (zoomxscale < zoomyscale ? zoomxscale : zoomyscale);
                if (newscale > conf.maxscale) { newscale = conf.maxscale; }

                var zoomw = conf.w / scale;
                var zoomh = conf.h / scale;
                var newx = centerx - zoomw/2 + (mc.zoombox.origx + mc.zoombox._xmouse + offsetx) * zoomw / (2*zoomboxw);
                var newy = centery - zoomh/2 + (mc.zoombox.origy + mc.zoombox._ymouse + offsety) * zoomh / (2*zoomboxh);

                scale = newscale;
                centerx = newx;
                centery = newy;

                zoompan = "Changed";
            }
            mc.zoombox.removeMovieClip();

        } else if (mc.grabber != undefined) {
            mc.grabber.removeMovieClip();
        }

        if (conf.onzoompan) {
            var args = "extent=" + cwest + "," + csouth + "," + ceast + "," + cnorth;
            //getURL( conf.onzoompan + "(\"" + args + "\");" );
            ExternalInterface.call( conf.onzoompan.substr(11), args);

        }
    }

    public function onMouseWheel(delta:Number):Void {
        //  centery -= delta/(scale);
        //  Pan();
        if (delta > 0) { delta = 1; } else { delta = -1; }
        scale = scale * (Math.pow(conf.zoomc, delta));
        if (scale > conf.maxscale) {
            scale = conf.maxscale;
        } else if (scale < 1) {
            scale = 1;
        }
        Zoom();
    }

    public function onEnterFrame():Void {
        if (zoompan != ""  && ! img.highLoad()) {
            switch(zoompan) {
                case("Up"):     
                    centery -= conf.h/(scale * conf.panc);
                Pan();
                break;

                case("In"):
                    if (scale < conf.maxscale) {
                        scale = scale * conf.zoomc;
                        if (scale > conf.maxscale) {
                            scale = conf.maxscale;
                        }
                        Zoom();
                    }
                    break;

                case("Out"):
                    if (scale > 1) {
                        scale = scale / conf.zoomc;
                        if (scale < 1) { scale = 1; }
                        Zoom();
                    }
                    break;

                case("Left"):
                    centerx -= conf.w/(scale * conf.panc);
                    Pan();
                    break;

                case("Right"):
                    centerx += conf.w/(scale * conf.panc);
                    Pan();
                    break;

                case("Down"):
                    centery += conf.h/(scale * conf.panc);
                    Pan();
                    break;

                case("Changed"):
                    Zoom();
                    zoompan = "";
                    if (conf.onzoompan) {
                        var args = "extent=" + cwest + "," + csouth + "," + ceast + "," + cnorth;
                        ExternalInterface.call( conf.onzoompan.substr(11), args);
                        //getURL(conf.onzoompan + "(\"" + args + "\");" );
                    }   
                    break;

                    default:    
                }
            }

        if (timenavplay) {
            var p = mc.timenav.scrollbar.getScrollPosition() + 1;
            if (p <= conf.timenavunit) {
                mc.timenav.scrollbar.setScrollPosition(p);
            } else {
                timenavplay = false;
            }
        }
    }

    public function Pan():Void {

        correctCenter();
        setCurrentBbox();

        img.Pan();
        rss.Pan();
        worldkitGPX.Pan();

        if (conf.locupdate) {
            var geo = xy2geo(centerx, centery, conf.w, conf.h);
            annotate(geo[0], geo[1]);
        }
    }

    public function Zoom():Void {
        Pan();
        rss.Zoom();
    }

    public function zoomTo(lat:Number, lon:Number, scale:Number):Void {
        var xy = geo2xy(lat,lon);
        centerx = xy[0];
        centery = xy[1];
        this.scale = scale;

        Zoom();

        if (conf.onzoompan) {
            var args = "extent=" + cwest + "," + csouth + "," + ceast + "," + cnorth;
            //getURL( conf.onzoompan + "(\"" + args + "\");" );
            ExternalInterface.call( conf.onzoompan.substr(11), args);
        }
    }

    public function correctCenter():Void {
        if (centerx < (conf.w / (2 * scale))) {
            centerx = conf.w / (2 * scale);
        } else if (centerx >  (conf.w - (conf.w / (2 * scale))) ) {
            centerx = conf.w - (conf.w / (2 * scale));
        }
        if (centery < (conf.h / (2 * scale))) {
            centery = conf.h / (2 * scale);
        } else if (centery >  (conf.h - (conf.h / (2 * scale))) ) {
            centery = conf.h - (conf.h / (2 * scale));
        }
    }

    public function setCurrentBbox():Void {
        var geo = xy2geo(centerx - conf.w/(2*scale), centery - conf.h/(2*scale), conf.w, conf.h);
        cnorth = geo[0]; cwest = geo[1];
        geo = xy2geo(centerx + conf.w/(2*scale), centery + conf.h/(2*scale), conf.w, conf.h);
        csouth = geo[0]; ceast = geo[1];

        ctop = centery - (conf.h/(2 * scale));
        cbottom = centery + (conf.h/(2 * scale));
        cleft = centerx - (conf.w/(2 * scale));
        cright = centerx + (conf.w/(2 * scale));
    }

    public function recordExtremes(lat:Number, lon:Number):Void {
        var xy = geo2xy(lat,lon);
        var x = xy[0]; var y = xy[1];

        if (x < initwestx) {
            initwestx = x;
        }
        if (x > initeastx) {
            initeastx = x;
        }

        if (y < initnorthy) {
            initnorthy = y;
        }
        if (y > initsouthy) {
            initsouthy = y;
        }
    }

    public function doMaxZoom():Void {
        //conf.maxzoom = false; // only maxzoom once

        var scalex,scaley;

        centerx = (initwestx + initeastx) / 2;
        centery = (initnorthy + initsouthy) / 2;

        scalex = conf.w/(initeastx-initwestx);
        scaley = conf.h/(initsouthy-initnorthy);

        var s;
        if ( scalex < scaley) { s = scalex; }
        else { s = scaley; }
        s = .8 * s;         
        if (s < 1) { s = 1; }
        else if (s > conf.maxscale) { s = conf.maxscale; }

        scale = s;

        Zoom();

    }

    public function cautiousProcessClick(url:String, window:String, jsargs:String):Void {
        if (zoompan == "" && mc.zoombox == undefined) {
            processClick(url,window,jsargs);
        }
    }
    public function processClick(url:String, window:String, jsargs:String):Void {
        if (mc.zoombox != undefined) {
            mc.zoombox.removeMovieClip();
        }

        if (window.indexOf("_javascript") == 0) {
            if (conf.fscommand == true) {
                var tmp = window.split(":");
                fscommand(tmp[1], jsargs);
            } else {
                //proxy.call( window.substr(12), jsargs);
                //getURL( window.substr(1) + "(\"" + jsargs + "\");" );
                ExternalInterface.call(window.substr(12), jsargs);
            }
        } else {
            getURL(url,window);
        }
    }

    /*
       annotate x/y is with respect to Stage, so lat/lon is calculated differently REVISIT

     */
    public function annotate(x:Number,y:Number,args:String):Void {
        if (args == undefined) {
            var w, h, xoffset=0, yoffset=0;
            if (ratio > 1) {
                w = 100 * ratio; h = 100;
                xoffset = (w - h) / 2;
            } else {
                h = 100 / ratio; w = 100;
                yoffset = (h - w) / 2;
            }
            var lon = ((x + xoffset)/w) * (ceast - cwest) + cwest;
            var lat = cnorth - ((y + yoffset)/h) * (cnorth - csouth);

            args = "lat=" + lat + "&long=" + lon + "&zoom=" + scale + "&extent=" + cwest + "," + csouth + "," + ceast + "," + cnorth;
        }

        if (conf.annotateurl.indexOf("javascript") == 0) {
            if (conf.fscommand == true) {
                var tmp = conf.annotateurl.split(":");
                fscommand(tmp[1], args);
            } else {
                //proxy.call( conf.annotateurl.substr(11), args);
                //getURL( conf.annotateurl + "(\"" + args + "\")" );
                ExternalInterface.call( conf.annotateurl.substr(11), args);

            }
        } else {
            getURL(conf.annotateurl + args, conf.window["_default_"]);
        }

    }

    public function SetupJavascript():Void {
        _root.JComm = "";
        _root.JSubComm = ""; 
        _root.JLayComm = "";
        _root.JLoadComm = "";
        _root.JRSSComm = "";
        _root.JZoomComm = "";
        _root.JActComm = "";
        _root.JItemActComm = "";
        _root.JAnnoComm = "";
        _root.JHackComm = "";
        _root.JInputComm = "";
        _root.JGetItemComm = "";
        _root.JNavmodecomm = "";
        _root.JGetExtentComm = "";
        _root.JWMSComm = "";
        _root.JStartDateComm="";
        _root.JEndDateComm="";
        _root.JHideTitleComm="";
        _root.JBackTraceComm="";
        _root.JShowBackTraceComm="";
        _root.watch("JComm",worldkitInteraction.onJavascript,this);
        _root.watch("JSubComm", worldkitInteraction.onJavascript,this);
        _root.watch("JLayComm", worldkitInteraction.onJavascript,this);
        _root.watch("JLoadComm", worldkitInteraction.onJavascript,this);
        _root.watch("JRSSComm", worldkitInteraction.onJavascript,this);
        _root.watch("JZoomComm", worldkitInteraction.onJavascript,this);
        _root.watch("JActComm", worldkitInteraction.onJavascript,this);
        _root.watch("JItemActComm", worldkitInteraction.onJavascript,this);
        _root.watch("JAnnoComm", worldkitInteraction.onJavascript,this);
        _root.watch("JHackComm", worldkitInteraction.onJavascript,this);
        _root.watch("JInputComm", worldkitInteraction.onJavascript,this);
        _root.watch("JGetItemComm", worldkitInteraction.onJavascript,this);
        _root.watch("JNavmodeComm", worldkitInteraction.onJavascript,this);
        _root.watch("JGetExtentComm", worldkitInteraction.onJavascript,this);
        _root.watch("JWMSComm", worldkitInteraction.onJavascript,this);
        _root.watch("JStartDateComm", worldkitInteraction.onJavascript,this);
        _root.watch("JEndDateComm", worldkitInteraction.onJavascript,this);
        _root.watch("JHideTitleComm", worldkitInteraction.onJavascript,this);
        _root.watch("JBackTraceComm", worldkitInteraction.onJavascript,this);
        _root.watch("JShowBackTraceComm", worldkitInteraction.onJavascript,this);
    }

    static public function onJavascript(prop, oldVal, newVal, userData) {
        var callback = "on" + prop;
        var args = new Array( newVal );
        userData[ callback ].apply( userData, args );
    }

    public function onJComm(newVal) {
        rss.onJComm(newVal);
    }
    public function onJSubComm(newVal) {
        newVal = newVal.toLowerCase();
        rss.onJSubComm(newVal);
    }
    public function onJLayComm(newVal) {

        newVal = newVal.toLowerCase();  
        /* categories should be handled locally - REVISIT */
        var c = conf.categories[newVal];
        if (conf.categories[newVal] == true || conf.categories[newVal] == undefined) {
            conf.categories[newVal] = false;
        } else {
            conf.categories[newVal] = true;
        }

        img.Pan(); /* This will do some extra unneeded repositioning of base images REVISIT */

        rss.setVisible();
    }
    public function onJHackComm(newVal) {
        var tmp = newVal.split(":");
        var layer = tmp[0]; var val;
        layer = layer.toLowerCase();
        if (tmp[1] == "true") { 
            val = true;
        } else {
            val = false;
        }
        conf.categories[ layer ] = val;

        img.Pan();
        rss.setVisible();
    }
    public function onJActComm(newVal) {
        newVal = newVal.toLowerCase();
        rss.onJActComm(newVal);
    }
    public function onJItemActComm(newVal) {
        rss.onJItemActComm(newVal);
    }
    public function onJLoadComm(newVal) {
        rss.onJLoadComm(newVal);
    }
    public function onJRSSComm(newVal) {
        rss.onJRSSComm(newVal);
    }
    public function onJZoomComm(newVal) {
        var a = newVal.split(',');
        zoomTo(Number(a[0]),Number(a[1]),Number(a[2]));
    }
    public function onJAnnoComm(newVal) {
        var geo = xy2geo(centerx, centery, conf.w, conf.h);
        annotate(geo[0], geo[1]);
    }
    public function onJInputComm(newVal) {
        var val = false;
        if (newVal == "true") {
            val = true;
        }
        conf.inputonly = val;
        acceptInput = val;
    }
    public function onJGetItemComm(newVal) {
        rss.onJGetItemComm(newVal);
    }
    public function onJNavmodeComm(newVal) {
        if (newVal == "zoomselect") {
            conf.zoomselect = true;
            conf.grabber = false;
        } else if (newVal == "grabber") {
            conf.grabber = true;
            conf.zoomselect = false;
        }
    }
    public function onJGetExtentComm(newVal) {
        var args = "extent=" + cwest + "," + csouth + "," + ceast + "," + cnorth + "&" + "zoom=" + scale;
        ExternalInterface.call( newVal, args);
        _root.JGetExtentComm = "";
    }
    public function onJWMSComm(newVal) {
        var params = new LoadVars();
        params.decode(newVal);
        conf.addNewWMS(params);
        img.addNewSwfTemplates();
        img.Pan();
    }
    public function onJStartDateComm(newVal) {
        var ss=newVal.toString();
        conf.startdate=ss;
    }
    public function onJEndDateComm(newVal) {
        conf.enddate=newVal;
    }
    public function onJHideTitleComm(newVal) {
        //  conf.hideemptytitle=newVal;
    }
    public function onJBackTraceComm(newVal) {
        //  conf.backtrace=newVal;
    }
    public function onJShowBackTraceComm(newVal) {
        //  conf.showbacktrace=newVal;
    }


    public function SetupTimenav():Void {
        mc.createEmptyMovieClip("timenav",timenavdepth);
        mc.timenav.attachMovie("FScrollBarSymbol","scrollbar",1);
        mc.timenav.scrollbar.setScrollProperties(1,0,conf.timenavunit);
        mc.timenav.scrollbar.setSize(200);
        mc.timenav.scrollbar.setHorizontal(true);
        mc.timenav.scrollbar.setChangeHandler("TimenavChange",this);
        mc.timenav.scrollbar.setEnabled(true);
        mc.timenav.scrollbar.setScrollPosition(conf.timenavpos);

        mc.timenav.createTextField("timetext",2,mc.timenav.scrollbar._width,0,100,15);
        mc.timenav.timetext.html = true;
        mc.timenav.timetext.backgroundColor = 0xffffff;
        mc.timenav.timetext.border = true;
        mc.timenav.timetext.background = true;
        mc.timenav.timetext.borderColor = 0x000000;
        mc.timenav.timetext.htmlText = "<font face=\"Arial\" size=\"9\"><b>" + worldkitUtil.dateToString(maxtime) +  "</b></font>";
        componentScaleAndPosition("timenav",100,0);
    }
    public function TimenavChange(component) {
        if (mc.zoombox != undefined) { mc.zoombox.removeMovieClip(); }
        maxtime = new Date(conf.startdate.valueOf() + (component.getScrollPosition()/conf.timenavunit) * (conf.enddate.valueOf() - conf.startdate.valueOf()));
        mc.timenav.timetext.htmlText = "<font face=\"Arial\" size=\"9\"><b>" + worldkitUtil.dateToString(maxtime) + "</b></font>";
        rss.setVisible(true);
        //img.Pan(); //ALPHA wms timenav
    }

    public function LoadingDialog(msg:String, force:Boolean, size:Number) {
        if (conf.showload == false && force != true) { return; }
        if (mc.worldkitLoadingDialog == undefined) {
            mc.createEmptyMovieClip("worldkitLoadingDialog",dialogdepth);
            mc.worldkitLoadingDialog.createTextField("text",1,0,0,160,30);
            mc.worldkitLoadingDialog.text.html = true;
            mc.worldkitLoadingDialog.text.backgroundColor = 0xffffff;
            mc.worldkitLoadingDialog.text.border = true;
            mc.worldkitLoadingDialog.text.background = true;
            mc.worldkitLoadingDialog.text.borderColor= 0x000000;
            componentScaleAndPosition("worldkitLoadingDialog",100,-1);
            mc.worldkitLoadingDialog.text.autoSize = "center";
        }
        if (msg == undefined) {
            mc.worldkitLoadingDialog._visible = 0;
        } else {
            var textsize:Number; 
            if (size == undefined) { textsize = 20; } else { textsize = size; }
            mc.worldkitLoadingDialog.text.htmlText = "<font face=\"Arial\" size=\"" + textsize.toString() + "\"><b>" + msg + "</b></font>";
            mc.worldkitLoadingDialog._visible = 1;
        }
    }

    public function xy2geo(x:Number,y:Number,w:Number,h:Number):Array {
        var lat,lon;
        if (conf.west >= conf.east) {
            lon = (x / w) * (conf.east + 360 - conf.west) + conf.west;
            if (lon > 180) {
                lon = lon - 360;
            }
        } else {
            lon = (x / w) * (conf.east - conf.west) + conf.west;
        }
        lat = conf.north - (y / h) * (conf.north - conf.south);
        return [lat,lon];
    }

    public function geo2xy(lat:Number,lon:Number,point:Boolean,over:Boolean):Array {

        var w = conf.w;
        var h = conf.h;
        var no,so,ea,we;
        if (conf.accuplot != true || point == undefined) {
            no = conf.north;
            so = conf.south;
            ea = conf.east;
            we = conf.west;
        } else {
            var nw = xy2geo(centerx - (conf.w/(2 * scale)), centery - (conf.h/(2 * scale)), conf.w, conf.h);
            var se = xy2geo(centerx + (conf.w/(2 * scale)), centery + (conf.h/(2 * scale)), conf.w, conf.h);
            no = nw[0];
            we = nw[1];
            so = se[0];
            ea = se[1];
        }
        var x,y;
        if (conf.displaytype == "polar") { //fix for north pole as well!!!!
            var r = ((lat -0 + 90)/(no + 90))* w/2;
            var angle = (lon - 0 + 90) * Math.PI / 180;
            x = (-1 * r * Math.cos(angle)) + w/2;
            y = (-1 * r * Math.sin(angle)) + h/2;
        } else if (conf.displaytype == "dymax") { //should add another namespace
            x = lat;
            y = lon;
        } else if (conf.west >= conf.east) {
            if (lon <= ea || over) {
                x = ((lon - we + 360)/(ea + 360 - we)) * w;
            } else {
                x = ((lon - we)/(ea + 360 - we)) * w;
            }
            y = ((no - lat)/(no - so)) * h;
        } else {
            x = ((lon - we)/(ea - we)) * w;
            y = ((no - lat)/(no - so)) * h;
        }
        if (conf.accuplot == true && point == true) {
            if (conf.w > conf.h) {
                x = (conf.w/conf.h) * 100 * x / conf.w - ((conf.w/conf.h) * 100 - 100)/2;
                y = 100 * y / conf.h;
            } else {
                x = 100 * x / conf.w;
                y = (conf.h/conf.w) * 100 * y / conf.h - ((conf.h/conf.w) * 100 - 100)/2;
            }

        }
        return [x,y];
    }

    public function pointOnMap(lat:Number, lon:Number):Boolean {
        if (conf.west >= conf.east) {
            if (lon <= 180 && lon >= -180 && (lon >= conf.west || lon <= conf.east) && lat <= conf.north && lat >= conf.south) {
                return true;
            } else {
                return false;
            }
        } else {
            if (lon >= conf.west && lon <= conf.east && lat <= conf.north && lat >= conf.south) {
                return true;
            } else {
                return false;
            }
        }
    }

    /*
       The black magic of worldKit. Fit images to a map with dynamically determing width/heigh
     */
    public function scaleAndPosition(parent:MovieClip, id:String, extent:String, tiled:Boolean):Void { 

        var w, h;
        var wfactor, hfactor;

        if (ratio > 1) {
            w = 100 * ratio; h = 100;
        } else {
            h = 100 / ratio; w = 100;
        }
        wfactor = 100;
        hfactor = 100;

        var wanother = 1;
        var hanother = 1;
        var xanother = 0;
        var yanother = 0;
        var xy;

        if (extent == 1) {
            hanother = 180/(conf.north - conf.south);
            wanother = 360/(conf.east - conf.west);

            xy = geo2xy(90,-180);
            xanother = xy[0] * w / conf.w;
            yanother = xy[1] * h / conf.h;

        } else if (extent != undefined) {
            var no,so,ea,we;
            var wsen = extent.split(",");
            we = wsen[0]; so = wsen[1]; ea = wsen[2]; no = wsen[3];
            hanother = (no - so)/(conf.north - conf.south);
            wanother = (ea - we)/(conf.east - conf.west);

            xy = geo2xy( no, we);
            xanother = xy[0] * scale * w / conf.w;
            yanother = xy[1] * scale * h / conf.h;

        }

        var clip;
        if (id == undefined) {
            clip = parent;
        } else {
            clip = parent[id];
        }


        var xscale = scale * 100 * ( w / clip.origwidth) * wanother;
        var yscale = scale * 100 * ( h / clip.origheight) * hanother;

        var xoffset = scale * ((conf.w / 2) - centerx) * (w / conf.w);
        var yoffset = scale * ((conf.h / 2) - centery) * (h / conf.h);

        var xp = - ((w - wfactor) / 2 + ((scale - 1) * w / 2)) + xoffset + xanother;
        var yp = - ((h - hfactor) / 2 + ((scale - 1) * h / 2)) + yoffset + yanother;

        if (tiled) {
            var width = clip.actualwidth * xscale / 100;
            var height = clip.actualheight * yscale / 100;  

            var x2 = Math.floor(xp * 20) / 20;
            var y2 = Math.floor(yp * 20) / 20;

            width = width + (xp - x2);
            height = height + (yp - y2);

            width = Math.ceil(width * 20) / 20;
            height = Math.ceil(height * 20) / 20;

            if (clip.actualwidth < clip.origwidth) {
                width = Math.ceil(width);
            }
            if (clip.actualheight < clip.origheight) {
                height = Math.ceil(height);
            }

            clip._width = width;
            clip._height = height;


            clip._x = x2;
            clip._y = y2;   
        } else {
            clip._xscale = xscale;
            clip._yscale = yscale;
            clip._x = xp;
            clip._y = yp;
        }

    }


    private function componentScaleAndPosition(id:String, sc:Number, hoffset:Number):Void {
        var scaleh = 1;
        var scalew = 1; 
        var w = conf.w;
        var h = conf.h;

        if (ratio > 1) {
            scalew = 100 * ratio / conf.w;
            scaleh = 100 / conf.h;
        } else {
            scalew = 100 / conf.w;
            scaleh = 100 / (conf.h * ratio);
        }
        w = 100;
        h = 100;

        mc[id]._xscale = sc * scalew;
        mc[id]._yscale = sc * scaleh;
        mc[id]._x = (w - mc[id]._width) / 2;
        if (hoffset == -1) {
            mc[id]._y = 0;
        } else {
            mc[id]._y = h - mc[id]._height - hoffset;
        }
    }
}
