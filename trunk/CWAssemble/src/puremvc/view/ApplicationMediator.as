package puremvc.view
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.CourseProxy;
	import puremvc.model.utils.CurrentInfo;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
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
			//app.btnAddLecture.addEventListener(MouseEvent.CLICK,addLecture);
		}
		
		private function initialize():void
		{
			app.treeContents.labelField="@name";
			var courseData:XMLList=facade.retrieveProxy(CourseProxy.NAME).getData() as XMLList;
			if(XML(courseData.parent()).name().toString().toLowerCase()=="courselist"){//多课程结构
				app.treeDataProvider.source=courseData;
				displayCurrInfo("course");//初始显示第一个课程信息
			}else{//单课程结构
				app.treeDataProvider.source=courseData.Chapter!=undefined?courseData.Chapter:courseData.chapter;
				app.boxNav.removeChild(app.btnAddCourse);
 				displayCurrInfo("chapter");
 				app.treeContents.callLater(expandAllNode);//初始展开所有节点
			}				
			 /* var single:Boolean;
			app.treeContents.labelField="name";				
			var courseList:Array = CourseProxy(facade.retrieveProxy(CourseProxy.NAME)).getCourses();			
        	for each(var course:CourseVO in courseList)
			{
				var chapterList:ArrayCollection=new ArrayCollection();
				for each(var chapter:ChapterVO in course.chapters)
				{        					
					chapterList.addItem({name:chapter.name,children:chapter.sections,vo:chapter});				
	        	}
	        	if(course.name==null)
	        	{//单课程xml
	        		app.treeDataProvider=chapterList;
	        		single=true;
	        		break;
	        	}
	        	else
	        	{//多课程xml
	        		app.treeDataProvider.addItem({name:course.name,children:chapterList,vo:course});
	        	}								
        	} */  
		}
		
		public function addCourse(evt:MouseEvent):void
		{
			app.courseForm.reset();
			app.myViewStack.selectedChild=app.courseCanvas;
		}
		
		public function addChapter(evt:MouseEvent):void
		{
			app.chapterForm.reset();
			app.myViewStack.selectedChild=app.chapterCanvas;
		}
		
		public function addSection(evt:MouseEvent):void
		{
			app.sectionForm.reset();
			app.myViewStack.selectedChild=app.sectionCanvas;
		}
		
		/* public function addLecture(evt:MouseEvent):void
		{
			app.lectureForm.reset();
			app.myViewStack.selectedChild=app.lectureCanvas;
		} */
		
		public function deleteHandler(evt:MouseEvent):void
		{
			
		}
		
		public function resetHandler(evt:MouseEvent):void
		{
			Object(app.myViewStack.selectedChild.getChildAt(0)).reset();
		}
		
		public function saveHandler(evt:MouseEvent):void
		{
			var valid:Boolean=Object(app.myViewStack.selectedChild.getChildAt(0)).validate();
			if(valid){
				trace("noError");
			}
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
			var currInfo:CurrentInfo=CurrentInfo.getInstance();
			switch(type)
			{
				case "course":
					app.myViewStack.selectedChild=app.courseCanvas;
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getCourse());
					break;
				case "chapter":
					app.myViewStack.selectedChild=app.chapterCanvas;
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getChapter());
					break;
				case "section":
					app.myViewStack.selectedChild=app.sectionCanvas;
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getSection());
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.LOAD_FILE_FAILED,
						ApplicationFacade.INIT_COMPLETE,
						ApplicationFacade.DISPLAY		
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_FILE_FAILED : Alert.show(note.getBody().toString()); break;	
				case ApplicationFacade.INIT_COMPLETE : initialize(); break;	
				case ApplicationFacade.DISPLAY : displayCurrInfo(note.getBody().toString()); break;			
            }
        }
		
		public function get app():CWAssemble
		{
            return viewComponent as CWAssemble;
        }
	}
}