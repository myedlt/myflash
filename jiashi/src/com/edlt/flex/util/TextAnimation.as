package com.edlt.flex.util
{
	import flash.display.Sprite;

	public class TextAnimation extends Sprite
	{
		private var t:TextArea;
		
		public function TextAnimation()
		{
			//创建文本字段
			t = new TextField();
			t.text = "Hello";
			t.autoSize = TextFieldAutosize.Left;
			addChild(t);
			
			//Register
			addEventListener(Event.ENTER_FRAME, moveTextRight);
		}
		
		public function moveTextRight (e:Event):void
		{
			t.x += 10;
		}		
	}
}