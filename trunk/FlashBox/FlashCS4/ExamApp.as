package{
	import flash.display.*;
	import flash.text.TextField;
	
	public class ExamApp extends Sprite{
		
		private var textField:TextField;
		public function ExamApp(){
		
			textField = new TextField();
			textField.x = 200;
			textField.y = 300;
			textField.text = "Hello world!";
			addChild(textField);
			
			trace(textField.parent.parent);
			trace(textField.root);
			//root.gotoAndStop(15);
		}
		
		public function removeRect()
		{
			this.removeChild(textField);
		}
	}
}