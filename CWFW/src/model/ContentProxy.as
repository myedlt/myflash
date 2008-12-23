package model
{
	import model.utils.LoadXMLDelegate;
	
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
			facade.registerProxy(new CourseProxy(XML(this.data).CourseList.Course));
        	facade.registerProxy(new NavigatorProxy(XML(this.data).Navigator.button)); 
        	sendNotification(ApplicationFacade.STARTUP);//初始化完毕,加载缺省设置			
		}
		
		public function fault(info:Object):void
		{			
			sendNotification(ApplicationFacade.LOAD_CONTENT_FAILED,ApplicationFacade.ERROR_LOAD_FILE);			
		}
	}
}