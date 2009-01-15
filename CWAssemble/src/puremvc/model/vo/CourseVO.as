package puremvc.model.vo
{
	import puremvc.model.vo.LectureVO;
	
	public class CourseVO
	{	
		public var id:String;	
		public var name:String;			
		public var title:String;
		public var startSWF:String;
		public var endSWF:String;
		public var lecture:LectureVO;
		public var chapters:Array;			
	}
}