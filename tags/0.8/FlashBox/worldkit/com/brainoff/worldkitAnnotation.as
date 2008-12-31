import com.brainoff.worldkitConfig;
import com.brainoff.worldkitInteraction;
import com.brainoff.worldkitImages;
import com.brainoff.worldkitMain;
import com.brainoff.worldkitRSS;
import com.brainoff.worldkitUtil;

class com.brainoff.worldkitAnnotation {
    private var main:worldkitMain;
    private var conf:worldkitConfig;
    private var rss:worldkitRSS;
    private var interact:worldkitInteraction;
    private var img:worldkitImages;

    private var mc:MovieClip;
    private var depth:Number;
    private var title:String;
    private var url:String;
    private var lat:Number;
    private var lon:Number;
    private var summary:String;
    private var cats:Array;
    private var id:String;
    private var photo:String;
    private var prevlat:Number;
    private var prevlon:Number;
    private var vector:String;
    private var vtype:String;
    private var datestring:String;
    private var date:Date;
    private var precompile:Boolean;
    private var enddate:Date;

    public var present:Boolean;
    public var activate:Boolean;

    private var clipname:String;
    private var textname:String;
    private var x:Number;
    private var y:Number;
    private var prevx:Number;
    private var prevy:Number;
    private var scale:Number;
    private var jsargs:String;
    private var color:Number;
    private var createdate:Date;

    private var initialplotcolor:Number;
    private var restingplotcolor:Number;
    private var activatecolor:Number;
    private var plotsize:Number;
    private var plotshape:String;
    private var icon:String;
    private var linecolor:Number;
    private var zoomto:Number;
    private var linealpha:Number;
    private var linethickness:Number;
    private var fillalpha:Number;
    private var window:String;
    private var rssicon:String;
    private var curralpha:Number;

    private var colorobj:Color;

    public function worldkitAnnotation(main:worldkitMain, mc:MovieClip, depth:Number, title:String, url:String, lat:Number, lon:Number, summary:String, cats:Array, id:String, photo:String, prevlat:Number, prevlon:Number, vector:String, vtype:String, datestring:String, precompile:Boolean, enddate:String, rssicon:String) {

        this.main = main;
        this.mc = mc;

        conf = main.getConfig();
        rss = main.getRSS();
        interact = main.getInteract();
        img = main.getImages();

        this.depth = depth;
        this.title = title;
        this.url = url;
        this.lat = lat;
        this.lon = lon;
        this.summary = summary;
        this.cats = cats;
        this.id = id;
        this.photo = photo;
        this.prevlat = prevlat;
        this.prevlon = prevlon;
        this.vector = vector;
        this.vtype = vtype;
        this.datestring = datestring;
        this.date = new Date(worldkitUtil.parseDate(datestring));
        this.precompile = precompile;
        if (enddate != undefined) {
            this.enddate = new Date(worldkitUtil.parseDate(enddate));
        } 
        this.rssicon = rssicon;

        present = true;
        activate = false;

        setparams();

        if (this.precompile == undefined) {
            clipname = this.depth + "point";
            textname = this.depth + "pointtext";
            mc.createEmptyMovieClip(clipname,this.depth);
        } else {
            clipname = this.title;
            textname = this.title + "text";
        }

        if (this.precompile) {
            colorobj = new Color(mc[ this.clipname ]);
        }

        createdate = new Date();
        curralpha = 100;
        mc[this.clipname].annotation = this;
    }

