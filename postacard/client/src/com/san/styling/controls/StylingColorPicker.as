package com.san.styling.controls
{
	import flash.events.Event;
	
	import mx.controls.ColorPicker;
	import mx.core.UIComponent;
	import mx.events.ColorPickerEvent;

	public class StylingColorPicker extends ColorPicker implements IStylingControl
	{
		
		private var _target:Object;
		private var _property:String;
		
		
		public function StylingColorPicker()
		{
			super();
			
			this.addEventListener( ColorPickerEvent.CHANGE, changeHandler );
		}
		
		public function set target(value:Object):void
		{
			_target = value;			
			updateControl();
		}
		
		public function set property(value:String):void
		{
			_property = value;			
			updateControl();
		}
		
		private function updateControl( event:Event = null ):void
		{
			if( _target && _property )
				this.selectedColor = _target[ _property ];
			else
				this.selectedColor = 0;
		}
		
		private function changeHandler( event:ColorPickerEvent ):void
		{
			if( _target && _property )
				_target[ _property ] = this.selectedColor;
		}
		
	}
}