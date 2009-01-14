package puremvc.model.utils
{	
	import puremvc.model.vo.ChapterVO;
	import puremvc.model.vo.CourseVO;
	import puremvc.model.vo.SectionVO;	
	
	//singleton 保存课程的当前信息
	public class CurrentInfo 
	{					
		private var course:CourseVO;
		private var chapter:ChapterVO;
		private var section:SectionVO;		
		private static var instance:CurrentInfo=null;
				
		public static function getInstance():CurrentInfo
		{
			if(instance==null)instance=new CurrentInfo();
			return instance;
		}	
		
		public function getCourse():CourseVO
        {
        	return course;
        }
        
        public function getChapter():ChapterVO
        {
        	return chapter;
        }
        
        public function getSection():SectionVO
        {
        	return section;
        }       
        
        public function setCourse(course:CourseVO):void
        {
        	this.course=course;
        }
        
        public function setChapter(chapter:ChapterVO):void
        {
        	this.chapter=chapter;
        }
        
        public function setSection(section:SectionVO):void
        {
        	this.section=section;
        }        	
	}
}