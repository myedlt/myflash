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
package 
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import com.kingnare.utils.Filters;
	import com.kingnare.containers.SectorMenu;
	import com.hires.utils.Stats;

	public class PieMenu extends Sprite
	{
		private var tmpArray:Array = [{id:"menu1", label:"Open", backgroundColor:0x008EE6, borderColor:0x008EE6, alpha:0.7},
		  							  {id:"menu2", label:"Delete", backgroundColor:0x00AA00, borderColor:0x008EE6, alpha:0.7},
		  							  {id:"menu3", label:"Move", backgroundColor:0xE59702, borderColor:0x008EE6, alpha:0.7},
		  							  {id:"menu4", label:"Save", backgroundColor:0xD60102, borderColor:0x008EE6, alpha:0.7},
									  {id:"menu5", label:"Modify", backgroundColor:0xFF00FF, borderColor:0x008EE6, alpha:0.7}];
		
		private var stats:Stats;
		private var switchBool:Boolean = false;
		private var menu:SectorMenu;

		public function PieMenu()
		{
			stats = new Stats();
			stats.x = 10;
			stats.y = 10;
			addChild(stats);
			menu_btn.addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onClick(event:MouseEvent)
		{
			switchBool = !switchBool;
			if (switchBool)
			{
				menu = new SectorMenu(34, 100);
				menu.list = tmpArray;
				menu.total = 360;
				menu.start = 0;
				menu.createMenu();
				menu.x = 250;
				menu.y = 200;
				addChild(menu);
				menu.getChildById("menu1").addEventListener(MouseEvent.CLICK, cellClick);
				menu.getChildById("menu2").addEventListener(MouseEvent.CLICK, cellClick);
				menu.getChildById("menu3").addEventListener(MouseEvent.CLICK, cellClick);
				menu.getChildById("menu4").addEventListener(MouseEvent.CLICK, cellClick);
				menu.getChildById("menu5").addEventListener(MouseEvent.CLICK, cellClick);
			}
			else
			{
				menu.removeMenuList();
			}
		}

		private function cellClick(event:MouseEvent):void
		{
			switchBool = !switchBool;
			trace("click:"+event.target.name);
		}
	}
}