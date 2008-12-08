/* 
   worldkitConfig loads & parses the config file
   and stores the results for use throughout worldKit
 */

import com.brainoff.worldkitMain;
import com.brainoff.worldkitConfigCat;
import com.brainoff.worldkitUtil

class com.brainoff.worldkitConfig {
    private var main:worldkitMain;

    private var confurl:String = "config.xml";
    private var params:LoadVars;
    public var failed:Boolean = false;
    public var loaded:Boolean = false;

    /*
       REVISIT
       All config options are public, to ease transition from Actionscript 1.0.
       Add getter methods later on..
     */
    var accuplot:Boolean;
    var activatecolor:worldkitConfigCat;
    var annotateurl:String;
    var ascomponent:Boolean;
    var categories:Object; //REVISIT semi-config option; visibility is folded in; should be detached;
    var controlalpha;
    var controlscale;
    var dataurl:Array;
    var dayimg:String;
    var displaytype:String;
    var dontstretchimage:Boolean;
    var dymaximg:String;
    var east:Number;
    var enddate:Date;
    var enddatefield:String;
    var fade:Number;
    var fadeditemcallback:String;
    var fillalpha:worldkitConfigCat;
    var fscommand:Boolean;
    var grabber:Boolean;
    var gml:Object; //beta
    var gpx:Object; //beta
    var h:Number;
    var icon:worldkitConfigCat;
    var initiallat:Number;
    var initiallong:Number;
    var initialplotcolor:worldkitConfigCat;
    var initialzoom:Number;
    var inputonly:Boolean;
    var linealpha:worldkitConfigCat;
    var linecolor:worldkitConfigCat;
    var linethickness:worldkitConfigCat;
    var loadimgmsg:String; //"loading Images...";
    var loadrssmsg:String;
    var onloadcallback:String;
    var locfield:String;
    var locupdate:Boolean;
    var maximageload:Number;
    var maxscale:Number;
    var maxzoom:Boolean;
    var neartime:Number;
    var newitemcallback:String;
    var nightimg:String;
    var north:Number;
    var onzoompan:String;
    var panc:Number;
    var plotinterval:Number;
    var plotshape:worldkitConfigCat;
    var plotsize:worldkitConfigCat;
    var polarimg:String;
    var precompile:Object; //beta
    var projection:String;
    var resultssince:Boolean;
    var restingplotcolor:worldkitConfigCat;
    var roundtextbox:Boolean;
    var rssiconwidth:Number;
    var rssbbox:Boolean;
    var showload:Boolean;
    var showonlynew:Boolean;
    var singletextfield:Boolean; //beta
    var south:Number;
    var startdate:Date;
    var startdatefield:String;
    var swflayer:Object;
    var swftemplate:Object;
    var swftemplatelayer:Number; //REVISIT Is this really a config option? Should store in image class
    var textboxsize:Number;
    var textinterval:Number;
    var textsize:Number;
    var tilemap:Object;
    var genemap:Object;
    var timenav:Boolean;
    var timenavpos:Number;
    var timenavunit:Number;
    var toolbar:Boolean;
    var track:Boolean;
    var trackcats:Boolean;
    var uniqueurls:Boolean; //true;
    var update:Number;
    var updateurl:Array;
    var visinterval:Number;
    var w:Number;
    var west:Number;
    var wms:Object;
    var window:worldkitConfigCat;
    var zlevel:Number; //beta
    var zoomc:Number;
    var zoomifydir:String;
    var zoomifylayer:Number; //REVISITE this is not a config option, but storage convinience
    var zoomifypreload:Boolean;
    var zoomselect:Boolean;
    var zoomto:worldkitConfigCat;

