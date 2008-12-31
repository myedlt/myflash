package com.san.components
{
	import mx.controls.TileList;
	import mx.controls.listClasses.IListItemRenderer;
	
	public class EasyTileList extends TileList
	{
		
		protected override function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean=true):Boolean
		{
			return super.selectItem( item, shiftKey, true, transition );
		}
	}
}