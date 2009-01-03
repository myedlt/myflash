package mvc.view
{	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import mvc.ApplicationFacade;
	import mvc.view.component.ControlBoardComponent;

	public class ControlBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ControlBoardMediator";		
		
		public function ControlBoardMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);			
				
			controlBoard.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);
			controlBoard.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);					
		}		
		
		private function prevSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.PREVIOUS_SECTION);	
			//防止用户点击频率过快造成声音混乱 点击间隔为200毫秒
			controlBoard.btnPrevSection.removeEventListener(MouseEvent.CLICK,prevSection);
			setTimeout(function():void{controlBoard.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);},200);			
		}
		
		private function nextSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.NEXT_SECTION);
			//防止用户点击频率过快造成声音混乱 点击间隔为200毫秒
			controlBoard.btnNextSection.removeEventListener(MouseEvent.CLICK,nextSection);
			setTimeout(function():void{controlBoard.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);},200);	
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
		}  */
		
		protected function get controlBoard():ControlBoardComponent
		{
            return viewComponent as ControlBoardComponent;
        }	 
	}
}