package com.FSC.UI.InterActiveObject {
	import flash.text.TextField;	
	import flash.geom.Rectangle;	
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;
	
	/**
	 * @author Andy
	 * 水平拉动条
	 */
	public class VScrollBar extends MovieClip {
		public var scrollBlack:MovieClip;
		public var scrollBg:MovieClip;
		public var showBg:MovieClip;
		private var scroll_lock : String;//
		public var showNumber_txt:TextField;
		public var MaxShowNumber:Number;
		private var __currentNumber:Number=0;
		
		public var scroll_percent : Number = 0;//外部可访问
		
		public function VScrollBar() {
			init_VScrollBar ();
		}
		private function init_VScrollBar ()
		{
			scrollBlack.x = scrollBg.x;
			scrollBlack.showBg.visible =false;
				scrollBlack.showNumber_txt.visible =false;
			//scrollBlack.y = scrollBg.y+scrollBg.height/2 - scrollBlack.height/2;
			scrollBlack.addEventListener(MouseEvent.MOUSE_DOWN,onPressHandler);
			scrollBlack.addEventListener(MouseEvent.MOUSE_UP,onUpHandler);
			scrollBlack.addEventListener(MouseEvent.MOUSE_MOVE,onMoveHandler);
			scrollBlack.addEventListener(MouseEvent.ROLL_OUT,onUpHandler);
			scrollBlack.addEventListener(MouseEvent.ROLL_OVER, onOverHandler);
			scrollBlack.addEventListener(MouseEvent.ROLL_OUT,onUpHandler);
			//total_height = Math.abs (show_scrollbg_mc.height - show_scroll_mc.height);
		}
		private function onOverHandler(e:MouseEvent){
			scrollBlack.showBg.visible =true;
			scrollBlack.showNumber_txt.visible =true;
		}
		private function onPressHandler(eve:MouseEvent) {
			this.addEventListener(Event.ENTER_FRAME, rotateDragging);// Add MOUSE_UP event to stage        
			stage.addEventListener(MouseEvent.MOUSE_UP, rotateDragStop);
		}
		private function rotateDragStop(evt:MouseEvent):void {
			// Stop drag        
			// Remove ENTER_FRAME event from mc  
			scroll_lock = "yes";
			this.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME, rotateDragging);
			// Remove MOUSE_UP event from stage        
			stage.removeEventListener(MouseEvent.MOUSE_UP, rotateDragStop);
		}
		private function rotateDragging(evt:Event):void {
			// 在鼠标按下后 释放前一直执行
			scroll_lock = "no";
			MyStartDrag();
		}
		private function MyStartDrag() {
			if (scroll_lock == "no") {
				var secondRect:Rectangle = new Rectangle(scrollBg.x,scrollBlack.y,scrollBg.width-scrollBlack.width,0);
				scrollBlack.startDrag(false, secondRect);
				scroll_percent = Math.ceil ((Math.abs (Math.abs (scrollBg.x - scrollBlack.x) / (scrollBg.width-scrollBlack.width)) * 100));
				__currentNumber= Math.ceil(MaxShowNumber*scroll_percent/100);
				scrollBlack.showNumber_txt.text= __currentNumber.toString();
				scrollBlack.showBg.visible =true;
				scrollBlack.showNumber_txt.visible =true;
				this.dispatchEvent(new Event("OnScroll",true));
			}
		}
		private function onUpHandler(eve:MouseEvent) {
			scroll_lock = "yes";
			scrollBlack.showBg.visible =false;
			scrollBlack.showNumber_txt.visible =false;
			scrollBlack.stopDrag();
			this.dispatchEvent(new Event("OnScrollEnd",true));
			
		}
		private function onMoveHandler(eve:Event) {
			if (scroll_lock == "no") {
				MyStartDrag();
			}
		}
		
		public function get currentNumber() : Number {
			return __currentNumber;
		}
		
		public function set currentNumber(__currentNumber : Number) : void {
			if(__currentNumber>=0 && __currentNumber<=this.MaxShowNumber){
			this.__currentNumber = __currentNumber;
			scrollBlack.showNumber_txt.text=__currentNumber;
			trace("this.MaxShowNumber"+this.MaxShowNumber)
			scrollBlack.x = (__currentNumber / this.MaxShowNumber)*(scrollBg.width-scrollBlack.width)+scrollBg.x;
			}
		}
	}
}
