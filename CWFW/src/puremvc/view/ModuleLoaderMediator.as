package puremvc.view
{
	import module.FlvPlayerModule;
	import module.ImagePlayerModule;
	import module.SwfPlayerModule;
	
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.ApplicationFacade;	

	public class ModuleLoaderMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ModuleLoaderMediator";		
		private var contentUrl:String;
		private var contentType:String;
		
		public function ModuleLoaderMediator(viewComponent:Object)
		{
			super(mediatorName, viewComponent);
			moduleLoader.addEventListener(ModuleEvent.READY,ready);			
		}
		
		public function loadModule(data:Object):void
		{
			contentUrl=data.contentUrl;
			contentType=data.contentType;
			moduleLoader.url=data.moduleUrl;
			//moduleLoader.loadModule();
		}
		
		public function ready(evt:ModuleEvent):void
		{			
			switch(contentType)
        	{
        		case "flex":
        		case "flash":loadSwf({path:contentUrl,type:contentType});break;        		
        		case "image":loadImage(contentUrl);break;
        		case "flv":loadFlv(contentUrl);break;
        	}      
		}
		
		public function loadSwf(obj:Object):void
		{
			SwfPlayerModule(moduleLoader.child).callLater(SwfPlayerModule(moduleLoader.child).load,[obj.path,obj.type]);
		}
		
		public function loadFlv(url:String):void
		{
			FlvPlayerModule(moduleLoader.child).callLater(FlvPlayerModule(moduleLoader.child).load,[url]);
		}
		
		public function loadImage(url:String):void
		{
			ImagePlayerModule(moduleLoader.child).callLater(ImagePlayerModule(moduleLoader.child).load,[url]);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.MODULE_LOAD,
						ApplicationFacade.SWF_LOAD,
						ApplicationFacade.IMAGE_LOAD,
						ApplicationFacade.FLV_LOAD						
				   ];
		}
		
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.MODULE_LOAD: loadModule(note.getBody()); break;
			 	case ApplicationFacade.SWF_LOAD: loadSwf(note.getBody()); break;	
			 	case ApplicationFacade.IMAGE_LOAD: loadImage(note.getBody().toString()); break;
			 	case ApplicationFacade.FLV_LOAD: loadFlv(note.getBody().toString()); break;		 		
             }
		}
		
		public function get moduleLoader():ModuleLoader
		{
            return viewComponent as ModuleLoader;
        }
	}
}