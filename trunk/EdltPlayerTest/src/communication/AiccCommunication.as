package communication
{
	import com.edlt.edltplayer.vo.AiccDataObject;
	
	public class AiccCommunication
	{
		public function AiccCommunication()
		{
			
		}
		public function saveStatus(id:String,status:String):void {
			var aiccData:AiccDataObject = new AiccDataObject;
			// todo
			aiccData.lessonLocation = "1-1-1-4";
			aiccData.lessonStatus = AiccDataObject.INCOMPLETE;		// 未完成
			aiccData.score = "0";
			aiccData.time = "0";					// 暂时不知道时间如何来取得，意义是什么？
			
			aiccData.jId = null;
			aiccData.jStatus = null;
			aiccData.jScore = null;
			// 
			ExternalInterface.call("doSetAicc",aiccData.toString());
			
		}
		public function checkStatus(xmlList:XMLList):void 
		{
		}
		
		public function Test(str:String):void {
			var aiccData:AiccDataObject = new AiccDataObject();
			aiccData.lessonLocation = runSeekStr2(str,"Lesson_Location=");
			aiccData.lessonStatus = runSeekStr2(str,"Lesson_Status=");
			aiccData.score = runSeekStr2(str,"score=");
			
			
		}
		
		///////////////////////
		// 从非(字母 数字 : _)处截止
		// str
		// form
		// return 
		function runSeekStr2(str:String, from:String):String {
			str = str.toLowerCase();
			from = from.toLowerCase();
			var newstr:String = "";
			if (!(str.indexOf(from)+1)) {			// 如果找不到要找的字符串
				return newstr;
			}
			
			var startIndex:Number = str.indexOf(from) + from.length;			// 找出起始索引
			var endIndex = 0;
			// 复杂的字符串操作，能不能改造成正则表达式
			for (var i = startIndex; i<str.length; i++) {
				var id = str.charCodeAt(i);
				if ((id >= 65 && id <= 90) || (id >= 97 && id <= 122) || 
					(id >= 48 && id <= 58) || (id == 95)) 
				{
					
				} 
				else 
				{
					endIndex = i;
					break;
				}
			}
			newstr = str.substring(startIndex,endIndex);
			if (newstr.length==0) {
				newstr = "";
			}
			return newstr;
		}
	}
}