package com.FSC.FLVPlayer {
	import flash.display.SimpleButton;	
	
	import com.sun.view.StopButton;	
	import com.sun.view.SoundControl;	
	import com.sun.events.PlayEvent;	
	import com.sun.view.PlayButton;	
	import com.sun.view.SeekBar;	
	
	import flash.display.MovieClip;	
	import flash.display.Sprite;
	import flash.events.*;
	import com.sun.*;
	import com.sun.events.SeekBarEvent;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import fl.video.VideoProgressEvent;
	
	import com.sun.events.SoundEvent;
	
	/**
	 * @author andypan
	 * @deprecated 整合在一起的FLV 使用了QQ定义的Skin
	 */
	public class FlvPlayer extends Sprite {
		private var _sourceurl:String;
		public var FLVPB:FLVPlayback = new FLVPlayback();
		public var controlBar_mc:MovieClip;
		public var seekBar:SeekBar = new SeekBar();
		public var play_btn:PlayButton = new PlayButton();
		public var sound:SoundControl = new SoundControl();
		public var stop_btn:StopButton = new StopButton();
		public var pre:SimpleButton;
		public var next:SimpleButton;
		
		public function FlvPlayer() {
			init();
		}
		
		private function init():void {
			//FLVPB.seekBar = seekBar;
			initCotrl();
			FLVPB.addEventListener(VideoProgressEvent.PROGRESS , flvloadprogresshandler);
			FLVPB.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, flvplayinghandler);
			FLVPB.addEventListener(VideoEvent.PLAYHEAD_UPDATE , flvplayingupdatehandler);
			FLVPB.addEventListener(VideoEvent.STOPPED_STATE_ENTERED , flvstoppedhandler);
			//安装控制插件的事件
			controlBar_mc.seekBar.addEventListener(SeekBarEvent.SEEK_START, seek_startHandler);
			controlBar_mc.seekBar.addEventListener(SeekBarEvent.SEEK_STOP,seek_stopHandler);
			controlBar_mc.play_btn.addEventListener(PlayEvent.PLAY,playHandler);
			controlBar_mc.play_btn.addEventListener(PlayEvent.PAUSE, pauseHandler);
			controlBar_mc.sound.addEventListener(SoundEvent.SOUND_CHANGE, soundChangeHandler);
			controlBar_mc.sound.addEventListener(SoundEvent.SOUND_MUTE, muteChangeHandler);
			controlBar_mc.sound.addEventListener(SoundEvent.SOUND_UNMUTE, soundChangeHandler);
			controlBar_mc.stop_btn.addEventListener(MouseEvent.CLICK, stopHandler)
			//sound.changeMuteState();
			
			//controlBar_mc.pre.addEventListener(MouseEvent.CLICK, prehandler)
			//controlBar_mc.next.addEventListener(MouseEvent.CLICK, nexthandler)
		}
		private function prehandler(e:MouseEvent):void{
			this.dispatchEvent(new Event("pre",true))
		}
		private function nexthandler(e:MouseEvent):void{
			this.dispatchEvent(new Event("next",true))
		}
		private function initCotrl():void{
			controlBar_mc.seekBar.position=0;
			controlBar_mc.seekBar.loadingWidth=0;
			controlBar_mc.play_btn.state = "pause";
		}
		function flvstoppedhandler(e:VideoEvent){
			trace("stop")
			controlBar_mc.play_btn.state = "pause";
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		function stopHandler(e:MouseEvent){
			FLVPB.stop();
			FLVPB.seekSeconds(0);
			controlBar_mc.seekBar.position =0;
		}
		function soundChangeHandler(e:SoundEvent){
			FLVPB.volume = controlBar_mc.sound.getVolume();
			controlBar_mc.sound.changeMuteState("unmute");
		}
		function muteChangeHandler(e:SoundEvent){
			FLVPB.volume=0;
		}
		/**
		 * 播放时调度
		 */
		function flvplayingupdatehandler(se:VideoEvent){
			controlBar_mc.seekBar.position = FLVPB.playheadPercentage/100;
			
			controlBar_mc.time_txt.htmlText = "<b><font color='#000000'>"+sTostring(FLVPB.playheadTime)+"</font></b>"+"<font color='#000000'>"+"/"+sTostring(FLVPB.totalTime)+"</font>";
		}
		function flvplayinghandler(se:VideoEvent){
				controlBar_mc.play_btn.state = "play";
				controlBar_mc.sound.setVolume(FLVPB.volume);
				
				controlBar_mc.time_txt.htmlText = "<b><font color='#000000'>"+sTostring(FLVPB.playheadTime)+"</font></b>"+"<font color='#000000'>"+"/"+FLVPB.totalTime+"</font>";
		}
		function playHandler(e:PlayEvent){
			FLVPB.play();
		}
		function pauseHandler(e:PlayEvent){
			FLVPB.pause();
		}
		function seek_startHandler(se:SeekBarEvent){
			FLVPB.removeEventListener(VideoEvent.PLAYHEAD_UPDATE , flvplayingupdatehandler);
		}
		function seek_stopHandler(se:SeekBarEvent){
			//trace(se+" position="+controlBar_mc.seekBar.position)
			FLVPB.seekPercent(controlBar_mc.seekBar.position*100);
			FLVPB.addEventListener(VideoEvent.PLAYHEAD_UPDATE , flvplayingupdatehandler);
		}
		function flvloadprogresshandler(e:VideoProgressEvent){
			//trace(e);[ProgressEvent type="progress" bubbles=false cancelable=false eventPhase=2 bytesLoaded=13970377 bytesTotal=13970377]
			controlBar_mc.seekBar.loadingWidth = e.bytesLoaded/e.bytesTotal;
		}
		public function get sourceurl() : String {
			return _sourceurl;
		}
		
		public function set sourceurl(sourceurl : String) : void {
			if(_sourceurl != sourceurl){
				_sourceurl = sourceurl;
				FLVPB.source=sourceurl;
				initCotrl();
			}
		}
		private function sTostring(s:Number):String{
			return Math.floor(s/60)+":"+Math.floor(s%60);
		}
	}
}
