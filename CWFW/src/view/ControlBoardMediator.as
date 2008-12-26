package view
{
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.ControlBoard;

	public class ControlBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ControlBoardMediator";	
		
		public function ControlBoardMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);	
			controlBoard.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);
			controlBoard.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);
			controlBoard.btnPlayOrPause.addEventListener(MouseEvent.CLICK,playOrPause);	
			controlBoard.btnColumnOpenOrClose.addEventListener(MouseEvent.CLICK,openOrClose);	
		}
		
		private function prevSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.PREVIOUS_SECTION);
			trace("prevSection");
		}
		
		private function nextSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.NEXT_SECTION);
			trace("nextSection");
		}		
		//播放或暂停
		private function playOrPause(evt:MouseEvent):void
		{
			if(controlBoard.btnPlayOrPause.toolTip=="播放")
			{
				controlBoard.btnPlayOrPause.toolTip="暂停";
			}
			else
			{
				controlBoard.btnPlayOrPause.toolTip="播放";
			}
		}
		//音量关闭或打开
		private function openOrClose(evt:MouseEvent):void
		{
			if(controlBoard.btnColumnOpenOrClose.toolTip=="关闭")
			{
				controlBoard.btnColumnOpenOrClose.toolTip="打开";
			}
			else
			{
				controlBoard.btnColumnOpenOrClose.toolTip="关闭";
			}
		}
		
		/* override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade			
				   ];
		} */
				
		/* override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade : ; break;				
             }
		} */
		
		protected function get controlBoard():ControlBoard
		{
            return viewComponent as ControlBoard;
        }	 
	}
}