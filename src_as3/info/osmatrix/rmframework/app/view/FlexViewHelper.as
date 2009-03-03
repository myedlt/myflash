package info.osmatrix.rmframework.app.view
{
	import flash.display.DisplayObject;
	import flash.events.*;
	
	import info.osmatrix.rmframework.app.model.vo.*;
	import info.osmatrix.rmframework.app.view.event.MainViewEvent;
	import info.osmatrix.rmframework.app.view.IMainView;

	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.events.ListEvent;

	public class FlexViewHelper implements IMainView
	{
		private var viewComponent:Object;

		public function FlexViewHelper(app:Object):void
		{
			viewComponent = app as Object;
			
			viewComponent.btnPrevSection.addEventListener(MouseEvent.CLICK,	onPrevSection);
			viewComponent.btnNextSection.addEventListener(MouseEvent.CLICK,	onNextSection);					

			viewComponent.treeContents.addEventListener(ListEvent.ITEM_CLICK,	onSectionChanged);

			viewComponent.btnExit.addEventListener(MouseEvent.CLICK,	onExitApp);					

		}

		public function onChapterChanged(evt:Event):void
		{
		}
		
		public function onSectionChanged(evt:Event):void
		{
 			if(!viewComponent.treeContents.dataDescriptor.isBranch(evt.target.selectedItem))
			{	
				// MainView 传送参数为节的ID
				// var itemManual:Object = new Object(); itemManual.id = "0101";
				var item:Object = evt.target.selectedItem as Object;						
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_SECTIONCHANGED, item) );				
				//trace("itemClick:"+evt.target.selectedItem.toXMLString());
			}
		}
		
		public function onPrevSection(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_PREVSECTION, "") );
		}
		
		public function onNextSection(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_NEXTSECTION, "") );
		}

		public function onExitApp(evt:Event):void
		{
				viewComponent.dispatchEvent(new MainViewEvent(MainViewEvent.CE_EXITAPP, "") );
		}
		
		public function initContent(content:ContentVO):void
		{
				//treeContents.dataProvider=facade.retrieveProxy(CourseProxy.NAME).getData().Chapter as XMLList;									
				//treeContents.callLater(expandAllNode);//初始展开所有节点	
				
				// 1. 目录树
				var chapters:Array = content.getChapterAll();
	        	viewComponent.treeContents.labelField="name";

	        	for each(var chapter:ChapterVO in chapters) {
	        		// DataProvider 添加章时需要的子项目数组集合
	        		var childrenSections:ArrayCollection = new ArrayCollection();
	        		
	        		// 提取当前操作章的节列表，填入children备用
					for each(var section:SectionVO in chapter.sections) {
						childrenSections.addItem({"id":section.id,"name":section.name,"type":section.type,"url":section.path});
					}
	        		
					viewComponent.treeContents.dataProvider.addItem(
						{ "id":chapter.id, "name":chapter.name, "children":childrenSections });
					
	        	}
	        	
	        	// 2. 功能按钮条
	        	
	        	// 3. 导航条与前进后退控制按钮条、学习历史进度
	        	updateLocator(content.getChapterFirst(),content.getSectionFirst());
		}
				
		public function refreshUI():void
		{
			//txtChapter,arrowFlag,txtSection
		}
		
		public function updateLocator(chapter:ChapterVO, section:SectionVO):void
		{
			// 位置显示文本更新
			viewComponent.txtChapter.text = chapter.name;
			viewComponent.txtSection.text = section.name;
			
			// 目录树光标位置更新	
			
			// 上下节按钮可用性更新：当前播放第一节时，【上一节】按钮不可用；当前播放最后一节时，【下一节】按钮不可用
			
		}
		
		public function getPlayerRect():DisplayObject
		{
			return viewComponent.contentSWFLoader;
		}
		
	}
}