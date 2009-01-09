package com.san.webservice
{
	import com.mh.globals.GlobalsManager;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class WebserviceProxy
	{
		
		private var _loader:URLLoader;
		private var _request:URLRequest;
	
		private var _callback:Function;
	
	
		public function WebserviceProxy()
		{
			var url:String = GlobalsManager.globals.getGlobal( "sendPostCardServiceUrl" );
			
			_request = new URLRequest( url );
			_request.method = URLRequestMethod.POST;
			
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, loadComplete );	
			_loader.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loadSecurity );	
		}
		
		
		public function sendPostCard( toName:String, toEmail:String, message:String, imageData:String, callback:Function ):void
		{
			_callback = callback;
			
			var vars:URLVariables = new URLVariables();
				vars.toName = toName;
				vars.toEmail = toEmail;
				vars.message = message;
				vars.imageData = imageData;
				
			_request.data = vars;
			
			trace( "To name was", toName );
			trace( "To email was", toEmail );
			trace( "Message was", message );
			
			_loader.load( _request );
		}
		
		
		private function loadComplete( e:Event ):void
		{
			
			var loader:URLLoader = e.target as URLLoader;
			
			try {
				
				var request:XML = XML(loader.data);
				
				var success:String = request..success;
				var message:String = request..message;
				
				if( _callback != null )
					_callback.call( null, success=="Y", message, request.data );
			}
			catch(e:Error)
			{
				if( _callback != null )
					_callback.call( null, false, "Error occured while trying to parse response" );
			}
			
		}
		
		private function loadError( e:IOErrorEvent ):void
		{
			if( _callback != null )
				_callback.call( null, false, "IOError occured while sending request - "+e.text );
		}

		private function loadSecurity( e:SecurityErrorEvent ):void
		{
			if( _callback != null )
				_callback.call( null, false, "SecurityError occured while sending request - "+e.text );
		}

	}
}