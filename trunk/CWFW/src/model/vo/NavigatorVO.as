package model.vo
{
	public class NavigatorVO
	{
		public var label:String;
		public var url:String;
		
		public function NavigatorVO()
		{
		}
		
		public function NavigatorVO(label:String,url:String)
		{
			this.label=label;
			this.url=url;
		}
	}
}