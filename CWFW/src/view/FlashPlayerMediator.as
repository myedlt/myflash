package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.FlashPlayer;

	public class FlashPlayerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "FlashPlayerMediator";	
		
		public function FlashPlayerMediator(viewComponent:FlashPlayer)
		{
			super(mediatorName, viewComponent);
		}		
			
	}
}