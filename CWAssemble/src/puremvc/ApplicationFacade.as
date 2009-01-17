package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.ApplicationInitializeCommand;
	import puremvc.controller.ApplicationStartupCommand;
	import puremvc.controller.ContentsItemClickCommand;

	public class ApplicationFacade extends Facade
	{		
		// Notification name constants
		// application
		public static const INITIALIZE:String = "initialize";	
						
		//command
		public static const STARTUP:String="startup";
		public static const INIT_COMPLETE:String="initComplete";			
		public static const DISPLAY:String="display";
		
		//mediator		
		public static const CONTENTS_ITEM_CLICK:String="contentsItemClick";				
		
		// proxy
		public static const LOAD_FILE_FAILED:String = "loadFileFailed";				
		
		//common messages
		public static const ERROR_LOAD_FILE:String	= "加载文件失败!";
		
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