package com.san.styling.interfaces
{
	public interface IFillable
	{
	
		function set fill( value:String ):void;
		function get fill():String;
		
		function get fColor1():uint;
		function get fAlpha1():Number;
		function get fColor2():uint;
		function get fAlpha2():Number;
		function get fAngle():Number;
		
		function set fColor1(v:uint):void;
		function set fAlpha1(v:Number):void;
		function set fColor2(v:uint):void;
		function set fAlpha2(v:Number):void;
		function set fAngle(v:Number):void;

	}
}