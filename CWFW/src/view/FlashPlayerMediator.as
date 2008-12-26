package view
{	
	import flash.events.Event;	
	import mx.controls.SWFLoader;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;	

	public class FlashPlayerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "FlashPlayerMediator";		
		
		public function FlashPlayerMediator(viewComponent:Object)
		{
			super(mediatorName, viewComponent);
			player.addEventListener(Event.COMPLETE,loadComplete);
			player.addEventListener(Event.UNLOAD,swfUnload);			
		}
		
		private function loadComplete(evt:Event):void
		{			
			sendNotification(ApplicationFacade.SWF_LOAD_COMPLETE,evt.target);
		}		
		
		private function swfUnload(evt:Event):void
		{
			sendNotification(ApplicationFacade.SWF_UNLOAD);
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.SWF_LOAD						
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.SWF_LOAD : player.load(note.getBody()); break;			 		
             }
		}
		
		protected function get player():SWFLoader
		{
            return viewComponent.player as SWFLoader;
        }	
	}
}