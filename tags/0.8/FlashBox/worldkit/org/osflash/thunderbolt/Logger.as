/* ***** BEGIN LICENSE BLOCK *****
 * 
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with 
 * the License. You may obtain a copy of the License at 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is the Thunderbolt Flash Debugging Interface.
 * 
 * Contributors:
 * - Martin Kleppe <kleppe@gmail.com>
 * - Jens Krause
 * 
 * Project Home Page:
 * http://code.google.com/p/flash-thunderbolt/
 * 
 * ***** END LICENSE BLOCK *****
 */

import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.io.Commandline;
import org.osflash.thunderbolt.logging.LogInfo;
import org.osflash.thunderbolt.logging.LogLevel;
import org.osflash.thunderbolt.Settings;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 * @link http://code.google.com/p/flash-thunderbolt/
 */
 
class org.osflash.thunderbolt.Logger {
	
	private static var initialized:Boolean = Logger.initialize();
	public static var stopped:Boolean;
	
	private var classes:Array = [Commandline];

	private static function initialize():Boolean{
		Logger.stopped = Settings.INITALLY_STOPPED;
		return true;
	}

	/**
	 * Compiling your project using the MTASC trace command will replace 
	 * all calls of trace by calls to your custom trace function 
	 * and will add more parameters that contains debug infos such as 
	 * full class name with method name, file name and line number 
	 */
	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){

		// send traces to console 
		// but only if Firebug is available
		if (Console.enabled){
			if (Logger.stopped){
				return;	
			}
			// get more detailed information about current trace
			var info:LogInfo = new LogInfo(traceObject, fullClassWithMethodName, fileName, lineNumber);
			if (!info.matchClassFilter()){
				return;	
			}
			
			// check if movie has entered a new frame
			info.checkFrameGroup();
				
			if (String(traceObject).indexOf("+++") == 0){
				if (Settings.LOG_LEVEL == LogLevel.LOG){
					var message:String = String(traceObject).slice(String(traceObject).charAt(3) == " " ? 4 : 3);
					// open group	
					Console.group(message + (message ? " " : "") + "(" + fullClassWithMethodName + ")");
				}
			} else if (traceObject == "---"){
				if (Settings.LOG_LEVEL == LogLevel.LOG){
					// close group
					Console.groupEnd();
				}
			} else {
				// switch between console actions: log, info, warn, error
				var logLevel:LogLevel = new LogLevel(traceObject);
				
				if (logLevel.sendToOutput){
					// check if message should be sliced									
					traceObject = logLevel.messageModified ? logLevel.message : traceObject;
					// start group for xml output
	//				if (info.objectType == "xml" || info.objectType == "xmlnode"){
					//TODO: to debug XML output
					if (false){
						Console.group(info, new StringyfiedObject(traceObject));
						Console.dirxml(traceObject);
						Console.groupEnd();
					// group multi line strings			
					} else if (typeof traceObject == "string" && traceObject.indexOf("\n") > -1 && logLevel.console == Console.log) {
						// begin group
						Console.group(info);
						// log single lines
						var lines:Array = traceObject.split("\n");
						for (var i:Number = 0; i < lines.length; i++){
							Console.log(lines[i]);		
						}
						// end group
						Console.groupEnd();
					} else {
						// request javascript action
						logLevel.console(info, ":", new StringyfiedObject(traceObject));				
					}
				}
			}
		}
	}
}