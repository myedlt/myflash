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
		
		public static const INITIALIZE:String = "initialize";		
		public static const STARTUP:String="startup";
		public static const TREE_INIT:String="treeInit";
		public static const SWF_LOAD:String = "swfLoad";
		public static const FLV_LOAD:String = "flvLoad";
		public static const IMAGE_LOAD:String = "imageLoad";
		public static const MODULE_LOAD:String = "moduleLoad";
		public static const CHAPTER_CHANGE:String = "chapterChange";
		public static const SECTION_CHANGE:String = "sectionChange";			
		public static const SINGLE_CHAPTER:String="singleChapter";		
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		public static const CONTENTS_ITEM_CLICK:String="contentsItemClick";			
		public static const DATA_PREPARE:String = "dataPrepare";
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
		}
	}
}