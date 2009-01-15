package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.ApplicationInitializeCommand;
	import puremvc.controller.ApplicationStartupCommand;
	import puremvc.controller.ContentsItemClickCommand;
	import puremvc.controller.DataPrepCommand;	

	public class ApplicationFacade extends Facade
	{
		public var app:Object;
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
		public static const DATA_PREPARE:String = "dataPrepare";	
		
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
			
			registerCommand(DATA_PREPARE,DataPrepCommand);	
			registerCommand(INITIALIZE,ApplicationInitializeCommand);			
			registerCommand(STARTUP,ApplicationStartupCommand);			
			
			registerCommand(CONTENTS_ITEM_CLICK,ContentsItemClickCommand);
		}
		
		public function startup(app:Object):void
		{
			this.app=app;
			sendNotification(DATA_PREPARE);			
		}
	}
}