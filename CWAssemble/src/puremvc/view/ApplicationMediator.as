package puremvc.view
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.DataProxy;
	import puremvc.model.utils.CurrentInfo;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		private var currInfo:CurrentInfo = CurrentInfo.getInstance();
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
					
			app.treeContents.addEventListener(ListEvent.ITEM_CLICK,itemClick);			
			app.btnDelete.addEventListener(MouseEvent.CLICK,deleteHandler);
			app.btnReset.addEventListener(MouseEvent.CLICK,resetHandler);
			app.btnSave.addEventListener(MouseEvent.CLICK,saveHandler);			
			app.btnAddCourse.addEventListener(MouseEvent.CLICK,addCourse);
			app.btnAddChapter.addEventListener(MouseEvent.CLICK,addChapter);
			app.btnAddSection.addEventListener(MouseEvent.CLICK,addSection);			
		}
		
		private function initialize():void
		{
			app.treeContents.labelField="@name";
			var courseList:XMLList=DataProxy(facade.retrieveProxy(DataProxy.NAME)).getCourseList();
			app.treeDataProvider.source=courseList;
			app.treeContents.callLater(expandAllNode);//初始展开所有节点			
			displayCurrInfo("course");//初始显示课程信息				
		}
		
		public function courseInfo(event:MouseEvent):void{
			displayCurrInfo("course");
		}
		
		public function addCourse(evt:MouseEvent):void
		{
			app.myViewStack.selectedChild=app.courseCanvas;
			app.courseForm.reset();
			app.courseForm.flag="add";
		}
		
		public function addChapter(evt:MouseEvent):void
		{			
			app.myViewStack.selectedChild=app.chapterCanvas;
			app.chapterForm.reset();
			app.chapterForm.flag="add";
		}
		
		public function addSection(evt:MouseEvent):void
		{			
			app.myViewStack.selectedChild=app.sectionCanvas;
			app.sectionForm.reset();
			app.sectionForm.flag="add";
		}		
		
		public function deleteHandler(evt:MouseEvent):void
		{
			
		}
		
		public function resetHandler(evt:MouseEvent):void
		{
			Object(app.myViewStack.selectedChild.getChildAt(0)).reset();
		}
		
		public function saveHandler(evt:MouseEvent):void
		{
			var selectedItem:Object=app.myViewStack.selectedChild.getChildAt(0);
			var index:int;
			if(selectedItem.validate()){
				switch(selectedItem.id)
				{
					case "courseForm":break;
					case "chapterForm":break;
					case "sectionForm":
						var temp:XML=selectedItem.getter();
						app.treeDataProvider.source.(@id==currInfo.getChapter().@id).replace(index,temp);
						break;
				}
			}
		}
		public function getIndex(item:XML):int{
			if(item.name().toString().toLowerCase()=="section")
			{
						
			}
			else if(item.name().toString().toLowerCase()=="chapter")
			{
				
			}
			else
			{
				
			}	
			return null;
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
			sendNotification(ApplicationFacade.CONTENTS_ITEM_CLICK,evt.target.selectedItem);				
		}
		
		public function displayCurrInfo(type:String):void
		{			
			switch(type)
			{
				case "course":
					app.myViewStack.selectedChild=app.courseCanvas;
					app.courseForm.reset();
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getCourse());
					break;
				case "chapter":
					app.myViewStack.selectedChild=app.chapterCanvas;
					app.chapterForm.reset();
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getChapter());
					break;
				case "section":
					app.myViewStack.selectedChild=app.sectionCanvas;
					app.sectionForm.reset();
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getSection());
					break;
			}
			Object(app.myViewStack.selectedChild.getChildAt(0)).flag="edit";
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.ERROR,
						ApplicationFacade.START_COMPLETE,
						ApplicationFacade.DISPLAY		
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.ERROR : Alert.show(note.getBody().toString(),"Error"); break;	
				case ApplicationFacade.START_COMPLETE : initialize(); break;	
				case ApplicationFacade.DISPLAY : displayCurrInfo(note.getBody().toString()); break;			
            }
        }
		
		public function get app():CWAssemble
		{
            return viewComponent as CWAssemble;
        }
	}
}