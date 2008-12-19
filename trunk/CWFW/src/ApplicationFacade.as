package
{
	import controller.ApplicationStartupCommand;	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		// Notification name constants
		// application
		public static const STARTUP:String = "startup";
		
		// proxy
		public static const LOAD_CONTENT_FAILED:String = "loadContentFailed";
		
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
			registerCommand(STARTUP,ApplicationStartupCommand);
		}
		
		public function startup(app:CWFW):void
		{
			sendNotification(STARTUP,app);
		}
	}
}