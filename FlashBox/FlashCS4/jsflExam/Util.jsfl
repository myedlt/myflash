var flaPath="";
var doc;
fl.getDocumentDOM().library.newFolder("Assets");
fl.getDocumentDOM().library.newFolder("BitMaps");
fl.getDocumentDOM().library.newFolder("movieClips");

if(true == true)
{
flash.outputPanel.clear();
// get the asset path
var assetPath = prompt("Enter asset path.","");
if(assetPath != null)
{
  // transform the window path format to what Flash can understand
  var idx = assetPath.indexOf(":");
  var path = assetPath.substring(0,idx)+"|"+assetPath.substring(idx+1,assetPath.length);
  var path_tokens = path.split("\\");
  var actual_path = "";
   
  // reconstruct the actual path
  for(var i=0; i<path_tokens.length; i++)
   actual_path += (path_tokens+"/");
   
  // the -1 remove the last "/" in path
  assetPath = "[url=file:///]file:///"+actual_path.substring(0,actual_path.length-1[/url]);
  
  
  var idx2 = flaPath.indexOf(":");
  var path2 = flaPath.substring(0,idx2)+"|"+flaPath.substring(idx2+1,flaPath.length);
  var path_tokens2 = path.split("\\");
  var actual_path2 = "";
   
  // reconstruct the actual path
  for(var i=0; i<path_tokens2.length; i++)
   actual_path2 += (path_tokens2+"/");
   
  // the -1 remove the last "/" in path
  flaPath = "[url=file:///]file:///"+actual_path2.substring(0,actual_path2.length-1[/url]);
  
  if(!FLfile.exists(assetPath))
  {
   alert("asset path doesn't exist.");
  }
  else
  {
   flash.trace("Asset path: "+assetPath);
   flash.trace("Asset path okay, construction starts...");
   var fileList = FLfile.listFolder(assetPath,"files");
   var folderList = FLfile.listFolder(assetPath,"directories");
   traverseFolders(assetPath,"Assets");
   folder();
   flash.trace("construction complete");
   alert("DONE.");
  }
}
}

function folder(){
fl.getDocumentDOM().library.selectAll();
var selItems = fl.getDocumentDOM().library.getSelectedItems();
for(var i=0;i<selItems.length;i++)
{
   flash.trace("*****************selltems[]="+selItems.name+selItems.itemType);
   fl.getDocumentDOM().library.selectNone();
   //fl.getDocumentDOM().library.selectItem(selItems);
   if(selItems.itemType=="movie clip")
   {
    flash.trace("*****************movieClips*********");
    flash.trace("*************************selItems="+selItems.name);
     selItems.linkageExportForAS = true;
     selItems.linkageExportInFirstFrame = true;
     selItems.linkageIdentifier = selItems.name;
     fl.getDocumentDOM().library.moveToFolder("movieClips",selItems.name);
   }
   if(selItems.itemType=="bitmap")
   {
     fl.getDocumentDOM().library.moveToFolder("BitMaps",selItems.name);
     flash.trace("__________________________________________");
   }
   
}
}






