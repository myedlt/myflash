import com.brainoff.worldkitConfig;
import com.brainoff.worldkitGPX;
import com.brainoff.worldkitImages;
import com.brainoff.worldkitInteraction;
import com.brainoff.worldkitRSS;
import com.brainoff.worldkitUtil;

class com.brainoff.worldkitMain {
    static var version:String = "3.3-20071029";

    var conf:worldkitConfig;
    var img:worldkitImages;
    var interact:worldkitInteraction;
    var rss:worldkitRSS;

    var parent:MovieClip;

    public function worldkitMain (parent) { 
        this.parent = parent; 

        worldkitUtil.setUp();

        conf = new worldkitConfig(this);
        img = new worldkitImages(this);
        interact = new worldkitInteraction(this);
        rss = new worldkitRSS(this);

        conf.load();


    }

    public static function main(parent):Void {

        var wk = new worldkitMain(parent);
    }

    /*
       Controls loading order of config, images, rss
     */
    public function signalDone(sig:String) {
        switch (sig) {
            case "CONFIG":
                interact.afterConf();
                img.load();
                interact.SetupInput();
                break;
            case "IMAGES":
                worldkitGPX.start(this);
                rss.start();
                if (conf.onloadcallback) {
                    interact.processClick("","_"+conf.onloadcallback,"");
                }
                break;
            default:
                break;
        }
    }

    /*
       classes request access to other classes through worldkitMain
     */
    public function getConfig():worldkitConfig {
        return conf;
    }
    public function getInteract():worldkitInteraction {
        return interact;
    }
    public function getRSS():worldkitRSS {
        return rss;
    }
    public function getImages():worldkitImages {
        return img;
    }
}