    public function setparams():Void {
        initialplotcolor = conf.getConfBySubject("initialplotcolor", this.cats);
        restingplotcolor = conf.getConfBySubject("restingplotcolor", this.cats);
        activatecolor = conf.getConfBySubject("activatecolor", this.cats);
        plotsize = conf.getConfBySubject("plotsize", this.cats);
        plotshape = conf.getConfBySubject("plotshape", this.cats);
        icon = conf.getMatchingSubject("icon", this.cats);
        linecolor = conf.getConfBySubject("linecolor", this.cats);
        zoomto = conf.getConfBySubject("zoomto", this.cats);
        linealpha = conf.getConfBySubject("linealpha", this.cats);
        linethickness = conf.getConfBySubject("linethickness", this.cats);
        fillalpha = conf.getConfBySubject("fillalpha", this.cats);
        window = conf.getConfBySubject("window", this.cats);
    }
    public function plot():Void {
        if  (precompile != true && conf.accuplot != true) {
            /**/
            //reset scaling for plot
            /**/
            mc._x = 0; mc._y = 0; mc._xscale = 100; mc._yscale = 100;
        }

        if (precompile != true) {
            /**/
            // Calculate positions
            /**/
            var a = new Array();
            a = interact.geo2xy(lat,lon,true); x = a[0]; y = a[1];
            if (x == undefined || y == undefined) { return; }    
            if (conf.track && prevlat != undefined && prevlon != undefined) { 
                a = interact.geo2xy(prevlat,prevlon); prevx = a[0]; prevy = a[1]; 
            }
            mc[clipname]._x = x; mc[clipname]._y = this.y;

            var rescale = 100/interact.scale; 
            scale = rescale;
            if (vector == undefined && precompile != true && conf.accuplot != true) {
                mc[clipname]._xscale = rescale;    
                mc[clipname]._yscale = rescale;
            } else if (conf.accuplot == true) {
                scale = 100 * 100 /conf.h;
                mc[clipname]._xscale = scale;
                mc[clipname]._yscale = scale;
            }
        }

        jsargs = buildJsArgs();

        makeText();

        mc[clipname].onRelease = function() { this.annotation.onRelease(); }
        mc[clipname].onRollOver = function() { this.annotation.onRollOver();}
        mc[clipname].onRollOut = function() { this.annotation.onRollOut(); }

        setVisible(true,conf.textinterval);

        shape(1);

        if (initialplotcolor != restingplotcolor) { 
            worldkitUtil.setTimeout(this, "shape", 60000, 2);
        }

        if (precompile != true && conf.accuplot != true) {
            interact.scaleAndPosition(mc,undefined);
        }


        if (conf.newitemcallback) {
            var msg = "title=" + escape(title) + "&url=" + escape(url) +  "&summary=" + escape( summary.split("\"").join("\\\"") ) +  "&lat=" + escape(String(lat)) + "&lon=" + escape(String(lon)) + "&id=" + escape(id);	
            interact.processClick("", "_" + conf.newitemcallback, msg);
        }
    }

