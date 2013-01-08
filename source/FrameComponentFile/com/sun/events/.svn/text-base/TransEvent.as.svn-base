package com.sun.events{
	/**
	自定义过渡类的事件类
	*/
	import flash.events.Event;
	
	public class TransEvent extends Event{
		public static const TRANS_START:String = "trans_start";
		public static const TRANS_STOP:String = "trans_stop";
		
		public var value:*;
		public function TransEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}