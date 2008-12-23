package model
{		
	import model.vo.ChapterVO;
	import model.vo.CourseVO;
	import model.vo.LectureVO;
	import model.vo.SectionVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class CourseProxy extends Proxy implements IProxy
	{			
		public static const NAME:String = "CourseProxy";	
		private var courses:Array=new Array();	
		
		public function CourseProxy ( data:Object = null ) 
        {
            super ( NAME, data );	
            initialization();	            
        }
        	
        private function initialization():void
        { 					
			for each(var course:XML in this.data)
			{//课
				var chapters:Array=new Array();
				for each(var chapter:XML in course.Chapter)
				{//章					
					if(chapter.section!=undefined)
					{
						var sections:Array=new Array();
						for each(var section:XML in chapter.section)
						{//节
							var sec:SectionVO=new SectionVO();
							sec.name=section.@name;
							sec.path=section.@path;
							if(section.hasOwnProperty("@type"))
							{
								sec.type=section.@type;
							}
							if(section.hasOwnProperty("@title"))
							{
								sec.title=section.@title;
							}
							if(section.hasOwnProperty("@xml"))
							{
								sec.xml=section.@xml;
							}
							sections.push(sec);
						}
					}					
					var cha:ChapterVO=new ChapterVO();
					cha.name=chapter.@name;
					if(chapter.hasOwnProperty("@title"))
					{
						cha.title=chapter.@title;
					}
					if(chapter.hasOwnProperty("@path"))
					{
						cha.path=chapter.@path;
					}
					if(sections.length>0)
					{
						cha.sections=sections;
					}
					chapters.push(cha);
				}
				var cou:CourseVO=new CourseVO();
				cou.chapters=chapters;
				if(course.hasOwnProperty("@name"))
				{
					cou.name=course.@name;
				}
				if(course.hasOwnProperty("@title"))
				{
					cou.name=course.@name;
				}	
				if(course.hasOwnProperty("@startSWF"))
				{
					cou.name=course.@name;
				}	
				if(course.hasOwnProperty("@endSWF"))
				{
					cou.name=course.@name;
				}	
				if(course.Lecture!=undefined)
				{
					var lecture:LectureVO=new LectureVO();
					if(course.hasOwnProperty("@name"))
					{
						lecture.name=course.Lecture.name;
					}
					if(course.hasOwnProperty("@sex"))
					{
						lecture.sex=course.Lecture.sex;
					}
					if(course.hasOwnProperty("@age"))
					{
						lecture.age=course.Lecture.age;
					}
					if(course.hasOwnProperty("@position"))
					{
						lecture.position=course.Lecture.position;
					}
					if(course.hasOwnProperty("@photo"))
					{
						lecture.photo=course.Lecture.photo;
					}
					if(course.hasOwnProperty("@introduction"))
					{
						lecture.introduction=course.Lecture.introduction;
					}				
					cou.lecture=lecture;
				}
				courses.push(cou);					
			}
        }
        
        public function getCourses():Array
        {
        	return this.courses;
        }        
	}
}