package com.sun.view{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
//	import flash.system.Security;

	import com.sun.utils.DragBar;
	import com.sun.events.DragEvent;
	import com.sun.events.SoundEvent;
	
	public class SoundControl extends MovieClip{
		private var db:DragBar;
		public var bar_mc : MovieClip;
		public var drag_mc : MovieClip;
		public var mute_mc : MovieClip;

		public function SoundControl(){
//			Security.allowDomain("cache.tv.qq.com");
//			Security.allowDomain("imgcache.qq.com");
//			Security.allowDomain("dev.video.qq.com");
//			Security.allowDomain("video.qq.com");
//			Security.allowDomain("static.video.qq.com");
//			
//			Security.allowDomain("sonsun.qq.com");
			init();
		}
		private function init():void{
			db = new DragBar(bar_mc,drag_mc,new Rectangle(bar_mc.x-2,drag_mc.y,bar_mc.bg_mc.width - drag_mc.width+4,0));
			db.addEventListener(DragEvent.DRAGING,draging);
			db.addEventListener(DragEvent.DRAG_STOP,dragStop);
			//
			mute_mc.mute_btn.visible = false;
			//
			mute_mc.unmute_btn.addEventListener(MouseEvent.MOUSE_UP,unmute);
			mute_mc.mute_btn.addEventListener(MouseEvent.MOUSE_UP,mute);
			//
		}
		private function unmute(event:MouseEvent):void{
			mute_mc.unmute_btn.visible = false;
			mute_mc.mute_btn.visible = true;
			//
			dispatchEvent(new SoundEvent(SoundEvent.SOUND_MUTE));
		}
		private function mute(event:MouseEvent):void{
			mute_mc.unmute_btn.visible = true;
			mute_mc.mute_btn.visible = false;
			//
			dispatchEvent(new SoundEvent(SoundEvent.SOUND_UNMUTE));
		}
		private function draging(event:DragEvent):void{
			//trace(event.target.position);
			dispatchEvent(new SoundEvent(SoundEvent.SOUND_CHANGE));
		}
		private function dragStop(event:DragEvent):void{
			//trace(event.target.position);
			dispatchEvent(new SoundEvent(SoundEvent.SOUND_CHANGE));
		}
		private function setMuteStateHandler(sign:String = "mute"):void{
			if(sign=="mute"){
				mute_mc.unmute_btn.visible = false;
				mute_mc.mute_btn.visible = true;
			}else{
				mute_mc.unmute_btn.visible = true;
				mute_mc.mute_btn.visible = false;
			}
		}
		public function setVolume(v:Number):void{
			db.position = v;

			setMuteStateHandler(v==0?"mute":"unmute");
		}
		public function changeMuteState(sign:String = "mute"):void{
			setMuteStateHandler(sign);
		}
		public function getVolume():Number{
			return db.position;
		}
	}
}