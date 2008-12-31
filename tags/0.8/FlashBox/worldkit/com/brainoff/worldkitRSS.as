/*
worldkitRSS: loads and parses RSS feed, creates and manages annotations
 */

import com.brainoff.worldkitMain;
import com.brainoff.worldkitConfig;
import com.brainoff.worldkitImages;
import com.brainoff.worldkitInteraction;
import com.brainoff.worldkitUtil;
import com.brainoff.worldkitAnnotation;

class com.brainoff.worldkitRSS {
    private var main:worldkitMain;
    private var conf:worldkitConfig;
    private var img:worldkitImages;
    private var interact:worldkitInteraction;
    private var mc:MovieClip;

    private var Points:Object;
    private var activeAnnotation:worldkitAnnotation; 
    private var depth:Number;
    private var plotCount:Number;
    private var prevlat:Object;
    private var prevlon:Object;
    private var lastRequest:String;
    private var intervalId:Number;

    function worldkitRSS(main:worldkitMain) {
        this.main = main;

        Points = new Object();
    }
    public function createDataLayer() {
        main.parent.createEmptyMovieClip("worldkitDatalayer",3);
        mc = main.parent.worldkitDatalayer;
        mc.lineTo(-1,-1);
        mc.origwidth = conf.w;
        mc.origheight = conf.h;
        mc.layers = new Array();

        if (conf.zlevel == 1) {
            depth = 1;
        } else {
            depth = 10000;
        }
    }

    public function start() {
        conf = main.getConfig();
        img = main.getImages();
        interact = main.getInteract();

        createDataLayer();

        mc.createEmptyMovieClip("rss",20);
        mc.rss.origwidth = conf.w;
        mc.rss.origheight = conf.h;
        mc.layers.push("rss"); //the mc shouldn't be holding this REVISIT
        if (conf.accuplot != true) {
            interact.scaleAndPosition(mc.rss); 
        }

        if (conf.track && conf.trackcats) {
            mc.rss.createEmptyMovieClip("tracks",depth);
            depth = depth + conf.zlevel;
            mc.rss.tracks.tracklayer = 1;
        }

        if (conf.dataurl.length > 0) {
            loadData(conf.dataurl);
            if (conf.updateurl.length == 0) {
                conf.updateurl = conf.dataurl;
            }
            if (conf.update > 0) {
                intervalId = setInterval( this, "loadData", conf.update * 1000, conf.updateurl); 
            }
            interact.LoadingDialog(conf.loadrssmsg);
        }   
        if (conf.fade != -1) {
            var freq = 60000;
            if (conf.fade < 60) {
                freq = conf.fade * 1000;
            }
            setInterval( this, "setAlphaFade", freq);
        }
    }

    public function loadData(urlArray:Array):Void {
        for (var i=0; i<urlArray.length; i++) {
            var url:String = urlArray[i];
            if (conf.resultssince == true  && lastRequest != undefined) {
                if (url.indexOf("?") == -1) { url = url + "?"; }
                url = url + "&lastRequest=" + lastRequest;
                //var age = Math.ceil(conf.update / 60000);
                //url = url + "&age=" + age.toString(); //age is mc specific....
            }
            if (conf.rssbbox == true) {
                if (url.indexOf("?") == -1) { url = url + "?"; }
                var bbox = interact.cwest + "," + interact.csouth + "," + interact.ceast + "," + interact.cnorth;
                url = url + "&bbox=" + bbox;

            }   
            if (conf.uniqueurls == true) {
                var d = new Date();
                if (url.indexOf("?") == -1) { url = url +"?"; }
                url = url + "&" + d.getTime();
            }
            var rss:worldkitRSS = this;
            var loader:XML = new XML();
            loader.ignoreWhite = true;
            loader.onLoad = function(success):Void {
                rss.onLoad(this,success);
            }
            var now = new Date();
            lastRequest = worldkitUtil.dateToString(now); //set to now
            loader.load(url);
        }
    }

