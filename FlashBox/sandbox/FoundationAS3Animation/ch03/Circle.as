package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Circle extends Sprite {
		private var ball:Ball;
		private var angle:Number = 0;
		private var centerX:Number = 200;
		private var centerY:Number = 200;
		private var radius:Number = 50;
		private var speed:Number = .05;
		
		public function Circle()	{
			init();
		}
		private function init():void {
			ball = new Ball(15);
			addChild(ball);
			ball.x = 0;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		public function onEnterFrame(event:Event):void {
			ball.x = centerX + Math.sin(angle) * radius;
			ball.y = centerY + Math.cos(angle) * radius;
			var pBall:Ball = new Ball(1);
			pBall.x = ball.x;
			pBall.y = ball.y;
			addChild(pBall);
			angle += speed;
		}
	}
}