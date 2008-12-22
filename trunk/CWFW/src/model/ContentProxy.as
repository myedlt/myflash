package model
{
	import model.business.LoadXMLDelegate;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ContentProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "ContentProxy";		
		
		public function ContentProxy(data:String = "content.xml") 
		{
			super( NAME );			
			var delegate : LoadXMLDelegate = new LoadXMLDelegate(this,data);
			delegate.load();
		}			
		
		public function result(data:Object):void
		{
			this.data=data.result;
			sendNotification(ApplicationFacade.LOAD_CONTENT_SUCCESSFUL,this.data);
			trace("加载文件成功!");
		}
		
		public function fault(info:Object):void
		{			
			sendNotification(ApplicationFacade.LOAD_CONTENT_FAILED,ApplicationFacade.ERROR_LOAD_FILE);
			trace("加载文件失败!");
		}
	}
}