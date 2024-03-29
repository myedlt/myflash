package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.CourseProxy;
	import puremvc.model.utils.CurrentInfo;
	import puremvc.model.utils.ModuleLocator;	
	    
    public class ApplicationStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			var courseIndex:int=note.getBody()==null?0:note.getBody()as int;
			var courses:Array=CourseProxy(facade.retrieveProxy(CourseProxy.NAME)).getCourses();			
        	var currInfo:CurrentInfo=CurrentInfo.getInstance();         	
        	currInfo.setCurrentCourse(courses[courseIndex]);        	
        	currInfo.setCurrentChapter(courses[courseIndex].chapters[0]);
        	var des:Object;
        	if(courses[courseIndex].chapters[0].sections==null)
        	{
        		des=courses[courseIndex].chapters[0];
        		currInfo.setCurrentSection(null);        		
        	}
        	else
        	{
        		des=courses[courseIndex].chapters[0].sections[0];
        		currInfo.setCurrentSection(courses[courseIndex].chapters[0].sections[0]);   
        		sendNotification(ApplicationFacade.SECTION_CHANGE,currInfo.getCurrentSection().name);     		
        	}        	
        	sendNotification(ApplicationFacade.CHAPTER_CHANGE,currInfo.getCurrentChapter().name); 
        	sendNotification(ApplicationFacade.TREE_INIT);
        	var noteData:Object=ModuleLocator.locate(des);  
        	sendNotification(noteData.noteType,noteData.noteBody);       	
        }
    }
}