/**
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.profiling.ProfileHandle {

	public var target:Object;
	public var methodName:String;
	public var method:Function;
	
	public var executionCount:Number;
	public var totalTime:Number;
	public var minTime:Number;
	public var maxTime:Number;

	public function ProfileHandle(target:Object, methodName:String){
		this.target = target;
		this.methodName = methodName;
		this.method = target[methodName];
		this.executionCount = 0;
		this.totalTime = 0;
		this.maxTime = 0;
		this.minTime = 0;
	}
	
	public function log(time:Number){
		this.executionCount++;
		this.totalTime += time;
		this.maxTime = Math.max(this.maxTime, time);
		this.minTime = this.minTime ? Math.min(this.minTime, time) : time;
	}
	
	public function get averageTime():Number{
		return this.totalTime / this.executionCount;	
	}
}