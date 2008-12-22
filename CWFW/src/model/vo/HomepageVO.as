package model.vo
{
	public class HomepageVO
	{
		public var logo:String;
		public var copyright:String;
		public var navigator:Array;
		public var courses:Array;
		
		public function HomepageVO(courses:Array=null,navigator:Array=null,logo:String=null,copyright:String=null)
		{
			this.logo=logo;
			this.copyright=copyright;
			this.navigator=navigator;
			this.courses=courses;
		}
	}
}