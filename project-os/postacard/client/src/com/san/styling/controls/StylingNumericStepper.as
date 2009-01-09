package com.san.styling.controls
{
	import flash.events.Event;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.controls.NumericStepper;
	import mx.core.UIComponent;
	import mx.events.NumericStepperEvent;
	
	public class StylingNumericStepper extends NumericStepper implements IStylingControl
	{
		
		public static const NUMERIC_STEPPER:String = "numericStepper";
		
		
		private var _target:Object;
		private var _property:String;
		
		
		private var _watcher:ChangeWatcher;
		
		
		public function StylingNumericStepper()
		{
			super();
			
			this.minimum = -3000;
			this.maximum = 3000;

			this.addEventListener( NumericStepperEvent.CHANGE, changeHandler );
		}
		
		
		private function changeHandler( event:NumericStepperEvent ):void
		{
			if( _target && _property )
				_target[ _property ] = this.value;
		}
		
		
		private function monitorSource():void
		{
			if( _watcher )
				_watcher.unwatch();
			
			if( _target && _property )
				_watcher = ChangeWatcher.watch( _target, _property, updateControl );
		}
		
		private function updateControl( event:Event = null ):void
		{
			if( _target && _property )
				this.value = _target[ _property ];
			else
				this.value = 0;
		}
		
		
		public function set target(  value:Object ):void
		{
			_target = value;
			
			monitorSource();
			updateControl();
		}
		
		
		public function set property( value:String ):void
		{
			_property = value;	
			
			monitorSource();
			updateControl();
		}
		
	}
}