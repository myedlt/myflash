package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.ControlBoard;

	public class ControlBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ControlBoardMediator";	
		
		public function ControlBoardMediator(viewComponent:ControlBoard)
		{
			super(NAME,viewComponent);
			
		} 
	}
}