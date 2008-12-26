package controller
{
	import ascb.util.ArrayUtilities;	
	import model.CurrentInfoProxy;
	import model.vo.ChapterVO;
	import model.vo.CourseVO;
	import model.vo.SectionVO;	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class NextSectionCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{	
			var currInfo:CurrentInfoProxy=facade.retrieveProxy(CurrentInfoProxy.NAME) as CurrentInfoProxy;
			var currChapter:ChapterVO=currInfo.getCurrentChapter();
			var currSection:SectionVO=currInfo.getCurrentSection();
			var currCourse:CourseVO=currInfo.getCurrentCourse();
					
			if(currSection!=null)
			{//当前播放的课程为某一章的一节
				var index:int=ArrayUtilities.findMatchIndex(currChapter.sections,currSection);
				if(index!=-1)
				{
					if(index!=currChapter.sections.length-1)
					{
						currInfo.setCurrentSection(currChapter.sections[index+1]);//把下一节作为当前节
						sendNotification(ApplicationFacade.SWF_LOAD,currChapter.sections[index+1].path);//发送加载下一节的swf通知
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[index+1].name);//发送"当前位置"中的节名改变通知
					}
					else
					{//如果当前节是当前章的最后一节则遍历下一章
						traverseNextChapter(currCourse,currChapter,currInfo);	
					}
				}
				else
				{
					trace("找不到当前节对象!");
				}				
			}
			else
			{//当前播放的课程为单章即没有节				
				traverseNextChapter(currCourse,currChapter,currInfo);						
			}
		}
		
		private function traverseNextChapter(currCourse:CourseVO,currChapter:ChapterVO,currInfo:CurrentInfoProxy):void
		{
			var i:int=ArrayUtilities.findMatchIndex(currCourse.chapters,currChapter);
			if(i!=-1)
			{
				if(i!=currCourse.chapters.length-1)
				{
					currChapter=currCourse.chapters[i+1];
					currInfo.setCurrentChapter(currChapter);
					if(currChapter.sections!=null && currChapter.sections.length>0)
					{//如果该章有节 则把第一节作为当前节并加载swf、改变"当前位置"
						currInfo.setCurrentSection(currChapter.sections[0]);
						sendNotification(ApplicationFacade.SWF_LOAD,currChapter.sections[0].path);
						sendNotification(ApplicationFacade.CHAPTER_CHANGE,currChapter.name);
						sendNotification(ApplicationFacade.SECTION_CHANGE,currChapter.sections[0].name);
					}
					else
					{//如果该章没有节 即是一个单独的章 则把当前节置空，加载章的swf 并在“当前位置”中只显示章名
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