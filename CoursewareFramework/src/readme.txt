课件模型Demo
暂提供两种入口:1.本地浏览-------index.html
	   		   2.SCORM标准页面--scorm文件夹下
	   		   
1.index.swf中由SwfLoader和ModulePlayerComponent组件构成.
  SwfLoader用来加载flash界面或片头;
  ModulePlayerComponent用来动态加载播放器组件(目前有flash、flv和图片播放器).
  
2.对于本地浏览,实现程序和界面分离,根目录下main1.swf和main2.swf为两种flash界面,目前只有"上一页"/"下一页"功能做测试.
  需要在config.xml文件中进行界面布局和课程内容配置.

3.现实标准的scorm课件,要对imsmanifest.xml文件进行配置.所有sco页面需加载scorm文件夹下的scoPlayer.swf文件（sco播放器）并配  置加载参数：例如在html页面的Object元素下配置
  <param name="FlashVars" value="path=../assets/course/chapter01/unit02.jpg&type=image" />
  参数由path和type构成；路径前加上必须加"../",type即加载的文件类型:flash/flv/image.

注意:sco页面如果要播放flv视频,在配置参数path中不能出现"../",该路径必须是全路径或把flv文件放在scoPlayer.swf所在文件夹下然后path中写相对路径.
