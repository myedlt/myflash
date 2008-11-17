var curZoom_Index = -1;
var bImgLoad = 0;
var bMoveManual=true;
var bInitPos=false;
var newImage="slidebk.gif";
var oldImage="";
var b_loadFirstPic = true;
var nMovieFullScreen=2;
var bLoad = true;
var bChange=false;
var bHttp = true;
var preImage="slidebk.gif";
var Db_sign = true;
var bIsPic = true;
var PPWidth = 0;
var PPHeight = 0;
var oldPicMedia="";
var lState=2;
var bSyncStates = false;
var nMediaPlayNO = 2;
var ncount = 0;
var dblPosition=0;
var nOldSyncNO = 0;
var MMPos = 0;
var ch = 0;

var nWindowWidth = 1024;
var nWindowHeight = 775; 

// Movie Layer
var nMovieLeft = 4;
var nMovieTop = 139;
var nMovieWidth = 213;
var nMovieHeight = 213;
var nMovieMaxWidth = 1018;
var nMovieMaxHeight = 806;

// Image Layer	
var nImageLeft = 264;
var nImageTop = 141;
var nImageWidth = 717;
var nImageHeight = 538;
var nImageMaxWidth = 1024;
var nImageMaxHeight = 768;

function WinPos_Init() 
{
	var nScreenHeight = window.screen.availHeight;
	var nScreenWidth = window.screen.availWidth;
	var nClientLeft = (nScreenWidth - nWindowWidth)/2-1;
	var  nClientTop= (nScreenHeight - nWindowHeight)/2;
	//window.moveTo(nClientLeft, nClientTop);
	//window.resizeTo(nWindowWidth, nWindowHeight);
	if(b_loadFirstPic)
	{
		LoadImage("Slides\\pc00001.jpg");
		b_loadFirstPic = false;
		InitChange(timer);
	}
	if(document.URL.indexOf("http") != -1)
		bHttp = true;
	else
		bHttp = false;
	bInitPos = true;
	bSyncStates = true;
}

function LoadImage(ImageName)
{
	if (document.all("Img").complete)
	{
		if(ImageName != newImage)
		{
			bChange = true;
			if(ImageName.indexOf("~tmp") == -1)
			{
	   			if(document.all("Img1").fileSize!=-1)
				{
					preImage = newImage;
					newImage = ImageName;
			 		if(bLoad)
		 				document.all("Img").src=ImageName;
				 	bImgLoad = -1;
				}
				else
				{
					if(bHttp)
					{
						if(document.all("Img").src.indexOf(preImage.substring(preImage.indexOf("\\")+1,preImage.length)) == -1)
						{
							document.all("Img").src=preImage;
						}
					}
				}
			}
		 }
	}
}

function MouseOver_change(src)
{
	if (!src.contains(event.fromElement))
	{
		src.style.cursor = 'hand';
	}
}

function GetPicMediaSize()
{
	switch (curZoom_Index)
	{
	case -1:
		PPWidth = nImageWidth;
		PPHeight = nImageHeight;
		break;
	case 1:
		PPWidth = nMovieWidth;
		PPHeight = nMovieHeight-20;
		break;
	case 2:
		PPWidth = 0;
		PPHeight = 0;
		break;
	case 4:
		PPWidth = nImageMaxWidth;
		PPHeight = nImageMaxHeight;
		break;
	}
}

function InitPos(index)
{
	var MovieLeft = 9*1.28;
	var MovieWidth = 160*1.28;
	var MovieHeight = 120*1.28;
	switch (index)
	{
	case 0:
		break;
	case 1:
		Movie1.style.pixelLeft = nMovieLeft;
		Movie1.style.pixelTop = nMovieTop;
		Movie1.style.pixelWidth = nMovieWidth;
		Movie1.style.pixelHeight = nMovieHeight;
		MPlayer1.style.pixelWidth = nMovieWidth;
		MPlayer1.style.pixelHeight = nMovieHeight;
//		MPlayer1.ShowControls = 1;
		BtnZoomV1.src = "Image_l/full_button.gif";
		break;
	case 4:
		WinPos_Init();
		Layer1.style.pixelLeft = nImageLeft;
		Layer1.style.pixelTop = nImageTop;
		Layer1.style.pixelWidth = nImageWidth;
		Layer1.style.pixelHeight = nImageHeight;
		Img.style.pixelWidth = nImageWidth;
		Img.style.pixelHeight = nImageHeight;
		if(bIsPic)
		{
			Img.style.pixelWidth = nImageWidth;
			Img.style.pixelHeight = nImageHeight;
			picPlayer.width = 1;
			picPlayer.height = 1;
		}
		else
		{
			Img.style.pixelWidth = 0;
			Img.style.pixelHeight = 0;
			picPlayer.width = nImageWidth;
			picPlayer.height = nImageHeight;
		}
		//if (MPlayer1.FileName)	InitPos(1);
		break;
	}
	MPlayer1.DisplaySize=1;
	curZoom_Index = -1;
	return true;
}

