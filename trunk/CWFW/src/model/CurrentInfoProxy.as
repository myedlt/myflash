package model
{	
	import model.vo.ChapterVO;
	import model.vo.CourseVO;
	import model.vo.SectionVO;	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	//保存课程的当前信息
	public class CurrentInfoProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CurrentInfoProxy";				
		private var currentCourse:CourseVO;
		private var currentChapter:ChapterVO;
		private var currentSection:SectionVO;		
		
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