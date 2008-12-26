package
{
	import controller.ApplicationInitializeCommand;
	import controller.ApplicationStartupCommand;
	import controller.ContentsItemClickCommand;
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
		public static const CHAPTER_CHANGE:String = "chapterChange";
		public static const SECTION_CHANGE:String = "sectionChange";			
		public static const SINGLE_CHAPTER:String="singleChapter";
		
		//mediator
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		public static const CONTENTS_ITEM_CLICK:String="contentsItemClick";
		
		
		// proxy
		public static const LOAD_FILE_FAILED:String = "loadFileFailed";		
		public static const DATA_READY:String = "dataReady";	
		
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
			registerCommand(DATA_READY,ApplicationStartupCommand);
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);
			registerCommand(CONTENTS_ITEM_CLICK,ContentsItemClickCommand);
		}
		
		public function init(app:Object):void
		{
			sendNotification(INITIALIZE,app);
		}
	}
}