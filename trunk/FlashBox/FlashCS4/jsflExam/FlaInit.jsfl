    //第一步：自动产生AS层和Label层
    fl.getDocumentDOM().getTimeline().addNewLayer("AS");
    fl.getDocumentDOM().getTimeline().addNewLayer("Label");
    //第二步：在“AS”层第一帧上添加注释
    var layerIndex = fl.getDocumentDOM().getTimeline().findLayerIndex("AS");
    fl.getDocumentDOM().getTimeline().layers[layerIndex].frames[0].actionScript = '//================系统设置================//\n//——————变量初始化\n//——————数组初始化 \n//——————对象初始化\n//——————系统初始化\n//——————界面初始化\n//================功能逻辑================//\n//================函数模块================//\n';
    //第三步：在库里自动创建文件夹
    fl.getDocumentDOM().library.newFolder("0-image");
    fl.getDocumentDOM().library.newFolder("1-sound");
    fl.getDocumentDOM().library.newFolder("2-公用元件");