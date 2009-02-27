package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import puremvc.controller.*;

	public class ApplicationFacade extends Facade
	{
		public var app:Object;
		
		// Notification name constants
		//AppMediator
		public static const LOAD_FILE_FAILED:String = "loadFileFailed";				
		public static const INITUI:String="initui";
						
		//command - 系统启动消息组
		public static const INIT:String = "initialize";
		public static const STARTUP:String="startup";
		
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
			
		}
		
		//启动 PureMVC，在应用程序中调用此方法，并传递应用程序本身的引用 
	   	public function startup( viewComponent:Object ) : void  
	   	{   
	   		this.app = viewComponent;
			sendNotification( INIT, app ); 
	   	} 
		
	}
}