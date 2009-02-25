package puremvc.model
{		
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import puremvc.business.XmlResource;
	import puremvc.model.vo.*;
	
	//对课程数据模型代理
	public class CourseProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseProxy";
		
		private var courses:Array = new Array();	//课件的所有课程
		private var links:Array = new Array();
		
		public function CourseProxy ( data:Object = null ) 
        {        	
            super ( NAME, data );	
            parseCourses();            
        }
        
        private function parseCourses():void
        {
        	var courseData:XML = 
        		XML(DataProxy(facade.retrieveProxy(DataProxy.NAME)).getData()).CourseList.Course;
        	for each(var course:XML in courseData)
			{								
				courses.push(XmlResource.parseCourse(course));					
			}
			
        	var linkData:XML = XML(DataProxy(facade.retrieveProxy(DataProxy.NAME)).getData()).Navigator.button;
        	for each(var button:XML in linkData)
			{
				links.push(new LinkVO(button.@label,button.@url));
			}
        }
        
        public function getCourses():Array
        {
        	return this.courses;
        }        
	}
}