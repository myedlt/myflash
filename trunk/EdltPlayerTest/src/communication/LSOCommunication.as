package communication
{
	import flash.net.SharedObject;
	public class LSOCommunication implements IAiccCommunication
	{
		// 共享对象
		private var lso:SharedObject;
		// 指向外部的XML对象的引用
		private var _exXml:XML;
		
		private var statusArray:Array = new Array();
		private function get innerXML():XML {
			var xml:XML = null;
			if(lso.data.menuXML!=undefined) {
				xml = lso.data.menuXML as XML;
			}
			return xml;
		}
//		public function LSOCommunication(xml:XML)
//		{
//			init();
//			_exXML = xml;
//		}
		public function LSOCommunication() {
			
		}
		public function init():void
		{
			lso = SharedObject.getLocal("Aicc","/");
		}
		
		public function statusXML(xml:XML):void {
			
		}
		// 保存状态
		public function saveStatus(id:String,status:String):void {
//			id = "j_id." + id; 
			trace("保存id: " + id + " status: " + status);
			lso = SharedObject.getLocal("Aicc","/");
			var statusObj:Object
			if(lso.data.status) {
				statusObj = lso.data.status;
			} else {
				statusObj = new Object();
			}
			statusObj[id] = status;
			lso.data.status = statusObj;
			lso.flush();
		}
		public function checkStatus(xmlList:XMLList):void {
			lso = SharedObject.getLocal("Aicc","/");
			var statusObj:Object = lso.data.status;
			for(var i:* in statusObj) {
				trace("读取状态数据");
				trace(i);
				trace(statusObj[i]);
				xmlList[i].@iState = statusObj[i];
			}
		}
	}
}