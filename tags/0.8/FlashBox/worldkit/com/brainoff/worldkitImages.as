
import com.brainoff.worldkitMain;
import com.brainoff.worldkitConfig;
import com.brainoff.worldkitInteraction;
import com.brainoff.worldkitUtil;

//import flash.display.*;

class com.brainoff.worldkitImages {
    static private var imagemc:MovieClip;
    static private var layer:Number;

    private var main:worldkitMain;
    private var conf:worldkitConfig;
    private var interact:worldkitInteraction;

    private var imglist:Object;
    private var loadinglist:Object;
    private var imagesLoading:Number;
    private var startLoading:Number;
    private var loaderId:Number;

    public function worldkitImages(main:worldkitMain) {
        this.main = main;

        /* 
           create a main level holding mc for all images
           perhaps best to have a main level method for allocating movie clips, levels REVISIT
         */
        main.parent.createEmptyMovieClip("worldkitImages",1);
        imagemc = main.parent.worldkitImages;

        layer = 1;
        imagesLoading = 0;
        startLoading = 0;
        loaderId = -1;
        imglist = new Object();
        loadinglist = new Object();
        loadinglist.size = 0;

    }

    public function load():Void {
        conf = main.getConfig();
        interact = main.getInteract();

        /*
           Load by displaytype. This is a relic structure, 
           since there's many ways to load images now (wms, etc)
           displaytype should be deprecated sooner or later 
           and all these ways of loading and modelling images refactored //REVISIT
         */
        switch (conf.displaytype) {
            case("day"):
                if ((conf.dayimg).length > 0) { /* 0 length dayimg indicates don't load one */
                    loadImage(imagemc, "day", conf.dayimg, layer, "", 1, 0, undefined, undefined, undefined, true);
                    layer++;
                }
                break;
            case("daynight"):
                loadImage(imagemc, "day", conf.dayimg, layer+1, "Mask", 1, 0, undefined, undefined, undefined, true);
                loadImage(imagemc, "night", conf.nightimg, layer, "",1,0, undefined, undefined, undefined, true);
                layer += 3; //+=3 because mask mc is created layer, should just create here REVISIT
                break;

            case("dymax"): //No one is using dymax, deprecate REVISIT
                loadImage(imagemc, "dymax", conf.dymaximg, layer, "", 1, 0, undefined, undefined, undefined, true);
                layer++;
                break;
            case("polar"): //slighty more useful than dymax but REVISIT
                loadImage(imagemc, "polar", conf.polarimg, layer, "", 1, undefined, undefined, undefined, undefined, true);
                layer++;
                break;
        }

        /*
           preload in the icons used by RSS annotations
         */
        for (var s in conf.icon) {
            if (conf.icon[s] != "") {
                loadImage(imagemc,"icon" + s, conf.icon[s], layer, "MakeInvisible",0,1, undefined, undefined, undefined, true);
                layer++;
            }
        }

        /*
swftemplate: a way to specify a tiling on a single level
this should be our base representation of images -- a single image is a special case of tiling
         */
        var l=0;
        for (var s in conf.swftemplate) {
            imagemc.createEmptyMovieClip(s, layer + conf.swftemplate[s].layer);
            conf.swftemplate[ s ].mc_created = true;
        } 
        layer += conf.swftemplatelayer;

        //	checkSwfTemplate();

        /*
           swflayer can actually load in any type of image
           with additional positioning parameters
         */
        for (var swf in conf.swflayer) {
            if (conf.swflayer[swf].preload != false && conf.swflayer[swf].fromtemplate != true) { //need to save layer level if not preload
                loadImage(imagemc, "swflayer" + swf, conf.swflayer[swf].url, layer, "AdjustSwf", 0,1, conf.swflayer[swf].w, conf.swflayer[swf].h, conf.swflayer[swf].extent, true);
                layer++;
            }
            conf.swflayer[swf].parent = imagemc;
        }


        if (startLoading == 0) {
            main.signalDone("IMAGES");
        }
    }