    public function makeText():Void {
        if (conf.singletextfield != true) {
            mc.createEmptyMovieClip(textname, depth+10000); //REVISIT places 10000 plot limit 
            mc[ textname ].annotation = this;
            mc[ textname ]._visible = 0;

            var w = mc.origwidth; var h = mc.origheight;
            var textx = x; var texty = y;
            var rescale = (100/interact.scale); 
            var textboxsize = conf.textboxsize;
            if (precompile) {
                rescale = rescale * (w/conf.h);
                textboxsize = textboxsize * (100/conf.h);
            }
            // should maybe try to position this to the right of the point, or dynamically dependent on zoom)
            var boxmargin = 0;
            if (conf.roundtextbox) {
                boxmargin = 10;
            }
            if (w - x < (boxmargin + textboxsize)) { textx = x - (boxmargin + textboxsize / interact.scale); }
            if (h - y < 100) { texty = y - (50 / interact.scale); }	

            mc[ textname ]._x = textx; if (textx != x) { mc[textname].leftpos = true; }
            mc[ textname ]._y = texty; if (texty != y) { mc[textname].bottompos = true; }


            mc[textname]._xscale = scale;    
            mc[textname]._yscale = scale;

            if (photo != "" && photo != undefined) {
                mc[textname].createEmptyMovieClip("image",100000); //REVISIT 100000
                mc[textname].image.loadMovie(photo);
            } else {
                var textheight = 100;
                if (conf.textboxsize != 0) {
                    var htmlText;
                    if (conf.roundtextbox) {
                        mc[textname].createTextField("text",1,5,5,textboxsize,textheight);
                        mc[textname].text.border = false;
                        mc[textname].text.background = true;
                        htmlText = "<font color=\"#0000F0\" face=\"Verdana,Arial,_sans\" size=\"" + conf.textsize + "\"><b>" + title + "</b></font><br><font color=\"#000000\" face=\"Verdana,Arial,_sans\" size=\"" + conf.textsize + "\">" + summary + "</font>";
                    } else {
                        mc[textname].createTextField("text",1,0,0,textboxsize,textheight);
                        mc[textname].text.border = true;
                        mc[textname].text.backgroundColor = 0xFFFFFF;
                        mc[textname].text.background = true;
                        htmlText  = "<font color=\"#555555\" face=\"Verdana,Arial,_sans\" size=\"" + conf.textsize + "\"><b>" + title + "</b><br>" + summary + "</font>";
                    }
                    mc[textname].text.html = true; //REVISIT this might be trouble with non-roman chars
                    mc[textname].text.multiline = true;
                    mc[textname].text.wordWrap = true;
                    mc[textname].text.autoSize ="center";
                    mc[textname].text.htmlText = htmlText;

                    if (conf.roundtextbox) {
                        // turn box into a rounded rectangle
                        var cstroke = {width:2, color:0x808080, alpha:100};
                        var ccolor = {color:0xf0f0f0, alpha:100};
                        rrectangle(
                                mc[textname],
                                mc[textname]._width + boxmargin,
                                mc[textname]._height + boxmargin + 3,
                                6,
                                //				((textx+w+16) > Stage.width ) ? (Stage.width-w-16) : textx,
                                textx,
                                texty,
                                cstroke,
                                ccolor);

                        // add a dropshadow
                        var dropShadow = new flash.filters.DropShadowFilter();
                        dropShadow.blurX = 4;
                        dropShadow.blurY = 4;
                        dropShadow.distance = 4;
                        dropShadow.angle = 45;
                        dropShadow.quality = 2;
                        dropShadow.alpha = 0.75;
                        mc[textname].filters = [dropShadow];
                    }
                }
            }

            mc[textname].onRelease = function() { this.annotation.onReleaseText(); }
        }

    }

    // Rounded rectangle made only with actionscript.
    // Code taken and modified from http://www.actionscript-toolbox.com
    // w = rectangle width
    // h = rectangle height
    // rad = rounded corner radius
    // x = x  start point for rectangle
    // y = y  start point for rectangle
    // 
    private function rrectangle( mc:MovieClip, w:Number, h:Number, rad:Number, x:Number, y:Number, stroke:Object, fill:Object) : Void {
        x = Math.round(x);
        y = Math.round(y);
        w = Math.round(w);
        h = Math.round(h);

        mc.lineStyle(stroke.width, stroke.color, stroke.alpha);
        mc.beginFill(fill.color, fill.alpha);
        mc.moveTo(0+rad, 0);
        mc.lineTo(w-rad, 0);
        mc.curveTo(w, 0, w, rad);
        mc.lineTo(w, h-rad);
        mc.curveTo(w, h, w-rad, h);
        mc.lineTo(0+rad, h);
        mc.curveTo(0, h, 0, h-rad);
        mc.lineTo(0, 0+rad);
        mc.curveTo(0, 0, 0+rad, 0);
        mc.endFill();
        mc._x = x;
        mc._y = y;
    }

    private function shape(time:Number):Void {
        if (mc[clipname] == undefined) { return; }

        mc[clipname].clear();

        if (time == 3) { color = activatecolor; }
        else if (time == 1) { color = initialplotcolor; }
        else { color = restingplotcolor; }

        if (precompile == true) {
            colorobj.setRGB( color );
        } else if (vtype == "poly") {
            drawpoly();
        } else if (vtype == "line") {
            drawline();
        } else if (vtype == "box") {
            drawbox();
        } else if (rssicon != undefined && rssicon != "") {
            if (time == 1) {
                loadrssicon();
            } else {
                activateicon(time);
            }
        } else if (icon != undefined && icon != "") {
            if (time == 1) {
                loadicon();
            } 
        } else if (plotshape == "square") {
            square();
        } else if (plotshape == "circle") {
            circle();
        } else if (plotshape == "triangle") {
            triangle();
        } 

        tracks();

    }

