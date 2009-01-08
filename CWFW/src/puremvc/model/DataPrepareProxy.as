package mvc.model
{
	import mvc.ApplicationFacade;
	import mvc.business.LoadXMLDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	//数据初始化(加载xml数据文件),为facade注册代理.数据初始化完毕发送DATA_READY通知
	public class DataPrepareProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DataPrepareProxy";		
		
		public function DataPrepareProxy(data:String = "content.xml") 
		{
			super( NAME );			
			var delegate : LoadXMLDelegate = new LoadXMLDelegate(this,data);
			delegate.load();
		}			
		
		public function result(data:Object):void
		{
			this.data=data.result;			
			facade.registerProxy(new CourseProxy(XML(this.data).CourseList.Course));
        	facade.registerProxy(new NavigatorProxy(XML(this.data).Navigator.button));
        	sendNotification(ApplicationFacade.DATA_READY);         				
		}
		
		public function fault(info:Object):void
		{			
			sendNotification(ApplicationFacade.LOAD_FILE_FAILED,ApplicationFacade.ERROR_LOAD_FILE);			
		}
	}
}