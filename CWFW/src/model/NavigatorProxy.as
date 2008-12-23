package model
{
	import model.vo.NavigatorVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class NavigatorProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "NavigatorProxy";
		private var navigator:Array=new Array();
		
		public function NavigatorProxy ( data:Object = null ) 
        {
            super ( NAME, data );
			initialization();				
        }
        
        private function initialization():void
        {
        	for each(var button:XML in this.data)
			{
				navigator.push(new NavigatorVO(button.@label,button.@url));
			}
        }
        
        public function getNavigator():Array
        {
        	return this.navigator;
        }
	}
}