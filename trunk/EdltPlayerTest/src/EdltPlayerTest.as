import communication.AiccCommunication;
import communication.IAiccCommunication;
import communication.LSOCommunication;
import events.PathEvent;
import mx.collections.XMLListCollection;
import mx.rpc.events.ResultEvent;

// aicc数据
public var dataCourse:String="";

// 片头路径
[Bindable]
private var introPath:String="";

// xml数据
private var menuXML:XML=null;

private var xmlList:XMLList;

[Bindable]
private var xmlDataCollection:XMLListCollection=new XMLListCollection();

[Bindable]
private var path:String="";
// 当前播放节目的序号
private var currentPlayId:String;
// 用于为课程菜单提供数据的集合

////////////////////////////////
// 程序运行环境环境
private var isHttp:Boolean;
////////////////////////////////

// 与外部进行通信的接口
private var comm:IAiccCommunication;

// 初始化
private function initApp():void
{
	// 差别应用环境是不是HTTP
	isHttp=(this.url.substr(0, 4).toUpperCase() == "HTTP") ? true : false;
	if (isHttp)
	{
		comm=new LSOCommunication();
	}
	else
	{
		comm=new AiccCommunication(dataCourse); // todo
	}
}

// 程序的初始工作
private function appCompHandler():void
{
	// 开放外部调用
	ExternalInterface.addCallback("goHome", goHomeCallback);
	httpSvr.send();
}

// 定义将来由js调用的
// 对状态进行保存的
// 函数
private function goHomeCallback():void
{
//	if (wasSuccessful) {	// 感觉这是一句废话，这个函数的执行不就说明调用成功了吗？
//		runSend();
//	} else {
//		getURL("javascript:alert('最后一次的状态没有上传！')");	// 调用js输出一个文本提示框
//	}
}

// HTTPService结果处理
// 对原始的数据进行若干处理
private function httpResultHandler(event:ResultEvent):void
{
	menuXML=new XML(event.result);
	// 取得片头路径
	introPath=menuXML.Header.@data.toString();
	// 状态更新
	xmlList=menuXML.module.lesson.part; // 取得课程列表数据
	for (var i:*in xmlList)
	{
		xmlList[i].@id=i;
	}
	// 
	comm.checkStatus(xmlList);
	xmlDataCollection.source=xmlList;
}

// 片头跳过处理
private function introSkipHand():void
{
	this.currentState="menu";
}

private function pathHandler(event:PathEvent):void
{
	this.path=event.path;
	this.currentPlayId=event.currentPlayId;
	this.currentState="main";
}

// 导航
// 状态保存
private function navigaterFn(flag:Boolean):void
{
	var tXml:XML
	if (flag)
	{
		tXml=xmlList[int(currentPlayId) - 1];
	}
	else
	{
		tXml=xmlList[int(currentPlayId) + 1];
	}
	var str:String=tXml.sco[0].@sub.toString();
	var i:int=str.indexOf(')') + 1;
	var path:String=str.substring(i);
	path="unit\\" + path + ".swf";
//	trace(this.path);
	// 状态保存
	comm.saveStatus(currentPlayId, "1");
	comm.checkStatus(xmlList);
	this.path=path;
	this.currentPlayId=tXml.@id.toString();
}
