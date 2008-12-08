import org.osflash.thunderbolt.profiling.ProfileHandle;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.Logger;
import org.osflash.thunderbolt.data.StringyfiedObject;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.profiling.Profiler {
	
	private static var cache:Array = [];
	
	function Profiler(){
	}
	
	public static function start(target:Object, method:Object):Array{
	
		// check if profiler is already running
		if (Profiler.cache.length > 0){
			Console.info("Profiler is already runnning.");
		}
		// returns name of method
		var getMethodName = function():String{
			for (var all:String in target) {
				// see if given mehods matches expression
				if (target[all] == method) {
					return all;
				}
			}
		};
		// switch profile actions base on method type		
		switch (typeof method){
			case "undefined": 	Profiler.profileObject(target); break;	
			case "string": 		Profiler.profileMethod(target, String(method)); break;
			case "function": 	Profiler.profileMethod(target, getMethodName(method)); break;
		}
		return Profiler.cache;
	}
	
	private static function profileMethod(target:Object, methodName:String):Void{
		// check if method is currently profiled
		if (!target[methodName].profile){
			// create profile handle
			var profile:ProfileHandle = new ProfileHandle(target, methodName);
			// override method
			target[methodName] = function():Object{
				var startTime:Number = getTimer();
				// execute method and store returned value
				var returnValue = profile.method.apply(target, arguments);
				// log execution time
				profile.log(getTimer() - startTime);
				return returnValue;
			};
			// stick reference for later removal
			target[methodName].profile = profile; 
			// cache reference 
			Profiler.cache.push(target[methodName]);
		}
	}
	
	private static function profileObject(target:Object):Void{
		// unplug object's methods
		for (var all:String in target){
			if (typeof target[all] == "function"){
				Profiler.profileMethod(target, all);
			}
		}
	}
	
	public static function stop():Array {
		if (Profiler.cache.length == 0){
			Console.error("Please start the profiler first!");
			return null;
		}
		var profileLog = [];
		for (var i:Number=0; i<Profiler.cache.length; i++) {
			var method:Function	= Profiler.cache[i];
			var profile:ProfileHandle = method.profile;
			profile.target[profile.methodName] = profile.method;
			profileLog.push(profile);
			delete method;
		}
		Console.groupEnd();
		Profiler.cache = [];
		return profileLog;
	}
}