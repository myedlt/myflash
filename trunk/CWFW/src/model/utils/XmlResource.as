package model.utils
{
	import model.vo.ChapterVO;
	import model.vo.CourseVO;
	import model.vo.LectureVO;
	import model.vo.SectionVO;
	
	public class XmlResource
	{
		static public function parseSection(section:XML):SectionVO
		{
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
			return sec;
		}
		
		static public function parseChapter(chapter:XML):ChapterVO
		{
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
			if(chapter.section!=undefined)
			{
				var sections:Array=new Array();
				for each(var section:XML in chapter.section)
				{						
					sections.push(parseSection(section));
				}
				cha.sections=sections;
			}	
			return cha;			
		}
		
		static public function parseCourse(course:XML):CourseVO
		{
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
		{
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
