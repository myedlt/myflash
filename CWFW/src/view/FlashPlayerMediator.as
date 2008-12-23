package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.FlashPlayer;

	public class FlashPlayerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "FlashPlayerMediator";	
		
		public function FlashPlayerMediator(viewComponent:FlashPlayer)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD			
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.LOAD:
					 flashPlayer.player.load(note.getBody());
					 break;
				
             }
		}
		
		protected function get flashPlayer():FlashPlayer
		{
            return viewComponent as FlashPlayer;
        }	
	}
}