    public function worldkitConfig(main:worldkitMain) {
        this.main = main;

        accuplot = false;
        annotateurl = "";
        ascomponent = false;
        controlalpha = 70;
        controlscale = 100;
        dayimg = "day.jpg";
        displaytype = "daynight";
        dontstretchimage = false;
        dymaximg = "dymax.jpg";
        east = 180;
        enddate = new Date();
        enddatefield = "any";
        fade = -1;
        fscommand = false;
        grabber = false;
        h = 1000;
        initialzoom = 1;
        inputonly = false;
        loadimgmsg = "";
        loadrssmsg = "loading Points...";
        locfield = "";
        locupdate = false;
        maximageload = 10;
        maxscale = 64;
        maxzoom = false;
        nightimg = "night.jpg";
        north = 90;
        panc = 16;
        plotinterval = 5000;
        polarimg = "polar.jpg";
        projection = "none";
        resultssince = false;
        roundtextbox = false;
        rssbbox = false;
        rssiconwidth = 20;
        showload = false;
        showonlynew = false;
        singletextfield = false;
        south = -90;
        startdate = new Date();
        startdatefield = "any";
        swftemplatelayer = 1;
        textboxsize = 200;
        textinterval = 5000;
        textsize = 10;
        timenav = false;
        timenavpos = 0;
        timenavunit = 200;
        toolbar = undefined;
        track = false;
        trackcats = false;
        uniqueurls = false;
        update = 60;
        visinterval = 5000;
        w = 1000;
        west = -180;
        zlevel = 1;
        zoomc = 1.5;
        zoomifydir = ".";
        zoomifypreload = false;
        zoomselect = false;

        //Should these get classes? REVISIT
        categories = new Object(); categories._default_ = true;
        gml = new Object();
        gpx = new Object();
        precompile = new Object();
        swflayer = new Object();
        swftemplate = new Object();
        tilemap = new Object();
        wms = new Object();
        dataurl = new Array(); dataurl[0] = "data.xml";
        updateurl = new Array();

        activatecolor = new worldkitConfigCat(0xFF0000);
        fillalpha = new worldkitConfigCat(100);
        icon = new worldkitConfigCat("");
        initialplotcolor = new worldkitConfigCat(0xFF0000);
        linealpha = new worldkitConfigCat(100);
        linecolor = new worldkitConfigCat(0x000000);
        linethickness = new worldkitConfigCat(0);
        plotshape = new worldkitConfigCat("square");
        plotsize = new worldkitConfigCat(3);
        restingplotcolor = new worldkitConfigCat(0x00FFFF);
        window = new worldkitConfigCat("_blank");
        zoomto = new worldkitConfigCat(undefined); //REVISIT test that undefined works as expected

    }


    /*
       load
     */
    public function load():Void {

        var url = new String(this.main.parent._url);
        url = url.substr( url.indexOf('?') + 1 );

        params = new LoadVars();
        params.decode(url);

        if (params.confurl != undefined) {
            confurl = params.confurl;
        }

        if (confurl != "") {
            var config:worldkitConfig = this;
            var loader:XML = new XML();
            loader.ignoreWhite = true;
            loader.onLoad = function(success) { config.onLoad(this,success); };
            if (uniqueurls == true) {
                var d:Date = new Date();
                loader.load( confurl + "?" + Date.UTC(d.getTime()));
            } else {
                loader.load( confurl );
            }
        } else {
            afterLoad();
        }
    }                

    public function onLoad(xml:XML,success:Boolean):Void { 
        var val,i,j,k,node;
        if (success) {
            for (i = 0; i < xml.childNodes.length; i++) {
                if (xml.childNodes[i].nodeName == "worldkitconf") {
                    for (j = 0; j< xml.childNodes[i].childNodes.length; j++) {          
                        //Handle one-level nested config, as well as un-nested tags
                        val = "";          
                        node = xml.childNodes[i].childNodes[j];
                        for (k = 0; k < node.childNodes.length; k++) {
                            if (node.childNodes[k].nodeName == null) {
                                val = val + node.childNodes[k].nodeValue;
                            } else {
                                setConf(node.nodeName, node.childNodes[k].firstChild.nodeValue,
                                        node.attributes, node.childNodes[k].nodeName);
                            }
                        }
                        setConf(node.nodeName, val, node.attributes);
                    }
                }
            }

            afterLoad();
        } else {
            failed = true;
        }
    }



