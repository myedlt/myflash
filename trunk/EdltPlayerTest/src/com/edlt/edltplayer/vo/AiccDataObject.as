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
	}
}