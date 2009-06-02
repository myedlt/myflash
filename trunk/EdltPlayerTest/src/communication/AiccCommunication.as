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
	}
}