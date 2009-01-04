package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.ApplicationInitializeCommand;
	import puremvc.controller.ApplicationStartupCommand;
	import puremvc.controller.ContentsItemClickCommand;
	import puremvc.controller.DataPrepCommand;
	import puremvc.controller.NextSectionCommand;
	import puremvc.controller.PreviousSectionCommand;

	public class ApplicationFacade extends Facade
	{
		public var app:Object;
		// Notification name constants
		// application
		public static const INITIALIZE:String = "initialize";	
						
		//command
		public static const STARTUP:String="startup";
		public static const SWF_LOAD:String = "swfLoad";
		public static const FLV_LOAD:String = "flvLoad";
		public static const IMAGE_LOAD:String = "imageLoad";
		public static const MODULE_LOAD:String = "moduleLoad";
		public static const CHAPTER_CHANGE:String = "chapterChange";
		public static const SECTION_CHANGE:String = "sectionChange";			
		public static const SINGLE_CHAPTER:String="singleChapter";
		
		//mediator
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		public static const CONTENTS_ITEM_CLICK:String="contentsItemClick";
		public static const SWF_LOAD_COMPLETE:String="swfLoadComplete";
		public static const FLV_LOAD_COMPLETE:String="flvLoadComplete";
		public static const SWF_UNLOAD:String="swfUnload";
		public static const ENTER_FRAME:String="enterFrame";
		public static const PLAYHEAD_UPDATE:String="playheadUpdate";
		public static const GOTO_AND_PLAY:String="gotoAndPlay";
		public static const GOTO_AND_STOP:String="gotoAndStop";	
		public static const PLAY:String="play";	
		public static const PAUSE:String="pause";	
		public static const STOP:String="stop";		
		
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
			
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);
			registerCommand(CONTENTS_ITEM_CLICK,ContentsItemClickCommand);
		}
		
		public function startup(app:Object):void
		{
			this.app=app;
			sendNotification(DATA_PREPARE);
			//sendNotification(INITIALIZE);
		}
	}
}