package view
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.NavigatorProxy;
	import model.vo.NavigatorVO;
	
	import mx.events.ItemClickEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.Navigator;

	public class NavigatorMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "NavigatorMediator";	
		private var navLabelArr:Array=new Array();
		private var navUrlArr:Array=new Array();	
		
		public function NavigatorMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);			
			navigator.addEventListener(ItemClickEvent.ITEM_CLICK,itemClick);
		} 
		private function initialize():void
		{
			for each(var button:NavigatorVO in NavigatorProxy(facade.retrieveProxy(NavigatorProxy.NAME)).getNavigator())
			{
				navLabelArr.push(button.label);
				navUrlArr.push(button.url);
			}
			navigator.dataProvider=navLabelArr;
		}
		
		private function itemClick(evt:ItemClickEvent):void
		{
			var url:String=navUrlArr[evt.index];
			var target:String=navLabelArr[evt.index]=="退出"||evt.index==navUrlArr.length-1?"_self":"_blank";
			navigateToURL(new URLRequest(url),target);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.DATA_READY			
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.DATA_READY : initialize(); break;
				
             }
		} 
		
		protected function get navigator():Navigator
		{
            return viewComponent as Navigator;
        }	
	}
}