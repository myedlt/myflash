package events
{
	import flash.events.Event;

	public class PathEvent extends Event
	{
		public static const SELECT_PATH:String = "selectPath";
		public var path:String;
		public var currentPlayId:String;
//		public function PathEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		public function PathEvent(path:String,currentPlayId:String)
		{
			super(SELECT_PATH, true, true);
			this.path = path;
			this.currentPlayId = currentPlayId;
		}
	}
}