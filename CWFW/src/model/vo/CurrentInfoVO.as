package model.vo
{
	public class CurrentInfoVO
	{
		private var currentCourse:CourseVO;
		private var currentChapter:ChapterVO;
		private var currentSection:SectionVO;
		private var currentLecture:LectureVO;		
        
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