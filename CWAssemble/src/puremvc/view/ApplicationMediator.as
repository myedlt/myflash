package puremvc.view
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
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
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );
					
			app.treeContents.addEventListener(ListEvent.ITEM_CLICK,itemClick);			
			app.btnDelete.addEventListener(MouseEvent.CLICK,deleteHandler);
			app.btnReset.addEventListener(MouseEvent.CLICK,resetHandler);
			app.btnSave.addEventListener(MouseEvent.CLICK,saveHandler);			
			app.btnAddChapter.addEventListener(MouseEvent.CLICK,addChapter);
			app.btnAddSection.addEventListener(MouseEvent.CLICK,addSection);			
		}
		
		private function initialize():void
		{
			app.treeContents.labelField="@name";
			var courseList:XMLList=DataProxy(facade.retrieveProxy(DataProxy.NAME)).getCourseList();
			if(courseList.length()>1){//多课程结构
				app.treeDataProvider.source=courseList;
				
				var btnAddCourse:Button=new Button();
				btnAddCourse.id="btnAddCourse";
				btnAddCourse.label="添加课程";
				btnAddCourse.addEventListener(MouseEvent.CLICK,addCourse);
				app.boxNav.addChildAt(btnAddCourse,0);
			}else{//单课程结构
				app.treeDataProvider.source=courseList.Chapter!=undefined?courseList.Chapter:courseList.chapter;
				
				var btnCourseInfo:Button=new Button();
				btnCourseInfo.id="btnCourseInfo";
				btnCourseInfo.label="课程信息";
				btnCourseInfo.addEventListener(MouseEvent.CLICK,courseInfo);
				app.boxNav.addChildAt(btnCourseInfo,0);
 				
 				app.treeContents.callLater(expandAllNode);//初始展开所有节点
			}
			displayCurrInfo("course");//初始显示课程信息				
		}
		
		public function courseInfo(event:MouseEvent):void{
			displayCurrInfo("course");
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
					Object(app.myViewStack.selectedChild.getChildAt(0)).reset();
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getCourse());
					break;
				case "chapter":
					app.myViewStack.selectedChild=app.chapterCanvas;
					Object(app.myViewStack.selectedChild.getChildAt(0)).reset();
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getChapter());
					break;
				case "section":
					app.myViewStack.selectedChild=app.sectionCanvas;
					Object(app.myViewStack.selectedChild.getChildAt(0)).reset();
					Object(app.myViewStack.selectedChild.getChildAt(0)).setter(currInfo.getSection());
					break;
			}
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