package com.san.styling.controls
{
	import flash.events.Event;
	
	import mx.controls.HSlider;
	import mx.core.UIComponent;
	import mx.events.SliderEvent;

	public class StylingHSlider extends HSlider implements IStylingControl
	{
		
		private var _target:Object;
		private var _property:String;
		
		
		public function StylingHSlider()
		{
			super();
			
			this.minimum = 0;
			this.maximum = 1;
			this.snapInterval = 0.01;
			this.liveDragging = false;
			this.showDataTip = true;
			this.allowTrackClick = true;
			
			this.addEventListener( SliderEvent.CHANGE, changeHandler );
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
				this.value = _target[ _property ];
			else
				this.value = 0;
		}
		
		private function changeHandler( event:SliderEvent ):void
		{
			if( _target && _property )
				_target[ _property ] = this.value;
		}
		
	}
}