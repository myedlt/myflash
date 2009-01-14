package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.*;

	public class ApplicationFacade extends Facade
	{
		public var app:Object;
		// Notification name constants
		// application
		public static const INIT:String = "initialize";	
						
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
		
		// 注册Command，建立Command与 Notification之间的映射 
		override protected function initializeController():void
		{
			super.initializeController();
			
			// Proxy和Mediator对象创建，并加载xml文件，加载完成后发STARTUP消息
			registerCommand(INIT,AppInitCommand);
			// 对象数据初始化		
			registerCommand(STARTUP,AppStartupCommand);
			
			// UI交互命令
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);
			registerCommand(CONTENTS_ITEM_CLICK,ContentsItemClickCommand);
		}
		
		//启动 PureMVC，在应用程序中调用此方法，并传递应用程序本身的引用 
	   	public function startup( viewComponent:Object ) : void  
	   	{   
	   		this.app = viewComponent;
			sendNotification( INIT, app ); 
	   	} 
		
	}
}