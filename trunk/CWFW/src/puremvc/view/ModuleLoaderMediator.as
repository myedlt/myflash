package mvc.view
{
	import module.SwfPlayerModule;
	
	import mvc.ApplicationFacade;
	import mvc.business.CurrentInfo;
	
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;	

	public class ModuleLoaderMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ModuleLoaderMediator";		
		
		public function ModuleLoaderMediator(viewComponent:Object)
		{
			super(mediatorName, viewComponent);
			moduleLoader.addEventListener(ModuleEvent.READY,ready);			
		}
		
		public function loadModule(url:String):void
		{
			moduleLoader.url=url;
			//moduleLoader.loadModule();
		}
		
		public function ready(evt:ModuleEvent):void
		{
			facade.registerMediator(new SwfPlayerMediator(moduleLoader.child as SwfPlayerModule));
        	sendNotification(ApplicationFacade.SWF_LOAD,CurrentInfo.getInstance().getCurrentSection().path);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.MODULE_LOAD						
				   ];
		}
		
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.MODULE_LOAD: loadModule(note.getBody().toString()); break;
			 				 		
             }
		}
		
		public function get moduleLoader():ModuleLoader
		{
            return viewComponent as ModuleLoader;
        }
	}
}