function traverseFolders(phyPath,logPath)
{
var folderList = FLfile.listFolder(phyPath,"directories");
var lastName = logPath.substring(logPath.lastIndexOf("/")+1,logPath.length);
if(folderList.length != 0)
{

  for(var i=0; i<folderList.length; i++)
  {
   traverseFolders(phyPath+"/"+folderList,logPath+"/"+folderList);
  }
}
var fileList = FLfile.listFolder(phyPath+"/*.png","files");
if(fileList.length > 0)
{
  var mcName = lastName.toLowerCase();
  var prevName = "";
  var newFrameNeeded = false;

  for(var z in fileList)
  {
   var currentName = truncPostfixNumber(truncExtension(fileList[z]));
   if(currentName != prevName)
   {
    prevName = currentName;
    lib=fl.getDocumentDOM().library;
    newFrameNeeded = false;
    //fl.getDocumentDOM().library.addNewItem('movie clip',currentName);
    fl.getDocumentDOM().library.addNewItem('movie clip',currentName);
    //lib.setItemProperty('linkageExportForAS', true);
    //fl.getDocumentDOM().library.currentName.linkageIdentifier=currentName+"_mc";
    //fl.getDocumentDOM().library.selectNone();
    //fl.getDocumentDOM().library.items[4].linkageExportForAS = true;
    //currentName.linkageExportForAS = true;
    //currentName.linkageIdentifier=currentName+"_mc";
  
    //flash.trace("&&&&&&&&&&&&&&&&&&&Item====="+fl.getDocumentDOM().library.items);
   

   
    fl.getDocumentDOM().library.selectNone();
    fl.getDocumentDOM().library.editItem(currentName);
   }
   //fl.getDocumentDOM().library.moveToFolder("Assets", currentName, true);
   var dom = fl.getDocumentDOM(); ///////////导入图片
   dom.importFile(phyPath+"/"+fileList[z],true);
   
   fl.getDocumentDOM().library.selectNone();
   fl.getDocumentDOM().library.editItem(currentName);
   //flash.trace("***************************currentName.currentFrame="+currentName.currentFrame);
   
   //flash.trace("&%%%%%%%%%%%%%%%%%%%fileList[z]"+fileList[z]+"%%%%%%%%%%%%%%%%%%%%%%%%%%%");
   fl.getDocumentDOM().library.addItemToDocument({x:0, y:0},fileList[z]);
   //fl.getDocumentDOM().getTimeline().setSelectedFrames([z]);
   fl.getDocumentDOM().align('top', true);
   fl.getDocumentDOM().distribute('left edge', true);
   fl.getDocumentDOM().getTimeline().insertBlankKeyframe();
   
   flash.trace("Handling "+fileList[z]+"/"+currentName+" Prev:"+prevName);
   newFrameNeeded = true;
   fl.getDocumentDOM().library.editItem();
  }
}
fl.getDocumentDOM().library.editItem(currentName);
fl.getDocumentDOM().getTimeline().removeFrames(fileList.length);
//if()
flash.trace("***********currentName="+currentName);
/*if(currentName!=undefined)
{
  fl.getDocumentDOM().library.selectAll();
  var selItems = fl.getDocumentDOM().library.getSelectedItems();
  flash.trace("*****************selltems="+selItems);
  flash.trace("******************selltems.length="+selItems.length);
  for(var i=0;i<selItems.length;i++)
  {
       // var type=fl.getDocumentDOM().library.getItemType(selItems);
   //if(type!=folder)
   
  if(selItems.itemType=="movie clip")
   {
    fl.getDocumentDOM().library.selectItem(selItems);
    fl.getDocumentDOM().library.moveToFolder("movieClips");
   }
    if(selItems.itemType=="bitmap")
   {
    fl.getDocumentDOM().library.selectItem(selItems);
    fl.getDocumentDOM().library.moveToFolder("BitMaps");
   }
   flash.trace("*****************selltems[]="+selItems.name+selItems.itemType);
   if(selItems.itemType=="movie clip")
   {
     fl.getDocumentDOM().library.selectItem(selItems);
     fl.getDocumentDOM().library.moveToFolder("movieClips");
   }
   if(selItems.itemType=="bitmap")
   {
     fl.getDocumentDOM().library.selectItem(selItems);
     fl.getDocumentDOM().library.moveToFolder("BitMaps");
   }
   
  }*/
}

function truncExtension(str){
return str.substring(0,str.lastIndexOf(".")-1);
}
function truncPostfixNumber(str){
var idx = str.length - 1;
var stop = false;
var hasNumber = false;
var doTrunc = false;
while(!stop){
  if(str.charAt(idx) >= "0" && str.charAt(idx) <= "9"){
   hasNumber = true;
   idx--;
  }else if(str.charAt(idx) == "_"){
   doTrunc = true;
   stop = true;
  }else{
   doTrunc = false;
   stop = true;
  }
}
return str.substring(0,idx);
}