package puremvc.business
{	
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
	
	public class LoadXMLDelegate
	{	
		public var loader:URLLoader;
		private var request:URLRequest
			
		public function LoadXMLDelegate(url:String) 
		{				
			request=new URLRequest(url);	
			loader=new URLLoader();	
			//loader.addEventListener(Event.COMPLETE,loadComplete);
			//loader.addEventListener(IOErrorEvent.IO_ERROR,ioError);				
		}
		
		public function load():void
		{
			try 
			{
                loader.load(request);
            }
            catch (error:SecurityError)
            {
                trace("A SecurityError has occurred.");
            }
		}		
	}
}