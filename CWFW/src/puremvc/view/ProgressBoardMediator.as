package puremvc.view
{
	import flash.events.MouseEvent;
	
	import mx.events.SliderEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.view.component.ProgressBoardComponent;
	
	public class ProgressBoardMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = "ProgressBoardMediator";
		private var stoped:Boolean=true;	//记录当前播放状态是否停止
		private var pressing:Boolean;//进度条拖拽按钮是否按下
		
		public function ProgressBoardMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);
			
			progressBoard.btnPlayOrPause.addEventListener("play",play);	
			progressBoard.btnPlayOrPause.addEventListener("pause",pause);
			progressBoard.btnStop.addEventListener(MouseEvent.CLICK,stop);
			progressBoard.sldCtrlProgress.addEventListener(SliderEvent.CHANGE,progressChange);
			progressBoard.sldCtrlProgress.addEventListener(SliderEvent.THUMB_PRESS,thumbPress);
			progressBoard.sldCtrlProgress.addEventListener(SliderEvent.THUMB_RELEASE,thumbRelease);
		}
		
		private function play(evt:MouseEvent):void
		{
			if(stoped)
			{
				sendNotification(ApplicationFacade.PLAY);
				stoped=false;
			}
		}
		
		private function pause(evt:MouseEvent):void
		{
			if(!stoped)
			{
				sendNotification(ApplicationFacade.PAUSE);
				stoped=true;
			}	
		}				
		
		private function stop(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.STOP);
			if(stoped==false)
			{
				stoped=true;
				progressBoard.pauseState();
			}			
		}
		
		private function onLoadComplete(value:uint):void
		{						
			progressBoard.sldCtrlProgress.maximum=value;
			if(stoped==true)
			{
				progressBoard.playState();
				stoped=false;
			}			
		}		
		
		private function progressUpdate(value:uint):void
		{
			if(progressBoard.sldCtrlProgress.value!=progressBoard.sldCtrlProgress.maximum)
			{
				progressBoard.sldCtrlProgress.value=value;
			}
			else
			{
				if(stoped==false)
				{
					progressBoard.pauseState();
					stoped=true;
				}				
			}
		}		
		
		private function progressChange(evt:SliderEvent):void
		{ 			
			if(stoped || pressing)
			{
				sendNotification(ApplicationFacade.GOTO_AND_STOP,evt.value);
			}
			else
			{
				sendNotification(ApplicationFacade.GOTO_AND_PLAY,evt.value);
			}
		}
		
		private function thumbPress(evt:SliderEvent):void
		{
			sendNotification(ApplicationFacade.PAUSE);
			pressing=true;
		}
		
		private function thumbRelease(evt:SliderEvent):void
		{
			if(!stoped)sendNotification(ApplicationFacade.PLAY);
			pressing=false;
		}	
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.SWF_LOAD_COMPLETE,
						ApplicationFacade.FLV_LOAD_COMPLETE,
						ApplicationFacade.ENTER_FRAME,
						ApplicationFacade.PLAYHEAD_UPDATE												
				   ];
		} 
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.SWF_LOAD_COMPLETE : onLoadComplete(note.getBody()as uint); break;
			 	case ApplicationFacade.FLV_LOAD_COMPLETE : onLoadComplete(note.getBody()as uint); break;
			 	case ApplicationFacade.ENTER_FRAME : progressUpdate(note.getBody()as uint); break;	
			 	case ApplicationFacade.PLAYHEAD_UPDATE : progressUpdate(note.getBody()as uint); break;			 	
             }
		} 
		
		protected function get progressBoard():ProgressBoardComponent
		{
            return viewComponent as ProgressBoardComponent;
        }	
	}
}