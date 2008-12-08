import org.osflash.thunderbolt.Settings;
import org.osflash.thunderbolt.io.Console;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.io.JavaScriptInterface {

	private static var codeSnippet:String =  
	
		"var ThunderBolt = {" +
		
		"	storedTarget: null," +
		"	elementID: null," +
		
		// display structure of flash target
		"	inspect: function(target, id){" +
		"		this.getFlash(id).inspect(this.getFullTarget(target));" +
		"	}," +

		// start the logger
		"	start: function(id){" +
		"		this.getFlash(id).start();" +
		"	}," +
		
		// stop the logger
		"	stop: function(id){" +
		"		this.getFlash(id).pause();" +
		"	}," +
				
		// filter output based on class
		"	filter: function(className, id){" +
		"		this.getFlash(id).filter(className);" +
		"	}," +		
		
		// run an expression within flash
		"	run: function(expression, id){" +
		"		this.getFlash(id).run(expression);" +
		"	}," +
		
		// assign a new value to the target
		"	set: function(target, value, id){" +
		"		this.getFlash(id).set(this.getFullTarget(target), value);" +
		"	}," +
		
		"	profile: function(target, id){" +
		"		this.getFlash(id).profileStart(target);" +
		"	}," +
		
		"	profileEnd: function(target, id){" +
		"		this.getFlash(id).profileEnd();" +
		"	}," +
		
		// set the target for future actions
		"	cd: function(path, id){" +
		
		"		if (path.indexOf('_root') == 0){" +
		"			this.storedTarget = path;	" +
		"		} else if (path){" +
		"			switch(path){" +
		"				case '.':	" +
		"				case '/': 	this.storedTarget = null; break;" +
		"				case '..':	this.storedTarget = this.storedTarget.split('.').slice(0,-1).join('.'); break;" +
		"				default: 	this.storedTarget = this.storedTarget ? this.storedTarget + '.' + path : path;" +
		"			}" +
		"		}" +
		"		this.inspect(id);" +
		"	}," +
	
		"	getFlash: function(id){" +
				// returns a reference of the flash Object or the first flash movie in document
		"		var d = document;		" +
		"		if(id) {		" +
		"			this.elementID = id;"+
		"			return d.getElementById(id);"+
		"		} else if(this.elementID){ " +
		"			return d.getElementById(this.elementID);"+
		"		} else { " +
		"			return d.getElementsByTagName('embed')[0];" +
		"		}"+
		"	}," +
	
		// private method" 
		"	getFullTarget: function(target){" +
		"		if (!target){" +
		"			return this.storedTarget;" +
		"		} else {" +
		"			if (target.indexOf('_root') == 0) {" +
		"				return target;" +
		"			} else {" +
		"				return this.storedTarget ? this.storedTarget + '.' + target : target; " +
		"			}" +
		"		}" +
		"	}" +
		"};" +

		// add shortcut;
		"var " + Settings.JAVASCRIPT_CONSOLE_SHORTCUT + " = ThunderBolt;";
		
	public static function injectCode():Boolean{
		if (System.capabilities.playerType == "PlugIn"){
			getURL("javascript:" + JavaScriptInterface.codeSnippet);
		}
		return true;
	//	return Console.enabled;
	};
	
	private static var enabled:Boolean = JavaScriptInterface.injectCode();
}