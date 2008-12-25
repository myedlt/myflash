package view
{
	import mx.controls.Label;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.CurrentPosition;

	public class CurrentPositionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CurrentPositionMediator";	
		
		public function CurrentPositionMediator(viewComponent:CurrentPosition)
		{
			super(NAME,viewComponent);			
		} 
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.CHAPTER_CHANGE,
						ApplicationFacade.SECTION_CHANGE		
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.CHAPTER_CHANGE : txtChapter.text=note.getBody().toString(); break;
			 	case ApplicationFacade.SECTION_CHANGE : txtSection.text=note.getBody().toString(); break;				
             }
		}
		
		protected function get txtChapter():Label
		{
            return viewComponent.txtChapter as Label;
        }	
        
        protected function get txtSection():Label
		{
            return viewComponent.txtSection as Label;
        }	
	}
}