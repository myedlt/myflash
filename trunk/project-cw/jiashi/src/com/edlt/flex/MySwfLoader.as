package com.edlt.flex
{
 import flash.display.MovieClip;
 
 public class MySwfLoader extends CtmObjLoader
 {
  public function MySwfLoader(UrlRequest:String=null, progressHandle:Function=null, bShow:Boolean=true)
  {
   
   super(UrlRequest, progressHandle, bShow);
  }
  public function get movieClip():MovieClip{
   if(!_bLoaded)return null
   return content as MovieClip;
  }
  
 }
}