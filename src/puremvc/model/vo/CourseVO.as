package puremvc.model.vo
{
	import puremvc.model.vo.LectureVO;
	
	public class CourseVO
	{	
		// 基本信息
		public var id:String;	// 唯一标志		
		public var name:String;			
		public var title:String;
		public var startSWF:String;
		public var endSWF:String;
		
		// 包含数据对象
		public var lecture:LectureVO;

		private var links:Array;	// push LinkVO
		public var chapters:Array;	// push ChapterVO
		public var sections:Array;
		
		// 实时数据
		private var curSection:SectionVO;
		private var curTime:int;	// 本次学习时长,单位秒
		private var totalTime:int;	// 累计学习时长，单位秒
		
		public function CourseVO():void
		{
			// 填充所有数据
		}
		
		public function getChapterAll():Array
		{
			return chapters;
		}
		public function getChapterById(id:String):ChapterVO
		{
			var chapter:ChapterVO = new ChapterVO();
			// 轮询
			return chapter;
		}
		public function getChapterBySectionId(id:String):ChapterVO
		{
			var chapter:ChapterVO = new ChapterVO();
			// 轮询
			return chapter;
		}
		public function getChapterNext(id:String):ChapterVO
		{
			var chapter:ChapterVO = new ChapterVO();
			// 轮询
			return chapter;
		}		
		public function getSectionAll():Array
		{
			return sections;
		}
		
		public function getSectionById(id:String):SectionVO
		{
			var section:SectionVO = new SectionVO();
			// 轮询
			return section;			
		}
		public function getSectionNext(id:String):SectionVO
		{
			var section:SectionVO = new SectionVO();
			// 轮询
			return section;			
		}
		
		public function getCurrentChapter():ChapterVO
		{
			// 由当前节结算出当前章
			var chapter:ChapterVO = new ChapterVO();
			return chapter;
		}
		public function getCurrentSection():SectionVO
		{
			return this.curSection;
		}
		public function goToNextSection():void
		{
			// 设置当前节到下一节
		}
	}
}