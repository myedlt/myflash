package puremvc.controller
{	
	import mx.modules.ModuleManager;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import puremvc.ApplicationFacade;
	
	public class ModuleLocatorCommand extends SimpleCommand
	{
		private var SwfPlayerModule:String="module/SwfPlayerModule.swf";
		private var ImagePlayerModule:String="module/ImagePlayerModule.swf";
		private var FlvPlayerModule:String="module/FlvPlayerModule.swf";
		
		public function locate(type:String,path:String):void
		{			
			switch(type)
        	{
        		case "flash":
        		case "flex":
        			if(ModuleManager.getModule(SwfPlayerModule).loaded)
        			{
        				sendNotification(ApplicationFacade.SWF_LOAD,{path:path,type:type});
        			}
        			else
        			{
        				sendNotification(ApplicationFacade.MODULE_LOAD,{moduleUrl:SwfPlayerModule,contentType:type,contentUrl:path});
        			}
        			break;        		
        		case "image":
        			if(ModuleManager.getModule(ImagePlayerModule).loaded)
        			{
        				sendNotification(ApplicationFacade.IMAGE_LOAD,path);
        			}
        			else
        			{
        				sendNotification(ApplicationFacade.MODULE_LOAD,{moduleUrl:ImagePlayerModule,contentType:type,contentUrl:path});
        			}
        			break;
        		case "flv":
        			if(ModuleManager.getModule(FlvPlayerModule).loaded)
        			{
        				sendNotification(ApplicationFacade.FLV_LOAD,path);
        			}
        			else
        			{
        				sendNotification(ApplicationFacade.MODULE_LOAD,{moduleUrl:FlvPlayerModule,contentType:type,contentUrl:path});
        			}
        			break;
        	}        
		}
	}
}