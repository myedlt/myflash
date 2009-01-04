package puremvc.controller
{	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.CourseProxy;
	import puremvc.model.DataProxy;
	import puremvc.model.NavigatorProxy;
	
	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{
			//facade.registerProxy(new DataProxy());					
			facade.registerProxy(new CourseProxy());
        	facade.registerProxy(new NavigatorProxy());         	
        	sendNotification(ApplicationFacade.STARTUP);     	
        }
	}
}