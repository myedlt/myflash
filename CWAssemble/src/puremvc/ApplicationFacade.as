package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.ApplicationInitializeCommand;
	import puremvc.controller.ApplicationStartupCommand;
	import puremvc.controller.ContentsItemClickCommand;

	public class ApplicationFacade extends Facade
	{		
		public static const INITIALIZE:String = "initialize";	
		public static const STARTUP:String="startup";
		public static const START_COMPLETE:String="startComplete";			
		public static const DISPLAY:String="display";
		public static const CONTENTS_ITEM_CLICK:String="contentsItemClick";				
		public static const ERROR:String="error";	
		public static const LOAD_FILE_FAILED:String = "加载xml文件失败";	
		public static const PARSE_XML_FAILED:String = "解析xml文件失败";				
		
		public static function getInstance():ApplicationFacade
		{
			if(instance==null)instance=new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();			
			registerCommand(INITIALIZE,ApplicationInitializeCommand);			
			registerCommand(STARTUP,ApplicationStartupCommand);			
			registerCommand(CONTENTS_ITEM_CLICK,ContentsItemClickCommand);
		}
		
		public function startup(app:Object):void
		{			
			sendNotification(INITIALIZE,app);			
		}
	}
}