    /*
       setConf
       the switch statement is an actionscript 1.0 relic. could be replaced with type checking REVISIT
     */
    private function setConf( name:String, value, attr:Object, subname:String):Void {     
        value = worldkitUtil.trimWhite(value);
        if (subname == undefined) { 
            subname = "_default_"; 
        } else {
            subname = subname.toLowerCase();
        }

        switch (name) {
            //numeric
            case "textsize":
            case "north":
            case "south":
            case "east":
            case "west":
            case "textboxsize":
            case "maxscale":
            case "initiallat":
            case "initiallong":
            case "controlalpha":
            case "controlscale":
            case "timenavunit":
            case "panc":
            case "zoomc":
            case "maximageload":
            case "timenavpos":
            case "neartime":
            case "rssiconwidth":
            case "fade":
                this[name] = Number(value);
                break;

            //string
            case "dayimg":
            case "nightimg":
            case "dymaximg":
            case "polarimg":
            case "zoomifydir":
            //case "dataurl":
            case "update":
            //case "updateurl":
            case "annotateurl":
            case "locfield":
            case "loadimgmsg":
            case "loadrssmsg":
            case "projection":
            case "startdatefield":
            case "enddatefield":
            case "newitemcallback":
            case "onzoompan":
            case "fadeditemcallback":
            case "onloadcallback":

                this[name] = value;
            break;

            //boolean
            case "showonlynew":
            case "dontstretchimage":
            case "maxzoom":
            case "toolbar":
            case "track":
            case "uniqueurls":
            case "zoomselect":
            case "showload":
            case "ascomponent":
            case "trackcats":
            case "grabber":
            case "singletextfield":
            case "locupdate":
            case "accuplot":
            case "fscommand":
            case "timenav":
            case "resultssince":
            case "rssbbox":
            case "zoomifypreload":
            case "roundtextbox":
            case "zoomifypreload":

                if (value == "true") {
                    this[name] = true;
                } else {
                    this[name] = false;
                }
                break;

            //seconds
            case "plotinterval":
            case "textinterval":
            case "visinterval":

                this[name] = Number(value) * 1000;
                break;

            //categorized

            case "window":
            case "plotshape":
            case "icon":


                this[name][subname] = value;
                break;

            //categorized numeric
            case "zoomto":
            case "linealpha":
            case "fillalpha":
            case "linethickness":
            case "initialplotcolor":
            case "restingplotcolor":
            case "activatecolor":
            case "linecolor":

                this[name][subname] = Number(value);
                break;

            //categorized boolean
            case "visible":
                if (value == "true") {
                    this["categories"][subname] = true;
                } else {
                    this["categories"][subname] = false;
                }
                break;

            //dates
            case "startdate":
            case "enddate":
                this[name] = new Date(worldkitUtil.parseDate(value));
                break;

            case "swflayer":
                if (attr.width != undefined && attr.height != undefined && attr.id != undefined) {
                    this.swflayer[attr.id] = new Object();
                    this.swflayer[attr.id].url = value;
                    this.swflayer[attr.id].h = attr.height;
                    this.swflayer[attr.id].w = attr.width;
                    if (attr.extent != undefined) {
                        this.swflayer[attr.id].extent = attr.extent;
                    }
                    if (attr.minscale != undefined) {
                        this.swflayer[attr.id].minview = attr.minscale;
                    }
                    if (attr.maxscale != undefined) {
                        this.swflayer[attr.id].maxview = attr.maxscale;
                    }
                    if (attr.preload != undefined) {
                        if (attr.preload == "false") {
                            this.swflayer[attr.id].preload = false;
                        }
                    }
                    if (attr.mask != undefined) {
                        if (attr.mask == "true") {
                            this.swflayer[attr.id].mask = true;
                        }
                    }
                    if (attr.category != undefined) {
                        this.swflayer[attr.id].category = attr.category;
                    }
                }
                break;

            case "displaytype":
                this[name] = value;
                if (value == "zoomify") {
                    this.zoomifylayer = this.swftemplatelayer;
                    this.swftemplatelayer = this.swftemplatelayer + 50; //50 is just some too large number
                }
                break;

            case "swftemplate":
                this.swftemplate[ attr.id ] = new Object();
                this.swftemplate[ attr.id ].url = value;
                this.swftemplate[ attr.id ].minscale = attr.minscale;
                this.swftemplate[ attr.id ].maxscale = attr.maxscale;
                this.swftemplate[ attr.id ].minview = attr.minview;
                this.swftemplate[ attr.id ].maxview = attr.maxview;
                this.swftemplate[ attr.id ].extent = attr.extent;
                this.swftemplate[ attr.id ].tilewidth = attr.tilewidth;
                this.swftemplate[ attr.id ].tileheight = attr.tileheight;
                this.swftemplate[ attr.id ].spanx = attr.spanx;
                this.swftemplate[ attr.id ].spany = attr.spany;
                this.swftemplate[ attr.id ].category = attr.category;
                this.swftemplate[ attr.id ].layer = this.swftemplatelayer; this.swftemplatelayer++;
                break;

            case "wms":
                this.wms[ attr.id ] = new Object();
                this.wms[ attr.id ].url = value;
                this.wms[ attr.id ].category = attr.category; //not required
                if (attr.width != undefined) { this.wms[ attr.id ].width = attr.width; }
                if (attr.height != undefined) { this.wms[ attr.id ].height = attr.height; } 
                if (attr.maxtiledeg != undefined) { this.wms[ attr.id ].maxtiledeg = attr.maxtiledeg; }
                if (attr.time != undefined) { this.wms[ attr.id ].time =  new Date(worldkitUtil.parseDate(attr.time)); }
                if (attr.minview != undefined) { this.wms[ attr.id ].minview = attr.minview; }
                if (attr.maxview != undefined) { this.wms[ attr.id ].maxview = attr.maxview; }
                break;

            case "tilemap":
                if (attr.global_profile && attr.global_profile == 1) { //only support global profile for now
                    this.wms[ attr.id ] = new Object();
                    this.wms[ attr.id ].url = value;
                    if (attr.path) {
                        this.wms[ attr.id ].url = this.wms[ attr.id ].url + attr.path;
                    } else {
                        this.wms[ attr.id ].url = this.wms[ attr.id ].url + "ZOOM/XTILE/YTILE.jpg";
                    }
                    if (attr.origin) {
                        this.wms[ attr.id ].origin = attr.origin;
                    } else {
                        this.wms[ attr.id ].origin = "sw";
                    }
                    this.wms[ attr.id ].width = 256;
                    this.wms[ attr.id ].height = 256;
                    this.wms[ attr.id ].maxtiledeg = 180;
                    this.wms[ attr.id ].tilemap = true;
                }   
                break;      

            case "precompile":
                if (attr.id != undefined) {
                    this.precompile[attr.id] = value;
                }
                break;

            case "gml":
                if (attr.id != undefined) {
                    this.gml[ attr.id ] = new Object();
                    this.gml[ attr.id ].url = value;
                }
                break;

            case "gpx":
                if (attr.id != undefined) {
                    this.gpx[ attr.id ] = new Object();
                    this.gpx[ attr.id ].url = value;
                    if (attr.category != undefined) {
                        this.gpx[ attr.id ].cats = attr.category;
                    }
                }
                break;

            case "plotsize":
                if (subname != undefined) {
                    this.plotsize[subname] = Number(value) / 2;
                } else {
                    this.plotsize._default_ = Number(value) / 2;
                }
                break;

            case "initialzoom":
                this.initialzoom = Number(value);
                if (this.initialzoom < 1) { this.initialzoom = 1; }
                break;

            case "inputonly":
                if (value == "true") {
                    this.inputonly = true;
                } else {
                    this.inputonly = false;
                }
                break;

            case "zlevel":
                if (Number(value) < 0) {
                    this.zlevel = -1;
                } else {
                    this.zlevel = 1;
                }
                break;

            case "width":
                this.w = Number(value);
                break;

            case "height":
                this.h = Number(value);
                break;

            case "dataurl":
                // one missing case . if user sets data.xml
                if (this.dataurl[0] == "") {
                } else if (value == "") {
                    this.dataurl = new Array("");
                } else if (this.dataurl.length == 1 && this.dataurl[0] == "data.xml") {
                    this.dataurl[0] = value;
                } else {
                    this.dataurl.push( value);
                }
                break;


            case "updateurl":
                this[name].push( value );
                break;

            default:
        } 
    }

