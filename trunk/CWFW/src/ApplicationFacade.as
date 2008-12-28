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
		public static const SWF_LOAD:String = "swfLoad";
		public static const CHAPTER_CHANGE:String = "chapterChange";
		public static const SECTION_CHANGE:String = "sectionChange";			
		public static const SINGLE_CHAPTER:String="singleChapter";
		
		//mediator
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		public static const CONTENTS_ITEM_CLICK:String="contentsItemClick";
		public static const SWF_LOAD_COMPLETE:String="swfLoadComplete";
		public static const SWF_UNLOAD:String="swfUnload";
		public static const ENTER_FRAME:String="enterFrame";
		public static const GOTO_AND_PLAY:String="gotoAndPlay";
		public static const GOTO_AND_STOP:String="gotoAndStop";	
		public static const PLAY:String="play";	
		public static const PAUSE:String="pause";	
		public static const STOP:String="stop";		
		
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