    public function onLoad(xml:XML, success:Boolean):Void {
        if (! success) {
            return;
        }

        if (conf.showonlynew == true) {
            for (var p in Points) {
                Points[p].present = false;  
            }
        }

        plotCount = 0; 
        prevlat = new Object(); 
        prevlon = new Object();

        for (var i = 0; i < xml.childNodes.length; i++) {
            if (xml.childNodes[i].nodeName == "rss") { 
                parseRss(xml.childNodes[i]);
            } else if (xml.childNodes[i].nodeName == "rdf:RDF") {
                parseRdf(xml.childNodes[i]);
            } else if (xml.childNodes[i].nodeName == "feed") {
                parseAtom(xml.childNodes[i]);
            }
        }

        if (conf.maxzoom == true) {
            interact.doMaxZoom();
        }

        if (conf.showonlynew == true) {
            for (var p in Points) {
                if (Points[p].present == false) {
                    Points[p].clear();
                    delete Points[p];
                }
            }
        }
        interact.LoadingDialog();

    }

    private function parseRss(node:XMLNode):Void {

        for (var j = 0; j < node.childNodes.length; j++) {
            if (node.childNodes[j].nodeName == "channel") {

                for (var k = 0; k < node.childNodes[j].childNodes.length; k++) {
                    if (node.childNodes[j].childNodes[k].nodeName == "item") {
                        parseItem( node.childNodes[j].childNodes[k]);
                    }
                }

            }
        }
    }
    private function parseRdf(node:XMLNode):Void {
        for (var j = 0; j < node.childNodes.length; j++) {
            if (node.childNodes[j].nodeName == "item") {
                parseItem( node.childNodes[j]);

            } else if (node.childNodes[j].nodeName == "rdf:Bag") {
                for (var k = 0; k < node.childNodes[j].childNodes.length; k++) {
                    if (node.childNodes[j].childNodes[k].nodeName == "rdf:li") {
                        for (var l = 0; l < node.childNodes[j].childNodes[k].childNodes.length; l++) {
                            if (node.childNodes[j].childNodes[k].childNodes[l].nodeName == "geo:SpatialThing") {
                                parseItem( node.childNodes[j].childNodes[k].childNodes[l]);
                            }
                        }
                    }
                }

            }
        }
    }
    private function parseAtom(node:XMLNode):Void {
        for (var j = 0; j < node.childNodes.length; j++) {
            if (node.childNodes[j].nodeName == "entry") {
                parseItem( node.childNodes[j]);
            }
        }
    }

