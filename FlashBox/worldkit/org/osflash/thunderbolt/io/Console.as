import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.data.JSReturn;
import org.osflash.thunderbolt.Settings;
import org.osflash.thunderbolt.io.JavaScriptInterface;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.io.Console {
	
	public static var version:Number;
	private static var _enabled:Boolean;
	
	private var classImport:Array = [JavaScriptInterface];

	// Writes a message to the console.
	public static function log(parameters:Object){
		Console.run("log", arguments);	
	}
		
	// Writes a message to the console with the visual "info" icon and color coding.
	public static function info(parameters:Object){
		Console.run("info", arguments);	
	}

	// Writes a message to the console with the visual "warning" icon and color coding.
	public static function warn(parameters:Object){
		Console.run("warn", arguments);	
	}

	// Writes a message to the console with the visual "error" icon and color coding.
	public static function error(parameters:Object){
		Console.run("error", arguments);	
	}
	
	// Prints an interactive listing of all properties of the object.
	public static function dir(parameters:Object){
		Console.run("dir", arguments);	
	}	

	// Prints the XML source tree of an HTML or XML element.
	public static function dirxml(node:Object){
	
		var out = Parser.stringify(node.toString());
		var returnObject:JSReturn = new JSReturn(
			"var n = document.createElement('xml');" +
			"n.innerHTML = \"" + out + "\";" +
			"return n;"
		);
		Console.run("dirxml", [returnObject]);
	}	

	// Writes a message to the console and opens a nested block 
	// to indent all future messages sent to the console.
	public static function group(parameters:Object):Void{
		Console.run("group", arguments);	
	}

	// Closes the most recently opened block.
	public static function groupEnd():Void{
		Console.run("groupEnd");	
	}

	// Executes JavaScript command
	private static function run(method:String, parameter:Array):Void{
		if (System.capabilities.playerType == "PlugIn"){	
			if (parameter){
				// check if unquoted strings are in cluded in parameters
				for (var i:Number=0; i < parameter.length; i++) {
					if (typeof parameter[i] == "string" && parameter[i].indexOf('"') != 0){
						parameter[i] = Parser.stringify(parameter[i]);
					}
					parameter[i] = "[" + parameter[i].toString() + "][0]";
				}
			} else {
				parameter = [];	
			}
		
			if (Console.enabled){
				if (Settings.USE_EXTERNAL_INTERFACE){
					// the External Interface is more stable than the
					// getURL(JavaScript) version
					var execute = ExternalInterface.call("thunderbolt_external_interface", method, parameter);
					if (execute) {
						return;
					}
				} 
				getURL("javascript:console." + method + "(" + parameter + ");");
			}
		}
	}
	
	// Inject some JavaScript code to pass complex objects to FireBug
	private static function initExternalInterface():Void{
/*
		getURL("javascript:" +
		"	var thunderbolt_external_interface = function(method, parameter){" +
		"		var output = [];" +
		"		try {" +
		"			for(var i=0; i< parameter.length; i++){" +
		"				output[i] = eval(unescape(parameter[i]));" +
		"			};" +
		"			console[method].apply(this, output);" +
		"		} catch(e){" +
		"			console.error(e);"+
		"		};" +
		"		return true;" +
		"	}");	
 */		
	}
	
	// Check if Firebug is enabled
	public static function get enabled():Boolean{
		if (Console._enabled !== undefined){
			return Console._enabled;
		} else {
			Console.version = Number(ExternalInterface.call("function(){ return window.console && console.firebug}", true));
			Console._enabled = Console.version > 0;
			if (Console._enabled){
				if (Settings.USE_EXTERNAL_INTERFACE){
					Console.initExternalInterface();
				}
				Console.log("Firebug v" + Console.version + " enabled.");
				return Console._enabled;
			} 
		}
	}	
}