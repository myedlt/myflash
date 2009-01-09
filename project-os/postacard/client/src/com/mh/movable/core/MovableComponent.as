package com.mh.movable.core
{
	import com.mh.movable.event.MovableEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	
	public class MovableComponent extends Canvas
	{
		private const MIN_SIZE:Number = 15;
		
		public var maintainAspectRatio:Boolean = true;
		
		
		public function MovableComponent()
		{
			this.clipContent = false;
			this.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
		}
		
		
		private function mouseDownHandler( event:MouseEvent ):void
		{
			event.stopPropagation();
						
			this.dispatchEvent( new MovableEvent( MovableEvent.SELECT_COMPONENT ) ); 
			this.dispatchEvent( new MovableEvent( MovableEvent.MOVE_COMPONENT ) );
		}
		
		public function clone():Object
		{
			var tmp:MovableComponent = new MovableComponent();
			
			tmp.x = x;
			tmp.y = y;
			tmp.width = width;
			tmp.height = height;
			
			return tmp;
		}
		
		
		public function moveCenter( deltaX:Number, deltaY:Number ):void
		{
			x += deltaX;
			y += deltaY;
		}
		
		public function resizeLeft( delta:Number ):void
		{
			if( delta>0 && width < MIN_SIZE )
				return;
				
			x += delta;
			width -= delta;
		}
		public function resizeRight( delta:Number ):void
		{
			if( delta<0 && width<MIN_SIZE )
				return;
				
			width += delta;
		}
		public function resizeTop( delta:Number ):void
		{
			if( delta>0 && height < MIN_SIZE )
				return;
				
			y += delta;
			height -= delta;
		}
		public function resizeBottom( delta:Number ):void
		{
			if( delta<0 && height < MIN_SIZE )
				return;
				
			height += delta;
		}
		
		public function resizeTopLeft( deltaX:Number, deltaY:Number ):void
		{
			if( maintainAspectRatio )
			{
				if( Math.abs(deltaX) > Math.abs(deltaY) ) // resize according to largest
					deltaY = deltaX*(height/width);
				else
					deltaX = deltaY*(width/height);
			}
				
			if( (deltaX>0 && width < MIN_SIZE) || (deltaY>0 && height < MIN_SIZE) )
				return;
				
			resizeLeft( deltaX );
			resizeTop( deltaY );
		}
		
		public function resizeTopRight( deltaX:Number, deltaY:Number ):void
		{
			if( maintainAspectRatio )
			{
				if( Math.abs(deltaX) > Math.abs(deltaY) ) // resize according to largest
					deltaY = deltaX*(height/width)*-1;
				else
					deltaX = deltaY*(width/height)*-1;
			}

			if( (deltaX<0 && width < MIN_SIZE) || (deltaY>0 && height < MIN_SIZE) )
				return;
				
			resizeRight( deltaX );
			resizeTop( deltaY );
		}
		
		public function resizeBottomLeft( deltaX:Number, deltaY:Number ):void
		{
			if( maintainAspectRatio )
			{
				if( Math.abs(deltaX) > Math.abs(deltaY) ) // resize according to largest
					deltaY = deltaX*(height/width)*-1;
				else
					deltaX = deltaY*(width/height)*-1;
			}
				
			if( (deltaX>0 && width < MIN_SIZE) || (deltaY<0 && height < MIN_SIZE) )
				return;
				
			resizeLeft( deltaX );
			resizeBottom( deltaY );
		}

		public function resizeBottomRight( deltaX:Number, deltaY:Number ):void
		{
			if( maintainAspectRatio )
			{
				if( Math.abs(deltaX) > Math.abs(deltaY) ) // resize according to largest
					deltaY = deltaX*(height/width);
				else
					deltaX = deltaY*(width/height);
			}
				
			if( (deltaX<0 && width<MIN_SIZE) || (deltaY<0 && height<MIN_SIZE) )
				return;
				
			resizeRight( deltaX );
			resizeBottom( deltaY );
		}
		
	}
}