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
			if(selectedItem.name().toString()=="section")
			{
				type="section";
				currInfo.setSection(selectedItem);
				if(currInfo.getChapter()==null||currInfo.getChapter().@id!=selectedItem.parent().@id)currInfo.setChapter(selectedItem.parent());
				if(currInfo.getCourse().@id!=selectedItem.parent().parent().@id)currInfo.setCourse(selectedItem.parent().parent());		
			}
			else if(selectedItem.name().toString()=="chapter")
			{
				type="chapter";
				//if(selectedItem.elements().length()>0)currInfo.setSection(selectedItem.section[0]);
				currInfo.setSection(null);
				currInfo.setChapter(selectedItem);
				if(currInfo.getCourse().@id!=selectedItem.parent().@id)currInfo.setCourse(selectedItem.parent());
			}
			else
			{
				type="course";
				currInfo.setSection(null);
				currInfo.setChapter(null);
				currInfo.setCourse(selectedItem);
			}			
			sendNotification(ApplicationFacade.DISPLAY,type);			
		}
	}
}