/************MyButton.as**************/
package{
import flash.display.*;
import flash.events.*;
import flash.system.ApplicationDomain;
import fl.core.UIComponent;

public class MeButton extends UIComponent{
　private var nowSkin:MovieClip;
　private var thisDomain:ApplicationDomain;
　public function MeButton()
	{
　		super();
　	trace("MyButton");
　}

　override protected function draw():void{
　if(nowSkin==null){
　　thisDomain=loaderInfo.applicationDomain;
　　var classDef;
　　try{
　　classDef=thisDomain.getDefinition(getNormalSkinName());}
　　catch(e:ReferenceError){
　　trace("没有在库中找到相关的类!")
　　return;
　　}
　　nowSkin=new classDef as MovieClip;
　　nowSkin.addEventListener(MouseEvent.MOUSE_OVER，mouseOverHandler);
　　addChild(nowSkin);
　}
　nowSkin.width=width;
　nowSkin.height=height;
　}
　protected function mouseOverHandler(e:MouseEvent):void{
　trace("over");
　removeChild(nowSkin);
　var classDef=thisDomain.getDefinition(getOverSkinName());
　nowSkin=new classDef as MovieClip;
　addChild(nowSkin);
　nowSkin.addEventListener(MouseEvent.MOUSE_OUT，mouseOutHandler);
　draw();
　}
　protected function mouseOutHandler(e:MouseEvent):void{
　trace("out");
　removeChild(nowSkin);
　var classDef=thisDomain.getDefinition(getNormalSkinName());
　nowSkin=new classDef as MovieClip;
　addChild(nowSkin);
　nowSkin.addEventListener(MouseEvent.MOUSE_OVER，mouseOverHandler);
　draw();
　}
　protected function getNormalSkinName():String{
　	return"NormalSkin";
　}
　protected function getOverSkinName():String{
　	return"OverSkin";
　}
}
}