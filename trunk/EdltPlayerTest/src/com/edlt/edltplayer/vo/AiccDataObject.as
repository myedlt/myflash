package com.edlt.edltplayer.vo
{
	// Aicc数据封装对象
	public class AiccDataObject
	{
		public static const PASS:String = "P";
		public static const COMPLETED:String = "C";
		public static const FAIL:String = "F";
		public static const INCOMPLETE:String = "I";
		public static const NONE:String = "N";
		// [Core]区段
		// Lesson_Location
		public var lessonLocation:String;
		// Lesson_Status
		public var lessonStatus:String;
		// Score
		public var score:String;
		// Time
		public var time:String;
		// [Core_Lesson]
		// [Comment]
		// [Objectives_Status]
		// J_ID
		public var jId:Object;
		// J_score
		public var jScore:Object;
		// J_status
		public var jStatus:Object;
		
		public function AiccDataObject()
		{
			
		}
		// 输出aicc_data中的数据
		public function toString():String {
			var result:String = "";
			result += "[Core]\r\n";
			result += "Lesson_Location="+this.lessonLocation;
			result += "Lesson_Status="+this.lessonStatus+"\n";
			result += "score="+this.score+"\n";
			result += "Time="+""+"\n";
			//[Core_Lesson]                                                                                                                                                                                                                                
			result += "[Core_Lesson]\r\n";
			//[Comments]
			result += "[Comments]\r\n";
			//[Objectives_Status]
			result += "[Objectives_Status]\r\n";
			for(var s:String in jId) {
				result += "J_ID."+ s + "=" + jId[s];
				result += "J_status."+ s + "=" + jStatus[s];
				result += "J_score."+ s + "=" + jScore[s];
			}
		}
	}
}