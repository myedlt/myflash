package view
{
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
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_SWF			
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.LOAD_SWF : player.load(note.getBody()); break;				
             }
		}
		
		protected function get player():SWFLoader
		{
            return viewComponent.player as SWFLoader;
        }	
	}
}