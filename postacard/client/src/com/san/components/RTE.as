package com.san.components
{
	import flash.events.Event;
	
	import mx.controls.RichTextEditor;
	import mx.core.ContainerLayout;
	import mx.events.FlexEvent;

	public class RTE extends RichTextEditor
	{
		public function RTE()
		{
			super();
			
			this.layout = ContainerLayout.ABSOLUTE;
			
			this.addEventListener( FlexEvent.CREATION_COMPLETE, creationComplete );
		}
		
		
		private function creationComplete(event:Event=null):void
		{
			textArea.setStyle("top", 0 );
			textArea.setStyle("left", 0 );
			textArea.setStyle("right", 0 );
			textArea.setStyle("bottom", 70 );
			
			this.linkTextInput.visible = this.linkTextInput.includeInLayout = false;
			this.linkTextInput.height = 0;
		}
		
		
		
		
	}
}