function MovieZoom(index)
{
	var nClientLeft = 262;
	var nClientTop = 139;
	var nClientWidth = 722;
	var nClientHeight = 542;
	
	switch (index)
	{
	case 1:
		if (MPlayer1.Filename)
		{
			Movie1.style.zindex =1;
			Movie1.style.pixelLeft = nClientLeft;
			Movie1.style.pixelTop = nClientTop;
			Movie1.style.pixelHeight = nClientHeight;
			Movie1.style.pixelWidth = nClientWidth;
			MPlayer1.style.pixelHeight = nClientHeight;
			MPlayer1.style.pixelWidth = nClientWidth;
//			MPlayer1.ShowControls = 0;
			BtnZoomV1.src="Image_l/full_button2.gif";
			Layer1.style.pixelLeft = nMovieLeft;
			Layer1.style.pixelTop = nMovieTop;
			Layer1.style.pixelWidth = nMovieWidth;
			Layer1.style.pixelHeight = nMovieHeight;
			if(bIsPic)
			{
				Img.style.pixelWidth = nMovieWidth;
				Img.style.pixelHeight = nMovieHeight-26;
				picPlayer.width = 1;
				picPlayer.height = 1;
			}
			else
			{
				Img.style.pixelWidth = 0;
				Img.style.pixelHeight = 0;
				picPlayer.width = nMovieWidth;
				picPlayer.height = nMovieHeight-26;
			}
			curZoom_Index = 1;
		}
		
		break;
	case 2:
		if (MPlayer1.Filename)
		{
			Movie1.style.zindex =1;
			Movie1.style.pixelLeft = 0;
			Movie1.style.pixelTop = 0;
			Movie1.style.pixelHeight = nMovieMaxHeight;
			Movie1.style.pixelWidth = nMovieMaxWidth;
			MPlayer1.style.pixelHeight = nMovieMaxHeight;
			MPlayer1.style.pixelWidth = nMovieMaxWidth;
			Layer1.style.pixelLeft = 0;
			Layer1.style.pixelTop = 0;
			Layer1.style.pixelWidth = 0;
			Layer1.style.pixelHeight = 0;
			Img.style.pixelWidth = 0;
			Img.style.pixelHeight = 0;
			picPlayer.width = 1;
			picPlayer.height = 1;
			MPlayer1.DisplaySize=3;
			bLoad = false;
			curZoom_Index = 2;
		}
		
		break;
	}
	return true;
}

function MovieMin()
{
	var MovieLeft = 12;
	Movie1.style.pixelLeft = MovieLeft;
	Movie1.style.pixelTop = 56;
	Movie1.style.pixelWidth = 0;
	Movie1.style.pixelHeight = 0;
	MPlayer1.style.pixelWidth = 1;
	MPlayer1.style.pixelHeight = 1;
}

function OnBtnZoom(index)
{
	if (curZoom_Index==index)
	{
		InitPos(1);
		InitPos(4);
//		InitPos(index);
	}
	else
	{
		InitPos(curZoom_Index);
		MovieZoom(index);
	}
	Db_sign = false;
}

function FullScreenZoom()
{
	switch (curZoom_Index)
	{
	case -1:
	case 4:
		ImgZoom();
		break;
	case 1:
		MovieZoom(nMovieFullScreen);
		break;
	}

}

function ImgZoom()
{
	var nClientWidth = 1038;
	var nClientHeight = 808;
	var nScreenHeight = window.screen.availHeight;
	var nScreenWidth = window.screen.availWidth;
	var nClientLeft = window.screenLeft-5;
	var  nClientTop= window.screenTop-42;
	if (bIsPic)
	{
		if (curZoom_Index != 4 && bImgLoad)
		{
			//window.moveTo(nClientLeft, nClientTop);
			//window.resizeTo(nClientWidth, nClientHeight);
			MovieMin();
			Layer1.style.pixelLeft = 0;
			Layer1.style.pixelTop = 0;
			Layer1.style.pixelWidth = nImageMaxWidth;
			Layer1.style.pixelHeight = nImageMaxHeight;
			Img.style.pixelWidth = nImageMaxWidth;
			Img.style.pixelHeight = nImageMaxHeight;
			curZoom_Index =4;
		}
	}
	else
	{
		//window.moveTo(nClientLeft, nClientTop);
		//window.resizeTo(nClientWidth, nClientHeight);
		MovieMin();
		Layer1.style.pixelLeft = 0;
		Layer1.style.pixelTop = 0;
		Layer1.style.pixelWidth = nImageMaxWidth;
		Layer1.style.pixelHeight = nImageMaxHeight;
		picPlayer.width = nImageMaxWidth;
		picPlayer.height = nImageMaxHeight;
		curZoom_Index =4;
		
	}
}

