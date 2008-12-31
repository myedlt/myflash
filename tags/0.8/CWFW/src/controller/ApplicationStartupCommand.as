package controller
{	
	import model.CourseProxy;
	import model.CurrentInfoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;	
	    
    public class ApplicationStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			var courses:Array=CourseProxy(facade.retrieveProxy(CourseProxy.NAME)).getCourses();			
        	var currInfo:CurrentInfoProxy=new CurrentInfoProxy();        	
        	facade.registerProxy(currInfo);
        	currInfo.setCurrentCourse(courses[0]);        	
        	currInfo.setCurrentChapter(courses[0].chapters[0]);
        	currInfo.setCurrentSection(courses[0].chapters[0].sections[0]);
        	sendNotification(ApplicationFacade.SWF_LOAD,currInfo.getCurrentSection().path);
        	sendNotification(ApplicationFacade.CHAPTER_CHANGE,currInfo.getCurrentChapter().name);
        	sendNotification(ApplicationFacade.SECTION_CHANGE,currInfo.getCurrentSection().name);
        }
    }
}