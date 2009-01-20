package puremvc.controller
{
	import mx.controls.Tree;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.CurrentInfo;
	import puremvc.model.utils.XmlResource;

	public class ContentsItemClickCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			//var selectedItem:Object=note.getBody();
			var type:String;
			var selectedItem:XML=note.getBody() as XML;
			var currInfo:CurrentInfo=CurrentInfo.getInstance();	
			if(selectedItem.name().toString().toLowerCase()=="section")
			{
				type="section";
				currInfo.setSection(XmlResource.parseSection(selectedItem));		
			}
			else if(selectedItem.name().toString().toLowerCase()=="chapter")
			{
				type="chapter";
				currInfo.setChapter(XmlResource.parseChapter(selectedItem));
			}
			else
			{
				type="course";
				currInfo.setCourse(XmlResource.parseCourse(selectedItem));
			}
			/*if(selectedItem is SectionVO)
			{
				type="section";
				currInfo.setSection(selectedItem as SectionVO);		
			}
			else if(selectedItem.vo is ChapterVO)
			{
				type="chapter";
				currInfo.setChapter(selectedItem.vo);
			}
			else
			{
				type="course";
				currInfo.setCourse(selectedItem.vo);
			} */
			sendNotification(ApplicationFacade.DISPLAY,type);			
		}
	}
}