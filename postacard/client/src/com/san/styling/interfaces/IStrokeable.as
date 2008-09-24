package com.san.styling.interfaces
{
	
	public interface IStrokeable
	{
		
		function set stroke( value:String ):void;
		function get stroke():String;
		
		function get sWeight():Number;
		function get sColor1():uint;
		function get sAlpha1():Number;
		function get sColor2():uint;
		function get sAlpha2():Number;
		function get sAngle():Number;
		
		function set sWeight(v:Number):void;
		function set sColor1(v:uint):void;
		function set sAlpha1(v:Number):void;
		function set sColor2(v:uint):void;
		function set sAlpha2(v:Number):void;
		function set sAngle(v:Number):void;
		
	}
}