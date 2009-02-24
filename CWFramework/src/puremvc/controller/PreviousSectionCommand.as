package puremvc.controller
{
	//import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.CurrentInfo;
	import puremvc.model.utils.ModuleLocator;
	import puremvc.model.vo.ChapterVO;
	import puremvc.model.vo.CourseVO;
	import puremvc.model.vo.SectionVO;

	public class PreviousSectionCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var currInfo:CurrentInfo=CurrentInfo.getInstance();
			var currChapter:ChapterVO=currInfo.getCurrentChapter();
			var currSection:SectionVO=currInfo.getCurrentSection();
			var currCourse:CourseVO=currInfo.getCurrentCourse();
					
			if(currSection!=null)
			{
				//var index:int=ArrayUtilities.findMatchIndex(currChapter.sections,currSection);
				var index:int=-1;
				for(var i:int=0;i<currChapter.sections.length;i++)
				{
					//if(ObjectUtil.compare(currChapter.sections[i],currSection,0)==0)
					if(currChapter.sections[i].id==currSection.id)
					{
						index=i; break;
					}
				}		
				if(index!=-1)
				{
					if(index!=0)
					{
						currInfo.setCurrentSection(currChapter.sections[index-1]);
						//sendNotification(ApplicationFacade.SWF_LOAD,currChapter.sections[index-1].path);
						var noteData1:Object=ModuleLocator.locate(currChapter.sections[index-1]);  
        				sendNotification(noteData1.noteType,noteData1.noteBody); 
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[index-1].name);
					}
					else
					{
						traversePrevChapter(currCourse,currChapter,currInfo);	
					}
				}
				else
				{
					//trace("找不到当前节对象!");
				}				
			}
			else
			{				
				traversePrevChapter(currCourse,currChapter,currInfo);						
			}
		}
		
		private function traversePrevChapter(currCourse:CourseVO,currChapter:ChapterVO,currInfo:CurrentInfo):void
		{
			//var i:int=ArrayUtilities.findMatchIndex(currCourse.chapters,currChapter);
			var i:int=-1;
			for(var k:int=0;k<currCourse.chapters.length;k++)
			{
				//if(ObjectUtil.compare(currCourse.chapters[k],currChapter,0)==0)
				if(currCourse.chapters[k].id==currChapter.id)
				{
					i=k; break;
				}
			}	
			if(i!=-1)
			{
				if(i!=0)
				{
					currChapter=currCourse.chapters[i-1];
					currInfo.setCurrentChapter(currChapter);
					if(currChapter.sections!=null && currChapter.sections.length>0)
					{
						currInfo.setCurrentSection(currChapter.sections[currChapter.sections.length-1]);
						//sendNotification(ApplicationFacade.SWF_LOAD,currChapter.sections[currChapter.sections.length-1].path);
						var noteData2:Object=ModuleLocator.locate(currChapter.sections[currChapter.sections.length-1]);  
        				sendNotification(noteData2.noteType,noteData2.noteBody);
						sendNotification(ApplicationFacade.CHAPTER_CHANGE,currChapter.name);
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[currChapter.sections.length-1].name);
					}
					else
					{
						currInfo.setCurrentSection(null);
						//sendNotification(ApplicationFacade.SWF_LOAD,currChapter.path);
						var noteData3:Object=ModuleLocator.locate(currChapter);  
        				sendNotification(noteData3.noteType,noteData3.noteBody);
						sendNotification(ApplicationFacade.SINGLE_CHAPTER,currChapter.name);
					}							
				}
			}
			else
			{
				//trace("找不到当前章对象!");
			}	 
		}			
	}
}