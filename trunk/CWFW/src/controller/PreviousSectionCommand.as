package controller
{
	import ascb.util.ArrayUtilities;	
	import model.CurrentInfoProxy;
	import model.vo.ChapterVO;
	import model.vo.CourseVO;
	import model.vo.SectionVO;	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class PreviousSectionCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var currInfo:CurrentInfoProxy=facade.retrieveProxy(CurrentInfoProxy.NAME) as CurrentInfoProxy;
			var currChapter:ChapterVO=currInfo.getCurrentChapter();
			var currSection:SectionVO=currInfo.getCurrentSection();
			var currCourse:CourseVO=currInfo.getCurrentCourse();
					
			if(currSection!=null)
			{
				var index:int=ArrayUtilities.findMatchIndex(currChapter.sections,currSection);
				if(index!=-1)
				{
					if(index!=0)
					{
						currInfo.setCurrentSection(currChapter.sections[index-1]);
						sendNotification(ApplicationFacade.LOAD_SWF,currChapter.sections[index-1].path);
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
		
		private function traversePrevChapter(currCourse:CourseVO,currChapter:ChapterVO,currInfo:CurrentInfoProxy):void
		{
			var i:int=ArrayUtilities.findMatchIndex(currCourse.chapters,currChapter);
			if(i!=-1)
			{
				if(i!=0)
				{
					currChapter=currCourse.chapters[i-1];
					currInfo.setCurrentChapter(currChapter);
					if(currChapter.sections!=null && currChapter.sections.length>0)
					{
						currInfo.setCurrentSection(currChapter.sections[currChapter.sections.length-1]);
						sendNotification(ApplicationFacade.LOAD_SWF,currChapter.sections[currChapter.sections.length-1].path);
						sendNotification(ApplicationFacade.CHAPTER_CHANGE,currChapter.name);
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[currChapter.sections.length-1].name);
					}
					else
					{
						currInfo.setCurrentSection(null);
						sendNotification(ApplicationFacade.LOAD_SWF,currChapter.path);
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