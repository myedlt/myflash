var aicc_url;					// 该值在doTrunOn()中被赋值
var aicc_sid;					// 
var aicc_version = "2.2";		// 

// 
// 涉及到的函数外部的变量
// aicc_url
// aicc_version
// 
function doSetAicc(aicc_data) {
	if(aicc_url!=0){
		var aicc_form = "<form name='command' action='"+aicc_url+"' method='POST'>";
		aicc_form += "<input type='hidden' name='command' value='putparam'>";
		aicc_form += "<input type='hidden' name='session_id' value='"+aicc_sid+"'>";
		aicc_form += "<input type='hidden' name='version' value='"+aicc_version+"'>";
		aicc_form += "<input type='hidden' name='aicc_data' value='"+aicc_data+"'></form>";
		aicc_comm.document.write(aicc_form);
		aicc_comm.document.command.submit();
	}
}

var aicc_inter;
// 
// getparam
function doGetAicc() {
	// 构建表单字符串
	var aicc_form = "<form name='command' action='"+aicc_url+"' method='POST'>";
	aicc_form += "<input type='hidden' name='command' value='getparam'>";
	aicc_form += "<input type='hidden' name='session_id' value='"+aicc_sid+"'>";
	aicc_form += "<input type='hidden' name='version' value='"+aicc_version+"'>";
	aicc_form += "<input type='hidden' name='aicc_data' value=''></form>";
	// 表单输出
	aicc_comm.document.write(aicc_form);
	aicc_comm.document.command.submit();				// 将名为command的表单提交
	aicc_inter = setInterval("doGetInter()", 200);		// ?
}

function doGetInter() {
	if (aicc_comm.document.readyState == "complete") {			// 当接收返回数据完成时
		clearInterval(aicc_inter);
		window.document.EdltPlayerTest.SetVariable("dataCourse",aicc_comm.document.body.innerText);
	}
}
var numTry = 0;
var isoff = false;
//
// 发送“ExitAU”Aicc指令
//
function doTurnoff() {
	if(aicc_url!=0){
		if(!isoff){
			isoff = true;
			var aicc_form = "<form action='"+aicc_url+"' method='POST' name='command'>";
			aicc_form += "<input type='hidden' name='command' value='ExitAU'>";
			aicc_form += "<input type='hidden' name='session_id' value='"+aicc_sid+"'>";
			aicc_form += "<input type='hidden' name='version' value='"+aicc_version+"'>";
			aicc_form += "<input type='hidden' name='aicc_data' value=''></form>";
			aicc_comm.document.write(aicc_form);
			aicc_comm.document.command.submit();
		}
	}
}

var ison = false;
// 
function doTurnon() {
	if(!ison){
		ison = true;
		if (runURL(window)) {
			doGetAicc();
		}
	}
}

// 
// 对一系列window对象的url地址执行runFind()
function runURL(win) {
	if (runFind(win.document.location+"") == false) {
		numTry++;
		if (numTry>10) {
			return false;
		}
		if (win.opener != null) {
			if (win == window.top) {
				return (runURL(win.opener));
			}
		}
		return (runURL(win.parent));
	}
	return true;
}

// 
function runFind(url) {
	aicc_url = unescape(runSeekStr(url, "aicc_url=", "&"));			// 截取aicc_url=和&之间的字符并解码
	aicc_sid = unescape(runSeekStr(url, "aicc_sid=", "&"));
	if (aicc_url == 0 || aicc_sid == 0) {
		return false;
	} else {
		if (aicc_url.toLowerCase().indexOf("http://") == -1) {
			aicc_url = "http://"+aicc_url;
		}
		return true;
	}
}

// 字符串处理
// 从str中截取从form到to之间的字符
function runSeekStr(str, from, to) {
	var mystr = str;
	var newstr = 0;
	var str = str.toLowerCase();
	var from = from.toLowerCase();
	var to = to.toLowerCase();
	if (!(str.indexOf(from)+1)) {
		return newstr;
	}
	var fromhere = str.indexOf(from)+from.length;
	var tostr = str.substr(fromhere, str.length-fromhere);
	mystr = mystr.substr(fromhere, str.length-fromhere);
	var tothere = tostr.length;
	if (to != "" && (tostr.indexOf(to)+1)) {
		tothere = tostr.indexOf(to);
	}
	newstr = mystr.substr(0, tothere);
	if (!newstr.length) {
		newstr = 0;
	}
	return newstr;
}



