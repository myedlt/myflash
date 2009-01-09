package puremvc.controller
{	
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class ApplicationInitializeCommand extends MacroCommand
	{
		override protected function initializeMacroCommand() :void
        {
            addSubCommand( ViewPrepCommand );
            addSubCommand( ModelPrepCommand );            
        }		
	}
}