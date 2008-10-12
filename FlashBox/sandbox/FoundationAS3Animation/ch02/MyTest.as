package {
	import flash.display.Sprite;
	public class MyTest extends Sprite {
		public function MyTest() {
			init();
		}
		private function init():void {
			var mySprite:Sprite = new Sprite();
			mySprite.graphics.beginFill(0xff0000);
			mySprite.graphics.drawCircle(200, 200, 40);
			mySprite.graphics.endFill();
			
			var ball:Ball = new Ball();
			addChild(ball);
			addChild(mySprite);
		}
	}
}