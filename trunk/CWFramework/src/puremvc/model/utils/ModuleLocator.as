package puremvc.model.utils
{	
	import mx.modules.ModuleManager;
	
	import puremvc.ApplicationFacade;
	//模块定位 返回一个Notification对象
	public class ModuleLocator
	{
		public static var SwfPlayerModule:String="module/SwfPlayerModule.swf";
		public static var ImagePlayerModule:String="module/ImagePlayerModule.swf";
		public static var FlvPlayerModule:String="module/FlvPlayerModule.swf";
		
		public static function locate(type:String,path:String):Object
		{
			var notification:Object=new Object();			
						
			switch(type)
        	{
        		case "flash":
        		case "flex":
        			if(ModuleManager.getModule(SwfPlayerModule).loaded)
        			{
        				notification.noteType=ApplicationFacade.SWF_LOAD;
        				notification.noteBody={path:path,type:type};
        			}
        			else
        			{
        				notification.noteType=ApplicationFacade.MODULE_LOAD;
        				notification.noteBody={moduleUrl:SwfPlayerModule,contentType:type,contentUrl:path};
        			}
        			break;        		
        		case "image":
        		case "album":
        			if(ModuleManager.getModule(ImagePlayerModule).loaded)
        			{
        				notification.noteType=ApplicationFacade.IMAGE_LOAD;
        				notification.noteBody=path;
        			}
        			else
        			{
        				notification.noteType=ApplicationFacade.MODULE_LOAD;
        				notification.noteBody={moduleUrl:ImagePlayerModule,contentType:type,contentUrl:path};
        			}
        			break;
        		case "flv":
        			if(ModuleManager.getModule(FlvPlayerModule).loaded)
        			{
        				notification.noteType=ApplicationFacade.FLV_LOAD;
        				notification.noteBody=path;
        			}
        			else
        			{
        				notification.noteType=ApplicationFacade.MODULE_LOAD;
        				notification.noteBody={moduleUrl:FlvPlayerModule,contentType:type,contentUrl:path};
        			}
        			break;
        	}
        	return notification;       
		}
	}
}