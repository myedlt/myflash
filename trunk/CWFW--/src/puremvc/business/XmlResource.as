package puremvc.business
{
	import puremvc.model.vo.ChapterVO;
	import puremvc.model.vo.CourseVO;
	import puremvc.model.vo.LectureVO;
	import puremvc.model.vo.SectionVO;
	//xml->object 一门课程包括讲师和章,章中包括节
	public class XmlResource
	{
		static public function parseSection(section:XML):SectionVO
		{//节:
			var sec:SectionVO=new SectionVO();
			if(section.hasOwnProperty("@name"))
			{
				sec.name=section.@name;
			}
			if(section.hasOwnProperty("@path"))
			{
				sec.path=section.@path;
			}			
			if(section.hasOwnProperty("@type"))
			{
				sec.type=section.@type;
			}
			else
			{
				sec.type="flash";//默认课件类型为flash
			}
			if(section.hasOwnProperty("@title"))
			{
				sec.title=section.@title;
			}
			if(section.hasOwnProperty("@xml"))
			{
				sec.xml=section.@xml;
			}
			return sec;
		}
		
		static public function parseChapter(chapter:XML):ChapterVO
		{//章:
			var cha:ChapterVO=new ChapterVO();					
			if(chapter.hasOwnProperty("@name"))
			{
				cha.name=chapter.@name;	
			}
			if(chapter.hasOwnProperty("@title"))
			{
				cha.title=chapter.@title;
			}				
			if(chapter.section!=undefined)
			{
				var sections:Array=new Array();
				for each(var section:XML in chapter.section)
				{						
					sections.push(parseSection(section));
				}
				cha.sections=sections;
			}
			else
			{
				if(chapter.hasOwnProperty("@type"))
				{
					cha.type=chapter.@type;
				}
				else
				{
					cha.type="flash";//默认课件类型为flash
				}
				if(chapter.hasOwnProperty("@xml"))
				{
					cha.xml=chapter.@xml;
				}
				if(chapter.hasOwnProperty("@path"))
				{
					cha.path=chapter.@path;
				}	
			}	
			return cha;			
		}
		
		static public function parseCourse(course:XML):CourseVO
		{//课程:
			var cou:CourseVO=new CourseVO();			
			var chapters:Array=new Array();
			for each(var chapter:XML in course.Chapter)
			{								
				chapters.push(parseChapter(chapter));
			}
			cou.chapters=chapters;
			if(course.hasOwnProperty("@name"))
			{
				cou.name=course.@name;
			}
			if(course.hasOwnProperty("@title"))
			{
				cou.title=course.@title;
			}	
			if(course.hasOwnProperty("@startSWF"))
			{
				cou.startSWF=course.@startSWF;
			}	
			if(course.hasOwnProperty("@endSWF"))
			{
				cou.endSWF=course.@endSWF;
			}	
			if(course.Lecture!=undefined)
			{	
				cou.lecture=parseLecture(course.Lecture);
			}
			return cou;
		}
		
		static public function parseLecture(lecture:XMLList):LectureVO
		{//讲师:
			var lec:LectureVO=new LectureVO();
			if(lecture.name!=undefined)
			{
				lec.name=lecture.name;
			}
			if(lecture.sex!=undefined)
			{
				lec.sex=lecture.sex;
			}
			if(lecture.age!=undefined)
			{
				lec.age=lecture.age;
			}
			if(lecture.position!=undefined)
			{
				lec.position=lecture.position;
			}
			if(lecture.photo!=undefined)
			{
				lec.photo=lecture.photo;
			}
			if(lecture.introduction!=undefined)
			{
				lec.introduction=lecture.introduction;
			}	
			return lec;
		}
	}
}
