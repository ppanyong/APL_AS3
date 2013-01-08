package com.FSC.UI.DateUI {
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.display.MovieClip;

	/**
	 * 时钟显示类
	 * @author Andy
	 * @version 1.080516
	 */
	public class Clock extends MovieClip {
		
		private var myTimer:Timer = new Timer(1000, 0);
		public var mc_HandSec : MovieClip;
		public var mc_HandMin : MovieClip;
		public var mc_Hand : MovieClip;

		public function Clock() {
			super();
			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
		}
		private function timerHandler(event:TimerEvent):void {
			var Time:Date = new Date();
			mc_HandSec.rotation = 6 * Time.getSeconds();
			mc_HandMin.rotation = 6 * Time.getMinutes();
			var o_Date:Date = new Date();
			var Hours:Number = o_Date.getHours();
			if (Hours > 12) {
				Hours = Hours - 12;
			}// end if
			mc_Hand.rotation = Hours * 30 + o_Date.getMinutes() / 2;
		}
	}
}
