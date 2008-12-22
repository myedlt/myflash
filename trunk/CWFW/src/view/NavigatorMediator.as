package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.Navigator;

	public class NavigatorMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "NavigatorMediator";	
		
		public function NavigatorMediator(viewComponent:Navigator)
		{
			super(NAME,viewComponent);
			
		} 
	}
}