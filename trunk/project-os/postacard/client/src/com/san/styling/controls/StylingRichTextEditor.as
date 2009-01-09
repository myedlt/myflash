package com.san.styling.controls
{
	import flash.events.Event;
	
	import mx.controls.RichTextEditor;
	import mx.core.ContainerLayout;
	import mx.events.FlexEvent;

	public class StylingRichTextEditor extends RichTextEditor implements IStylingControl
	{
		
		
		private var _target:Object;
		private var _property:String;
		
		private var _selectText:Boolean = false;
		
		public function StylingRichTextEditor()
		{
			super();
			this.clipContent = false;
			this.layout = ContainerLayout.ABSOLUTE;
			
			this.addEventListener( FlexEvent.CREATION_COMPLETE, creationComplete );
			
			this.addEventListener( Event.CHANGE, changeHandler );
		}
	
		
		private function creationComplete(event:Event=null):void
		{
			this.linkTextInput.visible = this.linkTextInput.includeInLayout = false;
			this.linkTextInput.height = 0;
			
			textArea.x = -450;
			textArea.y = 10;
			textArea.width = 450;
			textArea.height = 90;
			textArea.setStyle( "backgroundColor", 0xE5E5E5 );
		}
		
		
		
				
		private function changeHandler( event:Event ):void
		{
			if( _target && _property )
				_target[ _property ] = this.htmlText;
		}
		
		
		private function updateControl( event:Event = null ):void
		{
			if( _target && _property )
			{
				this.htmlText = _target[ _property ];
			}
			else
				this.htmlText = "";
			
			_selectText = true;
		}
		
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if( _selectText )
			{
				callLater( selectAllText );
				
				_selectText = false;
			}
		}
		
		private function selectAllText():void
		{
			if( textArea && textArea.text )
			{	
				textArea.selectionBeginIndex = 0;
				textArea.selectionEndIndex = 1000;
				
				styleChanged( "Nonexistant style" );
			}
		}
		
		public function set target(  value:Object ):void
		{
			_target = value;
			
			updateControl();
		}		
		
		public function set property( value:String ):void
		{
			_property = value;	
			
			updateControl();
		}
		
		
		
	}
}