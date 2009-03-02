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
package info.osmatrix.rmframework.app.view
{	
	import flash.events.Event;
	
	import mx.collections.*;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import info.osmatrix.rmframework.app.ApplicationFacade;
	import info.osmatrix.rmframework.app.model.*;
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.event.MainViewEvent;

	public class AppMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AppMediator";
		
		public function AppMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
			
			viewComponent.addEventListener(MainViewEvent.CE_CHAPTERCHANGED , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_SECTIONCHANGED , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_NEXTSECTION , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_PREVSECTION , handleEvent);
			
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
        
        private function handleEvent(evt:MainViewEvent):void
        {
            switch ( evt.type ) 
			{
				case MainViewEvent.CE_CHAPTERCHANGED : 

					break;
				case MainViewEvent.CE_SECTIONCHANGED :
					viewComponent.playSection(evt.body);
					break;
				case MainViewEvent.CE_NEXTSECTION :
					
					break;
				case MainViewEvent.CE_PREVSECTION :
					
					break;
				default:
					break;
							
            }        	
        }
        
        private function initUI():void{
        	// 树型目录
        	//var chapterlist:XMLList = facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;
        	var content:Object = facade.retrieveProxy(ContentProxy.NAME).getData();
        	viewComponent.initContent(CourseVO(content));
        	
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