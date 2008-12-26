package view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;	
	import mx.controls.SWFLoader;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.ControlBoard;

	public class ControlBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ControlBoardMediator";	
		private var soundTrans:SoundTransform=SoundMixer.soundTransform;
		private var mc:MovieClip;
		
		public function ControlBoardMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);	
			//组件初始化
			pauseState();//播放开关处于暂停状态
			openState();//音量开关处于打开状态
			controlBoard.sldCtrlColumn.dataTipFormatFunction=formatColumeToolTip;
			controlBoard.sldCtrlProgress.dataTipFormatFunction=formatProgressToolTip;
			controlBoard.sldCtrlProgress.minimum=1;
			//添加事件(监听器)
			controlBoard.btnStop.addEventListener(MouseEvent.CLICK,stop);
			controlBoard.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);
			controlBoard.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);
			controlBoard.btnPlayOrPause.addEventListener(MouseEvent.CLICK,playOrPause);	
			controlBoard.btnColumnOpenOrClose.addEventListener(MouseEvent.CLICK,openOrClose);	
		}		
		
		private function stop(evt:MouseEvent):void
		{
			mc.gotoAndStop(1);
			pauseState();
		}
		
		private function prevSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.PREVIOUS_SECTION);			
		}
		
		private function nextSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.NEXT_SECTION);			
		}		
		//播放或暂停
		private function playOrPause(evt:MouseEvent):void
		{
			if(controlBoard.btnPlayOrPause.toolTip=="播放")
			{
				playState();
				mc.play();
			}
			else
			{
				pauseState();
				mc.stop();
			}
		}
		//音量关闭或打开
		private function openOrClose(evt:MouseEvent):void
		{
			if(controlBoard.btnColumnOpenOrClose.toolTip=="关闭")
			{
				closeState();
				soundTrans.volume=0;
				SoundMixer.soundTransform=soundTrans;
			}
			else
			{
				openState();
				soundTrans.volume=controlBoard.sldCtrlColumn.value;
				SoundMixer.soundTransform=soundTrans;
			}
		}
		
		private function playState():void
		{
			controlBoard.btnPlayOrPause.toolTip="暂停";
		}
		
		private function pauseState():void
		{
			controlBoard.btnPlayOrPause.toolTip="播放";
		}
		
		private function onSWFLoadComplete(loader:SWFLoader):void
		{						
			try
			{
				mc=MovieClip(loader.content);
				controlBoard.sldCtrlProgress.maximum=mc.totalFrames;
				mc.addEventListener(Event.ENTER_FRAME,enterFrame);									
			}
			catch(e:Error)
			{											
				trace("SWF文件转换成MovieClip对象时出错,可能与flash发布版本有关.");
			}
			if(controlBoard.btnPlayOrPause.toolTip=="播放")
			{
				playState();
			}			
		}
		
		private function onSWFUnload():void
		{
			mc.stop();
			mc.removeEventListener(Event.ENTER_FRAME,enterFrame);
		}
		
		private function enterFrame(evt:Event):void
		{
			controlBoard.sldCtrlProgress.value=evt.target.currentFrame;
		}		
		
		private function openState():void
		{
			controlBoard.btnColumnOpenOrClose.toolTip="关闭";
		}
		
		private function closeState():void
		{
			controlBoard.btnColumnOpenOrClose.toolTip="打开";
		}
		
		private function formatProgressToolTip(value:int):String
    	{
    		value=Math.ceil(value / 12);  //flash 12frames/s  			
    		var result:String = (value % 60).toString();
      	    if (result.length == 1)
      	    {
         		result = Math.floor(value / 60).toString() + ":0" + result;
       	 	}
      		else
		  	{
       	    	result = Math.floor(value / 60).toString() + ":" + result;
       	  	}      			      			 
      	    return result;
  		} 
  			
  		private function formatColumeToolTip(value:Number):String
  		{
  			var temp:String=value.toString();
  			if(temp.length==1)
  			{
  				return temp+".0";
  			}
  			else
  			{
  				return temp.substr(0,3);
  			}
  		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.SWF_LOAD_COMPLETE,
						ApplicationFacade.SWF_UNLOAD						
				   ];
		} 
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.SWF_LOAD_COMPLETE : onSWFLoadComplete(note.getBody()as SWFLoader); break;
			 	case ApplicationFacade.SWF_UNLOAD : onSWFUnload(); break;
             }
		} 
		
		protected function get controlBoard():ControlBoard
		{
            return viewComponent as ControlBoard;
        }	 
	}
}