    private function parseItem(node:XMLNode):Void {
        var e="", n="", u="", g="", lat="", lon="", v="", photo="", id="", nv="", nn=n, attr="", dt=undefined, edt=undefined, list:String=undefined, type="", icon=undefined;
        var sub=new Array();

        for (var l = 0; l < node.childNodes.length; l++) {
            nn = node.childNodes[l].nodeName;
            nv = node.childNodes[l].firstChild.nodeValue;
            if (nn == "summary" && nn == "content" && nv.length == null) {
                nv = node.childNodes[l].toString();
            }
            //  if (nv == undefined) { continue; }
            attr = node.childNodes[l].attributes;

            switch (nn.toLowerCase()) {
                case ("title"):
                case ("dc:title"):
                        n = nv; //REVISIT bug -- won't take non-roman characters -- why?
                    break;
                case ("link"):
                    if (attr.href != undefined) { //Atom
                        u = attr.href;
                    } else {
                        u = nv;
                    }
                    break;
                case ("description"):
                case ("summary"): //Atom
                case ("content"): //Atom
                    if ((conf.locfield == "any" || conf.locfield == "description" || conf.locfield == "summary" || conf.locfield == "content") && nv != undefined) {
                        if (nv.indexOf("geo:lat=") != -1) {
                            var b = nv.indexOf("geo:lat=");
                            lat = parseFloat(nv.substr(b+8));
                            if (lat == NaN) { lat = ""; }
                        } 
                        if (nv.indexOf("geo:long=") != -1) {
                            var b = nv.indexOf("geo:long=");
                            lon = parseFloat(nv.substr(b+9));
                            if (lon == NaN) { lon = ""; }
                        } 
                        if (nv.indexOf("geo:lon=") != -1) {
                            var b = nv.indexOf("geo:lon=");
                            lon = parseFloat(nv.substr(b+8));
                            if (lon == NaN) { lon = ""; }
                        }
                    }
                    v = nv;
                    break;
                case ("icbm:lat"):
                case ("icbm:latitude"):
                case ("geo:lat"):
                case ("geourl:latitude"): //not necessary any more
                    lat = parseFloat(nv);
                    break;
                case ("icbm:lon"):
                case ("icbm:longitude"):
                case ("geo:lon"):
                case ("geo:long"):
                case ("geourl:longitude"):
                    lon = parseFloat(nv);
                    break;
                case ("geo:polygon"):
                    list = nv;
                    type = "poly";
                    break;
                case ("geo:line"):
                    list = nv;
                    type = "line";
                    break;
                case ("geo:point"):
                    for (var m = 0; m < node.childNodes[l].childNodes.length; m++) {
                        nn = node.childNodes[l].childNodes[m].nodeName;
                        //nn = nn.toLowerCase();
                        nv = node.childNodes[l].childNodes[m].firstChild.nodeValue;
                        if (nn == "geo:lat") { lat = parseFloat(nv); }
                        else if (nn == "geo:long") { lon = parseFloat(nv); }
                    }
                    break;
                case("georss:point"):
                    nv = worldkitUtil.myreplace(nv,',',' ');
                    //nv.replace(this.regexws,' ');
                    var listtmp = nv.split(' ');
                    lat = parseFloat(listtmp[0]);
                    lon = parseFloat(listtmp[1]);
                    break;
                case("georss:line"):
                    list = nv;
                        type = "line";
                    break;
                case("georss:polygon"):
                    list = nv;
                    type = "poly";
                    break;
                case("georss:box"):
                    list = nv;
                    type = "box";
                    break;
                case("georss:where"):
                    if (node.childNodes[l].firstChild.nodeName == "gml:Point") {
                        nv = node.childNodes[l].firstChild.firstChild.firstChild.nodeValue;
                        //nv.myreplace(',',' ');
                        //nv.replace(this.regexws,' ');
                        var listtmp = nv.split(' ');
                        lat = parseFloat(listtmp[0]);
                        lon = parseFloat(listtmp[1]);       
                    } else if (node.childNodes[l].firstChild.nodeName == "gml:LineString") {
                        list = node.childNodes[l].firstChild.firstChild.firstChild.nodeValue;
                        type = "line";
                    } else if (node.childNodes[l].firstChild.nodeName == "gml:Polygon") {
                        list = node.childNodes[l].firstChild.firstChild.firstChild.firstChild.firstChild.nodeValue;
                        type = "poly";
                    } else if (node.childNodes[l].firstChild.nodeName == "gml:Envelope") {
                        list = node.childNodes[l].firstChild.childNodes[0].firstChild.nodeValue + " " + node.childNodes[l].firstChild.childNodes[1].firstChild.nodeValue;
                        type = "box";
                    }
                    break;
                case ("dc:subject"):
                case ("category"): //RSS 2.0
                        //geo tags can be shoved in here, as last resort
                    var a = nv.split(" ");
                    for (var b in a) {
                        if (conf.locfield == "any" || conf.locfield == "dc:subject" || conf.locfield == "category") {
                            if (a[b].indexOf("geo:lat=") != -1) {
                                lat = a[b].substr( a[b].indexOf("geo:lat=") + 8);
                            } else if (a[b].indexOf("geo:long=") != -1) {
                                lon = a[b].substr( a[b].indexOf("geo:long=") + 9);
                            } else if (a[b].indexOf("geo:lon=") != -1) {
                                lon = a[b].substr( a[b].indexOf("geo:lon=") + 8);
                            } else {
                                sub.push(a[b].toLowerCase());
                            }
                        } else {
                            sub.push(a[b].toLowerCase());
                        }
                    }
                    break;
                case("id"): //Atom
                case("guid"): //RSS 2.0
                case("dc:identifier"): //RSS 1.0
                    id = nv;
                    break;
                case ("photo:thumbnail"):
                    photo = nv;
                    break;
                case("media:content"):
                    if (attr.url != undefined) {
                        photo = attr.url;
                    }
                    break;
                case("media:icon"):
                    icon = nv;
                    break;
                case("media:thumbnail"):
                    if (attr.url != undefined) {
                        icon = attr.url;
                    }
                    break;
                case("pubdate"): //RSS 2.0
                case("issued"): //Atom 0.3
                case("updated"): //Atom 1.0
                case("dc:date"): //RSS 1.0
                case("ev:startdate"): //for consistency
                case("xcal:dtstart"):
                    if (conf.startdatefield == "any" || conf.startdatefield == nn.toLowerCase()) {
                        dt = nv;
                    }
                    break;
                case("ev:enddate"): //RSS 1.0 module
                    if (conf.enddatefield == "any" || conf.enddatefield == nn.toLowerCase()) {
                        edt = nv;
                    }
                    break;
                case("metacarta:geoextract"):
                    v = v + "<br/><font color='#ff0000'>" + nv + "</font>";
                    break;
                default:
            }
        }

        if (list != undefined) {
            list = worldkitUtil.myreplace(list,',',' ');
            //  list.replace(this.regexws,' '); //REVISIT want to remove all whitespace
        }

        if (lat != "" && lon != "") {
            g = lat + "," + lon;
        } else if (list != "") {
            var listtmp = list.split(" ");
            lat = listtmp[0]; lon = listtmp[1];
            g = lat + "," + lon;
        }


        //reshape annotation structure
        //so that it is readdressable in the same feed
        //and not dependent on g

        if (id == "") { 
            id = g + ":" + n + ":" + v + ":" + u + ":" + sub.toString();
        }

        for (var s in sub) { //REVISIT belongs in interact
            if (conf.categories[sub[s]] == undefined) {
                conf.categories[sub[s]] = true;
            }
        }
        sub.push("_default_");

        if ((g != "" && interact.pointOnMap(lat,lon)) || (Points[id] != undefined) || (type != "")) {
            if (Points[id] == undefined) {
                var plat,plon;
                if (conf.trackcats) { //REVISIT -- prevlat not setup to be dynamically object or number
                    plat = prevlat[ sub[0] ];
                    plon = prevlon[ sub[0] ];
                } else {
                    plat = prevlat['_default_'];
                    plon = prevlon['_default_'];
                }

                Points[id] = new worldkitAnnotation(main,mc.rss,depth,n,u,lat,lon,v,sub,id,photo,plat,plon,list,type,dt,undefined,edt,icon);

                if (conf.plotinterval == 0) {
                    Points[id].plot();
                } else {
                    worldkitUtil.setTimeout(Points[id],"plot",conf.plotinterval * plotCount);
                }

                depth = depth + conf.zlevel;
                plotCount++;

                if (conf.maxzoom) {
                    if (type == "poly" || type == "line") {
                        var varray = list.split(" ");
                        for (var i=0; i<varray.length-1; i+=2) {
                            interact.recordExtremes(varray[i],varray[i+1]);
                        }
                    } else {
                        interact.recordExtremes(lat,lon);
                    }
                }
                //record time extremes?

            } else if (Points[id].changed(n,u,lat,lon,v,sub,photo,list,type,dt)) { //REVISIT working??

                Points[id].clearMC();
                Points[id].setparams();
                Points[id].plot();
            }

            Points[id].present = true;

            if (conf.trackcats) {
                prevlat[ sub[0] ] = lat;
                prevlon[ sub[0] ] = lon;
            } else {
                prevlat._default_ = lat;
                prevlon._default_ = lon;
            }
        }
    }    

