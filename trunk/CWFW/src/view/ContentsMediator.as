package view
{
	import model.CourseProxy;	
	import mx.controls.Tree;
	import mx.events.ListEvent;	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;	

	public class ContentsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentsMediator";	
		
		public function ContentsMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);
			treeContents.addEventListener(ListEvent.ITEM_CLICK,itemClick);
		} 
		
		private function initialize():void
		{
			treeContents.labelField="@name";
			treeContents.dataProvider=facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;
			treeContents.callLater(expandAllNode);//展开所有节点			
		}
		
		public function expandAllNode():void
		{
			for each(var item:XML in treeContents.dataProvider)
			{					
				treeContents.expandChildrenOf(item,true);
			}
		}
		
		private function itemClick(evt:ListEvent):void
		{
			var selectedItem:Object=Tree(evt.target).selectedItem;
			if(!treeContents.dataDescriptor.isBranch(selectedItem))
			{
				sendNotification(ApplicationFacade.CONTENTS_ITEM_CLICK,selectedItem);
				trace("itemClick:"+selectedItem.toXMLString());
			}			
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
		
		protected function get treeContents():Tree
		{
            return viewComponent.treeContents as Tree;
        }	 
	}
}