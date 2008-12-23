package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.Contents;

	public class ContentsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentsMediator";	
		
		public function ContentsMediator(viewComponent:Contents)
		{
			super(NAME,viewComponent);
		} 
	}
}