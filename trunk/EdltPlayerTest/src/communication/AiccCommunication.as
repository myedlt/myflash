package communication
{
	import com.edlt.edltplayer.vo.AiccDataObject;
	
	import flash.external.ExternalInterface;
	
	import mx.utils.StringUtil;
	public class AiccCommunication implements IAiccCommunication
	{
		private var flag:Boolean;
		private var aiccData:AiccDataObject = new AiccDataObject();
		// aicc数据对象
		private var obj:Object = new Object();
		
		public function AiccCommunication(dataCourse:String) {
			obj["j_id"] = new Object();
			obj["j_status"] = new Object();
			obj["j_score"] = new Object();
			decode(dataCourse);			// 解析
		}
		
		public function init():void {
			
		}
		public function saveStatus(id:String,status:String):void {
			var request:String = "";
			request += "[Core]\r\n";
			request += "Lesson_Location=p002\r\n";
			request += "Lesson_Status=C\r\n";
			request += "Score=0\r\n";
			request += "Time=00:01:53\r\n";
			request += "[Core_Lesson]\r\n";
			request += "[Core_Vendor]\r\n";
			request += "[Objectives_status]\r\n";
			request += "J_ID.1=p001\r\n";
			request += "J_Status.1=C\r\n";
			ExternalInterface.call("doSetAicc",request);
		}
		public function checkStatus(xmlList:XMLList):void 
		{
			
		}
		

		// 对Aicc字符串数据进行解析
		private function decode(str:String):void {
			var newstr:String = str.toLowerCase();
			var arr:Array = newstr.split('\r\n');
			arr.forEach(trimCallback);
			arr = arr.filter(filterCallback);
			arr.forEach(toObjectCallback);
			trace(obj["j_id"]["2"]);
		}
		
		// forEach回调函数——删除每个数组元素中前后的空格
		private function trimCallback(item:*, index:int, array:Array):void {
			array[index] = StringUtil.trim(item);
		}

		// 过滤回调函数
		private function filterCallback(item:*, index:int, array:Array):Boolean {
			if(item.length != 0) {
				return true;
			} else {
				return false;
			}
		}
		
		private function toObjectCallback(item:*, index:int, array:Array):void {
			var arr:Array = item.split("=");
			trace(arr);
			var name:String = StringUtil.trim(arr[0]);
			var value:String = StringUtil.trim(arr[1]);
			var fen:int = 0;
			if((fen = name.indexOf(".")) == -1) {			// 不包含.
				obj[name] = value;
			} else {
				var i:String = name.substring(0,fen);
				var j:String = name.substring(fen+1);
				obj[i][j] = value;
			}
		}
	}
}