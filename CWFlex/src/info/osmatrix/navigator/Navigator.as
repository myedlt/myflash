package info.osmatrix.navigator
{
	import flash.xml.XMLDocument;
	
	/**
	 * 存储加载的content.xml文件；
	 * 保存当前所处位置；
	 *  
	 * @author huhj
	 * 
	 */
	public class Navigator
	{
		var contentXML:XMLDocument;
		var currentChapter:String;
		var currentSection:String;
		
		/**
		 * 
		 * 
		 */		
		public function Navigator()
		{
		}
		
		// 类初始化；从配置文件获得xml文件路径

		// 定义xml文件读取完成后的处理函数
			//httpservice结果处理函数
			public function resultHandler(event:ResultEvent):void
			{				
				header=XMLList(XML(event.result).Header);						
				treeMenuData=XMLList(XML(event.result).CourseList.Chapter);	
				this.currentState="header";					
			}		
	}
}