    /*
       load a single image into worldKit, and rectify
     */
    private function loadImage(mc:MovieClip, id:String, url:String, level:Number, callback:String, resize:Number, bg:Number, width:Number, height:Number, extent:String,start:Boolean):Void {

        addLoading(mc,id,url,level,callback,resize,bg,width,height,extent,start);

        mc.createEmptyMovieClip(id, level);
        //if (bg == 1) {
        mc[ id ]._alpha = 0;
        //}

        MovieClipLoaderFix(mc._name + ":" + id);
        //var image_mcl:MovieClipLoader = new MovieClipLoader();
        //image_mcl.addListener(this);
        //image_mcl.loadClip(url, mc[ id ]);

        imageDialog();
    }

    /*
       Keep record of parameters for loading image
       Can't be stored in the MovieClip itself, since that is overwritten by the loaded image
     */
    private function addLoading(mc:MovieClip, id:String, url:String, level:Number, callback:String, resize:Number, bg:Number, width:Number, height:Number, extent:String,start:Boolean):Void {
        var key:String = mc._name + ":" + id;
        imglist[ key ] = new Object();
        imglist[ key ].mc = mc;
        imglist[ key ].id = id;
        imglist[ key ].url = url;
        imglist[ key ].level = level;
        imglist[ key ].callback = callback;
        imglist[ key ].resize = resize;
        imglist[ key ].bg = bg;
        imglist[ key ].width = width;
        imglist[ key ].height = height;
        imglist[ key ].extent = extent;
        imglist[ key ].starttime = new Date();
        imglist[ key ].start = start;

        imagesLoading++;
        if (start == true) startLoading++;
    }

    private function MovieClipLoaderFix(key:String):Void {
        var mc = imglist[ key ].mc;
        mc[ imglist[key].id ].loadMovie( imglist[ key ].url );

        loadinglist[ key ] = true;
        loadinglist.size++;
        if (loaderId == -1) {
            var i = 250;
            loaderId = setInterval( this, "MovieClipLoaderInterval", i );
        }
    }

    public function MovieClipLoaderInterval():Void {
        var key;
        for (key in loadinglist) {
            if (key == "size") { continue; }
            var mc = imglist[ key ].mc[ imglist[key].id ];
            var bl = mc.getBytesLoaded();
            var bt = mc.getBytesTotal();
            var w = mc._width;
            var h = mc._height;
            if (bt > 0 && bl >= bt && w > 0 && h > 0) {
                delete loadinglist[ key ];
                loadinglist.size--;
                if (loadinglist.size == 0) {
                    clearInterval( loaderId );
                    loaderId = -1;
                }

                onLoadInit(mc);
            }
        }
    }

    /*
       Callback on loaded image
     */
    public function onLoadInit(target_mc:MovieClip):Void {
        var key:String = target_mc._parent._name + ":" + target_mc._name;
        /* var parent = target_mc._parent;
           var name = target_mc._name;
           var level = target_mc.getDepth();
           var myBitmap = new BitmapData(target_mc._width, target_mc._height, true, 0x00ffffff);
           myBitmap.draw(target_mc);
           removeMovieClip(target_mc);
           parent.createEmptyMovieClip(name, level);
           target_mc.attachBitmap(myBitmap, 1, "never", true); */

        target_mc.loaded = true;

        if (conf.dontstretchimage) {
            target_mc.origwidth = conf.w;
            target_mc.origheight = conf.h;
        } else {
            if (imglist[key].width != undefined) {
                target_mc.origwidth = imglist[key].width;
            } else {
                target_mc.origwidth = target_mc._width;
            }
            target_mc.actualwidth = target_mc._width;

            if (imglist[key].height != undefined) {
                target_mc.origheight = imglist[key].height;
            } else {
                target_mc.origheight = target_mc._height;
            }
            target_mc.actualheight = target_mc._height;
        }

        if (imglist[key].resize == 1) {
            interact.scaleAndPosition(imglist[key].mc, imglist[key].id, imglist[key].extent);
        }

        if (imglist[key].callback != "") {
            this[ imglist[key].callback ].apply(this, [imglist[key].mc, imglist[key].id]);
        }

        if (! imglist[key].bg) {
            target_mc._alpha = 100;
        }

        imagesLoading--;
        imageDialog();

        if (imglist[key].start) {
            startLoading--;
            if (startLoading == 0) {
                main.signalDone("IMAGES");
            }
        }
    }

