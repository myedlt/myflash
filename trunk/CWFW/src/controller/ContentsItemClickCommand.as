package controller
{
	import model.CurrentInfoProxy;
	
	import mx.controls.Tree;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ContentsMediator;
	import view.CurrentPositionMediator;

	public class ContentsItemClickCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var selectedItem:XML=note.getBody() as XML;
			var currInfo:CurrentInfoProxy=facade.retrieveProxy(CurrentInfoProxy.NAME)as CurrentInfoProxy;	
			var treeContents:Tree=ContentsMediator(facade.retrieveMediator(ContentsMediator.NAME)).treeContents;					
			
			if(treeContents.getParentItem(selectedItem)==null)
			{
				sendNotification(ApplicationFacade.SINGLE_CHAPTER,selectedItem.@name);
				currInfo.setCurrentChapter(null);
				currInfo.setCurrentSection(null);
			}
			else
			{
				if(treeContents.getParentItem(selectedItem).@name!=CurrentPositionMediator(facade.retrieveMediator(CurrentPositionMediator.NAME)).txtChapter.text)
				{
					sendNotification(ApplicationFacade.CHAPTER_CHANGE,treeContents.getParentItem(selectedItem).@name);
					currInfo.setCurrentChapter(null);
				}  
				if(selectedItem.@name!=CurrentPositionMediator(facade.retrieveMediator(CurrentPositionMediator.NAME)).txtSection.text)
				{
					sendNotification(ApplicationFacade.SECTION_CHANGE,selectedItem.@name);
					currInfo.setCurrentSection(null);
				} 				
			}
			sendNotification(ApplicationFacade.LOAD_SWF,selectedItem.@path);				
		}
	}
}