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
		
		public function LectureVO()
		{
		}
		
		public function LectureVO(name:String,sex:String,age:int,photo:String,position:String,introduction:String)
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