package puremvc.view
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.NavigatorProxy;
	import puremvc.model.vo.NavigatorVO;
	
	import mx.controls.LinkBar;
	import mx.events.ItemClickEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	//页面头部导航链接的"中介器"
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
			linkBar.dataProvider=NavigatorProxy(facade.retrieveProxy(NavigatorProxy.NAME)).getNavigator();
		}
		
		private function itemClick(evt:ItemClickEvent):void
		{			
			var url:String=NavigatorVO(evt.item).url;
			var target:String=evt.label=="退出"||evt.index==linkBar.dataProvider.length-1?"_self":"_blank";
			navigateToURL(new URLRequest(url),target);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.STARTUP			
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.STARTUP : initialize(); break;				
             }
		} 
		
		protected function get linkBar():LinkBar
		{
            return viewComponent.linkBar as LinkBar;
        }	
	}
}