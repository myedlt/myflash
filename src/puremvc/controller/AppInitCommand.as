package puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.model.*;
	import puremvc.view.*;
	
	public class AppInitCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
		{
			/* 
			 *	数据准备：先将xml文件读入DataProxy,数据加载成功后发STARTUP消息
			 *		CourseProxy和NavigatorProxy都从DataProxy获得数据
			 * 
			 */
			facade.registerProxy(new DataProxy("content.xml"));

        }
	}
}