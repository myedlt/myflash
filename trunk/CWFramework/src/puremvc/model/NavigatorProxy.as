package puremvc.model
{
	import puremvc.model.vo.NavigatorVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	//对导航数据模型代理
	public class NavigatorProxy extends Proxy implements IProxy
	{		
		public static const NAME:String = "NavigatorProxy";
		private var navigator:Array=new Array();
		
		public function NavigatorProxy ( data:Object = null ) 
        {
            super ( NAME, data );
			parseNavigator();				
        }
        
        private function parseNavigator():void
        {
        	if(data==null)
        	{
        		data=XML(DataProxy(facade.retrieveProxy(DataProxy.NAME)).getData()).Navigator.button;
        	}
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