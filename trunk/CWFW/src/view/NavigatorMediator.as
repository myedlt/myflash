package view
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.NavigatorProxy;
	import model.vo.NavigatorVO;
	
	import mx.controls.LinkBar;
	import mx.events.ItemClickEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class NavigatorMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "NavigatorMediator";	
		private var navLabelArr:Array=new Array();
		private var navUrlArr:Array=new Array();	
		
		public function NavigatorMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);			
			linkBar.addEventListener(ItemClickEvent.ITEM_CLICK,itemClick);
		} 
		private function initialize():void
		{
			/* for each(var button:NavigatorVO in NavigatorProxy(facade.retrieveProxy(NavigatorProxy.NAME)).getNavigator())
			{
				navLabelArr.push(button.label);
				navUrlArr.push(button.url);
			} 
			linkBar.dataProvider=navLabelArr;*/
			linkBar.dataProvider=NavigatorProxy(facade.retrieveProxy(NavigatorProxy.NAME)).getNavigator();
		}
		
		private function itemClick(evt:ItemClickEvent):void
		{
			//var url:String=navUrlArr[evt.index];
			//var target:String=navLabelArr[evt.index]=="退出"||evt.index==navUrlArr.length-1?"_self":"_blank";
			var url:String=NavigatorVO(evt.item).url;
			var target:String=evt.label=="退出"||evt.index==linkBar.dataProvider.length-1?"_self":"_blank";
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
		
		protected function get linkBar():LinkBar
		{
            return viewComponent.linkBar as LinkBar;
        }	
	}
}