    private function drawpoly():Void {
        var polyarray = vector.split(" ");
        var xy,x,y;

        mc[clipname].lineStyle( linethickness, linecolor, linealpha);
        for (var i=0; i<polyarray.length-1; i+=2) {
            xy = interact.geo2xy(polyarray[i],polyarray[i+1]);
            x = xy[0] - mc[clipname]._x; //need to adjust geo2xy
            y = xy[1] - mc[clipname]._y; //relative to movie clip position
            if (i == 0) {
                mc[clipname].moveTo(x,y);
                mc[clipname].beginFill( color, fillalpha );
            } else {
                mc[clipname].lineTo(x,y);
            }
        }
        mc[clipname].endFill();
    }

    private function drawbox():Void {
        var boxarray = vector.split(" ");
        if (boxarray.length == 4) {
            vector = boxarray[0] + " " + boxarray[1] + " " + boxarray[0] + " " + boxarray[3] + " " + boxarray[2] + " " + boxarray[3] + " " + boxarray[2] + " " + boxarray[1] + " " + boxarray[0] + " " + boxarray[1];
            vtype = "poly";
            drawpoly();
        }
    }

    private function drawline():Void {
        var linearray = vector.split(" ");
        var l;
        var xy,x,y;

        mc[clipname].lineStyle( linethickness, linecolor, linealpha); 
        for (var i=0; i<linearray.length-1; i+=2) {
            xy = interact.geo2xy(linearray[i],linearray[i+1]);
            x = xy[0]  - mc[clipname]._x; //need to adjust geo2xy
            y = xy[1]  - mc[clipname]._y; //relative to movie clip position
            if (i == 0) {
                mc[clipname].moveTo(x,y);
            } else {
                mc[clipname].lineTo(x,y);
            }
        }
    }

    private function square():Void {
        var x = 0; var y = 0; //movie clip is already positioned
        var s = plotsize;
        mc[clipname].lineStyle( linethickness, linecolor, linealpha );
        mc[clipname].moveTo(x-s,y-s);
        mc[clipname].beginFill( color, fillalpha );
        mc[clipname].lineTo(x-s,y+s);
        mc[clipname].lineTo(x+s,y+s);
        mc[clipname].lineTo(x+s,y-s);
        mc[clipname].lineTo(x-s,y-s);
        mc[clipname].endFill();	
    }

    private function circle():Void {
        var x = 0; var y = 0; //movie clip is already positioned
        var s = plotsize;
        mc[clipname].lineStyle( linethickness, linecolor, linealpha );
        mc[clipname].moveTo(x+s,y); //move to point on the circle to drawArc
        mc[clipname].beginFill( color, fillalpha );
        mc[clipname].drawArc(x+s,y,s,360,0);
        mc[clipname].endFill();	
    }

    private function triangle():Void {
        var x = 0; var y = 0; //movie clip is already positioned
        var s = plotsize;
        mc[clipname].lineStyle( linethickness, linecolor, linealpha );
        mc[clipname].moveTo(x /*Math.cos(Math.PI / 2)*/,
                y - s /*Math.sin(Math.PI / 2)*/);
        mc[clipname].beginFill( color );
        //this.datalayer[this.clipname].lineTo(x + s * -0.86603 /*Math.cos(Math.PI * 7 / 6)*/,
        //		      y - s * -0.5 /*Math.sin(Math.PI * 7 / 6)*/ );
        //this.datalayer[this.clipname].lineTo(x - s * 0.86603 /*Math.cos(Math.PI * 11 / 6)*/,
        //		      y - s * -0.5 /*Math.sin(Math.PI * 11 / 6)*/ );
        mc[clipname].lineTo(x+s,y+s);
        mc[clipname].lineTo(x-s,y+s);
        mc[clipname].lineTo(x,y - s);
        mc[clipname].endFill();
    }

    //REVISIT if icon hasn't loaded yet, it won't load here
    private function loadicon():Void {
        if (mc[clipname]["icon"] == undefined) {
            mc[clipname].createEmptyMovieClip("icon",1);
        } 
        if (! img.loadicon(mc[clipname]["icon"], "icon" + icon)) {
            worldkitUtil.setTimeout(this, "loadicon", 1000);
        }
    }

