package puremvc.controller
{
	import mx.controls.Tree;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.CurrentInfo;

	public class ContentsItemClickCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{						
			var selectedItem:XML=note.getBody() as XML;
			var currInfo:CurrentInfo=CurrentInfo.getInstance();	
			var type:String;
			if(selectedItem.name().toString().toLowerCase()=="section")
			{
				type="section";
				currInfo.setSection(selectedItem);		
			}
			else if(selectedItem.name().toString().toLowerCase()=="chapter")
			{
				type="chapter";
				currInfo.setChapter(selectedItem);
			}
			else
			{
				type="course";
				currInfo.setCourse(selectedItem);
			}			
			sendNotification(ApplicationFacade.DISPLAY,type);			
		}
	}
}