package {
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class MovieClipExample extends MovieClip {

        public function MovieClipExample() {
            var outputText:TextField = new TextField();
            outputText.text = getPropertiesString();
            outputText.width = stage.stageWidth;
            outputText.height = outputText.textHeight;
            addChild(outputText);
        }

        private function getPropertiesString():String {
            var str:String = ""
                + "currentFrame: " + currentFrame + "\n"
                + "currentLabel: " + currentLabel + "\n"
                + "currentScene: " + currentScene + "\n"
                + "framesLoaded: " + framesLoaded + "\n"
                + "totalFrames: " + totalFrames + "\n"
                + "trackAsMenu: " + trackAsMenu + "\n";
            return str;
        }
    }
}