package com.mh.preloader
{
	//============================================================
	// LinkButton Class
	// Copyright 2005,2006 - MobiMarketing/Interspot
	//============================================================
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	public class PreloadLinkButton extends SimpleButton {
		
	    public var selected:Boolean = false;
	    public var rect:Rectangle;
	    public var url:String;
	    public var text:String;
	    public var format:TextFormat;
	    public var overColor:uint;		
		public var downColor:uint;
		
		private var _textFieldUp:TextField;
		private var _textFieldOver:TextField;
		private var _textFieldDown:TextField;
			    
	    //--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
	    public function PreloadLinkButton(rect:Rectangle, url:String, text:String, format:TextFormat, overColor:uint, downColor:uint)
	    { 
	        this.rect = rect;
	        this.url = url;
	        this.text = text;
	        this.format = format;
	        this.overColor = overColor;
	        this.downColor = downColor;	        
	        this.useHandCursor = true;
	        
	        _textFieldUp = new TextField();	        
			_textFieldUp.width = rect.width;
			_textFieldUp.height = rect.height;						
			_textFieldUp.selectable = false;
			_textFieldUp.defaultTextFormat = format;
			_textFieldUp.text = this.text;
			
			_textFieldOver = new TextField();		
			_textFieldOver.width = rect.width;
			_textFieldOver.height = rect.height;						
			_textFieldOver.selectable = false;
			_textFieldOver.defaultTextFormat = format;
			_textFieldOver.text = this.text;
			
			_textFieldDown = new TextField();			
			_textFieldDown.width = rect.width;
			_textFieldDown.height = rect.height;						
			_textFieldDown.selectable = false;
			_textFieldDown.defaultTextFormat = format;
			_textFieldDown.text = this.text;
			
			var upSprite:Sprite = new Sprite();			
			upSprite.addChild(_textFieldUp);
			 
			var overSprite:Sprite = new Sprite();			 
			overSprite.graphics.beginFill(overColor);
			overSprite.graphics.drawRoundRect(0, 0, rect.width, rect.height,8,8);
			overSprite.graphics.endFill();
			overSprite.addChild(_textFieldOver);
			 
			var downSprite:Sprite = new Sprite();			 
			downSprite.graphics.beginFill(downColor);
			downSprite.graphics.drawRoundRect(0, 0, rect.width, rect.height,8,8);
			overSprite.graphics.endFill();
			downSprite.addChild(_textFieldDown);
									
			this.upState = upSprite;
	        this.downState = downSprite;
	        this.hitTestState = overSprite;
	        this.overState = overSprite;
	        
	        addEventListener(MouseEvent.CLICK, buttonClicked);
	    }
	    
	    public function buttonClicked(e:Event):void
	    {	       
			navigateToURL(new URLRequest(url));		
	    }
	}
}




