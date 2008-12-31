import org.osflash.thunderbolt.data.ObjectType;
import org.osflash.thunderbolt.Settings;
/**
 * A Parser to convert an object into its JavaScript Object Notation 
 * (JSON) so it could be passed to JavaScipt calls.
 * 
 * @author Martin Kleppe <kleppe@gmail.com>
 */
 
class org.osflash.thunderbolt.data.Parser{
	
	// movieclip properties that should be displayed
	private static var mcProperties:Array = [
		"_x", 
		"_y", 
		"_width", 
		"_height", 
		"_xscale", 
		"_yscale", 
		"_alpha"
	];
	
	/**
	 * Converts an object into its JavaScript Object Notation (JSON) 
	 * so it could be passed to JavaScipt calls.
	 * 
	 * @param	target	Object to stringify
	 * @param	depth	Optional paramter specifying the level of recusion
	 * @return 			Stringified object in JavaScript Object Notation (JSON)
	 * 
	 * @see	http://www.json.org/json.as
	 */
    public static function stringify(target:Object, depth:Number, label:String):String {

        var output:String = '';
		var type:String = ObjectType.get(target);
		
		if (depth === undefined){
			depth = Settings.COMPLEX_RECURSION_DEPTH; 
		} 
		
		// stop execution if depth is equal or less than zero
		var stopAnalysing:Boolean = depth <= 0;
		if (stopAnalysing){
			return ObjectType.isComplex(type) ? Parser.returnString(type, true, true) : Parser.stringify(target);
		}

        switch (type) {
        	case 'textfield': 
	        	return Parser.returnString(type, true, true);
        		output = Parser.returnString("textfield | " + target, false, true);
                for (var all:String in target) {
                    output += "," + all + ':' + Parser.stringify(target[all].toString());
                } 
        		return "{" + output + "}";     		
        		
        	case 'button':
        	case 'movieclip':
        		output = Parser.returnString(type + " | " + target, false, true); 
        		for (var i:Number=0; i< Parser.mcProperties.length; i++) {
        			var property:String = Parser.mcProperties[i];
        			output += "," + property + ":" + target[property];
        		}
	        case 'object':
                for (var all:String in target) {
                    output += (output ? "," : "") + all + ':' + Parser.stringify(target[all], depth-1);
                }
                if (label) {
                	output += (output ? "," : "") + Parser.returnString(label);
                }
                return '{' + output + '}';
            case 'array':
                for (var i:Number = 0; i < target.length; i++) {
                    output += (output ? "," : "") + Parser.stringify(target[i], depth-1);
                }
                return '[' + output + ']';
	        case 'number': 		return isFinite(target) ? String(target) : 'null';
	        case 'string': 		
	        	if (Settings.USE_EXTERNAL_INTERFACE){
	        		output =  target.split('"').join("''");
	        	} else {
	        		
	        		output =  target.split('"').join('\\"');
	        	}
	        	output = output.split('\n').join("");
	        	output = output.split('\t').join("");
	        	output = output.split('\r').join("");
	        	return '"' + output + '"';
	        case 'boolean':		return String(target);
	        case 'date':		return 'new Date(' + target.valueOf() + ')';
	        case 'xml':
	        case 'xmlnode':		return Parser.returnString(type, true, true);
//	        case 'xmlnode':		return '{xml:%22' + target.toString().split('"').join('%22') + '%22, ' + Parser.returnString('xml', false, true) + '}';
	        case 'undefined': 	return 'undefined';
	        default: 			return Parser.returnString(type, true, true);
        }
    }
    
    private static function returnString(value:String, enclose:Boolean, addBrackets:Boolean):String{
    	value = addBrackets ? "[" + value + "]" : value;	
		value = 'toString:function(){return %22' + value + '%22}';
    	value = enclose ? "{" + value + "}" : value;	

    	return value;
    }
}