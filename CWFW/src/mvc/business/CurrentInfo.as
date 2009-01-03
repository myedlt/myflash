package mvc.business
{	
	import mvc.model.vo.ChapterVO;
	import mvc.model.vo.CourseVO;
	import mvc.model.vo.SectionVO;	
	
	//singleton 保存课程的当前信息
	public class CurrentInfo 
	{					
		private var currentCourse:CourseVO;
		private var currentChapter:ChapterVO;
		private var currentSection:SectionVO;		
		private static var instance:CurrentInfo=null;
				
		public static function getInstance():CurrentInfo
		{
			if(instance==null)instance=new CurrentInfo();
			return instance;
		}	
		
		public function getCurrentCourse():CourseVO
        {
        	return currentCourse;
        }
        
        public function getCurrentChapter():ChapterVO
        {
        	return currentChapter;
        }
        
        public function getCurrentSection():SectionVO
        {
        	return currentSection;
        }       
        
        public function setCurrentCourse(course:CourseVO):void
        {
        	this.currentCourse=course;
        }
        
        public function setCurrentChapter(chapter:ChapterVO):void
        {
        	this.currentChapter=chapter;
        }
        
        public function setCurrentSection(section:SectionVO):void
        {
        	this.currentSection=section;
        }        	
	}
}