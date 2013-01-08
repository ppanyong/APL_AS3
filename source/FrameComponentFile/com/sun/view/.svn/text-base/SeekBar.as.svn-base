package com.sun.view{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
//	import flash.system.Security;

	import com.sun.utils.DragBar;
	import com.sun.events.DragEvent;
	import com.sun.events.SeekBarEvent;

	public class SeekBar extends MovieClip {
		private var db:DragBar;
		public var bar_mc : MovieClip;
		public var drag_mc : MovieClip;

		public function SeekBar() {
			init();
		}
		private function init():void {
			bar_mc.loading_mc.width = 0;
			db = new DragBar(bar_mc,drag_mc,new Rectangle(0,drag_mc.y,bar_mc.bg_mc.width - drag_mc.width,0));
			db.addEventListener(DragEvent.DRAG_START,dragStartHandler);
			db.addEventListener(DragEvent.DRAG_STOP,dragStopHandler);
			db.addEventListener(DragEvent.DRAGING,dragingHandler);
		}
		
		private function dragStartHandler(event:DragEvent):void{
			dispatchEvent(new SeekBarEvent(SeekBarEvent.SEEK_START));
		}
		private function dragStopHandler(event:DragEvent):void{
			dispatchEvent(new SeekBarEvent(SeekBarEvent.SEEK_STOP));
		}
		private function dragingHandler(event:DragEvent):void{
			dispatchEvent(new SeekBarEvent(SeekBarEvent.SEEKING));
		}
		
		public function setWidth(w:Number):void {
			if(bar_mc.loading_mc.width == bar_mc.bg_mc.width){
				bar_mc.loading_mc.width = w;
				//
				var rect:Rectangle = db.dragRange;
				rect.width = bar_mc.loading_mc.width;
				db.dragRange = rect;
			}
			trace("setWidth="+w);
			db.setValue(w);
		}
		//返回和设置拖动条的位置,以%的形式返回
		public function set loadingWidth(n:Number):void{
			bar_mc.loading_mc.width = bar_mc.bg_mc.width*n;
			//
			var rect:Rectangle = db.dragRange;
			rect.width = bar_mc.loading_mc.width;
			db.dragRange = rect;
		}
		public function set position(n:Number):void {
			db.position = n;
		}
		public function get position():Number {
			return db.position;
		}
	}
}