package {
	import api.event.AppEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.IMainView;

	public class Main extends MovieClip implements IMainView {

		public function Main() {
			initApp();
		}
		//
		public function initApp():void {
			exit_btn.addEventListener(MouseEvent.CLICK, onExitApp);
			prev_btn.addEventListener(MouseEvent.CLICK, onPrevSection);
			next_btn.addEventListener(MouseEvent.CLICK, onNextSection);

			btnContent01.addEventListener(MouseEvent.CLICK, onSectionChanged);
		}

		public function onExitApp(evt:Event):void {
			dispatchEvent(new AppEvent("onExitApp",""));
		}
		public function onPrevSection(evt:Event):void {
			dispatchEvent(new AppEvent("onPrevSection",""));
		}
		public function onNextSection(evt:Event):void {
			dispatchEvent(new AppEvent("onNextSection",""));
		}
		public function onSectionChanged(evt:Event):void {
			
			dispatchEvent(new AppEvent("onSectionChanged",new Object({"id","1"})));
		}
		public function onChapterChanged(evt:Event):void 
		{
			
		}
		public function updateLocator():void
		{
			
		}

		public function initContent(content:CourseVO):void {
			//treeContents.dataProvider=facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;
			//treeContents.callLater(expandAllNode);//初始展开所有节点
			// 1. 目录树

			// 2. 功能按钮条

			// 3. 导航条与前进后退控制按钮条、学习历史进度

		}
		public function refreshUI():void {
			//txtChapter,arrowFlag,txtSection

		}

	}
}