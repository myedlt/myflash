package model
{
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class CourseInfoProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CourseInfoProxy";
		
		public function CourseInfoProxy ( data:Object = null ) 
        {
            super ( NAME, data );
			
        }
	}
}