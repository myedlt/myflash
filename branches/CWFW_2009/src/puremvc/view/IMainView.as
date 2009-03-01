package puremvc.view
{
	import flash.events.Event;
	
	import puremvc.model.vo.CourseVO;
	
	public interface IMainView
	{

		function onChapterChanged(evt:Event):void;
		function onSectionChanged(evt:Event):void;

		function onPrevSection(evt:Event):void;
		function onNextSection(evt:Event):void;
		
		function initApp():void;
		
		function initContent(content:CourseVO):void;
		function playSection(section:Object):void;
		function refreshUI():void;
		function updateLocator():void;
		
	}
}