package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.model.ConfigInfoProxy;
	import puremvc.view.ApplicationMediator;	
	    
    public class ApplicationStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			 facade.registerProxy(new ConfigInfoProxy("config.xml")); 
			 facade.registerMediator(new ApplicationMediator(note.getBody() as index));    	
        }
    }
}