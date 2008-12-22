package model.vo
{
	public class LectureVO
	{
		public var name:String;
		public var sex:String;
		public var age:int;
		public var photo:String;
		public var position:String;
		public var introduction:String;
		
		public function LectureVO(name:String=null,introduction:String=null,position:String=null,age:int=undefined,sex:String=null,photo:String=null)
		{
			this.name=name;
			this.sex=sex;
			this.age=age;
			this.photo=photo;
			this.position=position;
			this.introduction=introduction;			
		}
	}
}