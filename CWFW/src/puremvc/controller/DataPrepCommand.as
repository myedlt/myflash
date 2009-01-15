package puremvc.controller
{	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.model.DataProxy;
	
	public class DataPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{					
			facade.registerProxy(new DataProxy("content.xml"));
        }
	}
}