    public function clear() {
        for (var p in Points) {
            Points[p].clear();
            delete Points[p];
        }
        mc.rss.clear();
    }

    public function inputToggle(inputon:Boolean) {
        if (inputon) {
            mc._visible = false;
        } else {
            mc._visible = true;
        }
    }

    public function Pan():Void {
        if (conf.accuplot != true) {
            for (var l in mc.layers) {
                //accurate -- instead add in loop to reposition each point
                interact.scaleAndPosition(mc[ mc.layers[l] ],undefined);
            }
        } else {
            for (var pp in Points) {
                var p = Number(pp);
                Points[p].setLoc();
                if (conf.track) { //in accuplot, set track every time loc is updated
                    if (p == 0) {
                        Points[p].tracks();
                    } else {
                        Points[p].tracks(Points[p-1].mc[ Points[p-1].clipname]._x, Points[p-1].mc[ Points[p-1].clipname]._y);
                    }
                }
            }
        }
    }

    public function Zoom():Void {
        //accurate -- this wouldn't be necessary if set
        if (conf.accuplot != true) {
            for (var p in Points) {
                var point = Points[p];
                var ratio = conf.w / conf.h; 
                var rescale = 100/interact.scale;
                //should have each point do this REVISIT
                if (point.vector == undefined && point.precompile != true) {
                    point.mc[ point.clipname ]._xscale = rescale;
                    point.mc[ point.clipname ]._yscale = rescale;
                }
                point.mc[ point.textname ]._xscale = rescale;
                point.mc[ point.textname ]._yscale = rescale;


                if (point.mc[ point.textname ].leftpos) {
                    point.mc[ point.textname ]._x = point.x - (conf.textboxsize / interact.scale);
                }
                if (point.mc[ point.textname ].bottompos) {
                    point.mc[ point.textname ]._y = point.y - (50 / interact.scale);
                }
            }
        }
    }