function StartLoadPic()
{
	bLoad = true;
	if(bChange)
		document.all("Img").src=newImage;
}

function OnPlay()
{
	if (MPlayer1.playState==0 || MPlayer1.playState==1)
	{
		MPlayer1.play();
	}
	window.event.returnValue=false;
}

function OnStop()
{
	if (MPlayer1.playState==2 || MPlayer1.playState==1)
	{
		MPlayer1.stop();
		MPlayer1.currentposition=0;
	}
	bMoveManual = false;
	
	window.event.returnValue=false;
}

function OnPause()
{
	if (MPlayer1.PlayState==2)
	{
		MPlayer1.pause();
	}
	window.event.returnValue=false;
}

function OnBackward()
{
	if (MPlayer1.playstate==1 || MPlayer1.PlayState==2)
	{
		x = MPlayer1.currentposition;
		y = MPlayer1.Duration/10;
		if ( x>y)
		{
			x-=y;
		}
		MPlayer1.currentposition=x;
			
		bMoveManual=false;
		
	}
	window.event.returnValue=false;
}

function OnForward()
{
	if (MPlayer1.PlayState==1 || MPlayer1.PlayState==2)
	{
		x = MPlayer1.currentposition;
		x2= MPlayer1.Duration;
		y = x2/10;

		if (x<x2-y)
		{
			x+=y;
		}
		MPlayer1.currentposition=x;
		bMoveManual=false;
		
	}
	window.event.returnValue=false;
}

function MPlayer1_DblClick(iButton, iShiftState, fX, fY)
{
	if (curZoom_Index == 2)	
	{	
		MovieZoom(1);
	}
}

function picPlayer_DblClick(iButton, iShiftState, fX, fY)
{
	if (curZoom_Index == 4)	
	{	
		InitPos(1);		
		InitPos(4);
	}	
}

function MPlayer1_EndOfStream(lResult)
{
	if (picPlayer.url)
		picPlayer.controls.stop();
	InitPos(1);
	InitPos(4);
}

function SyncMPlayer(nSyncNO,m_MPlayer)
{
	bSyncStates = false;
	if(nOldSyncNO == nSyncNO)
	{
		ncount = ncount + 1;
	}
	else
	{
		if(parseInt(nOldSyncNO) > parseInt(nSyncNO))
		{
			bSyncStates = true;
			return;
		}
		else
		{
			nOldSyncNO = nSyncNO;
			if(ncount == 0)
			{
				ncount = ncount + 1;
			}
			else
			{
				ncount = 1;
				switch (m_MPlayer)
				{
				case 1:
					if (MPlayer1.Filename)
						MPlayer1.pause();				
					if (picPlayer.url)
						picPlayer.controls.play();
					break;
				case 2:
					if (picPlayer.url)
						picPlayer.controls.pause();				
					if (MPlayer1.Filename)
						MPlayer1.play();
					break;
				}
			}
		}
	}
	if(ncount < nMediaPlayNO)
	{
		switch (m_MPlayer)
		{
		case 1:
			if (MPlayer1.Filename)
				MPlayer1.pause();				
			break;
		case 2:
			if (picPlayer.url)
				picPlayer.controls.pause();				
			break;
		}
	}
	else
	{
		ncount = 0;
		if (MPlayer1.Filename)
			MPlayer1.play();
		if (picPlayer.url)
			picPlayer.controls.play();
	}
	bSyncStates = true;
	if(bIsPic)
		MPlayer1.play();
}

function MP_PositionChange(dblOldPosition, dblNewPosition)
{
	if(timer!=20000 && timer!=0 && dblNewPosition>300)
	{
		document.clear();
		changeTitle();
	}
	if(dblNewPosition!=dblPosition)
	{
		ncount = 0;
		nOldSyncNO = 0;
		dblPosition=dblNewPosition;
		if (MPlayer1.Filename)
		{
			MPlayer1.currentposition = dblNewPosition;
			MPlayer1.play();
		}
		try
		{
			if (picPlayer.url)
			{
				picPlayer.controls.currentposition = dblNewPosition + MMPos;
				picPlayer.controls.play();
			}
		}catch(e){}
	}
}