    public function onLoadError(target_mc:MovieClip):Void {
        var key:String = target_mc._parent._name + ":" + target_mc._name;

        /*
           if (imglist[key].start) {
           startLoading--;
           if (startLoading == 0) {
           main.signalDone("IMAGES");
           }
           }
         */

        delete imglist[key];

        interact.LoadingDialog("Could not load " + target_mc._name);
        target_mc.removeMovieClip();
        imagesLoading--;

    }

    private function imageDialog():Void {
        if (imagesLoading == 0) {
            interact.LoadingDialog();
        } else if (conf.loadimgmsg.length > 0) {
            interact.LoadingDialog(conf.loadimgmsg);
        } else if (imagesLoading == 1) {
            interact.LoadingDialog("1 Image Loading");
        } else if (imagesLoading > 1) {
            interact.LoadingDialog(String(imagesLoading) + " Images Loading");
        }
    }

    /* 
       Callbacks on image load 
     */

    public function Mask(mc:MovieClip, id:String):Void {
        var maskname = id + "Masker";
        mc.createEmptyMovieClip(maskname, mc[id].getDepth+1);
        mc[id].setMask(mc[maskname]);
        sino(mc, id, maskname);	
        setInterval(this,"sino",60000,mc,id,maskname); //Update mask every minute
    }


    public function MakeInvisible(mc:MovieClip, id:String):Void {
        mc[id]._visible = 0;
    }

    public function AdjustSwf(mc:MovieClip, id:String):Void {
        var confid = id.substr(8);

        if (conf.swflayer[confid].mask == true) {
            if (mc[ id ].masker == undefined) {
                mc[ id ].createEmptyMovieClip( "masker", 0);
                //parent[ swf ].setMask( parent[ swf ].mask );
                mc[ id ].masker.moveTo(0,0);
                mc[ id ].masker.beginFill(0x000000);
                mc[ id ].masker.lineTo(0, conf.swflayer[confid].h);
                mc[ id ].masker.lineTo(conf.swflayer[confid].w, conf.swflayer[confid].h);
                mc[ id ].masker.lineTo(conf.swflayer[confid].w, 0);
                mc[ id ].masker.lineTo(0,0);
                mc[ id ].masker.endFill();
            }
            var clip = mc[ id ];
            clip.setMask( clip[ "masker"] );
        }
        interact.scaleAndPosition(mc, id, conf.swflayer[confid].extent, true);
        mc[ id ]._alpha = 100;

        if (isSwfVisible(mc,id)) {
            //setTimeNavAlpha(mc,id);
            mc[ id ]._visible = true;
        } else {
            mc[ id ]._visible = false;
        }
    }


    private function checkSwf(mc:MovieClip, id:String):Void {
        var confid:String = id.substr(8);
        if (isSwfVisible(mc,id)) {
            if (mc[id] == undefined) {
                loadImage(mc, id, conf.swflayer[confid].url, layer, "AdjustSwf", 0, 1, conf.swflayer[confid].w, conf.swflayer[confid].h, conf.swflayer[confid].extent);
                layer++;
            } else if (mc[id].loaded == true) {
                interact.scaleAndPosition(mc, id, conf.swflayer[confid].extent, true);
                var wsen = conf.swflayer[confid].extent.split(',');
                //interact.onJRSSComm("<rss><channel><item><description>" + conf.swflayer[confid].extent + "</description><georss:box>" + wsen[1] + " " + wsen[0] + " " + wsen[3] + " " + wsen[2] + "</georss:box></item></channel></rss>");	
                mc[ id ]._visible = true;
                //setTimeNavAlpha(mc,id);
            }
        } else {
            mc[ id ]._visible = false;
        }
    } 

