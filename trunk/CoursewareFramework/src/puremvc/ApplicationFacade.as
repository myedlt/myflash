package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.ApplicationInitializeCommand;
	import puremvc.controller.ApplicationStartupCommand;
	import puremvc.controller.NextSectionCommand;
	import puremvc.controller.PreviousSectionCommand;
	import puremvc.model.ConfigInfoProxy;
	import puremvc.model.CourseInfoProxy;	

	public class ApplicationFacade extends Facade
	{			
		public static const STARTUP:String="startup";
		public static const DATA_READY:String="dataReady";
		public static const PREVIOUS_SECTION:String="previousSection";
		public static const NEXT_SECTION:String="nextSection";
		public static const SWF_LOAD:String = "swfLoad";
		public static const FLV_LOAD:String = "flvLoad";
		public static const IMAGE_LOAD:String = "imageLoad";
		public static const MODULE_LOAD:String = "moduleLoad";		
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
			registerCommand(STARTUP,ApplicationStartupCommand);	
			registerCommand(DATA_READY,ApplicationInitializeCommand);
			registerCommand(PREVIOUS_SECTION,PreviousSectionCommand);
			registerCommand(NEXT_SECTION,NextSectionCommand);		
		}
		
		public static function getConfigInfoProxy():ConfigInfoProxy
		{
			return ConfigInfoProxy( ApplicationFacade.getInstance().retrieveProxy( ConfigInfoProxy.NAME ) );
		}
		
		public static function getCourseInfoProxy():CourseInfoProxy
		{
			return CourseInfoProxy( ApplicationFacade.getInstance().retrieveProxy( CourseInfoProxy.NAME ) );
		}
		
		public function startup(app:Object):void
		{			
			sendNotification(STARTUP,app);			
		}
	}
}