package view
{
	import mx.controls.Label;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.CurrentPositionComponent;
	//页面"当前位置"/"面包屑'的"中介器"
	public class CurrentPositionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CurrentPositionMediator";	
		
		public function CurrentPositionMediator(viewComponent:CurrentPositionComponent)
		{
			super(NAME,viewComponent);			
		} 
		
		override public function listNotificationInterests():Array
		{
			return [
						ApplicationFacade.CHAPTER_CHANGE,
						ApplicationFacade.SECTION_CHANGE,
						ApplicationFacade.SINGLE_CHAPTER		
				   ];
		}
				
		override public function handleNotification(note:INotification):void
		{
			 switch ( note.getName() ) 
			 {
			 	case ApplicationFacade.CHAPTER_CHANGE:
				 	txtChapter.text=note.getBody().toString();
					break;
			 	case ApplicationFacade.SECTION_CHANGE:
				 	if(arrowFlag.visible==false)
				 	{
				 		arrowFlag.visible=true;
				 	}
				 	txtSection.text=note.getBody().toString(); 
				 	break;
			 	case ApplicationFacade.SINGLE_CHAPTER:
				 	txtChapter.text=note.getBody().toString();
				 	txtSection.text=null;
				 	if(arrowFlag.visible==true)
				 	{
				 		arrowFlag.visible=false;
				 	}
				 	break;			 					
             }
		}
		
		public function get txtChapter():Label
		{
            return viewComponent.txtChapter as Label;
        }	
        
        public function get txtSection():Label
		{
            return viewComponent.txtSection as Label;
        }
        
        public function get arrowFlag():Label
		{
            return viewComponent.arrowFlag as Label;
        }	
	}
}