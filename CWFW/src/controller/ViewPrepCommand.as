package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ApplicationMediator;
	    
    public class ViewPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            facade.registerMediator( new ApplicationMediator( note.getBody() as CWFW ) );			
        }
    }
}
