package view
{		
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;	

	public class ModuleLoaderMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ModuleLoaderMediator";		
		
		public function ModuleLoaderMediator(viewComponent:Object)
		{
			super(mediatorName, viewComponent);
						
		}
		
		/* override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade						
				   ];
		}
		
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case : ; break;
			 				 		
             }
		}
		
		protected function get ():
		{
            return viewComponent as ;
        }	 */
	}
}