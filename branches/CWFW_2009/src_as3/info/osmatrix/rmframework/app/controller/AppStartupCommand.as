package info.osmatrix.rmframework.app.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import info.osmatrix.rmframework.app.ApplicationFacade;
	import info.osmatrix.rmframework.app.model.*;
	import info.osmatrix.rmframework.app.view.*;
	    
    public class AppStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			// content.xml 读取成功后异步初始化 ContentProxy
			var data:Object = DataXMLProxy(facade.retrieveProxy(DataXMLProxy.NAME)).getData();

			facade.registerProxy(new ContentProxy(data));
        	 
			sendNotification(ApplicationFacade.DATAPREPARED); 
        }
    }
}