    private function checkSwfTemplate():Void {
        if (conf.swftemplate == undefined) { return; }

        for (var id in conf.swftemplate) {
            //for each template, see if its extent and scale cover current viewing
            var wsen:Array = conf.swftemplate[id].extent.split(",");
            var w = Number(wsen[0]); var s = Number(wsen[1]); var e = Number(wsen[2]); var n = Number(wsen[3]);

            //REVISIT break this out into several statements
            if (interact.scale >= conf.swftemplate[id].minscale && interact.scale <= conf.swftemplate[id].maxscale 
                    && interact.cnorth > s && interact.csouth < n && interact.ceast > w && interact.cwest < e
                    && (conf.swftemplate[id].category == undefined || conf.categories[ conf.swftemplate[id].category ] != false)) {

                //this template is viewable, so determing which tiles are required
                //and request them if not already cached
                var latspan = (n - s) / conf.swftemplate[id].spany;
                var longspan = (e - w) / conf.swftemplate[id].spanx;

                var curlong;
                var curlat;

                curlong = interact.cwest;
                while (curlong <= interact.ceast) {

                    curlat = interact.cnorth;
                    while (curlat >= interact.csouth) {

                        this.posToTile(curlat,curlong,id);

                        if (curlat == interact.csouth) {
                            break;
                        } else {
                            curlat -= latspan;
                            if (curlat < interact.csouth) { curlat = interact.csouth; }
                        }
                    }
                    if (curlong == interact.ceast) {
                        break;
                    } else {
                        curlong += longspan;
                        if (curlong > interact.ceast) { curlong = interact.ceast; }
                    }

                }
            }
        }
    }

    public function addNewSwfTemplates() {
        for (var s in conf.swftemplate) {
            if (conf.swftemplate[ s ].mc_created != true) {
                imagemc.createEmptyMovieClip(s, layer + conf.swftemplate[s].layer);
                conf.swftemplate[ s ].mc_created = true;
            }
        } 
    }

    /* Given a location and swftemplate id
       determine which tiles to load
     */
    private function posToTile(lat:Number, lon:Number, id:String):Void {
        var i,j;
        var wsen:Array  = conf.swftemplate[id].extent.split(",");
        var w = Number(wsen[0]); var s = Number(wsen[1]); var e = Number(wsen[2]); var n = Number(wsen[3]);
        var latspan = (n - s) / conf.swftemplate[id].spany;
        var longspan = (e - w) / conf.swftemplate[id].spanx;

        i = Math.floor( (lon-w) / longspan );
        j = Math.floor( (n-lat) / latspan );

        if (i >= 0 && i < conf.swftemplate[id].spanx && j >= 0 && j < conf.swftemplate[id].spany) {
            var tilenorth = n - (j * latspan);
            var tilesouth = n - ((j+1) * latspan);
            var tilewest = w + (i * longspan);
            var tileeast = w + ((i+1) * longspan);
            var tilelat = (tilenorth + tilesouth ) / 2;
            var tilelon = (tileeast + tilewest) / 2;
            var tileid = id + "i" + i + "j" + j;

            if (conf.swflayer[tileid] == undefined) {
                conf.swflayer[tileid] = new Object();
                conf.swflayer[tileid].extent = tilewest + "," + tilesouth + "," + tileeast + "," + tilenorth;
                if (conf.projection == "mercator") {
                    tilesouth = 180 / Math.PI * ( 2 * Math.atan(Math.exp(tilesouth * Math.PI / 180)) - Math.PI/2);
                    tilenorth = 180 / Math.PI * ( 2 * Math.atan(Math.exp(tilenorth * Math.PI / 180)) - Math.PI/2);
                }
                var tileurl = conf.swftemplate[id].url;

                if (conf.swftemplate[id].tilemap) {
                    tileurl = worldkitUtil.myreplace(tileurl,"ZOOM", (Math.log(conf.swftemplate[id].minscale)/Math.log(2)).toString());
                    tileurl = worldkitUtil.myreplace(tileurl,"XTILE", i);
                    if (conf.swftemplate[ id ].origin == "nw") {
                        tileurl = worldkitUtil.myreplace(tileurl,"YTILE", j);
                    } else {
                        tileurl = worldkitUtil.myreplace(tileurl,"YTILE", (conf.swftemplate[id].spany -j - 1).toString());
                    }


                    //tileurl = tileurl + Math.log(conf.swftemplate[id].minscale)/Math.log(2) + "/" +  i + "/" + (conf.swftemplate[id].spany - j - 1) + ".jpg";
                } else if (conf.swftemplate[id].zoomify != undefined) {
                    var group = Math.floor((conf.swftemplate[id].tilecount + i + (j * conf.swftemplate[id].spanx)) / 256);
                    tileurl = tileurl + "TileGroup" + group + "/" + conf.swftemplate[id].zoomify + "-" + i + "-" + j + ".jpg";
                    trace(tileurl);
                } else {
                    tileurl = worldkitUtil.myreplace(tileurl,"NORTH",tilenorth);
                    tileurl = worldkitUtil.myreplace(tileurl,"SOUTH",tilesouth);
                    tileurl = worldkitUtil.myreplace(tileurl,"EAST",tileeast);
                    tileurl = worldkitUtil.myreplace(tileurl,"WEST",tilewest);
                    tileurl = worldkitUtil.myreplace(tileurl,"LAT",tilelat);
                    tileurl = worldkitUtil.myreplace(tileurl,"LON",tilelon);
                }

                conf.swflayer[tileid].url = tileurl;

                conf.swflayer[tileid].h = conf.swftemplate[id].tileheight;
                conf.swflayer[tileid].w = conf.swftemplate[id].tilewidth;
                conf.swflayer[tileid].minscale = conf.swftemplate[id].minscale;
                conf.swflayer[tileid].maxscale = conf.swftemplate[id].maxscale;
                conf.swflayer[tileid].minview = conf.swftemplate[id].minview;
                conf.swflayer[tileid].maxview = conf.swftemplate[id].maxview;
                conf.swflayer[tileid].category = conf.swftemplate[id].category;
                conf.swflayer[tileid].time = conf.swftemplate[id].time;
                conf.swflayer[tileid].parent = imagemc[id];
                conf.swflayer[tileid].fromtemplate = true;
                loadImage( imagemc[ id ], "swflayer" + tileid, tileurl, layer, "AdjustSwf", 0, 1, conf.swflayer[ tileid ].w, conf.swflayer[ tileid ].h, conf.swflayer[ tileid ].extent );
                layer++;
            }
        }
    }


