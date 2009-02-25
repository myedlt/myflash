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
        	 
			sendNotification(ApplicationFacade.INITUI); 
        }
    }
}