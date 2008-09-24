package com.mh.globals
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class GlobalsManager
	{

		private var _callback:Function;


		public static const globals:GlobalsManager = new GlobalsManager();
		
		
		private var _globalsHolder:Object = {};
		
		
		public function GlobalsManager()
		{
			if( globals )
				throw new Error( "Singleton Error - Use GlobalsManager.globals" );
		}
		
		
		public function getGlobal( name:String ):String
		{
			var value:String = _globalsHolder[ name ]
			return value;
		}
		
		public function setGlobal( name:String, value:String ):void
		{
			_globalsHolder[ name ] = value;
		}
		
		public function loadGlobals( file:String = "globals.xml", callback:Function = null ):void
		{
			_callback = callback;
			
			var request:URLRequest = new URLRequest( file+"?rand="+Math.random() ); // prevent caching			
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener( Event.COMPLETE, loadComplete );	
			loader.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loadSecurity );	
			
			loader.load( request );
		}
		
		private function loadComplete( e:Event ):void
		{
			
			var loader:URLLoader = e.target as URLLoader;
			
			try {
				
				var data:XML = XML(loader.data);
				
				for each( var global:XML in data..global )
				{
					setGlobal( global.@name, global.@value );
				}
				
				if( _callback != null )
					_callback.call( null, true, "globals loaded" );
			}
			catch(e:Error)
			{
				if( _callback != null )
					_callback.call( null, false, "Error occured while trying to parse globals file" );
			}
			
		}
		
		private function loadError( e:IOErrorEvent ):void
		{
			if( _callback != null )
				_callback.call( null, false, "IOError occured while loading globals - "+e.text );
		}

		private function loadSecurity( e:SecurityErrorEvent ):void
		{
			if( _callback != null )
				_callback.call( null, false, "SecurityError occured while loading globals - "+e.text );
		}


	}
}