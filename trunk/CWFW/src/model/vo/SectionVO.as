package model.vo
{
	public class SectionVO
	{
		public var name:String;		
		public var title:String;
		public var path:String;
		public var type:String;		
		
		public function SectionVO()
		{
		}
		
		public function SectionVO(name:String,path:String,type="flash",title:String=this.name)
		{
			this.name=name;
			this.title=title;
			this.path=path;
			this.type=type;			
		}
	}
}