    public function setVisible(showAnnotation:Boolean):Void {
        for (var p in Points) {
            if (showAnnotation == true) {
                Points[p].setVisible(false,conf.textinterval);
            } else {
                Points[p].setVisible(false);
            }
        }

        /* this used to be called from worldkitAnnotationClass -- REVISIT */
        if (conf.track && conf.trackcats) {
            for (var c in conf.categories) {
                if (mc.rss.tracks[ c ] != undefined) {
                    mc.rss.tracks[ c ]._visible = conf.categories[ c ];
                }
            } 
        }
    }

    public function setAlphaFade():Void {
        var now:Date = new Date();
        var tmpPoints = new Object();
        for (var p in Points) {
            Points[p].setAlphaFade(now);
            if (Points[p].curralpha == -1) {
                Points[p].clear();
                delete Points[p];
            } else {
                tmpPoints[p] = Points[p];
            }
        }
        Points = tmpPoints;
    }

    public function setActive(nowActive:worldkitAnnotation):Void {
        var a = activeAnnotation;
        a.hidetext();
        activeAnnotation = nowActive;
    }

    public function onJComm(id:String):Void {
        if (Points[ id ] != undefined) {
            var p = Points[ id ];
            if (p.mc[ p.clipname ]._visible == 1) { 
                p.mc[ p.clipname ].onRollOver();
                worldkitUtil.setTimeout(p,"hidetext",conf.visinterval);
            }
        }
    }
    public function onJSubComm(subj:String):Void {
        subj = subj.toLowerCase();
        for (var p in Points) {
            var point = Points[p];
            if (point.mc[ point.clipname ]._visible == 1) {
                for (var s in point.cats) {
                    if (subj == point.cats[s]) {
                        point.showtext(false);
                        worldkitUtil.setTimeout(point,"hidetext",conf.visinterval);
                        break;
                    }
                }
            }
        }
    }
    public function onJActComm(subj:String):Void {
        for (var p in Points) {
            Points[p].setActivate(subj);
        }
    }
    public function onJItemActComm(id:String):Void {
        Points[id].forceActivate();
    }
    public function onJLoadComm(action:String):Void {
        if (action == "updateurl") {
            loadData(conf.updateurl);
            interact.LoadingDialog(conf.loadrssmsg);
        } else if (action == "dataurl") {
            loadData(conf.dataurl);
            interact.LoadingDialog(conf.loadrssmsg);
        } else if (action == "clear") {
            clear();
        } else if (action != "") {
            conf.updateurl = Array(action);
            if (conf.update > 0) {
                if (intervalId) {
                    clearInterval(intervalId);
                }   
                intervalId = setInterval( this, "loadData", conf.update * 1000, conf.updateurl);
            }
            loadData(conf.updateurl);
            interact.LoadingDialog(conf.loadrssmsg);
        }
    }
    public function onJRSSComm(xml:String):Void {
        var rss:worldkitRSS = this;
        var loader:XML = new XML();
        loader.ignoreWhite = true;
        loader.onLoad = function(success):Void {
            rss.onLoad(this,success);
        }
        loader.parseXML(xml);
        loader.onLoad(true);
    }
    public function onJGetItemComm(id:String):Void {
        if (Points[ id ] != undefined) {
            Points[id].GetItem();
        }
    }
}
