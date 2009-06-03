package com.edlt.edltplayer.vo
{
	public class AiccResponse
	{
		private var _data:Object = new Object();
		public function AiccResponse()
		{
		}
		
//		function runSeekStr3(str:String, from:String):String {
		// aicc响应数据解析
		private function decode(str:String):void {
			var arr:Array = new Array();
			str = str.toLowerCase();
			var newstr:String = null;
			// 解析每一行数据为数组
			var startIndex:int = 0;
			var endIndex:int = 0;
			for (var i:int = 0; i<str.length; i++) {
				var id = str.charCodeAt(i);
				if ((id >= 65 && id <= 90) || (id >= 97 && id <= 122) || 
					(id >= 48 && id <= 58) || (id == 95)) 
				{
					
				} 
				else 
				{
					endIndex = i;
					newstr = str.substring(startIndex,endIndex);
					///
					if(newstr.length != 0) {
						
					}
					///
					arr.push(newstr);
					startIndex = i+1;
				}
			}
		}
	}
}