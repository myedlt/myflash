package view
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.events.SliderEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.ControlBoard;

	public class ControlBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ControlBoardMediator";	
		private var stoped:Boolean;	//记录当前播放状态是否停止
		private var pressing:Boolean;//进度条拖拽按钮是否按下
		
		public function ControlBoardMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);			
			
			controlBoard.btnPlayOrPause.addEventListener("play",play);	
			controlBoard.btnPlayOrPause.addEventListener("pause",pause);
			controlBoard.btnStop.addEventListener(MouseEvent.CLICK,stop);	
			controlBoard.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);
			controlBoard.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);					
			controlBoard.sldCtrlProgress.addEventListener(SliderEvent.CHANGE,progressChange);
			controlBoard.sldCtrlProgress.addEventListener(SliderEvent.THUMB_PRESS,thumbPress);
			controlBoard.sldCtrlProgress.addEventListener(SliderEvent.THUMB_RELEASE,thumbRelease);	
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
				controlBoard.pauseState();
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
		
		private function onSWFLoadComplete(mc:MovieClip):void
		{						
			if(mc!=null)
			{
				controlBoard.sldCtrlProgress.maximum=mc.totalFrames;
			}
			if(stoped==true)
			{
				controlBoard.playState();
				stoped=false;
			}			
		}		
		
		private function enterFrame(mc:MovieClip):void
		{
			if(mc.currentFrame!=mc.totalFrames)
			{
				controlBoard.sldCtrlProgress.value=mc.currentFrame;
			}
			else
			{
				if(stoped==false)
				{
					controlBoard.pauseState();
					stoped=true;
				}				
			}
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.SWF_LOAD_COMPLETE,
						ApplicationFacade.ENTER_FRAME												
				   ];
		} 
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.SWF_LOAD_COMPLETE : onSWFLoadComplete(note.getBody()as MovieClip); break;
			 	case ApplicationFacade.ENTER_FRAME : enterFrame(note.getBody()as MovieClip); break;			 	
             }
		} 
		
		protected function get controlBoard():ControlBoard
		{
            return viewComponent as ControlBoard;
        }	 
	}
}