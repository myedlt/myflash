package com.san.utils
{
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.paint.SolidFill;
	
	public class UIColorUtil
	{
		

		public static const MAIN_COLOR:uint = 0xC0C0C0;
		
		public static const HIGHLIGHT_COLOR:uint = 0x2B6BCE;
		
		
		public static function get greyBackgroundFill():IGraphicsFill
		{
			var bgFill:SolidFill = new SolidFill();
				bgFill.color = MAIN_COLOR;
			return bgFill;
		}
	}
}