package puremvc.model.utils
{		
	//singleton 保存课程的当前信息
	public class CurrentInfo 
	{					
		private var course:XML;
		private var chapter:XML;
		private var section:XML;		
		private static var instance:CurrentInfo=null;
				
		public static function getInstance():CurrentInfo
		{
			if(instance==null)instance=new CurrentInfo();
			return instance;
		}	
		
		public function getCourse():XML
        {
        	return course;
        }
        
        public function getChapter():XML
        {
        	return chapter;
        }
        
        public function getSection():XML
        {
        	return section;
        }       
        
        public function setCourse(course:XML):void
        {
        	this.course=course;
        }
        
        public function setChapter(chapter:XML):void
        {
        	this.chapter=chapter;
        }
        
        public function setSection(section:XML):void
        {
        	this.section=section;
        }        	
	}
}