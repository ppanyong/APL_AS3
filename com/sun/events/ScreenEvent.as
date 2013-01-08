package com.sun.events{
	import flash.events.Event;
	
	public class ScreenEvent extends Event{
		public static const FULL:String = "full";
		public static const NORMAL:String = "normal";
		
		public var value:*;
		public function ScreenEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}