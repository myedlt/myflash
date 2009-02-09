package puremvc.model.utils
{
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class WriteFile
	{
		public static function write(content:String,filepath:String):void
		{
			var fs:FileStream=new FileStream();
			fs.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			fs.openAsync(new File(filepath),FileMode.WRITE);
			fs.writeUTFBytes(content);
			fs.close();
		}
		private static function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("保存文件时出错!");
		}
	}
}