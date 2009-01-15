package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.CourseProxy;
	import puremvc.model.utils.CurrentInfo;
	    
    public class ApplicationStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			var courseIndex:int=note.getBody()==null?0:note.getBody()as int;
			var courses:Array=CourseProxy(facade.retrieveProxy(CourseProxy.NAME)).getCourses();			
        	var currInfo:CurrentInfo=CurrentInfo.getInstance();         	
        	currInfo.setCourse(courses[courseIndex]);        	
        	currInfo.setChapter(courses[courseIndex].chapters[0]);
        	var type:String;
        	var path:String;
        	if(courses[courseIndex].chapters[0].sections==null)
        	{
        		type=courses[courseIndex].chapters[0].type;
        		path=courses[courseIndex].chapters[0].path;
        		currInfo.setSection(null);        		
        	}
        	else
        	{
        		type=courses[courseIndex].chapters[0].sections[0].type;
        		path=courses[courseIndex].chapters[0].sections[0].path;
        		currInfo.setSection(courses[courseIndex].chapters[0].sections[0]);         		    		
        	}        	 
        	sendNotification(ApplicationFacade.INIT_COMPLETE);        	   	
        }
    }
}