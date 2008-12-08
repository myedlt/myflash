import org.osflash.thunderbolt.data.Parser;

/**
 * Simple wrapper class to store parses object informations
 * 
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.data.StringyfiedObject {
	
	private var dataString:String;
	
	/**
	 * Creates a new instance holding the parsed object data.
	 *
	 * @param	data	The object to be passed
	 * @param	depth	Level of recursion (optional)
	 * @return 			A new instance holding the parsed object data
	 */
	function StringyfiedObject(data:Object, depth:Number, label:String){
		this.dataString = Parser.stringify(data, depth, label);	
	}
	
	/**
	 * Returns the parsed information in JavaScript Object Notation (JSON)
	 * @return 	The parsed JSON string;
	 */
	public function toString():String{
		return dataString;
	}
}