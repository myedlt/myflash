//read flas file:///S|/小語電子課本/42/20070115/ebook421/addon/,S:\小語電子課本\42\20070115\ebook421\addon
//folders=prompt("需要輸出的文件夾？\n(多個用\",\"分隔)",folders);
var tempDoc=undefined;
if(fl.documents.length==0){
	//xmlPanel need a document, if there is none, create a temp document
	tempDoc=fl.createDocument();
}
xui = fl.getDocumentDOM().xmlPanel(fl.configURI + "Commands/AutoPublishUI.xml");
if(tempDoc){
	//close temp document
	fl.closeDocument(tempDoc);
}
if(xui.dismiss=="accept"){
	var searchSubDir=xui.searchSubDir;
	var onlyUnpublished=xui.onlyUnpublished;
	var folders=xui.paths.split("\r").join("").split("\n").join("");
	var writeFile=xui.writeToFile;
	fl.trace(writeFile);
	folders=folders.split(",");
	//fl.trace(folders);
	for(var i=0;i<folders.length;i++){
		if(folders[i].substr(0,8)!="file:///"){
			folders[i]="file:///"+folders[i].split(":").join("|").split("\\").join("/");
			//fl.trace("format:"+folders[i]);
		}
		if(folders[i].substr(folders[i].length-1,1)!="/"){
			folders[i]=folders[i]+"/";
		}
	}
	exportlist=new Array();
	//fl.trace(folders);
	for(var j=0;j<folders.length;j++){
		checkFolder(folders[j],exportlist,searchSubDir,onlyUnpublished);
	}
	var totaltime=0;
	if(exportlist.length==0){
		alert("No file need to publish.");
	}else{
		//fl.trace(exportlist.join("\n"));
		fl.trace(writeFile);
		if(writeFile=="true"){
			var d=new Date();
			var script="//publish script created at "+d+"\n";
			script+="function formatTime(num){\n";
			script+="	var h=Math.floor(num/3600000);\n";
			script+="	num=num%3600000;\n";
			script+="	var m=Math.floor(num/60000);\n";
			script+="	if(m<10){\n";
			script+="		m=\"0\"+m;\n";
			script+="	}\n";
			script+="	num=num%60000;\n";
			script+="	var s=Math.floor(num/1000);\n";
			script+="	if(s<10){\n";
			script+="		s=\"0\"+s;\n";
			script+="	}\n";
			script+="	num=num%1000;\n";
			script+="	return h+\":\"+m+\":\"+s+\".\"+num;\n";
			script+="}\n";
			script+="function exportswf(id,total,flapath,swfpath){\n";
			script+="	fl.trace(\"[\"+id+\"/\"+total+\"] \"+flapath.substr(flapath.lastIndexOf(\"/\")+1)+\"\t@ \"+flapath.substr(0,flapath.lastIndexOf(\"/\")));\n";
			script+="	var stime=new Date().getTime();\n";
			script+="	var fla=fl.openDocument(flapath,true);\n";
			script+="	if(swfpath==undefined){\n";
			script+="		swfpath=flapath.substr(0,flapath.lastIndexOf(\".\"))+\".swf\";\n";
			script+="	}\n";
			script+="	fla.exportSWF(swfpath,true);\n";
			script+="	fla.close(false);\n";
			script+="	var etime=new Date().getTime();\n";
			script+="	fl.trace(\"Completed in \"+formatTime(etime-stime));\n";
			script+="	return etime-stime;\n";
			script+="}\n";
			script+="var totaltime=0;\n";
			script+="fl.trace(\"Start publishing...\");\n";
			for(var i=0;i<exportlist.length;i++){
				script+="totaltime+=exportswf("+(i+1)+","+exportlist.length+",\""+exportlist[i]+"\");\n";
			}
			script+="fl.trace(\"All done. Total time:\"+formatTime(totaltime));\n";
			var scriptfilename=folders[0]+"publish_script "+d.getFullYear()+"-"+d.getMonth()+"-"+d.getDate()+" "+d.getHours()+"-"+d.getMinutes()+"-"+d.getSeconds()+".jsfl";
			fl.trace("Script saved to:"+scriptfilename);
			//fl.trace(script);
			FLfile.write(scriptfilename,script);
		}else{
			if(prompt(exportlist.length+" files need to publish. Type OK to proceed.","OK")=="OK"){
				fl.trace("Start publishing...");
				for(var i=0;i<exportlist.length;i++){
					fl.trace("["+(i+1)+"/"+exportlist.length+"] "+exportlist[i].substr(exportlist[i].lastIndexOf("/")+1)+"\t@ "+exportlist[i].substr(0,exportlist[i].lastIndexOf("/"))+"");
					var t=exportswf(exportlist[i]);
					fl.trace("Completed in "+formatTime(t));
					totaltime+=t;
				}
				fl.trace("All done. Total time:"+formatTime(totaltime));
			}
		}
	}
}
function formatTime(num){
	var h=Math.floor(num/3600000);
	num=num%3600000;
	var m=Math.floor(num/60000);
	if(m<10){
		m="0"+m;
	}
	num=num%60000;
	var s=Math.floor(num/1000);
	if(s<10){
		s="0"+s;
	}
	num=num%1000;
	//if(h>0){
		return h+":"+m+":"+s+"."+num;
	//}else if(m>0){
	//	return m+":"+s+"."+num;
	//}else{
	//	return s+"."+num+"s";
	//}
}
function exportswf(flapath,swfpath){
	//return 0;
	var stime=new Date().getTime();
	var fla=fl.openDocument(flapath,true);
	if(swfpath==undefined){
		swfpath=flapath.substr(0,flapath.lastIndexOf("."))+".swf";
	}
	fla.exportSWF(swfpath,true);
	fla.close(false);
	var etime=new Date().getTime();
	return etime-stime;
}
function checkFolder(folder,list,checkSub,checkSwf,pre){
	if(pre==undefined){
		pre="";
	}
	//fl.trace(pre+folder+":"+checkSub+" "+checkSwf);
	var flas=FLfile.listFolder(folder+"*.fla","files");
	for(var i=0;i<flas.length;i++){
		//fl.trace(pre+" "+flas[i]);
		if(checkSwf=="true"){
			var flatime=Number("0x"+FLfile.getModificationDate(folder+flas[i]));
			var swfname=flas[i].substr(0,flas[i].lastIndexOf("."))+".swf";
			var swftime=Number("0x"+FLfile.getModificationDate(folder+swfname));
			//fl.trace(swfname+" "+flatime+" vs "+swftime);
			if(swftime<(flatime-100)){
				list.push(folder+flas[i]);
				fl.trace(pre+flas[i]);
			}
		}else{
			list.push(folder+flas[i]);
			fl.trace(pre+flas[i]);
		}
	}
	if(checkSub=="true"){
		var flds=FLfile.listFolder(folder,"directories");
		for(var i=0;i<flds.length;i++){
			//fl.trace(pre+i+" "+flds[i]+" of "+flds.length);
			checkFolder(folder+flds[i]+"/",list,checkSub,checkSwf,pre+" ");
			//fl.trace(pre+i);
		}
	}
}