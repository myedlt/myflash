package model.vo
{
	public class SectionVO
	{
		public var name:String;		
		public var title:String;
		public var path:String;
		public var type:String;		
		
		public function SectionVO(name:String=null,path:String=null,type:String="flash",title:String=null)
		{
			this.name=name;
			this.title=title;
			this.path=path;
			this.type=type;			
		}
	}
}