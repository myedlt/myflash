package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.DebugCamera3D;
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cone;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.typography.Text3D;
	import org.papervision3d.typography.fonts.HelveticaBold;
	import org.papervision3d.view.Viewport3D;

	[SWF(width='800', height='600', backgroundColor='0x868686', frameRate='12')]
	public class Chart extends Sprite
	{

		public function Chart()
		{
			// 用于显示状态或调试
			msgP = new TextField();
			msgP.x = 20;
			msgP.y = 20;
			msgP.multiline = true;
			msgP.width = 500;
			msgP.addEventListener(MouseEvent.CLICK, setCamera);
			this.addChild(msgP);
			
			// 1.set up the stage

			stage.align = StageAlign.TOP_LEFT; 			// 当影片输出的时候，整个影片相对浏览器的左上方对齐
			stage.scaleMode = StageScaleMode.NO_SCALE; 	// 影片不会跟随浏览的尺寸大小而发生缩放。
			//stage.quality = High;

			// 2.Initialise Papervision3D
			init3D();

			// 3.Create the 3D objects
			createScene();

			// Listen to mouse up and down events on the stage
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			// 为场景注册一个事件监听器，每当场景ENTER_FRAME的时候，就执行一次loop函数
			// ,ENTER_FRAME的频率就是输出影片时设置的每秒帧数。
			this.addEventListener(Event.ENTER_FRAME, renderClick);

		}

		private var xmlUrl:String = "assets/data.xml";
		private var d3oCord:DisplayObject3D = new DisplayObject3D();	// 环境对象容器
		private var d3oCube:DisplayObject3D = new DisplayObject3D();	// 立方体容器
		
		private var axes:Lines3D; // 全局坐标系统标注
		private var msgP:TextField;
		private var axesMark:Lines3D = new Lines3D(new LineMaterial(0xFFFFFF));

		// 摄像机鼠标操控的全局变量
		private var cameraPitch:Number = 60;
		private var cameraYaw:Number = -60;
		
		private var doRotation:Boolean = false;
		private var lastMouseX:int;
		private var lastMouseY:int;
		
		// PV3D engine 运行时必须实例化的对象
		private var renderer:BasicRenderEngine;
		private var scene:Scene3D;
		private var viewport:Viewport3D;
		private var camera:Camera3D;

		/**
		 * 实用功能方法：创建文本(Plane+movieMaterial+TextField)
		 *
		 * @param width		文本宽度
		 * @param height	文本高度
		 * @param message	文本
		 * @param format	文本格式
		 * @param alias		？
		 * @param transparent	透明
		 * @param smooth		平滑
		 * @return
		 *
		 */
		private function createPlane(width:Number = 100, height:Number = 100, message:String = "default", format:TextFormat = null, alias:String = AntiAliasType.NORMAL, transparent:Boolean = false, smooth:Boolean = false):Plane
		{

			var mc:MovieClip = new MovieClip();
			var txt:TextField = new TextField();
			txt.wordWrap = true;
			txt.width = width;
			txt.height = height;
			txt.multiline = true;
			txt.htmlText = message;

			txt.autoSize = TextFieldAutoSize.CENTER;
			if (format)
				txt.setTextFormat(format);

			txt.antiAliasType = alias;

			mc.graphics.beginFill(0x868686);
			mc.graphics.drawRect(0, 0, width, height);
			mc.graphics.endFill();

			mc.addChild(txt);

			var mat:MovieMaterial = new MovieMaterial(mc, transparent, false, true);
			mat.doubleSided = true;
			mat.smooth = smooth;
			mat.tiled = true;

			var p:Plane = new Plane(mat, width, height);
			d3oCord.addChild(p);

			return p;
		}

		/**
		 *	创建3D物件
		 *
		 */
		private function createScene():void
		{

			// 绘制全局坐标轴

			// Create a default line material and a Lines3D object (container for Line3D objects)
			var defaultMaterial:LineMaterial = new LineMaterial(0xFFFFFF); // black
			axes = new Lines3D(defaultMaterial);

			// Create a different colour line material for each axis
			var xAxisMaterial:LineMaterial = new LineMaterial(0xFF0000); // FF0000,red
			var yAxisMaterial:LineMaterial = new LineMaterial(0xFFFF00); // FFFF00,yello
			var zAxisMaterial:LineMaterial = new LineMaterial(0x0000FF); // 0000FF,blue

			// 创建原点对象
			var origin:Vertex3D = new Vertex3D(0, 0, 0);

			// Create a new line for each axis using the different materials and a width of 1.
			var xAxis:Line3D = new Line3D(axes, xAxisMaterial, 1, origin, new Vertex3D(50000, 0, 0));
			var yAxis:Line3D = new Line3D(axes, yAxisMaterial, 1, origin, new Vertex3D(0, 50000, 0));
			var zAxis:Line3D = new Line3D(axes, zAxisMaterial, 1, origin, new Vertex3D(0, 0, 50000));

			// Add lines to the Lines3D container
			axes.addLine(xAxis);
			axes.addLine(yAxis);
			axes.addLine(zAxis);
			//d3oCord.addChild(axes);
			d3oCord.addChild(axesMark);
			
			// 坐标尺：3D文字标注
			
			// Z轴
			this.createText("0", 		50000+1000, 	-500, 	0+1000, 		90);
			this.createText("20", 		50000+1000, 	-500, 	20*500+1000, 	90);
			this.createText("40", 		50000+1000, 	-500, 	40*500+1000,	90);
			this.createText("60", 		50000+1000, 	-500, 	60*500+1000, 	90);	
			this.createText("80", 		50000+1000, 	-500, 	80*500+1000, 	90);	
			this.createText("100", 	50000+1000, 	-500, 	100*500, 		90);
			//this.createText("Duration", 	50000+5000, 	-3500, 	50000/2, 	90);
			
			var pZ:Plane = this.createPlane(200,200,"周期",new TextFormat(null,"58"));
			pZ.x = 50000+5000+2000;
			pZ.y = -3500;
			pZ.z = 50000/2;
			pZ.scale = 50;
			pZ.rotationY +=270;
			
			// X轴
			this.createText("0", 		0, 			-500, 	50000+3000, 	90);
			this.createText("10", 		10*1000, 	-500, 	50000+3000, 	90);
			this.createText("20", 		20*1000, 	-500, 	50000+3000,		90);
			this.createText("30", 		30*1000, 	-500, 	50000+3000, 	90);	
			this.createText("40", 		40*1000, 	-500, 	50000+3000, 	90);	
			this.createText("50", 		50*1000, 	-500, 	50000+3000, 	90);	
			//this.createText("Phase", 	50000/2, 	-3500, 	50000+3000+5000, 	90);
			var pX:Plane = this.createPlane(200,200,"相位",new TextFormat(null,"58"));
			pX.x = 50000/2;
			pX.y = -3500;
			pX.z = 50000+5000+4000;
			pX.scale = 50;
			pX.rotationY +=270;
			

			//Y轴
			this.createText("0", 		50000, 	0+1000, 		-500, 	90);
			this.createText("10000", 	50000, 	20*500+1000, 	-500, 	90);
			this.createText("20000", 	50000, 	40*500+1000, 	-500,	90);
			
			//this.createText("Value(mV)", 50000+5000, 	20000/2 + 1000, 	-3500,	90);
			var pY:Plane = this.createPlane(200,200,"放电幅值(mV)",new TextFormat(null,"58"));
			pY.x =50000+5000+4000;
			pY.y = 15000;
			pY.z = -5500;
			pY.scale = 50;
			pY.rotationY +=270;
			
			// 创建2个平面材质，绘制网格时交替使用
			var materialA:ColorMaterial = new ColorMaterial(0x56526A);
			var materialB:ColorMaterial = new ColorMaterial(0x6A6A86);

			// 在X-Z正象限创建5X4网格（10000x9000）                
			var material:ColorMaterial = materialA;
			material.doubleSided = true;
			
			// 参数：x轴格数，z轴格数，宽，高，材质
			for (var iX:int = 1; iX <= 5; iX++)		// x轴方向5格
			{
				//material = (material == materialA) ? materialB : materialA;
				
				for (var iZ:int = 1; iZ <= 5; iZ++)		// z轴方向4格
				{
					material = (material == materialA) ? materialB : materialA;
					
					var plane:Plane = new Plane(material, 10000, 10000, 10, 10);
					plane.rotationX -= 90;
					plane.x = 10000 / 2 + (iX - 1) * 10000;
					plane.z = 10000 / 2 + (iZ - 1) * 10000;
					plane.rotationZ -= 180;
					d3oCord.addChild(plane);
				}
			}

			// 在X-Y正象限创建5X2网格（10000x9000）
			material = materialA;
			for (var ixXY:int = 1; ixXY <= 5; ixXY++)
			{
				material = (material == materialA) ? materialB : materialA;
				
				for (var iY:int = 1; iY <= 2; iY++)
				{
					material = (material == materialA) ? materialB : materialA;
					
					var pXY:Plane = new Plane(material, 10000, 10000, 10, 10);
					pXY.rotationY -= 180;
					pXY.x = 10000 / 2 + (ixXY - 1) * 10000;
					pXY.y = 10000 / 2 + (iY - 1) * 10000;
					pXY.rotationZ -= 180;
					d3oCord.addChild(pXY);
				}
			}

			//loadFromDemo();
			loadFromXML();

			//camera.x= -100;
			//camera.y= -500;
			//camera.z= -100;

//			axes.rotationX -=90;
//			axes.rotationZ -=90;
//			axes.rotationY +=90;

//			plane.rotationX -=90;
//			plane.rotationY -=90;
//			
//			cube.rotationZ -=90;
//			cube.rotationY -=90;
			

		}

		private function init3D():void
		{

			// create viewport
			viewport = new Viewport3D(800, 600, true, false);
			viewport.interactive = true;
			//viewport.graphics.lineStyle(2, 0xffffff);
			//viewport.graphics.drawRect(0, 0, viewport.viewportWidth, viewport.viewportHeight);
			//viewport.x=stage.stageWidth/2-viewport.viewportWidth/2;
			//viewport.y=stage.stageHeight/2-viewport.viewportHeight/2;

			addChild(viewport);

			// Create new camera with fov of 60 degrees (= default value)
			camera = new Camera3D();
			//camera = new DebugCamera3D(viewport);
			//camera.target = null;	//
			camera.target = DisplayObject3D.ZERO;	//Camera 类型：target/free
			
			// initialise the camera position (default = [0, 0, -1000])
			//camera.ortho = true;
			//camera.x = -100;
			//camera.y = -5000;
			camera.z = -300000;
			camera.orbit(60, -60);
			//camera.zoom = 0.8;
			camera.focus = 50;	// iso
			msgP.text = "Point:("+Math.round(camera.x)+","+Math.round(camera.y)+","+Math.round(camera.z)+")\n"
				+"RotationX: "+Math.round(camera.rotationX)+"\n"+"RotationY: "+Math.round(camera.rotationY)+"\n"+"RotationZ: "+Math.round(camera.rotationZ)+"\n"
				+"Fov: "+camera.focus+"\n"
				+"Near: "+camera.near+"\n"
				+"Far: "+camera.far+"\n";
			// Create a new scene where our 3D objects will be displayed
			scene = new Scene3D();

			// Create new renderer
			renderer = new BasicRenderEngine;
			//renderer = new QuadrantRenderEngine(QuadrantRenderEngine.CORRECT_Z_FILTER);	// 能解决破面，但性能差

		}
		
		private function loadFromDemo():void
		{
			
			// 负相位立方体材质
			var materialList1:MaterialsList = new MaterialsList();
			
			materialList1.addMaterial(new ColorMaterial(0xff69b4), "top");
			materialList1.addMaterial(new ColorMaterial(0xFF0A00), "bottom");
			materialList1.addMaterial(new ColorMaterial(0xffe4c4), "front");
			materialList1.addMaterial(new ColorMaterial(0xFF0A00), "back");
			materialList1.addMaterial(new ColorMaterial(0xFF0A00), "left");
			materialList1.addMaterial(new ColorMaterial(0x5F9EA0), "right");
			
			// 参数：宽，深，高，（x,*,z）
			var cw:int = 500;	// 宽
			var cd:int = 500;	// 深
			var ch:int;			// 高
			for (var i:int = 1; i <= 500; i++)
			{
				ch = 2*9000 * Math.random();
				
				var cube1:Cube = new Cube(materialList1, cw, cd, ch, 1, 1, 1);
				//cube1.z = cw/2 + (i-1)*(cw + 30);
				cube1.z = 4 * 9000 * Math.random();
				cube1.y = ch / 2;
				cube1.x = cd / 2 + 50000 * Math.random();
				//cube1.moveForward(28*i + 50);
				d3oCube.addChild(cube1);
			}			
		}
		
		private function loadFromXML():void
		{
			//System.useCodePage = useCodePage;
			
			var urlReq:URLRequest = new URLRequest(xmlUrl);
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, createCubeFromXML);
			urlLoader.load(urlReq);			
		}
		
		private function createCubeFromXML(evt:Event):void
		{
			var xml:XML = XML(evt.target.data);
			
			var xmlList:XMLList = xml.r;

			// 正相位立方体材质
			var materialList:MaterialsList = new MaterialsList();
			
			//materialList.addMaterial(new ColorMaterial(0xFF0000), "all");
			materialList.addMaterial(new ColorMaterial(0x4795C4,1,true), "top");
			materialList.addMaterial(new ColorMaterial(0xFF000,1,true), "bottom");
			materialList.addMaterial(new ColorMaterial(0x448EBA,1,true), "front");
			materialList.addMaterial(new ColorMaterial(0xFF000,	1,true), "back");
			materialList.addMaterial(new ColorMaterial(0xFFAE00,1,true), "left");
			materialList.addMaterial(new ColorMaterial(0x316788,1,true), "right");
			
			for each( var xmlRow:XML in xmlList)
			{
				var p:Number3D = new Number3D();
				p.x = xmlRow.@x * 1000;
				p.y = xmlRow.@z /2;
				p.z = xmlRow.@y * 500;
				
				// 参数：宽，深，高，（x,*,z）
				var cw:int = 600;	// 宽
				var cd:int = 400;	// 深
				var ch:int;			// 高	
				
				ch = p.y;
				
				var cube1:Cube = new Cube(materialList, cw, cd, ch, 1, 1, 1);
				cube1.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, handleMouseOverCube);
				//cube1.z = cw/2 + (i-1)*(cw + 30);
				cube1.z = p.z;
				cube1.y = ch / 2;
				cube1.x = p.x;
				//cube1.moveForward(28*i + 50);
				d3oCube.addChild(cube1);				
			}
			
			var d3oAll:DisplayObject3D = new DisplayObject3D();
			d3oAll.addChild(d3oCord);
			d3oAll.addChild(d3oCube);
			scene.addChild(d3oAll);
			
			d3oAll.rotationY +=90;
			//d3oAll.moveBackward(50000);
			renderer.renderScene(scene, camera, viewport);			
		}
		
		private function handleMouseOverCube(evt:InteractiveScene3DEvent):void
		{
			var cube:Cube = Cube(evt.displayObject3D); 
			
			cube.replaceMaterialByName(new ColorMaterial(0x0000FF,1,true), "top");
			//cube.replaceMaterialByName(new ColorMaterial(0x0000FF,1,true), "front");
			//cube.replaceMaterialByName(new ColorMaterial(0x0000FF,1,true), "right");
			//axesMark.removeAllLines();
			//var zMark:Line3D = new Line3D(axes, new LineMaterial(0xFF00FF), 1, new Vertex3D(0,cube.y,10), new Vertex3D(50000, cube.y, 10));
			//axesMark.addLine(zMark);
		}

		private function createText(msg:String, x:Number = 0, y:Number = 0, z:Number = 0, rotationY:int=0):void
		{
			var text:String = msg;
			
			var materialText:Letter3DMaterial = new Letter3DMaterial(0x000000);
			materialText.doubleSided = true;

			//use a built-in font:
			var font3D:HelveticaBold = new HelveticaBold();
			//or use a custom font class generated with the font creation tool
			//font3D = new Courier();
			
			var text3D:Text3D = new Text3D(text, font3D ,materialText);
			
			text3D.align = "right";
			text3D.letterSpacing = -3;
			text3D.lineSpacing = -12;
			
			text3D.x = x;
			text3D.y = y;
			text3D.z = z;
			text3D.localRotationY = rotationY;
			text3D.scale = 20;
			
			//show outline
			text3D.material.lineThickness = 2;
			text3D.material.lineAlpha = 1;
			text3D.material.lineColor = 0xCCCCCC;
			
			d3oCord.addChild(text3D);			
		}
		// called when mouse down on stage，拖拽按下鼠标时使旋转有效，记下按下时的鼠标位置
		private function onMouseDown(event:MouseEvent):void
		{
			doRotation = true;
			lastMouseX = event.stageX;
			lastMouseY = event.stageY;
		}

		// called when mouse up on stage，拖拽释放鼠标时使旋转失效
		private function onMouseUp(event:MouseEvent):void
		{
			doRotation = false;
		}

		private function renderClick(event:Event):void
		{
			// If the mouse button has been clicked then update the camera position
			if (doRotation)
			{

				// convert the change in mouse position into a change in camera angle
				var dPitch:Number = (mouseY - lastMouseY) / 2;
				var dYaw:Number = (mouseX - lastMouseX) / 2;

				// update the camera angles
				cameraPitch -= dPitch;
				cameraYaw -= dYaw;
				// limit the pitch of the camera
				if (cameraPitch <= 0)
				{
					cameraPitch = 0.1;
				}
				else if (cameraPitch >= 180)
				{
					cameraPitch = 179.9;
				}

				// reset the last mouse position
				lastMouseX = mouseX;
				lastMouseY = mouseY;

				// reposition the camera
				camera.orbit(cameraPitch, cameraYaw);
				msgP.text = "Point:("+Math.round(camera.x)+","+Math.round(camera.y)+","+Math.round(camera.z)+")\n"
					+"RotationX: "+Math.round(camera.rotationX)+"\n"+"RotationY: "+Math.round(camera.rotationY)+"\n"+"RotationZ: "+Math.round(camera.rotationZ)+"\n"
					+"Fov: "+camera.focus+"\n"
					+"Near: "+camera.near+"\n"
					+"Far: "+camera.far+"\n";
			}
			// Render the 3D scene
			renderer.renderScene(scene, camera, viewport);

		}
		
		public function setCamera(evt:MouseEvent):void
		{
			//rotX:Number = 30,rotY:Number =-30,rotZ:Number=0
			camera.x = 129904;
			camera.y = 150000;
			camera.z = -225000;
			
			camera.rotationX = 30;
			camera.rotationY = -30;
			camera.rotationZ = 0;
			renderer.renderScene(scene, camera, viewport);
			
		}
	}
}