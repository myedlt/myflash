
package puremvc.view
{
	import mx.controls.Alert;
	import mx.collections.*;
	import flash.utils.setTimeout;
	import flash.events.MouseEvent;	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.model.vo.*;
	import puremvc.model.*;
	import puremvc.ApplicationFacade;
	import api.ICourse;
	import api.event.CourseEvent;

	public class AppMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AppMediator";
		
		public function AppMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
			//var course:ICourse = ICourse(viewComponent);
			viewComponent.addEventListener(CourseEvent.CHAPTERCHANGED , handleEvent);
			
			// 目录树
			//viewComponent.initContent(CourseVO);
			refreshTree();
			
			// 控制面板
			viewComponent.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);
			viewComponent.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);		
			
		}

		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_FILE_FAILED,	
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_FILE_FAILED : Alert.show(note.getBody().toString()); break;				
            }
        }
        
        private function handleEvent():void
        {
        	
        }
        
		public function refreshTree():void
		{
			viewComponent.treeContents.labelField="name";
			viewComponent.treeContents.dataProvider=facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;									
			//treeContents.callLater(expandAllNode);//初始展开所有节点	

		}        
		private function prevSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.PREVIOUS_SECTION);	
			//防止用户点击频率过快造成声音混乱 点击间隔为200毫秒
			viewComponent.btnPrevSection.removeEventListener(MouseEvent.CLICK,prevSection);
			setTimeout(function():void{viewComponent.btnPrevSection.addEventListener(MouseEvent.CLICK,prevSection);},200);			
		}
		
		private function nextSection(evt:MouseEvent):void
		{
			sendNotification(ApplicationFacade.NEXT_SECTION);
			//防止用户点击频率过快造成声音混乱 点击间隔为200毫秒
			viewComponent.btnNextSection.removeEventListener(MouseEvent.CLICK,nextSection);
			setTimeout(function():void{viewComponent.btnNextSection.addEventListener(MouseEvent.CLICK,nextSection);},200);	
		}		        
	}
}