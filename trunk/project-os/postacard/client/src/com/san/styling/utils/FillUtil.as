package com.san.styling.utils
{
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.paint.BitmapFill;
	import com.degrafa.paint.GradientStop;
	import com.degrafa.paint.LinearGradientFill;
	import com.degrafa.paint.RadialGradientFill;
	import com.degrafa.paint.SolidFill;
	
	public class FillUtil
	{


		public static const SOLID_FILL:String = "solidFill";
		public static const LINEAR_GRADIENT_FILL:String = "linearGradientFill";
		public static const RADIAL_GRADIENT_FILL:String = "radialGradientFill";
		
		public static const BOARDS_FILL:String 	= "boardsFill";
		public static const BRICKS_FILL:String 	= "bricksFill";
		public static const GRASS_FILL:String 	= "grassFill";
		public static const METAL_FILL:String 	= "metalFill";
		public static const WOOD_FILL:String 	= "woodFill";

		
		public static const FILL_LIST:Array = [
												{label:"Solid Color",value:SOLID_FILL},
												{label:"Linear Gradient",value:LINEAR_GRADIENT_FILL},
												{label:"Radial Gradient",value:RADIAL_GRADIENT_FILL},
												{label:"Boards",value:BOARDS_FILL},
												{label:"Bricks",value:BRICKS_FILL},
												{label:"Grass",value:GRASS_FILL},
												{label:"Metal",value:METAL_FILL},
												{label:"Wood",value:WOOD_FILL}											
											  ];



		[Embed(source="../../../../assets/boards.jpg")]
        private static var boardsAsset:Class;
		
		[Embed(source="../../../../assets/bricks.jpg")]
        private static var bricksAsset:Class;
		
		[Embed(source="../../../../assets/grass.jpg")]
        private static var grassAsset:Class;
		
		[Embed(source="../../../../assets/metal.png")]
        private static var metalAsset:Class;
		
		[Embed(source="../../../../assets/wood.jpg")]
        private static var woodAsset:Class;
		

		public static function getFill( name:String, color1:uint=0x2B6BCE, alpha1:Number=1, color2:uint=0, alpha2:Number=1, angle:Number=0 ):IGraphicsFill
		{
			switch( name )
			{
				case BOARDS_FILL:
					var bof:BitmapFill = new BitmapFill()
						bof.source = boardsAsset;
					return bof;
					
				case BRICKS_FILL:
					var brf:BitmapFill = new BitmapFill()
						brf.source = bricksAsset;
					return brf;

				case GRASS_FILL:
					var gf:BitmapFill = new BitmapFill()
						gf.source = grassAsset;
					return gf;
					
				case METAL_FILL:
					var mf:BitmapFill = new BitmapFill()
						mf.source = metalAsset;
					return mf;
					
				case WOOD_FILL:
					var wf:BitmapFill = new BitmapFill()
						wf.source = woodAsset;
					return wf;
										
				
				case LINEAR_GRADIENT_FILL:
					var lgf:LinearGradientFill = new LinearGradientFill();
						lgf.angle = angle;
						lgf.gradientStops = [ new GradientStop( color1, alpha1 ), new GradientStop( color2, alpha2 ) ];
					return lgf;

				case RADIAL_GRADIENT_FILL:
					var rgf:RadialGradientFill = new RadialGradientFill();
						rgf.gradientStops = [ new GradientStop( color1, alpha1 ), new GradientStop( color2, alpha2 ) ];
					return rgf;

				case SOLID_FILL:
					var sf:SolidFill = new SolidFill();
						sf.color = color1;
						sf.alpha = alpha1;
					return sf;
				
				default:
					return null;			
			}
		}

	}
}