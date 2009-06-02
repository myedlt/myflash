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
			aiccData.lessonLocation = "";
			aiccData.lessonStatus = "";
			aiccData.score = "";
			aiccData.time = "";
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