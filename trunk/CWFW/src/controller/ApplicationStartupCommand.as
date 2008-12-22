/* package controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	    
    public class ApplicationStartupCommand extends MacroCommand
    {
        override protected function initializeMacroCommand() :void
        {
            addSubCommand( ModelPrepCommand );
            addSubCommand( ViewPrepCommand );
        }
    }
} */
package controller
{
	import model.ContentProxy;
	import view.ApplicationMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;	
	    
    public class ApplicationStartupCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{			
        	facade.registerProxy(new ContentProxy());
        	facade.registerMediator( new ApplicationMediator( note.getBody() as CWFW ) );
        }
    }
}