package com.san.utils
{
	import com.san.values.Photo;
	
	public class PhotoUtil
	{
		
		
		public static function getRegularSize( photo:Photo ):String
		{
			if( photo.medium && photo.medium != "" )
				return photo.medium;
			
			return photo.large; // origional
		}
	}
}