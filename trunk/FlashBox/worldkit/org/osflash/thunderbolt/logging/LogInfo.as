import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.Logger;
import org.osflash.thunderbolt.data.ObjectType;
import org.osflash.thunderbolt.Settings;
/**
 * LogInfo objects are used to parse information provided by the MTASC trace facility
 * and provide more detailed information about the current trace action.
 *  
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.logging.LogInfo {
	
	public var fullClassWithMethodName:String;
	
	public var fileName:String;
	public var classParts:Array;
	public var methodName:String;
	public var fullClass:String;
	public var className:String;
	public var traceObject:Object;
	public var lineNumber:Number;
	public var objectType:String;
	
	public static var frameNumber:Number;
	private static var lastFrame:Number;
	private static var _movieUrl:String;
	private static var frameCounter:MovieClip;
	
	/**
	 * LogInfo objects are used to parse information provided by the MTASC trace facility
	 * and provide more detailed information about the current trace action.
	 */
	function LogInfo(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){
		
		this.traceObject = traceObject;
		this.fullClassWithMethodName = fullClassWithMethodName || "";
		this.fileName = fileName.split("\\").join("/") || ""; 
		this.lineNumber = lineNumber || 0;

		this.objectType = ObjectType.get(traceObject);

		// retrieve information about current trace action
		this.classParts = this.fullClassWithMethodName.split("::");
		this.methodName = classParts[1] || "anonymous";
		this.fullClass = classParts[0] || "" ;
		this.className = String(fullClass.split(".").pop()) || "Thunderbolt";
		
		if (!LogInfo.frameNumber){
			LogInfo.frameNumber = 1;
			if (Settings.USE_FRAME_COUNTER){
				LogInfo.initializeFrameCounter();
			}
		}
	}
	
	public function matchClassFilter():Boolean {
		
		if (Settings.CLASS_FILTER == "" || Settings.CLASS_FILTER == "*"){
			return true;	
		}
		
		var isPackage:Boolean = Settings.CLASS_FILTER.indexOf("*") > -1;
		
		if (isPackage){
			var match:String = Settings.CLASS_FILTER.split("*")[0];
			return this.fullClass.indexOf(match) == 0;
		} else {
			return this.fullClass == Settings.CLASS_FILTER;
		}
	}
	
	/**
	 * Create a new empty movieclip at root level and count running frames. 
	 * @return The movieclip that is listening.
	 */
	private static function initializeFrameCounter():MovieClip{
		LogInfo.frameCounter = _root.createEmptyMovieClip("thunderbolt_frame_listener_mc", _root.getNextHighestDepth());
		LogInfo.frameCounter.onEnterFrame = function(){
			LogInfo.frameNumber++;
		};
		return LogInfo.frameCounter;
	}
	
	/**
	 * Returns the object information as a JSON formated string 
	 * which may be passed to JavaScript calls. 
	 *
	 * @return String in JavaScript object notation (JSON).
	 */
	public function toString():String{
		var description:String = this.fullClassWithMethodName + "[" + this.lineNumber + "] : " + this.objectType + " @ " + this.time;
		// cunstruct info object
		return "{" +
			'description:"' + description 				+ '",' +  
			'method:"'		+ methodName				+ '",' +
			'line:"'		+ lineNumber				+ '",' +
			'type:"'		+ objectType				+ '",' +
			'time:"'		+ time						+ '",' +
			'frame:"'		+ LogInfo.frameNumber 		+ '",' +
			'fullClass:"' 	+ fullClass 				+ '",' +
			'file:"' 		+ fileName 					+ '",' +
			'toString:'		+ 'function(){return "' + className + '.' + methodName + '"}' +
		"}";		
	}
	
	/**
	 * Get well formated current execution.
	 * @return	Current time
	 */
	private function get time():String{
		return (new Date()).toString().split(" ")[3];	
	}
	
	/**
	 * Get the name of the current running SWF.
	 * @return 	Name of the swf.
	 */
	private static function get movieUrl():String{
		if (!LogInfo._movieUrl){
			LogInfo._movieUrl = _root._url.split("\\").pop().split("/").pop();	
		}
		return LogInfo._movieUrl;
	}
	
	/*
	 * Test if there is an open frame group and close it
	 */
	public function checkFrameGroup():Void{
		if (LogInfo.frameNumber != LogInfo.lastFrame){
			Console.groupEnd();
			Console.group(LogInfo.movieUrl + " [frame " + LogInfo.frameNumber + "] @ " + this.time);
			LogInfo.lastFrame = LogInfo.frameNumber;
		}		
	}	
}