package puremvc.controller
{	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import puremvc.model.CourseProxy;
	import puremvc.ApplicationFacade;
	import puremvc.view.ApplicationMediator;
	
	public class ApplicationInitializeCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{
			facade.registerMediator( new ApplicationMediator(ApplicationFacade.getInstance().app) );
			facade.registerProxy(new CourseProxy());        	      	
        	sendNotification(ApplicationFacade.STARTUP);
		}
	}
}