    private function afterLoad():Void {
        processWMSConfig();

        //args passed in on url override config file
        parseArgs();

        if (loadZoomifyConfig()) {
            return; /* waiting for ImageProperties.xml to load, that will signalDone */
        } else {
            loaded = true;
            main.signalDone("CONFIG");
        }
    }

    private function parseArgs():Void {
        for (var i in params) {
            var k, sub = undefined;
            if (i.indexOf(":") != -1) {
                var tmp = i.split(":");
                k = tmp[0];
                sub = tmp[1];
            } else {
                k = i;
            }
            setConf(k,params[i],undefined,sub);
        }
    }

    /*
       <wms> actually creates a series of <swftemplates>
     */
    private function processWMSConfig():Void {
        for (var s in wms) {

            if (wms[ s ].processed) { continue; }

            var start; var end;
            if (wms[ s ].minview != undefined) {
                start = Math.log( wms[ s ].minview ) / Math.log(2);
            } else {
                start = 1;
            }
            if (wms[ s ].maxview == undefined) {
                wms[ s ].maxview = maxscale;
            }
            end = Math.log( wms[ s ].maxview ) / Math.log(2);

            //var l = Math.log( maxscale ) / Math.log( 2 ); //calcs number of levels in pyramid

            for (var i = start; i <= end; i++) {
                var id = s + i.toString();
                swftemplate[ id ] = new Object();
                if (wms[ s ].width != undefined) {
                    swftemplate[id].tilewidth = wms[ s ].width; 
                } else {
                    swftemplate[id].tilewidth = w;
                }
                if (wms[ s ].height != undefined) {
                    swftemplate[id].tileheight = wms[ s ].height; 
                } else {
                    swftemplate[id].tileheight = h;
                }
                if (wms[ s ].tilemap) {
                    swftemplate[ id ].url = wms[ s ].url;
                    swftemplate[ id ].origin = wms[ s ].origin;
                    swftemplate[ id ].tilemap = true;
                } else if ( wms[ s ].genemap ){
                    swftemplate[ id ].url = wms[ s ].url + "&width=" + swftemplate[id].tilewidth + "&height=" + swftemplate[id].tileheight + "&xmin=WEST&xmax=EAST";
                    swftemplate[ id ].genemap = true;
                } else {
                    swftemplate[ id ].url = wms[ s ].url + "&width=" + swftemplate[id].tilewidth + "&height=" + swftemplate[id].tileheight + "&bbox=WEST,SOUTH,EAST,NORTH";
                }
                swftemplate[ id ].minscale = Math.pow(2, (i-1));
                swftemplate[ id ].maxscale = wms[ s ].maxview;
                swftemplate[ id ].minview = i / 2; //BUG??
                swftemplate[ id ].maxview = wms[ s ].maxview;

                if (wms[ s ].maxtiledeg) { //can actually assume maxtiledeg for default and calc REVISIT
                    var tiledeg = wms[ s ].maxtiledeg / swftemplate[ id ].minscale;
                    swftemplate[ id ].spanx = Math.ceil( (east - west ) / tiledeg );
                    swftemplate[ id ].spany = Math.ceil( (north - south) / tiledeg );
                    swftemplate[ id ].extent = west + "," + (90 - (tiledeg * swftemplate[ id ].spany)) + "," + (-180 + (tiledeg * swftemplate[ id ].spanx)) + "," + north; /* BUG HERE in extent?? */
                } else {
                    swftemplate[ id ].extent = west + "," + south + "," + east + "," + north;
                    swftemplate[ id ].spanx = Math.pow(2, (i-1));
                    swftemplate[ id ].spany = Math.pow(2, (i-1));
                }
                swftemplate[ id ].category = wms[ s ].category;
                swftemplate[ id ].time = wms[ s ].time;
                swftemplate[ id ].layer = swftemplatelayer; swftemplatelayer++;
            }

            wms[ s ].processed = true;
        }
    }

