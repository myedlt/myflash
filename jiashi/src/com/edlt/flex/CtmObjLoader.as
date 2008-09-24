package com.edlt.flex
{
{

 import flash.display.DisplayObject;
 import flash.display.Loader;
 import flash.events.*;
 import flash.net.URLRequest;
 
 import mx.core.UIComponent;

 public class CtmObjLoader extends UIComponent
 {
  private var ProgressHandle:Function=null;
  public var loader:Loader;
  public var _bLoaded:Boolean=false;
  public var _bShow:Boolean=true;
  //@UrlRequest  加载的地址
  //@progressHandle 加载中的处理过程
  //bShow  加载后是否显示出来  
  public function CtmObjLoader(UrlRequest:String=null,progressHandle:Function=null,bShow:Boolean=true)
  {
   super();
   if(UrlRequest)LoadThis(UrlRequest,progressHandle,bShow);
  }
  public function LoadThis(UrlRequest:String,progressHandle:Function=null,bShow:Boolean=true):void{
   RemoveChild();
            loader = new Loader();
            _bShow=bShow;
            ProgressHandle=progressHandle;
            configureListeners(loader.contentLoaderInfo);
            if(_bShow)addChild(loader);//如果需要显示，则addchild
            var request:URLRequest = new URLRequest(UrlRequest);
            loader.load(request);    
  }
  public function UnLoadThis():void{
   try{
    RemoveChild();
    this.parent.removeChild(this);
   }catch(e:Error){}
   //this=null;  
  }
  public function get content():DisplayObject{
   if(!_bLoaded)return null;
   return loader.content;
  }
  public function RemoveChild():void{
            if(_bLoaded){
             try{
              DeleteListeners(loader.contentLoaderInfo);
              loader.unload();
              if(_bShow)removeChild(loader);
              loader=null;
              _bLoaded=false;
             }catch(e:Error){throw new Error('Define ObjLoader Remove Error')}
            }  
  }
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            if(ProgressHandle!=null)dispatcher.addEventListener(ProgressEvent.PROGRESS, ProgressHandle);
                 
        }
        private function DeleteListeners(dispatcher:IEventDispatcher):void {
            if(dispatcher.hasEventListener(Event.COMPLETE))dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            if(dispatcher.hasEventListener(HTTPStatusEvent.HTTP_STATUS))dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            if(dispatcher.hasEventListener(IOErrorEvent.IO_ERROR))dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            if(dispatcher.hasEventListener(ProgressEvent.PROGRESS))
             if(ProgressHandle!=null)dispatcher.removeEventListener(ProgressEvent.PROGRESS, ProgressHandle);         
        }
        private function completeHandler(event:Event):void {
         this.width=loader.content.width;
         this.height=loader.content.height;
         _bLoaded=true;         
         dispatchEvent(new Event(Event.COMPLETE));
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
         dispatchEvent(new Event(HTTPStatusEvent.HTTP_STATUS));
        }
        private function ioErrorHandler(event:IOErrorEvent):void {
   dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
        }
 
 }
}
}