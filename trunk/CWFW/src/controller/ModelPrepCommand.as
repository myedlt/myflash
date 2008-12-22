package controller
{	
	import model.CourseInfoProxy;
	import model.NavigatorProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	    
    public class ModelPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{			
        	facade.registerProxy(new CourseInfoProxy(XML(note.getBody()).CourseList.Course));
        	facade.registerProxy(new NavigatorProxy(XML(note.getBody()).Navigator.button));   
        }
    }
}