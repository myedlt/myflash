package puremvc.view
{
	import puremvc.ApplicationFacade;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	//主"中介器" 对页面各个子"中介器"进行初始化和出错处理
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super( NAME, viewComponent );			
			
			facade.registerMediator( new NavigatorMediator( app.navigator ) );
			facade.registerMediator( new ContentsMediator( app.contents ) );
			facade.registerMediator( new CurrentPositionMediator( app.currentPosition ) );			
			facade.registerMediator( new ModuleLoaderMediator( app.moduleLoader ) );
			facade.registerMediator( new ControlBoardMediator( app.controlBoard ) );
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.ERROR			
				   ];
		}
		
		override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.ERROR : Alert.show(note.getBody().toString(),"Error"); break;				
            }
        }
		
		public function get app():index
		{
            return viewComponent as index;
        }
	}
}