    private function isSwfVisible(mc:MovieClip, id:String):Boolean {
        var confid = id.substr(8);
        var visible = true;

        if (conf.swflayer[confid].extent != undefined) {
            var wsen = conf.swflayer[confid].extent.split(",");
            var w = Number(wsen[0]); var s = Number(wsen[1]); var e = Number(wsen[2]); var n = Number(wsen[3]);
            if (w > interact.ceast || s > interact.cnorth || e < interact.cwest || n < interact.csouth) {
                visible = false;
            }
        }

        if (conf.swflayer[confid].minview != undefined && conf.swflayer[confid].maxview != undefined) {
            if (conf.swflayer[confid].minview > interact.scale || conf.swflayer[confid].maxview < interact.scale) {
                visible = false;
            }
        }

        //lots of inconsistencies in how layers are addressed (in conf, in imagelayer, in javascript api) REVISIT
        if ((conf.swflayer[confid].category != undefined && conf.categories[ conf.swflayer[confid].category ] == false) ||
                (conf.categories[ confid ] == false)) {
            visible = false;
        }

        //if (conf.timenav != false && conf.swflayer[confid].time != undefined) {
        //    var diff = Math.abs( interact.maxtime - conf.swflayer[confid].time );
        //    trace(diff);
        //    if (diff > 1382400000 * 2) {
        //	trace("out of range");
        //	visible = false;
        //    }
        //}
        //visible = true;
        return visible;
    }

    //ALPHA wms time nav
    public function setTimeNavAlpha(mc:MovieClip, id:String):Void {
        var confid:String = id.substr(8);
        if (conf.timenav != false && conf.swflayer[confid].time != undefined) {
            var diff = Math.abs( Number(interact.maxtime) - Number(conf.swflayer[confid].time) );
            mc[id]._alpha = 100 * (1382400000 * 2 - diff) / (1382400000 * 2)+ 30;
        }
    }

