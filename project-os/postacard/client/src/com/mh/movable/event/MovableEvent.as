package com.mh.movable.event
{
	import flash.events.Event;
	
	public class MovableEvent extends Event
	{
		
		public static const SELECT_COMPONENT:String = "selectComponent";
		public static const MOVE_COMPONENT:String = "moveComponent";
		public static const RESIZE_COMPONENT:String = "resizeComponent";
		
		public var handle:String;
		
		
		public function MovableEvent( type:String, handle:String = null )
		{
			super( type, true );	
			
			this.handle = handle;
		}
		
	}
}