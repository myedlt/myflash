package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.DataProxy;
	import puremvc.model.utils.CurrentInfo;
	    
    public class ApplicationStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{			    	
			var courseIndex:int=note.getBody()==null?0:note.getBody()as int;
			var courses:XMLList=DataProxy(facade.retrieveProxy(DataProxy.NAME)).getCourseList();			
        	var currInfo:CurrentInfo=CurrentInfo.getInstance();         	
        	currInfo.setCourse(courses[courseIndex]);        	
        	sendNotification(ApplicationFacade.START_COMPLETE);        	   	
        }
    }
}