package com.sun.events{
	import flash.events.Event;
	
	public class SeekBarEvent extends Event{
		public static const SEEK_START:String = "seek_start";
		public static const SEEK_STOP:String = "seek_stop";
		public static const SEEKING:String = "seeking";
		
		public var value:*;
		public function SeekBarEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}