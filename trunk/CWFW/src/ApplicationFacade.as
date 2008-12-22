package
{
	import controller.ApplicationStartupCommand;
	import controller.ModelPrepCommand;
	import controller.NextSectionCommand;
	import controller.PreviousSectionCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		// Notification name constants
		// application
		public static const STARTUP:String = "startup";
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";		
		
		// proxy
		public static const LOAD_CONTENT_FAILED:String = "loadContentFailed";
		public static const LOAD_CONTENT_SUCCESSFUL:String = "loadContentSuccessful";
		
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
			registerCommand(LOAD_CONTENT_SUCCESSFUL,ModelPrepCommand);
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);
		}
		
		public function startup(app:CWFW):void
		{
			sendNotification(STARTUP,app);
		}
	}
}