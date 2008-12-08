/**
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.data.ObjectType {
	
	private static var simpleTypes:Array = [
		"string", 
		"boolean",
		"number", 
		"undefined", 
		"null"
	];
	
	private static var complexTypes:Object = {
		xmlnode: 	XMLNode,
		xml: 		XML,
		textfield: 	TextField,
		button: 	Button,
		movieclip: 	MovieClip,
		array: 		Array,
		date: 		Date
	};
	
	/**
	 * Get the "real" type of an object. Possible values are:
	 * undefined, null, number, string, boolean, number,
	 * object, array, date, movieclip, button, textfield,
	 * xml and xmlnode.
	 *
	 * @param	target	The object to analyse.
	 * @return 	Object type.
	 */
	static function get(target:Object):String{
		for (var i:Number=0; i<ObjectType.simpleTypes.length; i++) {
			if (ObjectType.simpleTypes[i] == typeof(target)){
				return ObjectType.simpleTypes[i];	
			}
		}
		for (var type:String in ObjectType.complexTypes) {
			if (target instanceof ObjectType.complexTypes[type]){
				return type;	
			}
		}
		return typeof target;
	}

    
    /**
     * Test if the object type is complex. This could be used 
     * to execute recursive code executions.
     *
     * @param	type	The object type
     * @return 			True if object type is complex
     */
    static function isComplex(type:Object):Boolean{
    	return type == "object" || type == "movieclip";
    } 	
}