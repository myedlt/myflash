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
		public static const INITIALIZE:String = "initialize";	
						
		//command
		public static const LOAD_SWF:String = "loadSWF";			
		
		//mediator
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		
		// proxy
		public static const LOAD_FILE_FAILED:String = "loadFileFailed";		
		public static const DATA_READY:String = "dataReady";	
		
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
			registerCommand(INITIALIZE,ApplicationInitializeCommand);
			registerCommand(DATA_READY,ApplicationStartupCommand);
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);
		}
		
		public function init(app:Object):void
		{
			sendNotification(INITIALIZE,app);
		}
	}
}