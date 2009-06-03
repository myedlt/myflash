package com.edlt.edltplayer.vo
{
	import flash.utils.Dictionary;
	
	// Aicc数据封装对象
	public class AiccDataResponse
	{
		public static const PASS:String = "P";
		public static const COMPLETED:String = "C";
		public static const FAIL:String = "F";
		public static const INCOMPLETE:String = "I";
		public static const NONE:String = "N";
		
		public var error:String;
		public var errorText:String;
		public var version:String;
		// aicc_data=
		// [Core]区段
		// Student_ID=admin
		public var studentId:String;
		// Student_Name=
		public var studentName:String;
		// Lesson_Location
		// Lesson_Location=p002
		public var lessonLocation:String;
		// Credit=
		public var credit:String;
		// Lesson_Status
		// Lesson_Status=i
		public var lessonStatus:String;
		// Score
		// Score=0
		public var score:String;
		// Time
		// Time=00:00:51.000
		public var time:String;
		//Lesson_Mode=Normal
		public var lessonMode:String;
		// [Core_Lesson]
		// [Core_Vendor]
		// [Objectives_Status]
		// J_ID
		public var jId:Object;
		// J_score
		public var jScore:Object;
		// J_status
		public var jStatus:Object;
		
		public function AiccDataObject(str:String=null)
		{
			if(str!=null) {
				
			}
		}
		private function decode(str:String):void {
			this.error = runSeekStr2(str,"error=");
			this.errorText = runSeekStr2(str,"error_text=");
			this.version = runSeekStr2(str,"version=");
			//[Core] 
			this.studentId = runSeekStr2(str,"Student_ID=");
			this.studentName = runSeekStr2(str,"Student_Name=");
			this.lessonLocation = runSeekStr2(str,"Lesson_Location=");
			this.credit = runSeekStr2(str,"Credit=");
			this.lessonStatus = runSeekStr2(str,"Lesson_Status=");
			this.score = runSeekStr2(str,"Score=");
			this.time = runSeekStr2(str,"Time=");
			this.lessonMode = runSeekStr2(str,"Lesson_Mode=");
			// [Core_Lesson]
			// Objectives_Status]
			var arr:Array = new Array();
			var i:int = str.indexOf("j_id.");
			while(i<str.length) {
				
			}
			runSeekStr2(str,"j_id.");
			
		}
		private var dic:Dictionary = new Dictionary();
		
		private function push(name:String,value:String):void {
			dic[name] = value;
		}
		private var tempStr:String; 
		private function runSeekStr(str:String,startIndex:Number):Number {
			var endIndex:Number = 0;
			/////
			
			///////
			return endIndex;
		}
		function runSeekStr3(str:String, from:String):String {
			var arr:Array = new Array();
			str = str.toLowerCase();
			// 解析每一行数据为数组
			var startIndex:int = 0;
			var endIndex:int = 0;
			for (var i:int = startIndex; i<str.length; i++) {
				var id = str.charCodeAt(i);
				if ((id >= 65 && id <= 90) || (id >= 97 && id <= 122) || 
					(id >= 48 && id <= 58) || (id == 95)) 
				{
					
				} 
				else 
				{
					endIndex = i;
					newstr = str.substring(startIndex,endIndex);
					arr.push(newstr);
					startIndex = i;
				}
			}
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
			for (var i:int = startIndex; i<str.length; i++) {
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
		
		// 输出aicc_data中的数据
		public function toString():String {
//			var result:String = "";
//			result += "[Core]\r\n";
//			result += "Lesson_Location="+this.lessonLocation;
//			result += "Lesson_Status="+this.lessonStatus+"\n";
//			result += "score="+this.score+"\n";
//			result += "Time="+""+"\n";
//			//[Core_Lesson]                                                                                                                                                                                                                                
//			result += "[Core_Lesson]\r\n";
//			//[Comments]
//			result += "[Comments]\r\n";
//			//[Objectives_Status]
//			result += "[Objectives_Status]\r\n";
//			for(var s:String in jId) {
//				result += "J_ID."+ s + "=" + jId[s];
//				result += "J_status."+ s + "=" + jStatus[s];
//				result += "J_score."+ s + "=" + jScore[s];
			}
		}
	}
}