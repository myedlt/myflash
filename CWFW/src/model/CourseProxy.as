package model
{		
	import model.utils.XmlResource;	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class CourseProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseProxy";	
		private var courses:Array=new Array();	
		
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