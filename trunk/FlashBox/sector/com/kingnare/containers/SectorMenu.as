/*
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
Contact: auzn1982@gmail.com
*/
package com.kingnare.containers
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.kingnare.events.FlashDynamicEvent;
	import com.kingnare.utils.Filters;

	public class SectorMenu extends Sprite
	{
		public static const OPENING:String = "opening";
		public static const OPENED:String = "opened";
		public static const CLOSING:String = "closing";
		public static const CLOSED:String = "closed";
		
		private var _menu:Sprite;
		private var _arrayList:Array = [];
		private var _arrayListItem:Array = [];
		private var _totalAngle:Number = 360;
		private var _startAngle:Number = 0;
		private var _x:Number=0;
		private var _y:Number=0;
		private var _r:Number=0;
		private var _R:Number=10;
		private var _status:String;

		//
		public function SectorMenu(r:Number, R:Number):void
		{
			trace("SectorMenu Init...");
			_x = 0;
			_y = 0;
			_r = r;
			_R = R;
			_status = SectorMenu.CLOSED;
			_menu = new Sprite();
			_menu.filters = [Filters.getBevelFilter(), Filters.getDropShadowFilter()];
		}
		
		public function createMenu():void
		{
			createMenuList(_menu);
			addChild(_menu);
		}
		
		private function createMenuList(_menu:Sprite):void
		{
			_status = SectorMenu.OPENING;
			var tmpArray:Array = _arrayList;
			for (var i:uint = 0; i<tmpArray.length; i++)
			{
				var tmpCell:SectorCreator = create(tmpArray[i]);
				tmpCell.start = _startAngle;
				tmpCell.createTweenAfter(i*50, _startAngle-_totalAngle/tmpArray.length*(i+1), 0.8-i*0.05, _totalAngle/tmpArray.length);
				tmpCell.addEventListener("cellRemoved", cellRemovedHandler);
				tmpCell.addEventListener("created", cellCreatedHandler);
				tmpCell.addEventListener(MouseEvent.CLICK, cellClickHandler);
				_menu.addChild(tmpCell);
			}
		}
		
		private function create(cellData:Object):SectorCreator
		{
			var cell:SectorCreator = new SectorCreator(_x, _y, _r, _R, 0, 0);
			cell.fillColor = cellData.backgroundColor;
			cell.lineColor = cellData.borderColor;
			cell.fillAlpha = cellData.alpha;
			cell.label = cellData.label;
			cell.name = cellData.id;
			return cell;
		}
		public function removeMenuList():void
		{
			_status = SectorMenu.CLOSING;
			var _len:uint = _arrayListItem.length;
			for (var i:uint=0; i<_len; i++)
			{
				var tmpCell:SectorCreator = _arrayListItem[i] as SectorCreator;
				var tmpDelta:Number = tmpCell.angle;
				var tmpStart:Number = tmpCell.start;
				tmpCell.removeTweenAfter(i*50, _startAngle, 0.6, _totalAngle/_arrayListItem.length);
			}
		}
		
		private function cellRemovedHandler(event:FlashDynamicEvent):void
		{
			var cell:SectorCreator = event.target as SectorCreator;
			if (cell)
			{
				cell.removeEventListener("cellRemoved", cellRemovedHandler);
				_menu.removeChild(cell);
				_arrayListItem.pop();
			}
			if (_arrayListItem.length == 0)
			{
				if(_menu && this.contains(_menu))
				{
					removeChild(_menu);
				}
				
				_status = SectorMenu.CLOSED;
				this.dispatchEvent(new FlashDynamicEvent("menuRemoved"));
			}
		}
		
		private function cellCreatedHandler(event:FlashDynamicEvent):void
		{
			var cell:SectorCreator = event.target as SectorCreator;
			if (cell)
			{
				_arrayListItem.push(cell);
			}
			if(_arrayList.length == _arrayListItem.length)
			{
				_status = SectorMenu.OPENED;
			}
		}
		
		private function cellClickHandler(event:MouseEvent):void
		{
			dispatchEvent(event);
			this.removeMenuList();
		}
		
		public function getChildById(id:String):SectorCreator
		{
			return _menu.getChildByName(id) as SectorCreator;
		}
		
		public function set list(array:Array):void
		{
			_arrayList = array;
		}
		
		public function get list():Array
		{
			return _arrayList;
		}
		
		public function set total(angle:Number):void
		{
			_totalAngle = angle;
		}
		
		public function get total():Number
		{
			return _totalAngle;
		}
		
		public function set start(angle:Number):void
		{
			_startAngle = angle;
		}
		
		public function get show():Boolean
		{
			return _status == SectorMenu.OPENED;
		}
	}
}