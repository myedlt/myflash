package puremvc.model
{	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import puremvc.ApplicationFacade;

	public class ConfigInfoProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ConfigInfoProxy";		
		
		public function ConfigInfoProxy(url:String) 
		{
			super( NAME );
			
			var loader:URLLoader=new URLLoader();				
			loader.addEventListener(Event.COMPLETE,result);
			loader.addEventListener(IOErrorEvent.IO_ERROR,fault);
			try 
			{
                loader.load(new URLRequest(url));
            }
            catch (error:SecurityError)
            {
                trace("A SecurityError has occurred.");
            }
		}			
		
		public function result(evt:Event):void
		{
//			try 
//			{
            	this.data = new XML(evt.target.data);
            	sendNotification(ApplicationFacade.DATA_READY);
//            }
//            catch (e:TypeError) 
//            {
//            	sendNotification(ApplicationFacade.ERROR,ApplicationFacade.PARSE_XML_FAILED);
//            }				         				
		}
		
		public function fault(evt:IOErrorEvent):void
		{		
			sendNotification(ApplicationFacade.ERROR,ApplicationFacade.LOAD_FILE_FAILED);			
		}
	}
}