package info.osmatrix.rmframework.app.model
{		
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import info.osmatrix.rmframework.app.model.vo.util.DataUtil;
	import info.osmatrix.rmframework.app.model.vo.*;
	
	//对课程数据模型代理
	public class ContentProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseProxy";
		
		private var courses:Array = new Array();	//课件的所有课程
		private var links:Array = new Array();
		
		public function ContentProxy ( data:Object):void 
        {        	
            super ( NAME, data );	
            parseData();            
        }
        
        private function parseData():void
        {
			this.data = DataUtil.parseCourse(XML(this.data));
        }
        
	}
}