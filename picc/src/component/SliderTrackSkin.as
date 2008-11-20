package component
{
	import mx.skins.halo.SliderTrackSkin;
	public class SliderTrackSkin extends mx.skins.halo.SliderTrackSkin     
	{    
    	public function SliderTrackSkin()    
    	{    
        	super();    
    	}    
   
    	override public function get measuredHeight():Number    
    	{    
        	return 8; //HSlider的高度    
    	}    
	}
}
