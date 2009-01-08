package mvc.model
{		
	import mvc.business.XmlResource;	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	//对课程数据模型代理
	public class CourseProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseProxy";	
		private var courses:Array=new Array();	//课件的所有课程
		
		public function CourseProxy ( data:Object = null ) 
        {
            super ( NAME, data );	
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