    public function sino(mc:MovieClip, id:String, mask:String):Void {
        mc[mask].clear();
        var width = mc[id].origwidth;
        var height = mc[id].origheight;

        var myTime = new Date();
        var m_offset = new Array(0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334); //adjust for leap year

        var txtphase1 = 2 * Math.PI * (myTime.getDate() + m_offset[ myTime.getMonth()+1 ] - 80)/360;
        var txttilt = 1 / (Math.sin (txtphase1) * Math.tan(23.45 * Math.PI / 180));
        var dot; if (txttilt>0) { dot = 0;} else {dot = height;}    
        var auxiliary_phase2 = (myTime.getHours()*60+myTime.getMinutes()+myTime.getTimezoneOffset());
        //REVISIT -- what is "offset"
        //var txtphase2 = 3.14159*2*(myTime.getHours()*60+offset+myTime.getMinutes()+myTime.getTimezoneOffset())/(24*60);
        var txtphase2 = 3.14159*2*(myTime.getHours()*60+myTime.getMinutes()+myTime.getTimezoneOffset())/(24*60);

        for (var j=1; j<width; j++) {
            //goes from -180 to 180 usually
            // which is shifted to 0 to 2Pi 
            var xy = interact.xy2geo(j,0,width,height);
            var rad = (xy[1]+180)*2*Math.PI/360;

            var y = ((height/2+Math.atan(txttilt*Math.cos(txtphase2+rad))*height/Math.PI));
            var lon = 90 - (y/height)*180;

            var topy, bottomy;
            if (dot == 0) {
                if (lon < conf.north) {
                    topy = 0;
                    if (lon < conf.south) { bottomy = height; }
                    else { bottomy = height * (conf.north - lon) / (conf.north - conf.south); }
                }
            } else {
                if (lon > conf.south) {
                    bottomy = height;
                    if (lon > conf.north) { topy = 0; }
                    else { topy = height * (conf.north - lon) / (conf.north - conf.south); }
                }
            }

            mc[mask].lineStyle(1,0x000000);
            mc[mask].beginFill(0x000000);
            mc[mask].moveTo(j,topy);
            mc[mask].lineTo(j,bottomy); mc[mask].lineTo(j+1,bottomy); mc[mask].lineTo(j+1,topy); mc[mask].lineTo(j,topy);
            mc[mask].endFill();

        }

        //Scale and reposition mask to maskee
        //Need to do this every update??
        mc[mask].origwidth = mc[id].origwidth;
        mc[mask].origheight = mc[id].origheight;
        mc[mask]._xscale = mc[id]._xscale;
        mc[mask]._yscale = mc[id]._yscale;
        mc[mask]._x = mc[id]._x;				
        mc[mask]._y = mc[id]._y;
    }

    public function Pan():Void {
        interact.scaleAndPosition(imagemc,"day");
        if (conf.displaytype == "daynight") {
            interact.scaleAndPosition(imagemc,"night");
            interact.scaleAndPosition(imagemc,"dayMasker");
        }
        //POLAR AND DYMAX?!
        for (var swf in conf.swflayer) {
            checkSwf(conf.swflayer[swf].parent, "swflayer" + swf);
        }
        checkSwfTemplate();
    }

    static public function nextLayer():Number {
        layer++;
        return layer - 1;
    }
    static public function getmc():MovieClip {
        return imagemc;
    }
    public function highLoad():Boolean {
        return imagesLoading > conf.maximageload;
    }

    public function loadicon(mc:MovieClip, id:String):Boolean {
        if (imagemc[id].loaded) {
            var key:String = imagemc._name + ":" + id;	  
            mc.loadMovie(imglist[key].url);
            mc._x = - .5 * imglist[key]["mc"][id]._width;
            mc._y = - .5 * imglist[key]["mc"][id]._height;
            return true;
        } else {
            return false;
        }
    }

    public function loadrssicon(mc:MovieClip, url:String):Boolean {
        var key:String = imagemc._name + ":" + escape(url);	
        if (imagemc[ escape(url) ].loaded) {
            mc.loadMovie(url);
            var w = imglist[key]["mc"][escape(url)]._width;
            var h = imglist[key]["mc"][escape(url)]._height;
            mc._xscale = 100 *  conf.rssiconwidth / w;
            mc._yscale = 100 * conf.rssiconwidth / w;
            mc._x = - .5 * (conf.rssiconwidth);
            mc._y = - .5 * (conf.rssiconwidth * h / w);
            return true;
        } else if (imglist[ key ] == undefined) {
            loadImage(imagemc, escape(url), url, layer, "MakeInvisible", 0, 1, undefined, undefined, undefined, false);
            layer++;
        }
        return false;
    }
    public function activateicon(mc:MovieClip, url:String, iconwidth:Number) {
        var key:String = imagemc._name + ":" + escape(url);
        var w = imglist[key]["mc"][escape(url)]._width;
        var h = imglist[key]["mc"][escape(url)]._height;	
        mc._xscale = 100 *  iconwidth / w;
        mc._yscale = 100 * iconwidth / w;
        mc._x = - .5 * (iconwidth);
        mc._y = - .5 * (iconwidth * h / w);
    }

}
