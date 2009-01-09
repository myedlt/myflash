package com.san.components
{
	import com.mh.movable.core.MovableCanvas;
	import com.san.components.library_classes.PhotoRenderer;
	import com.san.components.library_classes.DragDataTypes;
	import com.san.components.movable.MovableElipse;
	import com.san.components.movable.MovableImage;
	import com.san.components.movable.MovableRectangle;
	import com.san.components.movable.MovableStar;
	import com.san.components.movable.MovableText;
	import com.san.values.Photo;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	public class Page extends MovableCanvas
	{
		
		
		
		public function Page()
		{
			this.addEventListener( MouseEvent.CLICK, mouseClickHandler );
			this.addEventListener( DragEvent.DRAG_ENTER, dragEnterHandler );
			this.addEventListener( DragEvent.DRAG_DROP, dragDropHandler );
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			this.setFocus();
		}
		
		
		private function dragEnterHandler( event:DragEvent ):void
		{
			if( event.dragSource.hasFormat( DragDataTypes.PHOTO ) || 
				event.dragSource.hasFormat( DragDataTypes.STICKER ) || 
				event.dragSource.hasFormat( DragDataTypes.BACKGROUND ) || 
				event.dragSource.hasFormat( DragDataTypes.TILE ))
			{
				DragManager.acceptDragDrop( event.currentTarget as UIComponent );
			}
		}
		
		
		private function dragDropHandler(event:DragEvent):void
		{
			if( event.dragSource.hasFormat( DragDataTypes.PHOTO ) )
				handlePhotoDrop( event );
			
			if( event.dragSource.hasFormat( DragDataTypes.STICKER ) )
				handleStickerDrop( event );
			
			
		}
		
		
		private function handlePhotoDrop( event:DragEvent ):void
		{
			var photo:Photo = event.dragSource.dataForFormat( DragDataTypes.PHOTO ) as Photo;
			
			var di:PhotoRenderer = event.dragInitiator as PhotoRenderer;
			
			var mi:MovableImage = new MovableImage();
				mi.photoData = photo;
				mi.x = event.localX - (di.width/2);
				mi.y = event.localY - (di.height/2);
				mi.width = di.width;
				mi.height = di.height;
			this.addChild( mi );	
			
			this.setFocus();			
		}
		
		
		private function handleStickerDrop( event:DragEvent ):void
		{
			var shape:String = event.dragSource.dataForFormat( DragDataTypes.STICKER ) as String;
			
			var di:UIComponent = event.dragInitiator as UIComponent;
			
			var ms:UIComponent;
			
			switch( shape )
			{
				case MovableElipse.MOVABLE_ELIPSE:
					ms = new MovableElipse();
					break;
				case MovableRectangle.MOVABLE_RECTANGLE:
					ms = new MovableRectangle();
					break;
				case MovableStar.MOVABLE_STAR:
					ms = new MovableStar();
					break;
				case MovableText.MOVABLE_TEXT:
					ms = new MovableText();
					break;
			}
			
			ms.x = event.localX - (di.width/2);
			ms.y = event.localY - (di.height/2);
			ms.width = di.width;
			ms.height = di.height;
		
			this.addChild( ms );
			
			this.setFocus();
		}
		
		
		
		
	}
}