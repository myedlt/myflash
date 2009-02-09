package puremvc.model
{	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.LoadXMLDelegate;
	import puremvc.model.utils.WriteFile;
	//数据初始化(加载xml数据文件),数据加载完毕发送INITIALIZE通知
	public class DataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataProxy";		
		private var filepath:String;
		
		public function DataProxy(filepath:String) 
		{
			super( NAME );	
			this.filepath = filepath;		
			var delegate : LoadXMLDelegate = new LoadXMLDelegate(filepath);
			delegate.loader.addEventListener(Event.COMPLETE,result);
			delegate.loader.addEventListener(IOErrorEvent.IO_ERROR,fault);
			delegate.load();
		}			
		
		public function result(evt:Event):void
		{
			try 
			{
            	this.data = new XML(evt.target.data);
            	sendNotification(ApplicationFacade.STARTUP);
            }
            catch (e:TypeError) 
            {
            	sendNotification(ApplicationFacade.ERROR,ApplicationFacade.PARSE_XML_FAILED);
            }				         				
		}
		
		public function fault(evt:IOErrorEvent):void
		{		
			sendNotification(ApplicationFacade.ERROR,ApplicationFacade.LOAD_FILE_FAILED);			
		}
		
		public function getCourseList():XMLList
        {
        	return data.course;
        }  
        
        public function updateContent(elementName:String,data:*):void
        {
        	var content:String=XML(this.data).replace(elementName,data).toXMLString();
        	if(this.filepath!=null&&this.filepath!="")
        	{
        		WriteFile.write(content,filepath);
        	}
        }
	}
}