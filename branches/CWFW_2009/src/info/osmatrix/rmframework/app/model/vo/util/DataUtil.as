package info.osmatrix.rmframework.app.model.vo.util
{
	import info.osmatrix.rmframework.app.model.vo.ChapterVO;
	import info.osmatrix.rmframework.app.model.vo.CourseVO;
	import info.osmatrix.rmframework.app.model.vo.LectureVO;
	import info.osmatrix.rmframework.app.model.vo.SectionVO;
	
	/**
	 * 
	 * @author huhj
	 * 	1、xml转换为值对象，用于前端界面使用；
	 * 	2、值对象转换为xml，用于保存xml文件；
	 * 
	 *  注：数据库取值也许可以先转换为xml文件。
	 * 
	 */
	public class DataUtil
	{
		// 通过传入的XML(即content.xml)获得CourseVO
		static public function parseCourse(coXml:XML):CourseVO
		{

			var co:CourseVO = new CourseVO();						

			// 1、课程概要信息
			var course:XML = XML(coXml.CourseList.Course);
			co.name 	= (course.hasOwnProperty("@name"))?course.@name:"";
			co.title 	= (course.hasOwnProperty("@title"))?course.@title:"";
			co.startSWF = (course.hasOwnProperty("@startSWF"))?course.@startSWF:"";
			co.endSWF 	= (course.hasOwnProperty("@endSWF"))?course.@endSWF:"";
			
			// 2、讲师
			var lecture:XML = XML(coXml.CourseList.Course.Lecture);			
			if(lecture)
			{	
				co.lecture=parseLecture(lecture);
			}
			
			// 3、功能链接
			
			// 4、章
			var chapters:Array = new Array();
			var chapterList:XMLList = XMLList(coXml..Chapter);
			for each(var chapterXml:XML in chapterList)
			{								
				chapters.push(parseChapter(chapterXml));
			}
			co.chapters=chapters;
						
			// 5、节	
			var sections:Array = new Array();			
			var sectionList:XMLList = XMLList(coXml..section);
			for each(var sectionXml:XML in sectionList)
			{								
				sections.push(parseSection(sectionXml));
			}
			co.sections = sections;
			
			
			return co;
		}
				
		static public function parseSection(section:XML):SectionVO
		{
			//节:
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
		
		/**
		 * 	章:
		 * @param chapter
		 * @return 
		 * 
		 */
		static public function parseChapter(chapter:XML):ChapterVO
		{
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
		

		
		static public function parseLecture(lecture:XML):LectureVO
		{
			//讲师:
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
