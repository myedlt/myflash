package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.business.CurrentInfo;
	import puremvc.model.*;	
	import puremvc.view.*;
	    
    public class AppStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			facade.registerProxy(new CourseProxy());
        	facade.registerProxy(new NavigatorProxy());   
			facade.registerMediator( new AppMediator(ApplicationFacade.getInstance().app) );
						
			var courses:Array=CourseProxy(facade.retrieveProxy(CourseProxy.NAME)).getCourses();			
        	var currInfo:CurrentInfo=CurrentInfo.getInstance();         	
        	currInfo.setCurrentCourse(courses[0]);        	
        	currInfo.setCurrentChapter(courses[0].chapters[0]);
        	var type:String;
        	var path:String;
        	if(courses[0].chapters[0].sections==null)
        	{
        		type=courses[0].chapters[0].type;
        		path=courses[0].chapters[0].path;
        		currInfo.setCurrentSection(null);        		
        	}
        	else
        	{
        		type=courses[0].chapters[0].sections[0].type;
        		path=courses[0].chapters[0].sections[0].path;
        		currInfo.setCurrentSection(courses[0].chapters[0].sections[0]);   
        		sendNotification(ApplicationFacade.SECTION_CHANGE,currInfo.getCurrentSection().name);     		
        	}        	
        	sendNotification(ApplicationFacade.CHAPTER_CHANGE,currInfo.getCurrentChapter().name); 
        }
    }
}