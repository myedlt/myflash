package communication
{
	public interface IAiccCommunication
	{
		function init():void;
		function saveStatus(id:String,status:String):void;
		function checkStatus(xmlList:XMLList):void;
	}
}