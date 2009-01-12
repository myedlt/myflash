package puremvc.model
{		
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import puremvc.model.utils.XmlResource;
	//对课程数据模型代理
	public class CourseProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseProxy";	
		private var courses:Array=new Array();	//课件的所有课程
		
		public function CourseProxy ( data:Object = null ) 
        {        	
            super ( NAME, data );	
            parseCourses();            
        }
        
        private function parseCourses():void
        {
        	if(this.data==null)
        	{
        		this.data=XML(DataProxy(facade.retrieveProxy(DataProxy.NAME)).getData()).CourseList.Course;
        	}
        	for each(var course:XML in this.data)
			{								
				courses.push(XmlResource.parseCourse(course));					
			}	
        }
        
        public function getCourses():Array
        {
        	return this.courses;
        }        
	}
}