package puremvc.controller
{
	import mx.controls.Tree;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.CurrentInfo;
	import puremvc.model.utils.ModuleLocator;
	import puremvc.model.utils.XmlResource;
	import puremvc.view.ContentsMediator;

	public class ContentsItemClickCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var selectedItem:XML=note.getBody() as XML;
			var currInfo:CurrentInfo=CurrentInfo.getInstance();	
			var treeContents:Tree=ContentsMediator(facade.retrieveMediator(ContentsMediator.NAME)).treeContents;					
			
			if(treeContents.getParentItem(selectedItem)==null)
			{//单章
				sendNotification(ApplicationFacade.SINGLE_CHAPTER,selectedItem.@name);
				currInfo.setCurrentChapter(XmlResource.parseChapter(selectedItem));
				currInfo.setCurrentSection(null);
			}
			else
			{//节	
				if(ObjectUtil.compare(XmlResource.parseChapter(treeContents.getParentItem(selectedItem)),currInfo.getCurrentChapter(),0)!=0)
				{
					sendNotification(ApplicationFacade.CHAPTER_CHANGE,treeContents.getParentItem(selectedItem).@name);
					currInfo.setCurrentChapter(XmlResource.parseChapter(treeContents.getParentItem(selectedItem)));
				}  
				if(ObjectUtil.compare(XmlResource.parseSection(selectedItem),currInfo.getCurrentSection(),0)!=0)
				{
					sendNotification(ApplicationFacade.SECTION_CHANGE,selectedItem.@name);
					currInfo.setCurrentSection(XmlResource.parseSection(selectedItem));
				} 				
			}
			//sendNotification(ApplicationFacade.SWF_LOAD,selectedItem.@path);	
			var noteData:Object=ModuleLocator.locate(selectedItem.hasOwnProperty("@type")?selectedItem.@type:"flash",selectedItem.@path);  
        	sendNotification(noteData.noteType,noteData.noteBody); 
		}
	}
}