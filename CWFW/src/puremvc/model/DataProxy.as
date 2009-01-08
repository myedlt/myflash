package puremvc.model
{
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import puremvc.ApplicationFacade;
	import puremvc.business.LoadXMLDelegate;
	//数据初始化(加载xml数据文件),数据加载完毕发送INITIALIZE通知
	public class DataProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "DataProxy";		
		
		public function DataProxy(data:String = "content.xml") 
		{
			super( NAME );			
			var delegate : LoadXMLDelegate = new LoadXMLDelegate(this,data);
			delegate.load();
		}			
		
		public function result(data:Object):void
		{
			this.data=data.result;       
			sendNotification(ApplicationFacade.INITIALIZE); 	         				
		}
		
		public function fault(info:Object):void
		{			
			sendNotification(ApplicationFacade.LOAD_FILE_FAILED,ApplicationFacade.ERROR_LOAD_FILE);			
		}
	}
}