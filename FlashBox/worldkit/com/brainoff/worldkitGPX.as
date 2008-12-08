/*
   worldkitGPX classes transparently manages all worldkitGPX instances
   slightly different tact from other worldkit classes, works well, perhaps a model later on
 */

import com.brainoff.worldkitMain;
import com.brainoff.worldkitConfig;
import com.brainoff.worldkitImages;
import com.brainoff.worldkitInteraction;

class com.brainoff.worldkitGPX {
    static private var _instances:Array;

    private var main:worldkitMain;
    private var conf:worldkitConfig;
    private var img:worldkitImages;
    private var interact:worldkitInteraction;

    private var mcparent:MovieClip;
    private var mcid:String;
    private var level:Number;
    private var url:String;
    private var cats:Array;

    public static function start(main:worldkitMain) {
        var conf:worldkitConfig = main.getConfig();

        var layer = worldkitImages.nextLayer();
        var mc = worldkitImages.getmc();
        for (var s in conf.gpx) {
            var tmp = new worldkitGPX(main, mc, s, layer, conf.gpx[s].url, conf.gpx[s].cats);
        }
    }
    public static function Pan() {
        for (var g in _instances) {
            _instances[g].PanInstance();
        }
    }

    public function worldkitGPX(main:worldkitMain, mcparent:MovieClip, mcid:String, level:Number, url:String, cats:String) {
        if (_instances == undefined) {
            _instances = new Array();
        }
        _instances.push(this);

        this.main = main;
        this.conf = main.getConfig();
        this.img = main.getImages();
        this.interact = main.getInteract();
        this.mcparent = mcparent;
        this.mcid = mcid;
        this.level = level;
        this.url = url;
        if (cats != undefined) {
            this.cats = cats.split(",");
        } else {
            this.cats = new Array();
        }
        this.cats.push("_default_");


        this.mcparent.createEmptyMovieClip(this.mcid, this.level);
        this.mcparent[this.mcid].origwidth = this.conf.w;
        this.mcparent[this.mcid].origheight = this.conf.h;

        load();
    }

    private function unscale() {
        mcparent[ this.mcid ]._x = 0; mcparent[ this.mcid ]._y = 0; mcparent[ this.mcid ]._xscale = 100; mcparent[ this.mcid ]._yscale = 100; mcparent[ this.mcid ]._visible = 0;
    }

    private function load() {
        var gpx:worldkitGPX = this;
        var loader:XML = new XML();
        loader.ignoreWhite = true;
        loader.onLoad = function(success) { gpx.onLoad(this, success); }
        loader.load(url);
    }

    public function onLoad(xml:XML, success:Boolean):Void {
        if (! success) { return; }

        unscale();

        for (var i = 0; i < xml.childNodes.length; i++) {
            if (xml.childNodes[i].nodeName == "gpx") {
                for (var j = 0; j < xml.childNodes[i].childNodes.length; j++) {
                    if (xml.childNodes[i].childNodes[j].nodeName == "trk") {
                        parseTrack(xml.childNodes[i].childNodes[j]);
                    }
                }

            }
        }

        interact.scaleAndPosition(mcparent,mcid);
        mcparent[ mcid ]._visible = 1;
    }

    private function parseTrack(node:XMLNode):Void {
        var coordinates = new Array(); 
        var c;
        for (var i = 0; i < node.childNodes.length; i++) {
            if (node.childNodes[i].nodeName == "trkseg") {
                for (var j = 0; j < node.childNodes[i].childNodes.length; j++) {
                    if (node.childNodes[i].childNodes[j].nodeName == "trkpt") {
                        c = node.childNodes[i].childNodes[j].attributes.lat + "," + node.childNodes[i].childNodes[j].attributes.lon;
                        coordinates.push(c);
                    }
                }
            }
        }
        plotLine(coordinates);
    }

    private function plotLine(coordinates:Array):Void {
        var linecolor:Number = conf.getConfBySubject("linecolor",cats);
        var linealpha:Number = conf.getConfBySubject("linealpha",cats);
        var linethickness:Number = conf.getConfBySubject("linethickness",cats);

        mcparent[ mcid ].lineStyle(linethickness, linecolor, linealpha);
        for (var i = 0; i < coordinates.length; i++) {
            if (coordinates[i].indexOf(",") != -1) {
                var latlon = coordinates[i].split(",");
                var xy = interact.geo2xy(latlon[0], latlon[1]);
                if (i == 0) {
                    mcparent[ mcid ].moveTo(xy[0],xy[1]);
                } else {
                    mcparent[ mcid ].lineTo(xy[0],xy[1]);
                }
            }
        }
    }

    private function PanInstance():Void {
        interact.scaleAndPosition(mcparent, mcid);
    }
}

