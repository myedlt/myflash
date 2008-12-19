package controller
{
	import model.ContentProxy;
	import model.CourseInfoProxy;
	import model.NavigatorProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	    
    public class ModelPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			/* var contentProxy:ContentProxy=new ContentProxy();
			var content:XML=contentProxy.getData() as XML;
			var courseInfo:XMLList=content.CourseList.Course;
			var navigator:XMLList=content.Navigator.button; */
			
        	facade.registerProxy(new ContentProxy());
        	facade.registerProxy(new CourseInfoProxy());
        	facade.registerProxy(new NavigatorProxy());   
        }
    }
}