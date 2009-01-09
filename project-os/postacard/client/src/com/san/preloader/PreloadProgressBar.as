package com.san.preloader
{
	import com.mh.preloader.PreloadProgressBar;

	public class PreloadProgressBar extends com.mh.preloader.PreloadProgressBar
	{
		public function PreloadProgressBar()
		{
			super();
			
			logoUrl = "theme/loader_logo.png";
			linkButtonText = "developed by Tony Fendall";
		}
		
		
		override protected function get linkButtonUrl():String
		{
			return "http://www.munkiihouse.com";
		}
		
	}
}