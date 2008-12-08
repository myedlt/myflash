import org.osflash.thunderbolt.logging.LogLevel;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 * 
 * Change these settings for your need.
 * 
 */
class org.osflash.thunderbolt.Settings {
	
	/* 
	 * Set this flag to false if you do not want to group messages by frames.  
	 */
	public static var USE_FRAME_COUNTER:Boolean = true;
		
	/*
	 * Set the debugger log level.
	 * 
	 * LogLevel.LOG		- traces all messages
	 * LogLevel.INFO	- traces info, warning, error and fatal messages
	 * LogLevel.WARNING	- traces warning, error and fatal messages
	 * LogLevel.ERROR	- traces error and fatal messages
	 * LogLevel.FATAL	- traces fatal messages only
	 */
	public static var LOG_LEVEL:String = LogLevel.LOG;	

	/*
	 * If you want to trace debug messages only at a specific time
	 * you may set this value to "true" and later activate the debugger
	 * calling ThunderBolt.start(); via the console. 
	 */
	public static var INITALLY_STOPPED:Boolean = false;
	
	/*
	 * Set this property to false if you expect problems with the
	 * External Interface Logger.
	 */
	public static var USE_EXTERNAL_INTERFACE:Boolean = true;
	
	/*
	 * Set a handy shortcut to call methods from the FireBug 
	 * JavaScript console.
	 * 
	 * eg: 	ThunderBolt.inspect("_root");
	 * 		TB.inspect("_root");
	 */
	public static var JAVASCRIPT_CONSOLE_SHORTCUT:String = "TB";

	/*
	 * Increase this property if you want more details about
	 * complex object structures. 
	 */
	public static var COMPLEX_RECURSION_DEPTH:Number = 3;
	
	/*
	 * Use this filter to trace messages only from specific
	 * classes. To filter classes located in a specific
	 * package simply add the "*" wildcard character.
	 * 
	 * You can later change the filter via the console:
	 * 
	 * eg: 	ThunderBolt.filter("org.osflash.thunderbolt.Settings");
	 * 		ThunderBolt.filter("org.osflash.*");
	 * 
	 */
	public static var CLASS_FILTER:String = "*";
}