    private function loadrssicon():Void {
        if (mc[clipname]["icon"] == undefined) {
            mc[clipname].createEmptyMovieClip("icon",1);
        }
        if (! img.loadrssicon(mc[clipname]["icon"], rssicon)) {
            worldkitUtil.setTimeout(this, "loadrssicon", 1000);
        }
    }
    public function activateicon(time:Number) {
        if (mc[clipname]["icon"] == undefined) {
            return;
        }
        var iconwidth;
        var alpha = 100;
        if (time == 2) {
            iconwidth = conf.rssiconwidth;
            alpha = curralpha;
        } else if (time == 3) {
            iconwidth = conf.rssiconwidth * 1.5;
        }
        img.activateicon(mc[clipname]["icon"], rssicon, iconwidth);
        mc[clipname]["icon"]._alpha = alpha;
    }

    //REVISIT 
    private function tracks():Void {
        if (conf.track && prevx != undefined && prevy != undefined) {
            var layer;
            if (conf.trackcats) {
                if (mc.tracks[ cats[0] ] == undefined) {
                    mc.tracks.createEmptyMovieClip( cats[0], mc.tracks.tracklayer );
                    mc.tracks.tracklayer++;
                }
                layer = mc.tracks[ cats[0] ];

            } else {
                layer = mc;
            }

            layer.lineStyle( linethickness, linecolor, linealpha );
            layer.moveTo(mc[clipname]._x, mc[clipname]._y);
            layer.lineTo(prevx,prevy);
        }
        //rss.setTrackVis();
        //	worldkitAnnotationClass.setTrackVis(this.conf, this.datalayer);
    }


    private function buildJsArgs():String {
        return "link=" + escape(url) + "&lat=" + escape(String(lat)) + "&long=" + escape(String(lon)) + "&id=" + escape(id);
    }

    public function setLoc():Void {
        var a = interact.geo2xy(lat, lon, true);
        x = a[0]; y = a[1];
        if (x == undefined || y == undefined) { return; }
        mc[clipname]._x = x; mc[clipname]._y = y;
        mc[textname]._x = x; mc[textname]._y = y;
    }

    public function setVisible(forcetext:Boolean, textvis:Number):Void {
        //accurate -- might also just call this, or make another function for repositioning
        var visible = true;

        for (var s in cats) {
            if (conf.categories[ cats[s] ] == false) {
                visible = false;
            }
        }

        if (conf.timenav != false) {
            if (conf.neartime) {
                if (Math.abs(Number(interact.maxtime) - Number(date)) > Number(conf.neartime)) {
                    visible = false;
                }
            } else {
                if (enddate != undefined) {
                    if (Number(enddate) < Number(interact.maxtime)) {
                        visible = false;
                    }
                }
                if (Number(date) > Number(interact.maxtime)) {
                    visible = false;
                }
            }
        }

        if (visible) {
            if (mc[clipname]._visible == 0 || forcetext) {
                mc[clipname]._visible = 1;
                if (textvis > 0) {
                    mc[textname]._visible = 1;
                    worldkitUtil.setTimeout(this,"hidetext",textvis);
                }
            }
        } else {
            mc[clipname]._visible = 0;
            mc[textname]._visible = 0;
        }
    }

    public function setActivate(cat:String):Void {
        var hit = false;
        for (var s in cats) {
            if (cats[s] == cat) {
                hit = true;
            }
        }

        if (hit) {
            if (activate == true) {
                activate = false;
                shape(2);
            } else {
                activate = true;
                shape(3);
            }
        }
    }
    public function forceActivate():Void {
        if (activate == true) {
            activate = false;
            shape(2);
        } else {
            activate = true;
            shape(3);
        }
    }

