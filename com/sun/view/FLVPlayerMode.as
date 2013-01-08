package com.sun.view
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObject;
	import flash.media.Video;
	import flash.utils.*;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import flash.filters.BlurFilter;

	import flash.ui.Mouse;

	import flash.external.ExternalInterface;

	import com.sun.media.FLVStream;
	import com.sun.events.StreamEvent;
	import com.sun.utils.Tool;
	import com.sun.events.ClickEvent;
	import com.sun.utils.DoubleClick;
	import com.sun.utils.BMPTool;
	import com.sun.utils.MsgTip;
	import com.sun.utils.StatDot;

	import com.sun.utils.FPContextMenu;

	import com.sun.events.*;
	import com.sun.view.*;

	public class FLVPlayerMode extends EventDispatcher
	{
		//舞台允许的最小值
		private var min_win_height:uint = 250;
		private var min_win_width:uint = 250;

		private var mySkin:*;
		private var my_pc:*;

		private var bigPlay_btn:*;
		private var video_ct:Sprite;
		private var my_fpcm:FPContextMenu;

		private var my_mt:MsgTip;
		private var video_border:Shape;
		private var video_bg:Shape;
		private var video:Video;
		private var stream:FLVStream;
		private var dc:DoubleClick;
		private var view_w:uint = 350;
		private var view_h:uint = 350;
		private var adjustType:int = 0;
		private var flvWidth:uint;
		private var flvHeight:uint;
		private var isStopped:Boolean = false;
		private var isPlaying:Boolean = false;
		private var isSeeking:Boolean = false;
		private var isFullScreen:Boolean = false;
		private var volume:Number = 0.8;
		private var timer:Timer;
		private var timerDelay:uint = 200;
		private var totalTime:uint;
		private var intervalId:uint;

		private var sdTimeout:uint;
		private var sdCheckTimes:uint;

		private var tempBlur:uint = 0;
		private var endBlur:uint;
		private var blurSpeed:Number;
		//记录缓冲的次数
		private var emptyTimes:uint;
		//是否提交播放统计的标志变量
		private var statVar:Boolean;
		private var _state:String = "init";
		//视频类型:0普通视频;1加密视频;2FMS视频列
		private var _flvType:uint = 0;
		//flv视频服务器,用于统计上报
		private var _flvHost:String = "";
		private var flvPath:String = "";

		private var _loop:Boolean = false;

		private var seekError:Boolean;

		private var seekStopTime:uint;

		private var _adPlaying:Boolean = false;

		private var _imgList:Boolean = false;

		private var _list:Boolean = false;
		//缓冲中
		private var buffering:Boolean = false;
		//全屏鼠标是否可以隐藏
		private var hideAbled:Boolean = false;
		//是否显示控制栏
		private var _contrlShow:Boolean = true;
		//
		private var _error:Boolean = false;

		private var _newFlv:Boolean = true;
		private var _adLink:String = "";
		//由FLVPlayer收集的统计变量
		private var _vid:String = "";
		private var _vtype:uint = 0;
		private var _playerType:String;
		private var _from:String = "";
		private var _flvTitle:String = "";
		//是否已调用dataForWWJS2
		private var dataHasForWWJS2:Boolean;
		//用于计算缓冲时间
		private var sdTemp:uint;
		//统计计时器
		private var timeFormatType:String = "00:00";
		private var debug:Boolean = true;

		public function FLVPlayerMode(skin:*)
		{
			mySkin = skin;
			mySkin.x = 100000;
			mySkin.addEventListener(Event.ENTER_FRAME,stageCheck);
		}
		private function stageCheck(event:Event):void
		{
			if (mySkin.stage!=null) {
				if (mySkin.stage.stageWidth*mySkin.stage.stageHeight>0) {
					mySkin.removeEventListener(Event.ENTER_FRAME,stageCheck);
					init();
				}
			}
		}
		private function init():void
		{
			mySkin.stage.addEventListener(Event.RESIZE, resizeHandler);

			my_mt = new MsgTip(100,20);
			my_mt.mouseEnabled = false;
			my_mt.mouseChildren = false;

			my_pc = mySkin.controlBar_mc;
			bigPlay_btn = mySkin.bigPlay_btn;
			video = new Video();
			video_bg = new Shape();
			video_ct = new Sprite();
			video_border = new Shape();

			dc = new DoubleClick(video_ct);

			video.smoothing = true;
			video_ct.addChild(video_bg);
			video_ct.addChild(video);

			//设置各个对象的深度
			mySkin.addChildAt(video_ct,0);
			mySkin.setChildIndex(bigPlay_btn,1);

			mySkin.setChildIndex(my_pc,2);

			mySkin.addChildAt(my_mt,3);
			mySkin.addChildAt(video_border,4);

			my_pc.x = 0;
			my_pc.sound.setVolume(volume);

			my_pc.y = mySkin.stage.stageHeight-my_pc.height;

			view_w = mySkin.stage.stageWidth;
			view_h = mySkin.stage.stageHeight-my_pc.height;

			video_bg.graphics.beginFill(0x000000,100);
			video_bg.graphics.drawRect(0,0,view_w,view_h);
			video_bg.graphics.endFill();

			drawBorder(view_w-1,mySkin.stage.stageHeight-1);

			bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
			bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
			//禁止使用进度条
			my_pc.seekBar.mouseChildren = false;
			my_pc.stop_btn.mouseChildren = false;
			my_pc.sound.mouseChildren = false;
			my_pc.full_btn.mouseChildren = false;
			//禁止使用暂停和停止按钮
			my_pc.play_btn.state = "pause";
			video_ct.stage.showDefaultContextMenu = false;
			video_ct.mouseChildren = false;

			my_fpcm = new FPContextMenu(video_ct);

			//trace(my_fpcm);
			my_fpcm.playUnActive = false;
			my_fpcm.screenUnActive = false;

			steamInit();
			eventsConfig();
			//把控制条的背景转换成9Grid对象,以便进行缩放
			var tg:MovieClip = my_pc.bg_mc.getChildAt(0) as MovieClip;
			my_pc.bg_mc.removeChild(tg);
			my_pc.bg_mc.addChild(BMPTool.convertImageTo9Grid(BMPTool.getBMP(tg,0,0,Math.ceil(tg.width),Math.ceil(tg.height)),new Rectangle(70,0,200,Math.ceil(tg.height))));

			mySkin.showTime(timeFormatType,timeFormatType);
			my_pc.seekBar.position = 0;
			try {
				min_win_height = mySkin.minWinHeight;
				min_win_width = mySkin.minWinWidth;
			} catch (e:Error) {
			}
			video.width = view_w;
			video.height = view_h;
			resizeHandler(null);
			mySkin.x = 0;

			if (!_contrlShow) {
				my_pc.visible = false;
			}
			//添加鼠标移动检查
			if (_list) {
				mySkin.addEventListener(MouseEvent.MOUSE_MOVE,mousemoveCheck);
			}
			this.dispatchEvent(new Event("skinInitCompleted"));
		}
		//获取显示对象的秒素信息
		//private function showSkinDisplayObjectDetail():void
		//{
		//trace("=======皮肤对象里的显示对象层级信息========\t")
		//trace("层级0：视频窗口\t");
		//trace("层级1：大播放按钮\t");
		//trace("层级2：播放控制栏\t");
		//trace("层级3：信息提示框\t");
		//trace("层级4：播放器边框\t");
		//trace("=======皮肤对象里的显示对象层级信息========\t")
		//}
		private function steamInit():void
		{
			stream = new FLVStream();
			stream.addEventListener(StreamEvent.STREAM_READY,readyHandler);
			stream.addEventListener(StreamEvent.STREAM_START_READY,startReadyHandler);
			stream.addEventListener(StreamEvent.STREAM_STOP,stopHandler);
			//添加错误处理
			stream.addEventListener(StreamEvent.STREAM_ERROR,nsError);
			stream.addEventListener(StreamEvent.STREAM_404,ns404Error);
			//缓冲
			stream.addEventListener(StreamEvent.STREAM_EMPTY,emptyHandler);
			stream.addEventListener(StreamEvent.STREAM_FULL,fullHandler);
			//
			stream.addEventListener(StreamEvent.STREAM_STATUS,statusChanged);
			//NetConnection事件侦听
			stream.addEventListener(StreamEvent.STREAM_NC_ERROR,ncError);
		}
		private function eventsConfig():void
		{
			my_pc.play_btn.addEventListener(PlayEvent.PLAY,btnPlay);
			my_pc.play_btn.addEventListener(PlayEvent.PAUSE,btnPause);

			my_pc.full_btn.addEventListener(ScreenEvent.FULL,btnFull);
			my_pc.full_btn.addEventListener(ScreenEvent.NORMAL,btnNormal);

			my_pc.stop_btn.stop_btn.addEventListener(MouseEvent.MOUSE_UP,btnStop);

			my_pc.seekBar.addEventListener(SeekBarEvent.SEEK_START,seekStart);
			my_pc.seekBar.addEventListener(SeekBarEvent.SEEK_STOP,seekStop);
			my_pc.seekBar.addEventListener(SeekBarEvent.SEEKING,seeking);

			my_pc.sound.addEventListener(SoundEvent.SOUND_CHANGE,soundChange);
			my_pc.sound.addEventListener(SoundEvent.SOUND_MUTE,mute);
			my_pc.sound.addEventListener(SoundEvent.SOUND_UNMUTE,unmute);

			video_ct.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
			bigPlay_btn.addEventListener(MouseEvent.MOUSE_UP,bigBtnHandler);

			dc.addEventListener(ClickEvent.CLICK, vdClick);
			my_fpcm.addEventListener(FPContextMenuEvent.MENU_SELECTED,menuSelectedHandler);
		}
		private function drawBorder(w:Number,h:Number):void
		{
			video_border.graphics.clear();
			video_border.graphics.lineStyle(1,0x787878,1);
			video_border.graphics.moveTo(0,0);
			video_border.graphics.lineTo(w,0);
			video_border.graphics.lineTo(w,h);
			video_border.graphics.moveTo(0,0);
			video_border.graphics.lineTo(0,h);
			if (!_contrlShow) {
				//绘制第四个边框
				video_border.graphics.moveTo(0,h);
				video_border.graphics.lineTo(w,h);
			}
		}
		private function resizeHandler(event:Event):void
		{
			if (isFullScreen) {
				my_pc.full_btn.state = "normal";
				isFullScreen = false;
				hideAbled = false;
				if (!_list) {
					mySkin.removeEventListener(MouseEvent.MOUSE_MOVE,mousemoveCheck);
					clearTimeout(intervalId);
				}
				video_ct.removeEventListener(Event.ENTER_FRAME,enterFrame);
				//对动态文本使用模糊滤镜，需要嵌入字体，要不文字显示有问题
				my_pc.filters = [];
				my_pc.visible = true;
				tempBlur = 0;
				Mouse.show();
				//如果属于停止状态
			}
			if (my_pc.full_btn.state == "full") {
				my_fpcm.unActiveItem = "全    屏";
			} else {
				my_fpcm.unActiveItem = "退出全屏";
			}
			if (!_contrlShow) {
				//没有控制栏,只是简单的调整播放窗口的大小
				view_w = mySkin.stage.stageWidth;
				view_h = mySkin.stage.stageHeight;

				video_bg.width = view_w;
				video_bg.height = view_h;

				video_border.graphics.clear();
				drawBorder(view_w-1,mySkin.stage.stageHeight-1);

				try {
					if (flvWidth*flvHeight>0) {
						adjustSize(false);
					}
				} catch (e:Error) {
				}
				if (bigPlay_btn.visible) {
					bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
					bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
				}
				my_mt.x = 0;
				my_mt.y = view_h - my_mt.height;
				my_mt.setWidth(view_w-2);
				return;
			}
			//调整窗口大小
			if (mySkin.stage.stageWidth<min_win_width||mySkin.stage.stageHeight<min_win_height) {
				return;
			}
			view_w = mySkin.stage.stageWidth;
			view_h = my_pc.full_btn.state=="full"?mySkin.stage.stageHeight:mySkin.stage.stageHeight-my_pc.bg_mc.height;

			video_bg.width = view_w;
			video_bg.height = view_h;

			video_border.graphics.clear();

			if (my_pc.full_btn.state == "normal") {
				drawBorder(view_w-1,mySkin.stage.stageHeight-1);
			}
			try {
				if (flvWidth*flvHeight>0) {
					adjustSize(false);
				}
			} catch (e:Error) {
			}
			try {
				mySkin.controlBarAdjustSize(my_pc.full_btn.state=="full"?600:view_w,view_h);
			} catch (e:Error) {
			}

			BMPTool.NineGridObjectSizeAjust(my_pc.bg_mc.getChildAt(0) as Sprite,1,my_pc.full_btn.state=="full"?600:view_w,0);

			my_pc.y = mySkin.stage.stageHeight-my_pc.bg_mc.height;

			if (my_pc.full_btn.state=="full") {
				my_pc.y -= 20;
			}
			my_pc.x = my_pc.full_btn.state=="full"?(mySkin.stage.stageWidth - my_pc.width)/2:0;

			if (bigPlay_btn.visible) {
				bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
				bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
			}
			my_mt.x = my_pc.x+1;
			my_mt.y = my_pc.y - my_mt.height;
			my_mt.setWidth(my_pc.bg_mc.width-2);
			dispatchEvent(new Event("stageOnResize"));
		}
		//===================全屏的鼠标检查及处理==========================
		private function mousemoveCheck(event:MouseEvent):void
		{
			if (my_pc.full_btn.state == "normal") {
				if (!_list) {
					clearTimeout(intervalId);
					mySkin.removeEventListener(MouseEvent.MOUSE_MOVE,mousemoveCheck);
					return;
				}
			} else {
				if (tempBlur!=0) {
					my_pc.visible  = true;
					blur(0,-16);
				}
				Mouse.show();
			}
			try {
				clearTimeout(intervalId);
			} catch (e:Error) {
				//trace("clearTimeout:"+e);
			}
			//这个有问题啊
			if (my_pc.full_btn.state == "normal") {
				if (!my_pc.hitTestPoint(mySkin.mouseX,mySkin.mouseY,true)) {
					dispatchEvent(new Event("mouseMove"));
				} else {
					dispatchEvent(new Event("mouseRemain"));
				}
			}else{
				dispatchEvent(new Event("mouseMove"));
			}
			intervalId = setTimeout(timeoutHandler,3000);
			event.updateAfterEvent();
		}
		private function timeoutHandler():void
		{
			if (my_pc.full_btn.state == "full" && my_pc.hitTestPoint(mySkin.mouseX,mySkin.mouseY,true)) {
				return;
			}
			if (_state!="play"&&_state!="seeking") {
				return;
			}
			if (!_list&&!hideAbled) {
				return;
			}
			clearTimeout(intervalId);
			if (my_pc.full_btn.state == "full") {
				blur(160,16);
				Mouse.hide();
			}
			dispatchEvent(new Event("mouseRemain"));
		}
		private function blur(endValue:uint,speed:Number):void
		{
			endBlur = endValue;
			blurSpeed = speed;
			video_ct.addEventListener(Event.ENTER_FRAME,enterFrame);
		}
		private function enterFrame(event:Event):void
		{
			var myBlur:BlurFilter = new BlurFilter();
			tempBlur+=blurSpeed;
			//trace(tempBlur);
			if (blurSpeed<0) {
				if (tempBlur<=endBlur) {
					tempBlur = endBlur;
					video_ct.removeEventListener(Event.ENTER_FRAME,enterFrame);
				}
			} else {
				if (tempBlur>=endBlur) {
					tempBlur = endBlur;
					my_pc.visible = false;
					video_ct.removeEventListener(Event.ENTER_FRAME,enterFrame);
				}
			}
			myBlur.blurX=myBlur.blurY = tempBlur;

			var myFilters:Array = new Array();
			myFilters.push(myBlur);
			my_pc.filters = myFilters;
		}
		//===========================================================
		private function wheelHandler(event:MouseEvent):void
		{
			var sign:Number = event.delta*Math.abs(event.delta);
			volume+=sign*0.01;
			if (volume>1) {
				volume = 1;
			}
			if (volume<0) {
				volume = 0;
			}
			try {
				stream.NStream.soundTransform = new SoundTransform(volume);
			} catch (e:Error) {
			}
			my_pc.sound.setVolume(volume);
		}
		//暂停播放;
		private function vdClick(event:ClickEvent):void
		{
			if (_adPlaying) {
				if (_adLink!="") {
					navigateToURL(new URLRequest(_adLink),"_blank");
				}
				return;
			}
			clickHandler(null);
		}
		//全屏,退出全屏
		private function vdDBClick(event:ClickEvent):void
		{
			if (!_contrlShow) {
				//没有全屏，不提供双击全屏功能
				return;
			}
			if (_adPlaying) {
				return;
			}
			if (!my_pc.full_btn.mouseChildren) {
				return;
			}
			windHandler(null);
		}
		//鼠标右键功能
		private function menuSelectedHandler(event:FPContextMenuEvent):void
		{
			switch (event.value) {
				case "QQVideo" :
					navigateToURL(new URLRequest("http://video.qq.com/"),"_blank");
					break;
				case "播    放" :
					if (my_pc.play_btn.state=="pause") {
						my_pc.play_btn.state = "play";
						playHandler();
						my_fpcm.unActiveItem = event.value;
					}
					break;
				case "暂    停" :
					if (my_pc.play_btn.state=="play") {
						my_pc.play_btn.state = "pause";
						pauseHandler();
						my_fpcm.unActiveItem = event.value;
					}
					break;
				case "停    止" :
					if (my_pc.play_btn.state=="play") {
						my_pc.play_btn.state = "pause";
					}
					btnStop(null);
					my_fpcm.unActiveItem = event.value;
					break;
				case "全    屏" :
					if (my_pc.full_btn.state == "normal") {
						my_pc.full_btn.state = "full";
						fullScreen();
						my_fpcm.unActiveItem = event.value;
					}
					break;
				case "退出全屏" :
					if (my_pc.full_btn.state == "full") {
						my_pc.full_btn.state = "normal";
						normalScreen();
						my_fpcm.unActiveItem = event.value;
					}
					break;
			}
			try {
				ExternalInterface.call("console.info","menuSelectedHandler:"+event.value);
				trace("menuSelectedHandler:"+event.value);
			} catch (e:Error) {
				trace("调用外部JS方法错误");
			}
		}
		private function bigBtnHandler(event:MouseEvent):void
		{
			my_pc.play_btn.state = "play";
			playHandler();
		}
		private function btnPlay(event:*):void
		{
			playHandler();
		}
		private function btnPause(event:*):void
		{
			pauseHandler();
		}
		private function btnFull(event:*):void
		{
			fullScreen();
		}
		private function btnNormal(event:*):void
		{
			normalScreen();
		}
		private function btnStop(event:MouseEvent):void
		{
			if (_state=="play") {
				mySkin.addEventListener(Event.ENTER_FRAME,soundEaseOut);
			}
			//ExternalInterface.call("alert","btnStop()");
			stopHandler(null);
		}
		private function seekStart(event:*):void
		{
			if (isPlaying) {
				stream.NStream.pause();
				if (stream.NStream.bytesLoaded==stream.NStream.bytesTotal) {
					timer.stop();
				}
			}

			isSeeking = true;
		}
		private function seekStop(event:*):void
		{
			if (!isSeeking) {
				seeking(null);
			}
			isSeeking = false;
			if (isPlaying) {
				if (isStopped) {
					//ExternalInterface.call("alert","seekStop()");
					if (!dataHasForWWJS2) {
						dataHasForWWJS2 = true;
						dataForWWJS2(2,2,emptyTimes);
						if (totalTime!=0) {
							if (Math.abs(totalTime-stream.NStream.time*1000)/totalTime>0.05) {
								dataForWWJS2(2,3,emptyTimes);
							}
						}
					}
					stopHandler(null);
					return;
				}
				stream.NStream.resume();

				if (!timer.running) {
					if (!_adPlaying) {
						timer.start();
					}
				}
				_state = "play";
			} else {
				_state = "pause";
			}
		}
		//拖动的时候进行处理,可以seeking,前提是totalTime肯定不为0
		private function seeking(event:*):void
		{
			if (totalTime==0) {
				showMsgTipHandler("当前视频不允许拖动");
				return;
			}
			var p:Number = my_pc.seekBar.position;
			var t:Number;
			var temp_p:Number = 1;
			if (stream.NStream.bytesTotal==0&&_flvType!=2) {
				p = 0;
			} else if (stream.NStream.bytesLoaded!=stream.NStream.bytesTotal) {
				temp_p = stream.NStream.bytesLoaded/stream.NStream.bytesTotal;
			}
			if (p>temp_p) {
				p = temp_p;
			}
			if (p<0) {
				p=0;
			}
			t = totalTime*p/1000;
			t = Math.floor(t*100)/100;

			seekStopTime = t*1000;
			stream.NStream.seek(t);

			mySkin.showTime(Tool.timeFormat(t*1000,timeFormatType),Tool.timeFormat(totalTime,timeFormatType));
			if (isStopped) {
				isStopped = false;
			}
			_state = "seeking";
		}
		private function mute(event:*):void
		{
			my_pc.sound.setVolume(0);
			try {
				stream.NStream.soundTransform = new SoundTransform(0);
			} catch (e:Error) {
			}
		}
		private function unmute(event:*):void
		{
			my_pc.sound.setVolume(volume);
			try {
				stream.NStream.soundTransform = new SoundTransform(volume);
			} catch (e:Error) {
			}
		}
		private function soundChange(event:*):void
		{
			volume = my_pc.sound.getVolume();
			try {
				stream.NStream.soundTransform = new SoundTransform(volume);
			} catch (e:Error) {
			}
			my_pc.sound.changeMuteState(volume==0?"mute":"unmute");
		}
		private function timerHandler(event:TimerEvent):void
		{
			var playHeadTime:uint = Math.round(stream.NStream.time*1000);
			if (seekStopTime<playHeadTime-timerDelay&&(playHeadTime-timerDelay-seekStopTime)<(totalTime-playHeadTime)/2) {
				seekStopTime+=timerDelay;
				playHeadTime = seekStopTime;
			} else {
				seekStopTime = playHeadTime;
			}
			if (isPlaying&&!isSeeking) {
				mySkin.showTime(Tool.timeFormat(playHeadTime,timeFormatType),Tool.timeFormat(totalTime,timeFormatType));
				if (totalTime==0) {
					my_pc.seekBar.position = 0;
					return;
				}
				my_pc.seekBar.position = Math.round((playHeadTime/totalTime)*10000)/10000;
			}
			if (stream.NStream.bytesLoaded!=stream.NStream.bytesTotal) {
				var p:Number;
				if (stream.NStream.bytesTotal<=0) {
					my_mt.showTip("bytesTotal::0");
					p = 1;
				} else {
					p = stream.NStream.bytesLoaded/stream.NStream.bytesTotal;
				}
				my_pc.seekBar.loadingWidth = p;

			} else {
				my_pc.seekBar.loadingWidth = 1;
				if (totalTime!=0) {
					if (totalTime-stream.NStream.time*1000<2000) {
						if (!buffering) {
							var mySTF:SoundTransform = stream.NStream.soundTransform;
							var curr_volume:Number = mySTF.volume;
							if (curr_volume>0) {
								curr_volume-=volume/15;
								if (curr_volume<0) {
									curr_volume = 0;
								}
								stream.NStream.soundTransform = new SoundTransform(curr_volume);
							}
						}
					}
				}
			}
			if (buffering) {
				var b:Number = Math.round(stream.NStream.bufferLength*100/stream.NStream.bufferTime);
				if (b>=100) {
					b = 100;
					buffering = false;
					my_mt.hideTip();
				}
				showMsgTipHandler("缓冲中："+b+"%");
			}
		}
		private function fullScreen():void
		{
			mySkin.stage.displayState = StageDisplayState.FULL_SCREEN;
			//这个必须要在修改stage.displayState再设置,要不判断Esc退出会有问题
			isFullScreen = true;
			hideAbled = true;
			if (!_list) {
				mySkin.addEventListener(MouseEvent.MOUSE_MOVE,mousemoveCheck);
			}
		}
		private function normalScreen():void
		{
			isFullScreen = false;
			hideAbled = false;
			if (!_list) {
				mySkin.removeEventListener(MouseEvent.MOUSE_MOVE,mousemoveCheck);
				clearTimeout(intervalId);
			}
			video_ct.removeEventListener(Event.ENTER_FRAME,enterFrame);
			my_pc.filters = [];
			my_pc.visible = true;
			tempBlur = 0;
			Mouse.show();
			mySkin.stage.displayState = StageDisplayState.NORMAL;
		}
		private function statusChanged(event:StreamEvent):void
		{
			if (event.value.code=="NetStream.Seek.InvalidTime") {
				//invalidTime = event.value.details;
				stream.NStream.seek(event.value.details);
			}
			if (event.value.code=="NetStream.Seek.Notify") {
				//invalidTime = -1;
			}
		}
		private function ncClose(event:StreamEvent):void
		{
			if (!_error) {
				_error = true;
				showMsgTipHandler("FMS关闭连接");
				//trace("ncClose");
				errorHandler();
			}
		}
		private function nsError(event:StreamEvent):void
		{
			if (!_error) {
				_error = true;
				showMsgTipHandler("在服务器上找不到视频");
				errorHandler();
				//获取状态信息
			}
		}
		private function ns404Error(event:StreamEvent):void
		{
			stream.removeEventListener(StreamEvent.STREAM_404,ns404Error);
			//404错误
			dataForWWJS2(0,1,-1);
			dataForWWJS1();
		}
		private function ncError(event:StreamEvent):void
		{
			if (!_error) {
				_error = true;
				showMsgTipHandler("连接FMS服务器失败,请稍候再试");
				errorHandler();
			}
		}
		private function errorHandler():void
		{
			my_pc.play_btn.state = "pause";
			my_pc.play_btn.mouseChildren= true;

			bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
			bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
			bigPlay_btn.visible = true;
			isPlaying = false;

			_newFlv = true;

			try {
				if (timer.running) {
					timer.stop();
				}
			} catch (e:Error) {
			}
			//状态恢复
			_state = "error";
			if (!_adPlaying) {
				//视频加载失败,提交统计
				if (sdCheckTimes==1) {
					clearTimeout(sdTimeout);
					sdCheckTimes = 2;
				}
				dataForQQ(0,10000);
			}
			this.dispatchEvent(new Event("flvLoadError"));
		}
		private function emptyHandler(event:StreamEvent):void
		{
			if (stream.NStream.bytesTotal>0&&stream.NStream.bytesLoaded==stream.NStream.bytesTotal) {
				return;
			}
			//出现缓冲肯定没有加载完成,所有timer肯定还在，所以，就用这个来检查缓冲的情况
			_state = "empty";
			buffering = true;
			if (!_adPlaying) {
				showMsgTipHandler("缓冲中：0%");
				emptyTimes++;
				clearInterval(sdTimeout);
				sdTemp = getTimer();
				sdTimeout = setTimeout(emptyTimeCheck,10000);
			}
			//在播放广告的时候触发
			this.dispatchEvent(new Event("epmty"));
		}
		private function fullHandler(event:StreamEvent):void
		{
			if (isPlaying) {
				_state = "play";
			} else {
				if (isStopped) {
					_state = "stop";
				} else {
					_state = "pause";
				}
			}
			var tempTime:uint = getTimer()-sdTemp;
			if (tempTime<10000) {
				clearInterval(sdTimeout);
				dataForQQ(1,tempTime);
			}
			buffering = false;
			showMsgTipHandler("缓冲中：100%");
			//隐藏提示
			my_mt.hideTip();

			this.dispatchEvent(new Event("full"));
		}
		private function readyHandler(event:StreamEvent):void
		{
			_newFlv = false;
			buffering = false;

			my_pc.seekBar.mouseChildren = true;

			my_pc.stop_btn.mouseChildren = true;
			my_pc.play_btn.mouseChildren = true;
			my_pc.full_btn.mouseChildren = true;

			if (my_pc.full_btn.state == "full") {
				my_fpcm.unActiveItem = "全    屏";
			} else {
				my_fpcm.unActiveItem = "退出全屏";
			}
			my_fpcm.unActiveItem = "播    放";

			stream.NStream.resume();

			if (!my_pc.sound.mouseChildren) {
				my_pc.sound.mouseChildren = true;
			}
			video.attachNetStream(stream.NStream);

			if (my_pc.sound.getVolume()!=0) {
				stream.NStream.soundTransform = new SoundTransform(volume);
			} else {
				stream.NStream.soundTransform = new SoundTransform(0);
			}
			if (timer==null) {
				//第一次播放视频
				my_pc.full_btn.mouseChildren = true;
				dc.addEventListener(ClickEvent.DOUBLE_CLICK, vdDBClick);

				timer = new Timer(timerDelay);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);

				if (!_adPlaying) {
					timer.start();
				}
			} else {
				if (!_adPlaying) {
					timer.start();
				}
			}
			//统计判断
			if (!_adPlaying) {
				if (sdCheckTimes==1) {
					clearTimeout(sdTimeout);
					sdCheckTimes = 2;
					dataForQQ(0,getTimer()-sdTemp);
				}
				dataForWWJS2(1,2,-1);
			}
			_state = "ready";
			isPlaying = true;
			//隐藏提示
			my_mt.hideTip();

			if (_flvType==2) {
				_state = "play";
				video.visible = true;
				dc.addEventListener(ClickEvent.CLICK, vdClick);
				this.dispatchEvent(new Event("onPlayStart"));
			}
			try {
				ExternalInterface.call("console.info","FLVPlayerMode::readyHandler");
			} catch (e:Error) {
				trace("调用外部JS方法错误");
			}
			//播放专辑的时候，开始播放后进行鼠标检查
			if (_list) {
				mySkin.addEventListener(MouseEvent.MOUSE_MOVE,mousemoveCheck);
			}
		}
		private function startReadyHandler(event:StreamEvent):void
		{
			//显示视频
			if (!video.visible) {
				video.visible = true;
			}
			if (flvWidth==0) {
				flvWidth = view_w-2;
				flvHeight = view_h;
				adjustSize(false);
			}
			buffering = false;
			_state = "play";
			//缓冲满,第一次开始播放
			if (_flvType!=2) {
				dc.addEventListener(ClickEvent.CLICK, vdClick);
				this.dispatchEvent(new Event("onPlayStart"));
			}
		}
		private function stopHandler(event:StreamEvent):void
		{
			isStopped = true;

			if (!isSeeking&&_state!="stop") {
				my_mt.hideTip();
				_state = "stop";
				my_pc.play_btn.state = "pause";

				timer.stop();

				bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
				bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
				bigPlay_btn.visible = true;
				my_pc.stop_btn.mouseChildren = false;
				isPlaying = false;
				buffering = false;

				if (event!=null) {
					if (!dataHasForWWJS2) {
						dataHasForWWJS2 = true;
						dataForWWJS2(2,2,emptyTimes);
						if (totalTime!=0) {
							if (Math.abs(totalTime-stream.NStream.time*1000)/totalTime>0.05) {
								dataForWWJS2(2,3,emptyTimes);
							}
						}
					}
					stream.NStream.pause();
					if (_flvType!=2) {
						stream.NStream.seek(totalTime/2000);
					}
					//
				}
				my_pc.seekBar.position = 0;

				if (stream.NStream.bytesLoaded!=stream.NStream.bytesTotal) {
					my_pc.seekBar.loadingWidth = 0;
				}
				mySkin.showTime(Tool.timeFormat(0,timeFormatType),Tool.timeFormat(totalTime,timeFormatType));
				//ExternalInterface.call("alert","stopHandler:"+event);
				if (event==null) {
					//通过按钮停止
					this.dispatchEvent(new Event("onStop"));
				}
				if (event!=null) {
					//节目播放结束停止
					this.dispatchEvent(new Event("onPlayStop"));
				}
				my_fpcm.unActiveItem = "停    止";
			}
		}
		//怎么被调用了两次,开始播放和结束播放都被调用了??????
		private function mdHandler(event:StreamEvent):void
		{
			try {
				ExternalInterface.call("console.info","FLVPlayerMode::mdHandler:"+flvWidth*flvHeight+";"+event.value["duration"]);
			} catch (e:Error) {
				trace("调用外部JS方法错误");
			}
			stream.client.removeEventListener(StreamEvent.STREAM_MD,mdHandler);

			if (event.value["duration"]!=undefined) {
				totalTime = Math.round(event.value["duration"]*1000);
				//时间的格式化类型
				if (totalTime>=3600000) {
					timeFormatType = "00:00:00";
				} else {
					timeFormatType = "00:00";
				}
				//设置视频的缓冲时间
				stream.NStream.bufferTime = Math.round(totalTime/60000);
			}
			if (!event.value["width"]) {
				event.value["width"] = view_w;
				event.value["height"] = view_h;
			}

			flvWidth = event.value["width"];
			flvHeight = event.value["height"];
			adjustSize(false);
		}
		private function soundEaseOut(event:Event):void
		{
			try {
				var mySTF:SoundTransform = stream.NStream.soundTransform;
				var curr_volume:Number = mySTF.volume;

				if (curr_volume>0) {
					curr_volume-=0.06;
					if (curr_volume<0) {
						curr_volume = 0;
					}
					stream.NStream.soundTransform = new SoundTransform(curr_volume);
				} else {
					mySkin.removeEventListener(Event.ENTER_FRAME,soundEaseOut);
					stream.NStream.pause();
					if (_state=="stop") {
						if (_flvType!=2) {
							stream.NStream.seek(totalTime/2000);
						}
					}
				}
			} catch (e:Error) {
				try {
					ExternalInterface.call("console.info","声音淡出出错："+e);
				} catch (e:Error) {
					trace("调用外部JS方法错误");
				}
			}
		}
		private function playInit():void
		{
			dc.removeEventListener(ClickEvent.CLICK, vdClick);
			//禁止使用进度条
			my_pc.seekBar.mouseChildren = false;
			my_pc.play_btn.mouseChildren = false;
			my_pc.stop_btn.mouseChildren = false;

			if (my_pc.full_btn.state == "normal") {
				my_pc.full_btn.mouseChildren = false;
				my_fpcm.screenUnActive = false;
			}
			//禁止使用暂停和停止按钮
			if (my_pc.play_btn.state == "pause") {
				my_pc.play_btn.state = "play";
				bigPlay_btn.visible = false;
			}
			//
			emptyTimes = 0;
			flvWidth = 0;
			flvHeight = 0;
			totalTime = 0;

			statVar = false;
			isStopped = false;
			isSeeking = false;
			seekError = false;
			buffering = false;
			_newFlv = true;
			my_pc.seekBar.position = 0;
			mySkin.showTime(Tool.timeFormat(0,timeFormatType),Tool.timeFormat(totalTime,timeFormatType));
			showMsgTipHandler("视频缓冲中...");
		}
		private function playHandler():void
		{
			bigPlay_btn.visible = false;
			if (_newFlv) {
				playInit();
				dispatchEvent(new Event("readyToPlay"));
			} else {
				if (isStopped) {
					isStopped = false;
					stream.NStream.seek(0);
				}
				if (!my_pc.full_btn.mouseChildren) {
					my_pc.full_btn.mouseChildren = true;
					if (my_pc.full_btn.state == "full") {
						my_fpcm.unActiveItem = "全    屏";
					} else {
						my_fpcm.unActiveItem = "退出全屏";
					}
				}
				my_fpcm.unActiveItem = "播    放";

				if (!my_pc.stop_btn.mouseChildren) {
					my_pc.stop_btn.mouseChildren = true;
				}
				stream.NStream.resume();

				isPlaying = true;
				if (seekError) {
					seekError = false;
				}
				mySkin.removeEventListener(Event.ENTER_FRAME,soundEaseOut);

				try {
					if (my_pc.sound.getVolume()!=0) {
						stream.NStream.soundTransform = new SoundTransform(volume);
					}
				} catch (e:Error) {

				}
				try {
					if (!timer.running) {
						if (!_adPlaying) {
							timer.start();
						}
					}
				} catch (e:Error) {
				}
				_state = "play";
				dispatchEvent(new Event("onPlay"));
			}
		}
		private function pauseHandler():void
		{
			if (stream!=null) {
				bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
				bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
				bigPlay_btn.visible = true;

				stream.NStream.pause();
				isPlaying = false;
				if (stream.NStream.bytesLoaded==stream.NStream.bytesTotal) {
					timer.stop();
				}
				my_fpcm.unActiveItem = "暂    停";

				_state = "pause";
				this.dispatchEvent(new Event("onPause"));
			}
		}
		//参数：0||undefined>>按视频比例调整
		//      1>>铺满窗口
		//      2>>原始大小
		//      3>>以16:9播放
		//      4>>以4:3播放
		private function adjustSize(trans:Boolean = false):void
		{
			var size:Object = Tool.getViewSize(view_w-2,view_h,flvWidth,flvHeight,adjustType);
			video.width = Math.round(size.width);
			video.height = Math.round(size.height);

			video.x = video_bg.x + (video_bg.width - video.width)/2;
			video.y = video_bg.y + (video_bg.height - video.height)/2;
		}
		private function clickHandler(event:MouseEvent):void
		{
			if (my_pc.play_btn.state == "play") {
				my_pc.play_btn.state = "pause";
				pauseHandler();
			} else {
				my_pc.play_btn.state = "play";
				playHandler();
			}
		}
		private function windHandler(event:MouseEvent):void
		{
			if (my_pc.full_btn.state == "full") {
				my_pc.full_btn.state = "normal";
				normalScreen();
			} else {
				my_pc.full_btn.state = "full";
				fullScreen();
			}
		}
		private function showMsgTipHandler(msg:String):void
		{
			try {
				mySkin.setChildIndex(my_mt,mySkin.numChildren-1);
			} catch (e:Error) {
			}
			my_mt.showTip(msg);
		}
		//10秒内是否连接上netstream的检查
		private function streamConnetCheck():void
		{
			clearTimeout(sdTimeout);
			if (sdCheckTimes==1) {
				sdCheckTimes = 2;
				sdTemp = 0;
				//参数，缓冲时间
				dataForQQ(0,10000);
			}
		}
		private function emptyTimeCheck():void
		{
			clearTimeout(sdTimeout);
			if (_state!="stop") {
				dataForQQ(1,10000);
			}
		}
		//API
		public function showMsgTip(msg:String):void
		{
			showMsgTipHandler(msg);
		}
		public function hideMsgTip():void
		{
			my_mt.hideTip();
		}
		//切换视频
		public function playVideo(path:String):void
		{
			if (path=="") {
				throw new Error("请提供非空的视频地址!");
				return;
			}
			if (timer!=null) {
				//停止当前的视频
				if (timer.running) {
					timer.stop();
				}
				playInit();
			}
			//初始化播放器
			if (my_pc.play_btn.state == "pause") {
				my_pc.play_btn.state = "play";
				bigPlay_btn.visible = false;
			}
			//
			_state = "request";
			_error = false;
			//加载新的视频
			if (!_adPlaying) {
				//设置定时器
				clearTimeout(sdTimeout);
				sdTimeout = setTimeout(streamConnetCheck,10000);
				//第一次检查
				sdCheckTimes = 1;
				//用于统计
				sdTemp = getTimer();

				my_pc.mouseChildren = true;

				_flvHost = Tool.getHostFromURL(path);
				flvPath = path;
				dataHasForWWJS2 = false;
				dataForWWJS2(0,2,-1);

			} else {
				my_pc.mouseChildren = false;
			}
			try {
				ExternalInterface.call("console.info","开始加载视频："+path);
			} catch (e:Error) {
				trace("调用外部JS方法错误");
			}
			video.visible = false;

			try {
				if (_adPlaying) {
					video_ct.buttonMode = true;
					stream.load(path,1);
				} else {
					video_ct.buttonMode = false;
					stream.load(path,10);
				}
			} catch (e:Error) {
				trace(e);
			}
			stream.client.addEventListener(StreamEvent.STREAM_MD,mdHandler);
		}
		//停止后要重新播放时调用
		public function resume():void
		{
			if (!isPlaying&&stream.NStream.time>=0) {
				my_pc.play_btn.state = "play";
				isPlaying = true;
				playHandler();
			}
		}
		//暂停播放
		public function pause():void
		{
			if (isPlaying&&stream.NStream.time>=0) {
				my_pc.play_btn.state = "pause";
				isPlaying = false;
				pauseHandler();
			}
		}
		//停止
		public function stop():void
		{
			if (_state=="play") {
				mySkin.addEventListener(Event.ENTER_FRAME,soundEaseOut);
			}
			//ExternalInterface.call("alert","stop()");
			stopHandler(null);
		}
		//恢复初始状态
		//恢复初始状态
		public function reset():void
		{
			if (my_pc.play_btn.state == "play") {
				//禁止使用进度条
				my_pc.seekBar.mouseChildren = false;
				my_pc.stop_btn.mouseChildren = false;
				my_pc.sound.mouseChildren = false;
				my_pc.full_btn.mouseChildren = false;

				my_fpcm.screenUnActive = false;

				my_pc.play_btn.mouseChildren = true;

				bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
				bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
				bigPlay_btn.visible = true;
				//禁止使用暂停和停止按钮
				my_pc.play_btn.state = "pause";
			}
			_flvTitle = "";
			_state = "init";
			my_mt.hideTip();
		}
		//关闭当前的播放
		public function closeVideo():void
		{
			try {
				stream.NStream.pause();
				if (timer.running) {
					timer.stop();
				}
				mySkin.removeEventListener(Event.ENTER_FRAME,soundEaseOut);
				my_pc.seekBar.position = 0;
				my_pc.seekBar.loadingWidth = 0;
				stream.closeVideo();
				video.clear();
				video.visible = false;
				_newFlv = true;
				_state = "init";
				//删除统计上报
				clearInterval(sdTimeout);
			} catch (e:Error) {
				trace("关闭视频出错:"+e);
			}
		}
		public function mute_unmute(v:Number):Boolean
		{
			var rl:Boolean = true;
			try {
				if (v==0) {
					stream.NStream.soundTransform = new SoundTransform(0);
					my_pc.sound.setVolume(0);
				} else {
					my_pc.sound.setVolume(volume);
					stream.NStream.soundTransform = new SoundTransform(volume);
				}
			} catch (e:Error) {
				rl = false;
			}
			return rl;
		}
		public function hideBigPlayButton(b:Boolean):void
		{
			if (b) {
				//隐藏
				bigPlay_btn.visible = false;
			} else {
				//显示
				bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
				bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
				bigPlay_btn.visible = true;
			}
		}
		//为片尾推荐调整视频窗口大小的接口
		public function adjustSizeForEV(size:Rectangle = null):void
		{
			if (size==null) {
				my_pc.seekBar.mouseChildren = true;
				video_bg.x = 0;
				video_bg.y = 0;
				video_bg.width = view_w;
				video_bg.height = view_h;
				adjustSize(false);
				try {
					video_ct.removeChildAt(0);
				} catch (e:Error) {
				}
			} else {
				my_pc.seekBar.mouseChildren = false;
				video_bg.x = size.x;
				video_bg.y = size.y;
				video_bg.width = size.width;
				video_bg.height = size.height;

				var v_size:Object = Tool.getViewSize(size.width,size.height,flvWidth,flvHeight,adjustType);

				video.width = Math.round(v_size.width);
				video.height = Math.round(v_size.height);

				video.x = video_bg.x + (video_bg.width - video.width)/2;
				video.y = video_bg.y + (video_bg.height - video.height)/2;
				if (video_ct.numChildren>2) {
					try {
						video_ct.removeChildAt(0);
					} catch (e:Error) {
					}
				}
				var border_sp:Shape = new Shape();
				border_sp.graphics.beginFill(0xcccccc,1);
				border_sp.graphics.drawRect(0,0,size.width+2,size.height+2);
				border_sp.graphics.endFill();
				video_ct.addChildAt(border_sp,0);
				border_sp.x = video_bg.x - 1;
				border_sp.y = video_bg.y - 1;
			}
		}
		//是否显示边框
		public function showBorder(b:Boolean):void
		{
			video_border.visible = b;
		}
		//-----------
		public function set playState(state:String):void
		{
			if (state=="play") {
				my_pc.play_btn.state = "play";
				bigPlay_btn.visible = false;
			} else {
				my_pc.play_btn.state = "pause";
				bigPlay_btn.x = (view_w - bigPlay_btn.width)/2;
				bigPlay_btn.y = (view_h - bigPlay_btn.height)/2;
				bigPlay_btn.visible = true;
			}
		}
		public function get viewWindows():Rectangle
		{
			return new Rectangle(video_ct.x,video_ct.y,video_bg.width,video_bg.height);
		}
		public function get controlBarWindow():Rectangle
		{
			var rRect:Rectangle = new Rectangle();
			try {
				rRect.x = my_pc.x;
				rRect.y = my_pc.y;
				rRect.width = my_pc.bg_mc.width;
				rRect.height = my_pc.bg_mc.height;
			} catch (e:Error) {
			}
			return rRect;
		}
		public function get skin():*
		{
			return mySkin;
		}
		public function get videoWindow():Sprite
		{
			return video_ct;
		}
		public function get isFull():Boolean
		{
			if (my_pc.full_btn.state == "normal") {
				return false;
			} else {
				return true;
			}
		}
		public function get playState():String
		{
			return _state;
		}
		public function set flvType(t:uint):void
		{
			if (t!=0&&t!=1&&t!=2) {
				t = 0;
			}
			_flvType = t;
		}
		public function get flvType():uint
		{
			return _flvType;
		}
		//----------------------------统计------------------------------------
		public function set flvTitle(t:String):void
		{
			_flvTitle = t;
		}
		public function set from(f:String):void
		{
			_from = f;
		}
		public function set vid(vid:String):void
		{
			_vid = vid;
		}
		public function set vtype(vt:uint):void
		{
			_vtype = vt;
		}
		public function set playerType(pt:String):void
		{
			/*
			必填: type 
			   0:  "qqlive";
			   1:  "web_boke";
			  2:  "web_news";
			   3:  "web_oy";
			   default: "unkown";
			*/
			_playerType = pt;
		}
		//公司统计CGI
		private function dataForQQ(type:uint = 1,time:uint=10000):void
		{
			var cgi:String = "http://isdspeed.qq.com/cgi-bin/v.cgi";
			var data:Object = {};
			/*
			参数值：
			flag1："9002",这个是固定的
			flag2：vt
			flag3：0 请求视频连接;1 缓冲
			flag5：播放器类型，0:  "qqlive";1:  "web_boke";2:  "web_news";3:  "web_oy";default: "unkown";
			1：视频请求或者连接的时间长度，和flag3对应
			*/
			data.flag1 = "9002";
			data.flag2 = _vtype;
			data.flag3 = type;
			data.flag5 = _playerType;
			data["1"] = time;
			data.ran = Math.random();
			StatDot.dataForServer(data,cgi,"GET");
		}
		//给华老师的统计上报1
		private function dataForWWJS1():void
		{
			//视频加载错误，向WWJS提交数据
			//http://ts.qqlive.qq.com/cgi-bin/report_url404.cgi?key=test&url=testurl&type=wsf
			var url:String="null";
			var cgi:String = "http://ts.qqlive.qq.com/cgi-bin/report_url404.cgi";
			try {
				url = String(ExternalInterface.call("eval","location.href"));
			} catch (e:Error) {
				//trace(e);
			}
			if (url.indexOf("?")>=0) {
				url+="&type=swf";
			} else {
				url+="?type=swf";
			}
			url = Tool.getStrUnicode(url);
			var url1:String = Tool.getStrUnicode(_flvHost);

			StatDot.dataForServer({key:Tool.getStrUnicode(_vid),url:url,url1:url1,ran:Math.random(),mode:1},cgi,"GET");
		}
		//给华老师的统计上报2
		private function dataForWWJS2(st:uint = 0,code:uint = 2,bc:Number = -1):void
		{
			//http://ts.qqlive.qq.com/cgi-bin/report_url.cgi?url=abc&key=def&error=100
			var cgi:String = "http://ts.qqlive.qq.com/cgi-bin/report_url.cgi";
			var pageUrl:String="null";
			try {
				pageUrl = String(ExternalInterface.call("eval","location.href"));
			} catch (e:Error) {
				//trace(e);
			}
			/*
			统计参数说明：
			key        :swf播放的视频id
			name       :    swf播放的视频名称
			mode       :    默认为１即可
			url        :swf播放的视频的url
			pageUrl    :swf所以网页的url
			type       :播放器类型，0:  "qqlive";1:  "web_boke";2:  "web_news";3:"web_oy";default: "unkown";
			code       :上报数据类型(1为url不存在，2为域名统计上报，头部提供的总时间和视频播放的实际时间长度误差比较大，判断规则:总时间/时间播放时长>5%)
			blockcount :数据缓冲块数（如果是开始播放或者拉取视频错误的话，就提交-1,如果是播放结束的话，就提供观看这个视频总共缓冲的次数）
			vtype      :    vt
			  Status     :    0,开始请求视频；1，请求到视频数据；2，视频播放完
			*/
			var data:Object = {};

			data.key = Tool.getStrUnicode(_vid);
			data.name = _flvTitle==""?"null":_flvTitle;
			data.mode = "1";
			data.pageUrl = Tool.getStrUnicode(pageUrl);
			data.url = Tool.getStrUnicode(flvPath);
			data.type = _playerType;
			data.code = code;
			data.status = st;
			data.blockcount = bc;
			data.vtype = _vtype;
			data.ran = Math.random();

			StatDot.dataForServer(data,cgi,"GET");
		}
		//---------------------------------------------------------------------------
		public function get time():Number
		{
			try {
				return stream.NStream.time;
			} catch (e:Error) {
			}
			return 0;
		}
		public function get adDuration():uint
		{
			return totalTime;
		}
		//全屏的时候暂停和恢复鼠标检查
		public function mouseCheckPause():void
		{
			if (my_pc.full_btn.state == "full") {
				hideAbled = false;
			}
		}
		public function mouseCheckResume():void
		{
			if (my_pc.full_btn.state == "full") {
				hideAbled = true;
			}
		}
		//是否播放广告
		public function set adPlaying(b:Boolean):void
		{
			_adPlaying = b;
		}
		public function get adPlaying():Boolean
		{
			return _adPlaying;
		}
		//
		public function set newFlv(b:Boolean):void
		{
			_newFlv = b;
		}
		//
		public function set adLink(link:String):void
		{
			_adLink = link;
		}
		//是否显示控制栏
		public function set contrlShow(b:Boolean):void
		{
			_contrlShow = b;
			try {
				my_pc.visible = b;
			} catch (e:Error) {
				trace(e);
			}
		}
		public function set list(b:Boolean):void
		{
			_list = b;
		}
	}
}