/**
 *	监听事件：
 * 		CE_ITEMCLICK
 * 		CE_NEXTSECTION
 * 		CE_PREVSECTION
 * 	接口函数：
 * 		setContentXML(content:XML):void
 * 		setLocator():void
 * 		set
 *  
*/
package puremvc.view
{
	import api.event.AppEvent;
	
	import flash.events.Event;
	
	import mx.collections.*;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.*;
	import puremvc.model.vo.*;

	public class AppMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AppMediator";
		
		public function AppMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
			
			viewComponent.addEventListener(AppEvent.CE_CHAPTERCHANGED , handleEvent);
			viewComponent.addEventListener(AppEvent.CE_SECTIONCHANGED , handleEvent);
			viewComponent.addEventListener(AppEvent.CE_NEXTSECTION , handleEvent);
			viewComponent.addEventListener(AppEvent.CE_PREVSECTION , handleEvent);
			
		}

		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_FILE_FAILED,	
						ApplicationFacade.INITUI
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_FILE_FAILED : 
					Alert.show(note.getBody().toString()); 
					break;
				case ApplicationFacade.INITUI :
					initUI();
					break;
				default:
					break;
							
            }
        }
        
        private function handleEvent(evt:Event):void
        {
            switch ( evt.type ) 
			{
				case AppEvent.CE_CHAPTERCHANGED : 

					break;
				case AppEvent.CE_SECTIONCHANGED :
					
					break;
				case AppEvent.CE_NEXTSECTION :
					
					break;
				case AppEvent.CE_PREVSECTION :
					
					break;
				default:
					break;
							
            }        	
        }
        
        private function initUI():void{
        	// 树型目录
        	var chapterlist:XMLList = facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;
        	viewComponent.initContent(chapterlist);
        	
        	// 当前位置: Navigator
        	// 学习进度：History
        	// 统一在一个CourseProxy中
        	 
        }
        
        private function refreshUI():void{
        	// 更新界面显示，如目录的当前选中项、当前位置、进度显示和按钮可用性控制
        	//viewComponent.refreshUI();
        }
        
   }
}