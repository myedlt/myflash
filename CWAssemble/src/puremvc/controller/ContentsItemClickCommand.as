package puremvc.controller
{
	import mx.controls.Tree;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	import puremvc.model.utils.CurrentInfo;
	import puremvc.model.vo.ChapterVO;
	import puremvc.model.vo.SectionVO;
	import puremvc.view.ApplicationMediator;

	public class ContentsItemClickCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var selectedItem:Object=note.getBody();
			var type:String;
			var currInfo:CurrentInfo=CurrentInfo.getInstance();	
			var treeContents:Tree=ApplicationMediator(facade.retrieveMediator(ApplicationMediator.NAME)).app.treeContents;					
			
			if(selectedItem is SectionVO)
			{
//				if(currInfo.getSection()==null || selectedItem.id!=currInfo.getSection().id)				
//				{
					type="section";
					currInfo.setSection(selectedItem as SectionVO);		
//				}							
			}
			else if(selectedItem.vo is ChapterVO)
			{
//				if(selectedItem.vo.id!=currInfo.getChapter().id)
//				{
					type="chapter";
					currInfo.setChapter(selectedItem.vo);
//				}															
			}
			else
			{
//				if(selectedItem.vo.id!=currInfo.getCourse().id)
//				{
					type="course";
					currInfo.setCourse(selectedItem.vo);
//				}				
			}
			//trace("点击了:"+type);//type等于null说明已点击过
			//if(type!=null)
			sendNotification(ApplicationFacade.DISPLAY,type);			
		}
	}
}