package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.*;
	import puremvc.view.*;
	    
    public class AppStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			// content.xml 读取成功后异步初始化 CourseProxy
			var data:Object = DataXMLProxy(facade.retrieveProxy(DataXMLProxy.NAME)).getData();

			facade.registerProxy(new ContentProxy(data));
        	 
			sendNotification(ApplicationFacade.INITUI); 
        }
    }
}