package mvc.controller
{
	import mvc.ApplicationFacade;
	import mvc.business.CurrentInfo;
	import mvc.model.vo.ChapterVO;
	import mvc.model.vo.CourseVO;
	import mvc.model.vo.SectionVO;
	
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

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
					if(ObjectUtil.compare(currChapter.sections[i],currSection,0)==0)
					{
						index=i; break;
					}
				}		
				if(index!=-1)
				{
					if(index!=0)
					{
						currInfo.setCurrentSection(currChapter.sections[index-1]);
						sendNotification(ApplicationFacade.SWF_LOAD,currChapter.sections[index-1].path);
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[index-1].name);
					}
					else
					{
						traversePrevChapter(currCourse,currChapter,currInfo);	
					}
				}
				else
				{
					trace("找不到当前节对象!");
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
				if(ObjectUtil.compare(currCourse.chapters[k],currChapter,0)==0)
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
						sendNotification(ApplicationFacade.SWF_LOAD,currChapter.sections[currChapter.sections.length-1].path);
						sendNotification(ApplicationFacade.CHAPTER_CHANGE,currChapter.name);
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[currChapter.sections.length-1].name);
					}
					else
					{
						currInfo.setCurrentSection(null);
						sendNotification(ApplicationFacade.SWF_LOAD,currChapter.path);
						sendNotification(ApplicationFacade.SINGLE_CHAPTER,currChapter.name);
					}							
				}
			}
			else
			{
				trace("找不到当前章对象!");
			}	 
		}			
	}
}