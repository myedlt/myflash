package view
{
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
			facade.registerMediator( new ContentsMediator( app.contents ) );
			facade.registerMediator( new ControlBoardMediator( app.controlBoard ) );
			facade.registerMediator( new FlashPlayerMediator( app.flashPlayer ) );
			facade.registerMediator( new CurrentPositionMediator( app.currentPosition ) );
			facade.registerMediator( new NavigatorMediator( app.navigator ) );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_FILE_FAILED			
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_FILE_FAILED : Alert.show(note.getBody().toString()); break;				
            }
        }
		
		protected function get app():CWFW
		{
            return viewComponent as CWFW;
        }
	}
}