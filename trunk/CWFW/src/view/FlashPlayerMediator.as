package view
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mx.controls.SWFLoader;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;	

	public class FlashPlayerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "FlashPlayerMediator";		
		private var mc:MovieClip;
		
		public function FlashPlayerMediator(viewComponent:Object)
		{
			super(mediatorName, viewComponent);
			player.addEventListener(Event.COMPLETE,loadComplete);
			player.addEventListener(Event.UNLOAD,swfUnload);			
		}
		
		private function loadComplete(evt:Event):void
		{
			try
			{
				mc=MovieClip(player.content);				
				mc.addEventListener(Event.ENTER_FRAME,enterFrame);									
			}
			catch(e:Error)
			{		
				mc=null;									
				trace("SWF文件转换成MovieClip对象时出错,可能与flash发布版本有关.");				
			}			
			sendNotification(ApplicationFacade.SWF_LOAD_COMPLETE,mc);
		}		
		
		private function swfUnload(evt:Event):void
		{
			if(mc!=null)
			{
				mc.stop();
				mc.removeEventListener(Event.ENTER_FRAME,enterFrame);
			}
		}		
		
		private function enterFrame(evt:Event):void
		{
			sendNotification(ApplicationFacade.ENTER_FRAME,evt.target);
		}	
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.SWF_LOAD,
						ApplicationFacade.GOTO_AND_PLAY,
						ApplicationFacade.GOTO_AND_STOP,
						ApplicationFacade.PLAY,
						ApplicationFacade.PAUSE,
						ApplicationFacade.STOP						
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.SWF_LOAD : player.load(note.getBody()); break;
			 	case ApplicationFacade.PLAY : mc.play(); break;
			 	case ApplicationFacade.PAUSE : mc.stop(); break;
			 	case ApplicationFacade.STOP : mc.gotoAndStop(1); break;	
			 	case ApplicationFacade.GOTO_AND_PLAY : mc.gotoAndPlay(note.getBody()); break;	
			 	case ApplicationFacade.GOTO_AND_STOP : mc.gotoAndStop(note.getBody()); break;			 		
             }
		}
		
		protected function get player():SWFLoader
		{
            return viewComponent.player as SWFLoader;
        }	
	}
}