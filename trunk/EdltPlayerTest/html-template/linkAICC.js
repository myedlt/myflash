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
// 请求
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
