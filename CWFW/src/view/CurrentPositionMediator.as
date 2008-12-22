package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.CurrentPosition;

	public class CurrentPositionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CurrentPositionMediator";	
		
		public function CurrentPositionMediator(viewComponent:CurrentPosition)
		{
			super(NAME,viewComponent);
			
		} 
	}
}