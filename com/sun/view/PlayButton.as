package com.sun.view{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
//	import flash.system.Security;

	import com.sun.events.PlayEvent;

	public class PlayButton extends MovieClip {
		public var sign_mc : MovieClip;
		
		public function PlayButton() {
			init();
		}
		private function init():void {
//			Security.allowDomain("cache.tv.qq.com");
//			Security.allowDomain("imgcache.qq.com");
//			Security.allowDomain("dev.video.qq.com");
//			Security.allowDomain("video.qq.com");
//			Security.allowDomain("static.video.qq.com");
//			
//			Security.allowDomain("sonsun.qq.com");
			
			this.sign_mc.pause_btn.visible = false;
			eventsConfig();
		}
		private function eventsConfig():void {
			this.sign_mc.pause_btn.addEventListener(MouseEvent.MOUSE_UP,up);
			this.sign_mc.play_btn.addEventListener(MouseEvent.MOUSE_UP,up);
		}
		private function up(event:MouseEvent):void {
			this.sign_mc.pause_btn.visible=! this.sign_mc.pause_btn.visible;
			this.sign_mc.play_btn.visible=! this.sign_mc.play_btn.visible;
			if (this.sign_mc.pause_btn.visible) {
				dispatchEvent(new PlayEvent(PlayEvent.PLAY));
			} else {
				dispatchEvent(new PlayEvent(PlayEvent.PAUSE));
			}
		}
		
		public function set active(b:Boolean):void{
			this.sign_mc.pause_btn.enabled = this.sign_mc.play_btn.enabled = b;
			if(b){
				this.sign_mc.pause_btn.addEventListener(MouseEvent.MOUSE_UP,up);
				this.sign_mc.play_btn.addEventListener(MouseEvent.MOUSE_UP,up);
			}else{
				this.sign_mc.pause_btn.removeEventListener(MouseEvent.MOUSE_UP,up);
				this.sign_mc.play_btn.removeEventListener(MouseEvent.MOUSE_UP,up);
			}
		}
		
		public function set state(sign:String):void {
			if (sign == "play") {
				this.sign_mc.pause_btn.visible=true;
			} else {
				this.sign_mc.pause_btn.visible=false;
			}
			this.sign_mc.play_btn.visible=! this.sign_mc.pause_btn.visible;
		}
		public function get state():String{
			if(this.sign_mc.play_btn.visible){
				return "pause";
			}else{
				return "play";
			}
		}
		
	}
}