package model.vo
{
	public class ChapterVO
	{
		public var name:String;
		public var title:String;		
		public var path:String;
		public var sections:Array;		
		
		public function ChapterVO(name:String=null,sections:Array=null,path:String=null,title:String=null)
		{
			this.name=name;
			this.sections=sections;			
			this.title=title;
			this.path=path;			
		}
	}
}