    private function loadZoomifyConfig():Boolean {
        if (displaytype == "zoomify") {
            if (zoomifydir.charAt(zoomifydir.length-1) != "/") { zoomifydir = zoomifydir + "/"; }
            displaytype = "day";
            dayimg = "";
            var config:worldkitConfig = this;
            var loader:XML = new XML();
            loader.ignoreWhite = true;
            loader.onLoad = function(success) { config.onZoomifyConfig(this,success); };
            loader.load( zoomifydir + "ImageProperties.xml" ); 

            if (toolbar == undefined) {
                toolbar = true;
            }
            return true;
        } else {
            return false;
        }
    }

    public function onZoomifyConfig(xml:XML,success:Boolean):Void { 
        var val,i,node;
        var zoomwidth, zoomheight, tilesize;
        if (success) {
            for (i = 0; i < xml.childNodes.length; i++) {
                if (xml.childNodes[i].nodeName == "IMAGE_PROPERTIES") {
                    node = xml.childNodes[i];
                    zoomwidth = node.attributes["WIDTH"];
                    zoomheight = node.attributes["HEIGHT"];
                    tilesize = node.attributes["TILESIZE"];    
                }
            }

            var levelwidth = zoomwidth;
            var levelheight = zoomheight;
            while (((levelwidth / 2) > tilesize) || ((levelheight / 2) > tilesize)) {
                levelwidth = levelwidth / 2;
                levelheight = levelheight / 2;
            }
            var level = 1;

            var usewidth;
            var useheight;
            var spanx, spany;
            var id;
            var wklevel = 1;
            var tilecount = 1;      
            var tiledegw;
            var tiledegh;


            dayimg = zoomifydir + "/TileGroup0/0-0-0.jpg";

            while ((levelwidth <= zoomwidth) && (levelheight <= zoomheight)) {

                usewidth = levelwidth; //Math.floor(levelwidth);
                useheight = levelheight; //Math.floor(levelheight);
                spanx = Math.ceil( usewidth / tilesize);
                spany = Math.ceil( useheight / tilesize);
                tiledegw = tilesize * (east - west) / usewidth;
                tiledegh = tilesize * (north - south)  /useheight;

                if (levelwidth >= this.w && levelheight >= this.h) {

                    id = "zoomify" + level;         
                    swftemplate[ id ] = new Object();
                    swftemplate[ id ].tilewidth = tilesize;
                    swftemplate[ id ].tileheight = tilesize;
                    swftemplate[ id ].url = zoomifydir;
                    swftemplate[ id ].zoomify = level;
                    swftemplate[ id ].tilecount = tilecount;
                    if (this.zoomifypreload) {
                        swftemplate[ id ].minscale = Math.pow(2, (wklevel - 2));
                    } else {
                        swftemplate[ id ].minscale = Math.pow(2, (wklevel - 1));
                    }
                    swftemplate[ id ].maxscale = maxscale;
                    swftemplate[ id ].minview = Math.pow(2, (wklevel - 2));
                    swftemplate[ id ].maxview = maxscale;
                    swftemplate[ id ].spanx = spanx;
                    swftemplate[ id ].spany = spany;
                    swftemplate[ id ].extent = west + "," + (north - (tiledegh * spany)) + "," + (west + (tiledegw * spanx)) + "," + north;
                    swftemplate[ id ].category = "zoomify";
                    swftemplate[ id ].layer = this.zoomifylayer; this.zoomifylayer++;

                    wklevel++;
                }

                levelwidth = levelwidth * 2;
                levelheight = levelheight * 2;
                level++;

                tilecount = tilecount + ( spanx * spany ); 
            }
        }
        loaded = true;
        main.signalDone("CONFIG");  
    }


    public function getConfBySubject(option:String,cats:Array) {
        for (var i=0; i<cats.length; i++) {
            if (this[ option ][ cats[i] ] != undefined && this[ option ][ cats[i] ] != "") {
                return this[ option ][ cats[i] ];
            }
        }   
    }
    public function getMatchingSubject(option:String, cats:Array) {
        for (var i=0; i<cats.length; i++) {
            if (this[ option ][ cats[i] ] != undefined && this[ option ][ cats[i] ] != "") {
                return cats[i];
            }
        }
    }

    public function addNewWMS(args) {
        this.wms[ args.id ] = args;
        processWMSConfig();
    }
}
