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
	import info.osmatrix.rmframework.app.ApplicationFacade;
	import info.osmatrix.rmframework.app.model.*;
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.event.MainViewEvent;
	
	import mx.collections.*;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AppMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AppMediator";
		
		private var contentVO:ContentVO;
		
		public function AppMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
			
			viewComponent.addEventListener(MainViewEvent.CE_CHAPTERCHANGED , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_SECTIONCHANGED , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_NEXTSECTION , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_PREVSECTION , handleEvent);
			viewComponent.addEventListener(MainViewEvent.CE_EXITAPP , handleEvent);			
			
			// AppMediator和DataXMLProxy一起注册，此时不能保证数据已准备好
		}

		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_FILE_FAILED,	
						ApplicationFacade.DATAPREPARED
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_FILE_FAILED : 
					Alert.show(note.getBody().toString()); 
					break;
				case ApplicationFacade.DATAPREPARED :
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
					var sec:SectionVO = contentVO.getSectionById(evt.body.id);
					
					contentVO.curSection = sec;
					viewComponent.playSection(contentVO.getChapterBySectionId(sec.id),sec);
					
					break;
				case MainViewEvent.CE_NEXTSECTION :
					
					contentVO.curSection = contentVO.getSectionNext(contentVO.curSection.id);
					viewComponent.playSection(contentVO.getChapterBySectionId(contentVO.curSection.id), contentVO.curSection);
					
					break;
				case MainViewEvent.CE_PREVSECTION :

					contentVO.curSection = contentVO.getSectionPrev(contentVO.curSection.id);
					viewComponent.playSection(contentVO.getChapterBySectionId(contentVO.curSection.id), contentVO.curSection);
					
					break;
				case MainViewEvent.CE_EXITAPP :
					// 发通知给AppExitCmd保存数据，数据保存成功后发回消息给AppMediator执行注应用推出函数
					viewComponent.exitApp();
					break;				
				default:
					break;
							
            }        	
        }
        
        private function initUI():void{
        	// 此时数据已准备好，在initui之前必须获得VO数据格式
		    contentVO = facade.retrieveProxy(ContentProxy.NAME).getData() as ContentVO;

        	viewComponent.initContent(contentVO);
        	
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