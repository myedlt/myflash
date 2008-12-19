package model.vo
{
	public class ChapterVO
	{
		public var name:String;
		public var title:String;		
		public var path:String;
		public var sections:Array;
		
		public function ChapterVO()
		{
		}
		
		public function ChapterVO(name:String,sections:Array,path:String=null,title:String=this.name)
		{
			this.name=name;
			this.sections=sections;
			this.title=title;			
			this.path=path;			
		}
	}
}