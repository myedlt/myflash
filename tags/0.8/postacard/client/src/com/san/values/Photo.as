package com.san.values
{
	public class Photo
	{
		[Bindable]
		public var square:String;
		[Bindable]
		public var thumbnail:String;
		[Bindable]
		public var small:String;
		[Bindable]
		public var medium:String;
		[Bindable]
		public var large:String;

		[Bindable]
		public var link:String;
		
		public function Photo()
		{
		}
		
		public static function create( link:String, square:String, thumbnail:String, small:String, medium:String, large:String ):Photo
		{
			var tmp:Photo = new Photo();
			
			tmp.square = square;
			tmp.thumbnail = thumbnail;
			tmp.small = small;
			tmp.medium = medium;
			tmp.large = large;
			
			tmp.link = link;
			
			return tmp;	
		}
	}
}