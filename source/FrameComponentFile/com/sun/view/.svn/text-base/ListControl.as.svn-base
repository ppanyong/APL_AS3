package com.sun.view{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
//	import flash.system.Security;
	
	import com.sun.events.ListControlEvent;
	
	public class ListControl extends MovieClip
	{
		public function ListControl()
		{
//			Security.allowDomain("cache.tv.qq.com");
//			Security.allowDomain("imgcache.qq.com");
//			Security.allowDomain("dev.video.qq.com");
//			Security.allowDomain("video.qq.com");
//			Security.allowDomain("static.video.qq.com");
//			
//			Security.allowDomain("sonsun.qq.com");
			init();
		}
		private function init():void
		{
			preMc.buttonMode = true;
			nextMc.buttonMode = true;
			preMc.addEventListener(MouseEvent.MOUSE_UP,prevHandler);
			nextMc.addEventListener(MouseEvent.MOUSE_UP,nextHandler);
		}
		private function prevHandler(event:MouseEvent):void
		{
			dispatchEvent(new ListControlEvent(ListControlEvent.SELECTED_CHANGE,-1));
		}
		private function nextHandler(event:MouseEvent):void
		{
			dispatchEvent(new ListControlEvent(ListControlEvent.SELECTED_CHANGE,1));
		}
		public function setItems(title1:String,title2:String):void
		{
			preMc.txt.text = title1;
			nextMc.txt.text = title2;
		}
		public function setWidth(w:Number):void
		{
			bg_mc.width = w;
			preMc.x = (w/2-preMc.width)/2;
			nextMc.x = w/2+(w/2-preMc.width)/2;
		}
	}
}