function  MP_PlayStateChange(lOldState, lNewState)
{
	if(bSyncStates)
	{
		if(lNewState!=lState)
		{
			lState=lNewState;
			switch (lNewState)
			{
			case 0:
				ncount = 0;
				nOldSyncNO = 0;
				if (MPlayer1.Filename)
					MPlayer1.stop();
				if(!bIsPic)
					if (picPlayer.url)
						picPlayer.controls.stop();
				break;
			case 1:
				if (MPlayer1.Filename)
					MPlayer1.pause();
				if(!bIsPic)
					if (picPlayer.url)
						picPlayer.controls.pause();
				break;
			case 2:
				if (MPlayer1.Filename)
					MPlayer1.play();
				if(!bIsPic)
					if (picPlayer.url)
						picPlayer.controls.play();
				break;
			}
		}
	}
}

function MPlayer1_ScriptCommand(sType, sParam) 
{
	if(sType == "PICTURE")
	{
		if(sParam.indexOf("~tmp") == -1)
		{
			picPlayer.controls.pause();
			oldImage = "Slides\\" + sParam;
			document.all("Img1").src=oldImage;	
			LoadImage(oldImage);
			if(!bIsPic)
			{
					bIsPic = true;
					GetPicMediaSize();
					picPlayer.width = 1;
					picPlayer.height = 1;
					Img.style.pixelWidth = PPWidth;
					Img.style.pixelHeight = PPHeight;
			}
		}
	}
	if(sType == "MEDIA")
	{
		var mediaPos = sParam.split("#");
		if(picPlayer.PlayState==2)
			picPlayer.controls.play();
		var a = Math.abs(mediaPos[1]-picPlayer.controls.currentposition);
		if(a>3)
			picPlayer.controls.currentposition = mediaPos[1];
		MMPos = MPlayer1.currentposition - mediaPos[1];
		if(picPlayer.PlayState==3)
		{
			if(bIsPic)
			{
					bIsPic = false;
					GetPicMediaSize();
					Img.style.pixelWidth = 0;
					Img.style.pixelHeight = 0;
					picPlayer.width = PPWidth;
					picPlayer.height = PPHeight;
			}
		}
	}
	if(sType =="Exchange" && sParam == "VideoL")
	{
		if (curZoom_Index!=1)
		{
			InitPos(curZoom_Index);
			StartLoadPic();
			MovieZoom(1);
		}
	}
	if(sType == "Exchange" && sParam == "VideoS")
	{
		if (curZoom_Index==1)
		{
			StartLoadPic();
			InitPos(1);
			InitPos(4);
		}
	}
	if(sType =="VidZoom" && sParam == "VideoL")
	{
		if (curZoom_Index!=2)
		{
			InitPos(curZoom_Index);
			MovieZoom(2);
		}
	}
	if(sType == "VidZoom" && sParam == "VideoS")
	{
		if (curZoom_Index==2)
		{
			StartLoadPic();
			InitPos(1);
			InitPos(4);
		}
	}
	if(sType =="PicZoom" && sParam == "PicL")
	{
		if (curZoom_Index!=4)
		{
			StartLoadPic();
			ImgZoom();
		}
	}
	if(sType == "PicZoom" && sParam == "PicS")
	{
		if (curZoom_Index==4)
		{
			StartLoadPic();
			InitPos(1);
			InitPos(4);
		}
	}
	if(sType == "SYNC")
	{
		SyncMPlayer(sParam,1);
	}
}

function picPlayer_ScriptCommand(sType, sParam) 
{
	if(sType == "SYNC")
	{
		SyncMPlayer(sParam,2);
	}
	if(sType == "PAUSE")
	{
		if(sParam.indexOf("~tmp") == -1)
		{
			oldImage = "Slides\\" + sParam;
			document.all("Img1").src=oldImage;	
			LoadImage(oldImage);
			if(!bIsPic)
			{
				bIsPic = true;
				GetPicMediaSize();
				picPlayer.width = 1;
				picPlayer.height = 1;
				Img.style.pixelWidth = PPWidth;
				Img.style.pixelHeight = PPHeight;
			}
		}
	}
}

function Table_DblClick( )
{
	switch (curZoom_Index)
	{
	case -1:
	case 1:
		break;
	case 2:
		StartLoadPic();
		MovieZoom(1);
		break;
	case 4:
		InitPos(1);
		InitPos(4);
		break;
	}
	Db_sign = false;
}



function OnTimer()
{
	if (MPlayer1.PlayState==1 || MPlayer1.PlayState==2)
	{
		bMoveManual = false;
		PlayerSlider.Value = MPlayer1.currentposition;
	}
}

function InitChange(timer)
{
	if(timer==0)return 0;
	iTimerID = window.setTimeout( "changeTitle()", timer);
}

function changeTitle()
{
	if(timer==0)return 0;
	ch = ch % modNum;
	var filespec="../INTRO/ad/adl" + ch + ".htm";
	document.all("ad").src=filespec;
	ch++;
	timer = 20000;
	InitChange(timer);
}

function OnExit()
{
	window.close();
}