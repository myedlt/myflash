package api.event
{
	import mx.events.FlexEvent;
	
	public class AppEvent extends FlexEvent
	{
		/* UI 自定义事件	*/
		public static const CE_CHAPTERCHANGED:String 	= "onChapterChanged";
		public static const CE_SECTIONCHANGED:String 	= "onSectionChanged";
		public static const CE_NEXTSECTION:String 		= "onNextSection";
		public static const CE_PREVSECTION:String 		= "onPrevSection";
		
		public static const CE_EXITAPP:String 			= "onEXITAPP";		
		
       public var body:Object; //自定义的事件信息

       public function AppEvent(strType:String, msg:Object){

             super(strType, true); //如果在构造时不设bubbles，默认是false，也就是不能传递的。

             body = msg;

       }		
		
	}
}