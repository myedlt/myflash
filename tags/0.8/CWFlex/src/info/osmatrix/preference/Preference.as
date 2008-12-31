package preference
{
	/**
	 * 读写配置信息，读（配置文件和Cookie），写只能是Cookie
	 *  
	 * @author huhj
	 * 
	 */	
	public class Preference
	{
		var curSkin:String = "default";
		var navAuto:String = "false";
		const DEFAULT_SKIN:String = "css/default/defaultSkin.swf"; //如果找不到这个，就用Flex默认皮肤；
		var shortcutPS:String = ""; 
		var showMenuTooltip:String = "true";
		
		public function Preference()
		{
			//TODO: implement function
		}
		
		public function init()
		{
			//读取ShareObject和配置文件
		}
		
		public function getCurrentSkin():String
		{
			
		}
		
		public function setCurrentSkin():String
		{
			
		}
	}
}