package com.san.styling.utils
{
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.paint.GradientStop;
	import com.degrafa.paint.LinearGradientStroke;
	import com.degrafa.paint.RadialGradientStroke;
	import com.degrafa.paint.SolidStroke;
	
	public class StrokeUtil
	{
		public static const NONE:String = "none";
		public static const SOLID_STROKE:String = "solidStroke";
		public static const LINEAR_GRADIENT_STROKE:String = "linearGradientStroke";
		public static const RADIAL_GRADIENT_STROKE:String = "radialGradientStroke";
				

		public static function getStroke( name:String, weight:Number=4, color1:uint=0x000000, alpha1:Number=1, color2:uint=0xFFFFFF, alpha2:Number=1, angle:Number=0 ):IGraphicsStroke
		{
			switch( name )
			{
		
				case LINEAR_GRADIENT_STROKE:
					var lgs:LinearGradientStroke = new LinearGradientStroke();
						lgs.angle = angle;
						lgs.weight = weight;
						lgs.gradientStops = [ new GradientStop( color2, alpha2, 0 ), new GradientStop( color1, alpha1, 1 ) ];
					return lgs;

				case RADIAL_GRADIENT_STROKE:
					var rgs:RadialGradientStroke = new RadialGradientStroke();
						rgs.gradientStops = [ new GradientStop( color2, alpha2, 0 ), new GradientStop( color2, alpha2, 0.95 ), new GradientStop( color1, alpha1, 1) ];
						rgs.weight = weight;
					return rgs;

				case SOLID_STROKE:
					var ss:SolidStroke = new SolidStroke();
						ss.color = color1;
						ss.alpha = alpha1;
						ss.weight = weight;
					return ss;
				
				default:
				case NONE:
					var ns:SolidStroke = new SolidStroke();
						ns.alpha = 0;
					return ns;
			}
		}

	}
}