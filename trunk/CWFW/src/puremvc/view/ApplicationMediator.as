package puremvc.view
{
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.events.ListEvent;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.CourseProxy;
	import puremvc.model.vo.ChapterVO;
	import puremvc.model.vo.CourseVO;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );		
			app.treeContents.addEventListener(ListEvent.ITEM_CLICK,itemClick);
		}
		
		private function initialize():void
		{
			//treeContents.labelField="@name";
			//treeContents.dataProvider=facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;	
			app.treeContents.labelField="name";				
			var courseList:Array = CourseProxy(facade.retrieveProxy(CourseProxy.NAME)).getCourses();			
        	for each(var course:CourseVO in courseList)
			{
				var chapterList:ArrayCollection=new ArrayCollection();
				for each(var chapter:ChapterVO in course.chapters)
				{        					
					chapterList.addItem({name:chapter.name,children:chapter.sections,vo:chapter});				
	        	}	       					
				app.treeDataProvider.addItem({name:course.name,children:chapterList,vo:course});				
        	}        									
			//treeContents.callLater(expandAllNode);//初始展开所有节点			
		}
		
		public function expandAllNode():void
		{
			for each(var item:Object in app.treeDataProvider)
			{					
				app.treeContents.expandChildrenOf(item,true);
			}
		}
		
		private function itemClick(evt:ListEvent):void
		{			
//			if(!treeContents.dataDescriptor.isBranch(evt.target.selectedItem))
//			{							
				sendNotification(ApplicationFacade.CONTENTS_ITEM_CLICK,evt.target.selectedItem);				
				//trace("itemClick:"+evt.target.selectedItem.toXMLString());
//			}			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_FILE_FAILED,
						ApplicationFacade.INIT_COMPLETE			
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_FILE_FAILED : Alert.show(note.getBody().toString()); break;	
				case ApplicationFacade.INIT_COMPLETE : initialize(); break;				
            }
        }
		
		public function get app():CWAssemble
		{
            return viewComponent as CWAssemble;
        }
	}
}