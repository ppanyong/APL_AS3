package com.sun.utils{
	/*
	自定义双击类
	*/
	import com.sun.events.ClickEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	public class DoubleClick extends EventDispatcher{
		private var doc:DisplayObjectContainer;
		private var timer:Timer;
		private var _time:uint;
		public function DoubleClick(tg:DisplayObjectContainer){
			super();
			doc = tg;
			init();
		}
		private function init():void{
			timer = new Timer(300);
			_time = 0;
			doc.addEventListener(MouseEvent.CLICK,clickHandler);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}
		private function clickHandler(event:MouseEvent):void{
			dispatchEvent(new ClickEvent(ClickEvent.CLICK));
			if(_time==0){
				_time = getTimer();
				timer.start();
			}else{
				if(getTimer()-_time<400){
					dispatchEvent(new ClickEvent(ClickEvent.DOUBLE_CLICK));
					timer.stop();
					_time = 0;
				}
			}
		}
		private function timerHandler(event:TimerEvent):void{
			timer.stop();
			_time = 0;
		}
	}
}