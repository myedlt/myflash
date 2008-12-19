package model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class NavigatorProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "NavigatorProxy";
		
		public function NavigatorProxy ( data:Object = null ) 
        {
            super ( NAME, data );
			
        }
	}
}