package model
{	
	import model.vo.ChapterVO;
	import model.vo.CourseVO;
	import model.vo.LectureVO;
	import model.vo.SectionVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CurrentInfoProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CurrentInfoProxy";				
		private var currentCourse:CourseVO;
		private var currentChapter:ChapterVO;
		private var currentSection:SectionVO;
		private var currentLecture:LectureVO;
		
		public function CurrentInfoProxy() 
		{
			super( NAME );			
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
        
        public function getCurrentLecture():LectureVO
        {
        	return currentLecture;
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
        
        public function setCurrentLecture(lecture:LectureVO):void
        {
        	this.currentLecture=lecture;
        }    	
	}
}