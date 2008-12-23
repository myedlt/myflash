package
{
	import controller.ApplicationInitializeCommand;
	import controller.ApplicationStartupCommand;
	import controller.NextSectionCommand;
	import controller.PreviousSectionCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		// Notification name constants
		// application
		public static const INITIAL:String = "initial";	
						
		//command
		public static const LOAD:String = "load";	
		
		//mediator
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		
		// proxy
		public static const LOAD_CONTENT_FAILED:String = "loadContentFailed";		
		public static const STARTUP:String = "startup";
		
		//common messages
		public static const ERROR_LOAD_FILE:String	= "加载数据文件失败,请确定文件是否存在!";
		
		public static function getInstance():ApplicationFacade
		{
			if(instance==null)instance=new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(INITIAL,ApplicationInitializeCommand);
			registerCommand(STARTUP,ApplicationStartupCommand);
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);
		}
		
		public function startup(app:CWFW):void
		{
			sendNotification(INITIAL,app);
		}
	}
}