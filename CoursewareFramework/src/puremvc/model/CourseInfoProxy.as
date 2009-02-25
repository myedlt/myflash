package puremvc.model
{		
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.XmlResource;
	
	public class CourseInfoProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseInfoProxy";	
		private var courses:Array=new Array();	//课件的所有课程
		
		public function CourseInfoProxy ( data:Object = null ) 
        {        	
            super ( NAME, data );	
            parseCourses();            
        }
        
        private function parseCourses():void
        {
        	if(this.data==null)
        	{
        		this.data=XML(ApplicationFacade.getConfigInfoProxy().getData()).course;
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