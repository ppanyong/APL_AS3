package com.sun.view{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
//	import flash.system.Security;

	import com.sun.events.ScreenEvent;

	public class ScreenButton extends MovieClip {
		public var sign_mc : MovieClip;
		
		public function ScreenButton() {
//			Security.allowDomain("cache.tv.qq.com");
//			Security.allowDomain("imgcache.qq.com");
//			Security.allowDomain("dev.video.qq.com");
//			Security.allowDomain("video.qq.com");
//			Security.allowDomain("static.video.qq.com");
//			
//			Security.allowDomain("sonsun.qq.com");
			
			init();
		}
		private function init():void {
			this.sign_mc.full_close_btn.visible = false;
			eventsConfig();
		}
		private function eventsConfig():void {
			this.sign_mc.full_close_btn.addEventListener(MouseEvent.MOUSE_UP,up);
			this.sign_mc.full_btn.addEventListener(MouseEvent.MOUSE_UP,up);
		}
		private function up(event:MouseEvent):void {
			this.sign_mc.full_close_btn.visible=! this.sign_mc.full_close_btn.visible;
			this.sign_mc.full_btn.visible=! this.sign_mc.full_btn.visible;
			if (this.sign_mc.full_close_btn.visible) {
				dispatchEvent(new ScreenEvent(ScreenEvent.FULL));
			} else {
				dispatchEvent(new ScreenEvent(ScreenEvent.NORMAL));
			}
		}
		public function set active(b:Boolean):void{
			this.sign_mc.full_close_btn.enabled = this.sign_mc.full_btn.enabled = b;
			if(b){
				this.sign_mc.full_close_btn.addEventListener(MouseEvent.MOUSE_UP,up);
				this.sign_mc.full_btn.addEventListener(MouseEvent.MOUSE_UP,up);
			}else{
				this.sign_mc.full_close_btn.removeEventListener(MouseEvent.MOUSE_UP,up);
				this.sign_mc.full_btn.removeEventListener(MouseEvent.MOUSE_UP,up);
			}
		}
		public function set state(sign:String):void {
			if (sign == "full") {
				this.sign_mc.full_close_btn.visible=true;
			} else {
				this.sign_mc.full_close_btn.visible=false;
			}
			this.sign_mc.full_btn.visible=! this.sign_mc.full_close_btn.visible;
		}
		public function get state():String{
			if(this.sign_mc.full_btn.visible){
				return "normal";
			}else{
				return "full";
			}
		}
	}
}