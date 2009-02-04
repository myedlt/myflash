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
			app.sectionForm.courses=app.treeDataProvider.source;
			app.chapterForm.courses=app.treeDataProvider.source;
			app.courseForm.courses=app.treeDataProvider.source;			
		}
		
		public function addCourse(evt:MouseEvent):void
		{
			app.myViewStack.selectedChild=app.courseCanvas;
			app.courseForm.reset();
			app.courseForm.state="add";
			app.courseForm.changePosition();
		}
		
		public function addChapter(evt:MouseEvent):void
		{			
			app.myViewStack.selectedChild=app.chapterCanvas;
			app.chapterForm.reset();
			app.chapterForm.state="add";
			app.chapterForm.changePosition();
		}
		
		public function addSection(evt:MouseEvent):void
		{			
			app.myViewStack.selectedChild=app.sectionCanvas;
			app.sectionForm.reset();
			app.sectionForm.state="add";
			app.sectionForm.changePosition();
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
			var ret:XML=selectedItem.getter();
			if(selectedItem.validate())
			{
				var xml:XML=<root/>;
				xml.setChildren(app.treeDataProvider.source);
				switch(selectedItem.id)
				{
					case "courseForm":						
						if(selectedItem.state=="edit")
						{
							xml.replace(getIndex(ret),ret);
						}
						else
						{
							
						}						
						break;
					case "chapterForm":
						if(selectedItem.state=="edit")
						{
							xml.children().(@id==currInfo.getCourse().@id).replace(getIndex(ret),ret);
						}
						else
						{
							
						}	
						break;
					case "sectionForm":
						if(selectedItem.state=="edit")
						{
							xml.children().(@id==currInfo.getCourse().@id).chapter.(@id==currInfo.getChapter().@id).replace(getIndex(ret),ret);
						}
						else
						{
							
						}	
						break;
				}
				app.treeDataProvider.source=xml.children();
				expandAllNode();
			}
		}
		
		public function getIndex(item:XML):int
		{
			var ret:int;
			if(item.name().toString()=="section")
			{
				var sections:XMLList=currInfo.getChapter().section;
				for(var i:int;i<sections.length();i++)
				{
					if(sections[i].@id==item.@id)ret = i;
				}		
			}
			else if(item.name().toString()=="chapter")
			{
				var chapters:XMLList=currInfo.getCourse().chapter;
				for(var j:int;j<chapters.length();j++)
				{
					if(chapters[j].@id==item.@id)ret = j;
				}
			}
			else
			{
				var courses:XMLList=app.treeDataProvider.source;
				for(var k:int;k<courses.length();k++)
				{
					if(courses[k].@id==item.@id)ret = k;
				}
			}
			return ret;
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
			Object(app.myViewStack.selectedChild.getChildAt(0)).state="edit";
			Object(app.myViewStack.selectedChild.getChildAt(0)).changePosition();
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