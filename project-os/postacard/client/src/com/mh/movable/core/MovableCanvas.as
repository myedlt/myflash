package com.mh.movable.core
{
	import com.mh.movable.overlay.MovableOverlay;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.ScrollPolicy;

	public class MovableCanvas extends Canvas
	{
		
		import com.mh.movable.constants.OverlayHandles;
		import com.mh.movable.event.MovableEvent;
		import com.mh.movable.constants.MovableCanvasStates;
	
		private var behaviourState:String = MovableCanvasStates.DEFAULT_STATE;
		
		
		private var previousMovePoint:Point;
		
		private var _selectedComponent:MovableComponent;
		
		private var mhOverlay:MovableOverlay = new MovableOverlay();		
		

		
		private var clipBoard:MovableComponent;
		
		
		
		/**
		 * 
		 */
		public function MovableCanvas()
		{			
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;


			mhOverlay.visible = false;
			mhOverlay.width = 0;
			mhOverlay.height = 0;
			super.addChild( mhOverlay );
			
			this.addEventListener( MovableEvent.SELECT_COMPONENT, selectComponentHandler );
			this.addEventListener( MovableEvent.MOVE_COMPONENT, moveComponentHandler );
			this.addEventListener( MovableEvent.RESIZE_COMPONENT, resizeComponentHandler );
			
			this.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			Application.application.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			Application.application.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		}
		
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild( child );
			
			if( child is MovableComponent )
				selectComponent( child as MovableComponent );
				
			return child;
		}
		
		
		/**
		 * This property holds the currently selected child of this canvas
		 */
		[Bindable]
		public function set selectedComponent( value:MovableComponent ):void
		{
			_selectedComponent = value;
			
			mhOverlay.target = value;
			mhOverlay.visible = (value != null);
			
			dispatchEvent( new Event("selectionChanged" ) );
		}
		public function get selectedComponent():MovableComponent
		{
			return _selectedComponent;
		}
		
		
		/**
		 * Convenience function to set the current behaviour state of this canvas
		 */
		private function setState( state:String ):void
		{
			trace( "State changed to", state );
			this.behaviourState = state;
		}
		
		
		/**
		 * Remove the selected child component
		 */
		public function remove():void
		{
			if( !selectedComponent )
				return;
			
			this.removeChild( selectedComponent );
			deselectComponent();
		}
		
		
		[Bindable(event="selectionChanged")]
		public function get canCopy():Boolean
		{
			return ( selectedComponent != null );
		}
		
		[Bindable(event="clipboardChanged")]
		public function get canPaste():Boolean
		{
			return ( clipBoard != null );
		}
		
		public function cut():void
		{
			if( !selectedComponent )
				return;
				
			clipBoard = selectedComponent;
			this.removeChild( selectedComponent );
			deselectComponent();
			dispatchEvent( new Event("clipboardChanged" ) );
		}
		
		public function copy():void
		{
			if( !selectedComponent )
				return;
				
			clipBoard = selectedComponent;
			dispatchEvent( new Event("clipboardChanged" ) );
		}
		
		public function paste():void
		{
			if( !clipBoard )
				return;
			
			this.addChild( clipBoard.clone() as MovableComponent );			
		}
		
		
		
		/**
		 * 
		 */
		[Bindable(event="childOrderChanged")]
		public function get canMoveBack():Boolean
		{
			return ( selectedComponent && this.getChildIndex( selectedComponent )>0 );
		}
		
		[Bindable(event="childOrderChanged")]
		public function get canMoveForward():Boolean
		{
			return ( selectedComponent && this.getChildIndex( selectedComponent )<(numChildren-2));
		}
		
		/**
		 * Move the selected component to be behind all other child components
		 */
		public function moveToBack():void
		{
			if( !selectedComponent )
				return;
			
			bringOverlayToFront();
			
			this.removeChild( selectedComponent );
			this.addChildAt( selectedComponent, 0 );
			
			dispatchEvent( new Event("childOrderChanged" ) );
		}
		
		
		/**
		 * Move the selected component back one place in the child order
		 */
		public function moveBackward():void
		{
			if( !selectedComponent )
				return;
			
			var index:Number = this.getChildIndex( selectedComponent );
			
			if( index > 0 )
			{
				this.removeChildAt( index );
				this.addChildAt( selectedComponent, index-1 );	
			}
			dispatchEvent( new Event("childOrderChanged" ) );
		}
		
		
		/**
		 * Move the selected component to be in front of all other child components
		 */
		public function bringToFront():void
		{
			if( !selectedComponent )
				return;
				
			this.removeChild( selectedComponent );
			this.addChild( selectedComponent );
			
			bringOverlayToFront();
			dispatchEvent( new Event("childOrderChanged" ) );
		}
		
		
		/**
		 * Move the selected component forward one place in the child order
		 */
		public function bringForward():void
		{
			if( !selectedComponent )
				return;
			
			var index:Number = this.getChildIndex( selectedComponent );
			
			if( index < numChildren-2 )
			{
				this.removeChildAt( index );
				this.addChildAt( selectedComponent, index+1 );
			}
			dispatchEvent( new Event("childOrderChanged" ) );
		}
		
		
		/**
		 *
		 */
		private function moveComponentHandler( event:MovableEvent ):void
		{
			setState( MovableCanvasStates.MOVING );
		}


		/**
		 *
		 */
		private function selectComponentHandler( event:MovableEvent ):void
		{
			if( selectedComponent != event.target )
			{
				selectComponent( event.target as MovableComponent );
			}
		}


		/**
		 *
		 */
		private function resizeComponentHandler( event:MovableEvent ):void
		{
			switch( event.handle )
			{
				case OverlayHandles.TOP_LEFT:
					setState( MovableCanvasStates.RESIZING_TOP_LEFT );
					break;
				case OverlayHandles.TOP:
					setState( MovableCanvasStates.RESIZING_TOP );
					break;
				case OverlayHandles.TOP_RIGHT:
					setState( MovableCanvasStates.RESIZING_TOP_RIGHT );
					break;
				case OverlayHandles.LEFT:
					setState( MovableCanvasStates.RESIZING_LEFT );
					break;
				case OverlayHandles.RIGHT:
					setState( MovableCanvasStates.RESIZING_RIGHT );
					break;
				case OverlayHandles.BOTTOM_LEFT:
					setState( MovableCanvasStates.RESIZING_BOTTOM_LEFT );
					break;
				case OverlayHandles.BOTTOM:
					setState( MovableCanvasStates.RESIZING_BOTTOM );
					break;
				case OverlayHandles.BOTTOM_RIGHT:
					setState( MovableCanvasStates.RESIZING_BOTTOM_RIGHT );
					break;
			}
		}
		
		
		/**
		 * 
		 */
		private function mouseDownHandler( event:MouseEvent ):void
		{
			this.behaviourState = MovableCanvasStates.DEFAULT_STATE;
			
			deselectComponent();
							
			previousMovePoint = new Point( event.stageX, event.stageY );
		}
		
		
		/**
		 * 
		 */
		private function mouseMoveHandler( event:MouseEvent ):void
		{
			var currentPoint:Point = new Point( event.stageX, event.stageY );
			 
			switch( behaviourState )
			{
				case MovableCanvasStates.RESIZING_TOP_LEFT:
					selectedComponent.resizeTopLeft( currentPoint.x - previousMovePoint.x, currentPoint.y - previousMovePoint.y );
					break;
				case MovableCanvasStates.RESIZING_TOP:
					selectedComponent.resizeTop( currentPoint.y - previousMovePoint.y );
					break;
				case MovableCanvasStates.RESIZING_TOP_RIGHT:
					selectedComponent.resizeTopRight( currentPoint.x - previousMovePoint.x, currentPoint.y - previousMovePoint.y );
					break;
				case MovableCanvasStates.RESIZING_LEFT:
					selectedComponent.resizeLeft( currentPoint.x - previousMovePoint.x );
					break;
				case MovableCanvasStates.RESIZING_RIGHT:
					selectedComponent.resizeRight( currentPoint.x - previousMovePoint.x );
					break;
				case MovableCanvasStates.RESIZING_BOTTOM_LEFT:
					selectedComponent.resizeBottomLeft( currentPoint.x - previousMovePoint.x, currentPoint.y - previousMovePoint.y );
					break;
				case MovableCanvasStates.RESIZING_BOTTOM:
					selectedComponent.resizeBottom( currentPoint.y - previousMovePoint.y );
					break;
				case MovableCanvasStates.RESIZING_BOTTOM_RIGHT:
					selectedComponent.resizeBottomRight( currentPoint.x - previousMovePoint.x, currentPoint.y - previousMovePoint.y );
					break;
				case MovableCanvasStates.MOVING:
					selectedComponent.moveCenter( currentPoint.x - previousMovePoint.x, currentPoint.y - previousMovePoint.y );
					break;
			}
			
			previousMovePoint = currentPoint;
			 
		}
		
		
		
		private function mouseUpHandler( event:MouseEvent ):void
		{
			setState( MovableCanvasStates.DEFAULT_STATE );
		}
		
				
		/**
		 * 
		 */
		public function selectComponent( component:MovableComponent ):void
		{
			this.selectedComponent = component;
			
			bringOverlayToFront();
			
			dispatchEvent( new Event("childOrderChanged" ) );
			
		}
		
		
		/**
		 *
		 */
		public function deselectComponent():void
		{
			this.selectedComponent = null;
			
			dispatchEvent( new Event("childOrderChanged" ) );
		}
			
		
		/**
		 * 
		 */
		private function bringOverlayToFront():void
		{
			this.removeChild( mhOverlay );
			this.addChild( mhOverlay );
			
			dispatchEvent( new Event("childOrderChanged" ) );
		}
	}
}