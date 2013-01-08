package com.sun.utils{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import com.sun.events.DragEvent;

	public class DragBar extends Sprite {
		private var rect:Rectangle;
		private var drag_rect:Rectangle;
		private var _$v:Number;
		private var temp_v:Number;
		private var isDown:Boolean=false;
		private var bar:MovieClip;
		private var drag:MovieClip;
		private var _enbaled:Boolean = true;
		private var direction:String = "h";

		public function DragBar(bar:MovieClip,drag:MovieClip,rect:Rectangle,direc:String = "h") {
			this.bar=bar;
			this.drag=drag;
			this.rect=rect;
			drag_rect = new Rectangle(this.rect.x,this.rect.y,this.rect.width,this.rect.height);
			this.direction = direc;
			init();
			//trace("DragBar");
		}
		private function init():void {
			drag.stop();
			drag.buttonMode=true;
			//分开处理横向和竖向
			if (this.direction=="h") {
				//横向
				drag.x=rect.x;
				_$v=drag.x;
				bar.progress_mc.width=0;
				bar.hit_mc.width=bar.bg_mc.width;
			} else {
				//竖向
				drag.y=rect.y;
				_$v=drag.y;
				bar.progress_mc.height=0;
				bar.hit_mc.height=bar.bg_mc.height;
			}
			bar.hit_mc.x=bar.bg_mc.x;
			bar.hit_mc.y=bar.bg_mc.y;
			
			bar.bg_mc.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		private function enterFrameHandler(event:Event):void {
			if (drag.root != null) {
				bar.bg_mc.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
				//开始注册鼠标事件
				//rect=new Rectangle(bar.bg_mc.x,drag.y,bar.bg_mc.width - drag.width,0);
				drag.addEventListener(MouseEvent.MOUSE_DOWN,pressHandler);
				drag.addEventListener(MouseEvent.MOUSE_UP,releaseHandler,true);
				drag.root.stage.addEventListener(MouseEvent.MOUSE_UP,releaseHandler);

				//bar.hit_mc.addEventListener(MouseEvent.MOUSE_UP,bgReleaseHandler);
				bar.hit_mc.addEventListener(MouseEvent.MOUSE_DOWN,bgReleaseHandler);

				drag.buttonMode=true;
				drag.stage.frameRate=60;
				bar.hit_mc.buttonMode=true;
			}
		}
		private function pressHandler(event:MouseEvent):void {
			isDown=true;
			drag.startDrag(false,drag_rect);
			dispatchEvent(new DragEvent(DragEvent.DRAG_START));
			drag.root.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
		}
		private function releaseHandler(event:MouseEvent):void {
			if (! isDown) {
				return;
			}
			isDown=false;
			drag.stopDrag();
			dispatchEvent(new DragEvent(DragEvent.DRAG_STOP));
			drag.root.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
		}
		private function moveHandler(event:MouseEvent):void {
			if (this.direction=="h") {
				if (drag.x != _$v) {
					_$v=drag.x;
					//修改播放进度条的长度
					bar.progress_mc.width=(drag.x - rect.x)/rect.width * bar.bg_mc.width;
					//trace("width:"+bar.progress_mc.width+","+drag.x+","+rect.x+","+rect.width+","+bar.bg_mc.width);
				}
				dispatchEvent(new DragEvent(DragEvent.DRAGING));
			} else {
				if (drag.y != _$v) {
					_$v=drag.y;
					//修改播放进度条的长度
					bar.progress_mc.height=(drag.y - rect.y) / rect.height * bar.bg_mc.height;
				}
				dispatchEvent(new DragEvent(DragEvent.DRAGING));
			}
		}

		private function bgPressHandler(event:MouseEvent):void {
			dispatchEvent(new DragEvent(DragEvent.DRAG_START));
		}
		private function bgReleaseHandler(event:MouseEvent):void {
			//设置为drag的中间位置
			if (this.direction=="h") {
				drag.x=rect.x + event.currentTarget.parent.mouseX-drag.width/2;
				bar.progress_mc.width=(drag.x - rect.x) / rect.width * rect.width;
			} else {
				drag.y=rect.y + event.currentTarget.parent.mouseY - drag.height/2;
				bar.progress_mc.height=(drag.y - rect.y) / rect.height * rect.height;
			}
			dispatchEvent(new DragEvent(DragEvent.DRAG_STOP));
		}
		private function setValueHandler(n:Number):void {
			var p:Number=this.position;
			if (this.direction=="h") {
				bar.bg_mc.width=n;
				rect.width=bar.bg_mc.width - drag.width;
				bar.hit_mc.width=rect.width;
			} else {
				bar.bg_mc.height=n;

				rect.height=bar.bg_mc.height - drag.height;
				bar.hit_mc.height=rect.height;
			}
			this.position=p;
		}
		private function nullCheck(event:Event):void {
			setValue(temp_v);
		}
		//设置宽度或者高度的时候调用的 
		public function setValue(n:Number):void {
			if (n < 50) {
				n=50;
			}
			temp_v=n;

			if (rect == null) {
				bar.addEventListener(Event.ENTER_FRAME,nullCheck);
				return;
			}
			bar.removeEventListener(Event.ENTER_FRAME,nullCheck);

			setValueHandler(temp_v);
		}
		//返回和设置拖动条的位置,以%的形式返回
		public function set position(n:Number):void {
			if (n < 0) {
				n=0;
			}
			if (n > 1) {
				n=1;
			}
			//
			if (this.direction=="h") {
				drag.x=rect.x + rect.width * n;
				bar.progress_mc.width=n * rect.width;
			} else {
				drag.y=rect.y + rect.height * n;
				bar.progress_mc.height=n * bar.rect.height;
			}
		}
		public function get position():Number {
			var p:Number;
			if (this.direction=="h") {
				p=(drag.x - rect.x)/rect.width;
			} else {
				p=(drag.y - rect.y)/rect.height;
			}
			return p;
		}
		//设置滑块的拖动范围
		public function set dragRange(t_rect:Rectangle):void
		{
			drag_rect = t_rect;
			//修改hit_mc的范围
			if(this.direction=="h"){
				bar.hit_mc.width = bar.hit_mc.x + t_rect.width;
				if(drag_rect.width>rect.width){
					drag_rect.width = rect.width;
				}
			}else{
				bar.hit_mc.height = bar.hit_mc.y + t_rect.height;
				
				if(drag_rect.height>rect.height){
					drag_rect.height = rect.height;
				}
			}
		}
		public function get dragRange():Rectangle
		{
			return drag_rect;
		}
		
		public function get dragTarget():MovieClip{
			return drag;
		}
		public function get barTarget():MovieClip{
			return bar;
		}
	}
}