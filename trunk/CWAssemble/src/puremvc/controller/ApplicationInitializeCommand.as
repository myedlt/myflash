package puremvc.controller
{	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.model.DataProxy;
	import puremvc.view.ApplicationMediator;
	
	public class ApplicationInitializeCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{
			facade.registerMediator( new ApplicationMediator(note.getBody().app) );
			facade.registerProxy(new DataProxy(note.getBody().file));			
		}
	}
}