    public function setAlphaFade(now:Date):Void {
        if (curralpha == -1) { return; }
        var s = (Number(now) - Number(createdate)) / 1000;
        var clip;
        if (mc[clipname]["icon"]) {
            clip = mc[clipname]["icon"];
        } else {
            clip = mc[clipname];
        }
        clip._alpha = 100 - 100 * (s / conf.fade);
        curralpha = clip._alpha;

        if (curralpha <= 0) {
            if (mc[clipname]["icon"]) {
                mc[clipname]["icon"].removeMovieClip();
                mc[clipname]["icon"] = 1;
            } else {
                mc[clipname].clear();
            }
            if (conf.fadeditemcallback) {
                var msg = "&id=" + escape(id);	
                interact.processClick("", "_" + conf.fadeditemcallback, msg);
            }	
            curralpha = -1;
        }	
    }

    public function hidetext():Void {
        if (conf.singletextfield != true) {
            mc[textname]._visible = 0;
        } else {
            interact.LoadingDialog(undefined, true);
        }
    }

    public function showtext(setActive:Boolean):Void {
        if (conf.singletextfield != true) {
            if (setActive) {
                rss.setActive(this);
            }

            var ratio = conf.w / conf.h;
            var stagew, stageh, textx, texty;
            if (ratio > 1) { stagew  = 100 * ratio; stageh = 100; }
            else { stageh = 100 / ratio; stagew = 100; }

            var mousex = conf.w * (_root._xmouse / stagew);
            var mousey = conf.h * (_root._ymouse / stageh);

            if (mc.origwidth - mousex < conf.textboxsize) { textx = mousex - (conf.textboxsize / interact.scale); }
            if (mc.origheight - y < 100) { texty = mousey - (50 / interact.scale); }   

            mc[ textname ]._x = textx; if (textx != x) { mc[textname].leftpos = true; }
            mc[ textname ]._y = texty; if (texty != y) { mc[textname].bottompos = true; }

            mc[ textname ]._visible = 1; 
        } else {
            interact.LoadingDialog( title, true, 10);
        }
    }

    public function onRollOver():Void {
        showtext(true);
    }
    public function onRollOut():Void {
        worldkitUtil.setTimeout(this,"hidetext",conf.visinterval); 
    }
    public function onRelease():Void {
        if (zoomto != undefined) {
            interact.zoomTo(lat, lon, zoomto);
        } else {
            interact.cautiousProcessClick(url,window,jsargs); 
        }
    }
    public function onReleaseText():Void {
        if (zoomto != undefined) {
            interact.zoomTo(lat, lon, zoomto);
        } else {
            interact.cautiousProcessClick(url,window,jsargs+"&text=1"); 
        }
    }

    public function clear():Void {
        mc[clipname].removeMovieClip();
        mc[textname].removeMovieClip();
    }

    public function changed(title:String, url:String, lat:Number, lon:Number, summary:String, cats:Array, photo:String, vector:String, vtype:String, datestring:String):Boolean {
        var changed = false;
        if (title != this.title) { this.title = title; changed = true; }
        if (url != this.url) { this.url = url; changed = true; }
        if (lat != this.lat) { this.lat = lat; changed = true; }
        if (lon != this.lon) { this.lon = lon; changed = true; }
        if (summary != this.summary) { this.summary = summary; changed = true; }
        if (cats.join(':') != this.cats.join(':')) { this.cats = cats; changed = true; }
        if (photo != this.photo) { this.photo = photo; changed = true; }
        if (vector != this.vector) { this.vector = vector; changed = true; }
        if (vtype != this.vtype) { this.vtype = vtype; changed = true; }
        if (datestring != this.datestring) {this.date = new Date(worldkitUtil.parseDate(datestring)); changed = true; } //REVISIT work??

        return changed;
    }

    /*
       REVISIT -- what's the purpose of this
     */
    public function clearMC():Void {
        if (precompile != true) {
            mc[ clipname ].clear();
            mc[ textname ].removeMovieClip();
        }
    }

    public function GetItem():Void {
        var s = "||";
        var catstring = cats.join(",");
        var coords;
        if (vtype == "poly" || vtype == "line") {
            coords = vector;
        } else {
            coords = String(lat) + "," + String(lon);
        }
        var args = title + s + url + s + summary + s + catstring + s + coords + s + vtype;
        interact.annotate(null,null,args);
    }
}
