package model.vo
{
	public class NavigatorVO
	{
		public var label:String;
		public var url:String;		
		
		public function NavigatorVO(label:String=null,url:String=null)
		{
			this.label=label;
			this.url=url;
		}
	}
}