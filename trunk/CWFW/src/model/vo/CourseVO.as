package model.vo
{
	import model.vo.LectureVO;
	
	public class CourseVO
	{		
		public var name:String;			
		public var title:String;
		public var startSWF:String;
		public var endSWF:String;
		public var lecture:LectureVO;
		public var chapters:Array;			
			
		public function CourseVO(name:String=null,chapters:Array=null,startSWF:String=null,title:String=null,lecture:LectureVO=null,endSWF:String=null)
		{
			this.name=name;
			this.chapters=chapters;
			this.startSWF=startSWF;
			this.title=title;
			this.lecture=lecture;
			this.endSWF=endSWF;	
		}
	}
}