package puremvc.model.utils
{	
	import mx.controls.Alert;
	import mx.modules.ModuleManager;
	
	import puremvc.ApplicationFacade;
	//模块定位 返回一个Notification对象
	public class ModuleLocator
	{
		public static var SwfPlayerModule:String="module/SwfPlayerModule.swf";
		public static var ImagePlayerModule:String="module/ImagePlayerModule.swf";
		public static var FlvPlayerModule:String="module/FlvPlayerModule.swf";
		
		public static function locate(des:Object):Object
		{
			var notification:Object=new Object();			
			switch(des.type)
        	{
        		case "flash":        		
        			if(ModuleManager.getModule(SwfPlayerModule).loaded)
        			{
        				notification.noteType=ApplicationFacade.SWF_LOAD;
        				notification.noteBody={path:des.path,hasContrlBar:des.hasContrlBar};
        			}
        			else
        			{
        				notification.noteType=ApplicationFacade.MODULE_LOAD;
        				notification.noteBody={moduleUrl:SwfPlayerModule,contentType:des.type,contentUrl:des.path,hasContrlBar:des.hasContrlBar};
        			}
        			break;        		
        		case "image":        		
        			if(ModuleManager.getModule(ImagePlayerModule).loaded)
        			{
        				notification.noteType=ApplicationFacade.IMAGE_LOAD;
        				notification.noteBody=des.path;
        			}
        			else
        			{
        				notification.noteType=ApplicationFacade.MODULE_LOAD;
        				notification.noteBody={moduleUrl:ImagePlayerModule,contentType:des.type,contentUrl:des.path};
        			}
        			break;
        		case "flv":
        			if(ModuleManager.getModule(FlvPlayerModule).loaded)
        			{
        				notification.noteType=ApplicationFacade.FLV_LOAD;
        				notification.noteBody=des.path;
        			}
        			else
        			{
        				notification.noteType=ApplicationFacade.MODULE_LOAD;
        				notification.noteBody={moduleUrl:FlvPlayerModule,contentType:des.type,contentUrl:des.path};
        			}
        			break;
        	}
        	return notification;       
		}
	}
}