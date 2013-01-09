package com.andy.utility {
	import flash.display.Sprite
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;

	public class FPSShow extends Sprite {
		private var txt : TextField;
		private var count : int = 0

		public function FPSShow() {
			init()
		}

		private function init() {
			txt = new TextField();
			//创建文本实例
			txt.textColor = 0xff0000;
			//设置文本颜色
			addChild(txt)
			//加载这个文本
			var myTimer : Timer = new Timer(1000);
			//Timer类挺好使，类似于setInterval,参数是循环间隔时间，单位是毫秒
			myTimer.addEventListener("timer", timerHandler);
			//注册事件
			this.addEventListener("enterFrame", countHandler)
			//注册事件，这里相当于2.0的onEnterFrame
			myTimer.start();//Timer实例需要start来进行启动
		}

		private function timerHandler(event : TimerEvent) {
			//Timer实例调用的方法
			txt.text = "FPS:" + count
			count = 0//每隔1秒进行清零
		}

		private function countHandler(event : Event) {
			//真循环调用的方法
			count++//数值递加
		}
	}
}
