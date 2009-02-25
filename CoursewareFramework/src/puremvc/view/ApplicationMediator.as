package puremvc.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import module.FlvPlayerModule;
	import module.ImagePlayerModule;
	import module.SwfPlayerModule;
	
	import mx.controls.Alert;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	import mx.modules.ModuleManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.ModuleLocator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		private var contentUrl:String;
		private var contentType:String;
		private var hasContrlBar:String;
		private var mainApp:MovieClip;
		private var config:XML;
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
			player.addEventListener(ModuleEvent.READY,ready);						
		}
		
		private function initialize():void
		{
			config=ApplicationFacade.getConfigInfoProxy().getData() as XML;
			app.mainLoader.width=config.layout.main.@width;
			app.mainLoader.height=config.layout.main.@height;			
			app.mainLoader.addEventListener(Event.COMPLETE,loadComplete);
			app.mainLoader.load(config.layout.main.@path);		
		}
		
		 public function loadComplete(event:Event):void
		{
			try
			{
				mainApp=MovieClip(app.mainLoader.content);
				mainApp.addEventListener("nextPage",nextPage);
				mainApp.addEventListener("prevPage",prevPage);
				mainApp.addEventListener("exit",exit);
				//mainApp.addEventListener("play",play);
				//mainApp.addEventListener("pause",pause);
				//mainApp.addEventListener("stop",stop);
				//mainApp.addEventListener("volumeOpen",volumeOpen);
				//mainApp.addEventListener("volumeClose",volumeClose);
				
				var point:Point=new Point(config.layout.player.@x,config.layout.player.@y);	
				player.x=app.mainLoader.localToGlobal(point).x;
				player.y=app.mainLoader.localToGlobal(point).y;
				player.width=config.layout.player.@width;
				player.height=config.layout.player.@height;
			}
			catch(e:Error)
			{													
				trace("SWF文件转换成MovieClip对象时出错,可能与flash发布版本有关.");				
			}						
		} 
		
		public function exit(event:Event):void
		{
			navigateToURL(new URLRequest("javascript:window.top.close()"),"_self");
		}
		
		public function nextPage(event:Event):void
		{
			sendNotification(ApplicationFacade.NEXT_SECTION);
		}
		
		public function prevPage(event:Event):void
		{
			sendNotification(ApplicationFacade.PREVIOUS_SECTION);
		}
		
		public function loadModule(data:Object):void
		{
			doUnload();//解决跨模块串音问题			
			contentUrl=data.contentUrl;
			contentType=data.contentType;
			if(data.hasContrlBar!=null)hasContrlBar=data.hasContrlBar;
			player.url=data.moduleUrl;
			//player.loadModule();
		}
		
		public function doUnload():void
		{
			if(ModuleManager.getModule(ModuleLocator.SwfPlayerModule).loaded)
			{
				SwfPlayerModule(player.child).swfUnload(null);
			}
			if(ModuleManager.getModule(ModuleLocator.FlvPlayerModule).loaded)
			{
				FlvPlayerModule(player.child).stop(null);
			}
		}
		
		public function ready(evt:ModuleEvent):void
		{			
			switch(contentType)
        	{        		
        		case "flash":loadSwf({path:contentUrl,hasContrlBar:hasContrlBar});break;        		
        		case "image":loadImage(contentUrl);break;
        		case "flv":loadFlv(contentUrl);break;
        	}      
		}
		
		public function loadSwf(obj:Object):void
		{
			SwfPlayerModule(player.child).callLater(SwfPlayerModule(player.child).load,[obj.path,obj.hasContrlBar]);
		}
		
		public function loadFlv(url:String):void
		{
			FlvPlayerModule(player.child).callLater(FlvPlayerModule(player.child).load,[url]);
		}
		
		public function loadImage(url:String):void
		{
			ImagePlayerModule(player.child).callLater(ImagePlayerModule(player.child).load,[url]);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.ERROR,
						ApplicationFacade.DATA_READY,
						ApplicationFacade.MODULE_LOAD,
						ApplicationFacade.SWF_LOAD,
						ApplicationFacade.IMAGE_LOAD,
						ApplicationFacade.FLV_LOAD			
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.ERROR : Alert.show(note.getBody().toString(),"Error"); break;
				case ApplicationFacade.DATA_READY : initialize(); break;	
				case ApplicationFacade.MODULE_LOAD: loadModule(note.getBody()); break;
			 	case ApplicationFacade.SWF_LOAD: loadSwf(note.getBody()); break;	
			 	case ApplicationFacade.IMAGE_LOAD: loadImage(note.getBody().toString()); break;
			 	case ApplicationFacade.FLV_LOAD: loadFlv(note.getBody().toString()); break;				
            }
        }
		
		public function get app():index
		{
            return viewComponent as index;
        }		
        
        public function get player():ModuleLoader
		{
            return viewComponent.mainPlayer as ModuleLoader;
        }
	}
}