package com.sun.utils{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import com.sun.events.TialDriverEvent;

	public class TialDriver extends EventDispatcher {
		//转一圈涉及的操作对象的总个数
		private var _ttPCircle:uint;
		//Timer调用的频率
		private var _speed:uint = 20;
		private var _changeSpeed:uint = 10;
		//============================
		private var run_id:uint;
		private var steps:int;
		private var timer:Timer;
		//Timer的执行时间
		public function set runSpeed(s:uint):void{
			if(s<5){
				s=5;
			}
			if(s>100){
				s=100;
			}
			_speed = s;
		}
		//转动一圈经过的元件个数
		public function set totalPerCircle(n:uint):void {
			_ttPCircle = n;
		}
		//数值的提交频率
		public function set changeSpeed(n:uint):void{
			_changeSpeed = n;
		}
		public function get changeSpeed():uint{
			return _changeSpeed;
		}
		
		public function start():void {
			if (timer==null) {
				timer = new Timer(_speed);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
			}
			if (!timer.running) {
				//初始化变量
				run_id = 0;
				steps = 0;
				
				timer.start();
			} else {
				throw new Error("当前转动没有完成，请完成后再调用");
			}
		}
		
		public function stop():void{
			if(timer.running){
				timer.stop();
			}else{
				throw new Error("当前没有运行,无法停止");
			}
		}
		private function timerHandler(event:TimerEvent):void {
			steps++;
			if (steps%changeSpeed==0) {
				var id:uint = run_id%_ttPCircle;
				//广播事件
				dispatchEvent(new TialDriverEvent(TialDriverEvent.CHANGE,id));
				run_id++;
			}
			
			event.updateAfterEvent();
		}
	}
}