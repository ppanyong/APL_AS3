package com.sun.events{
	/**
	文件加载的事件类
	sonsun
	2008.2.22
	*/
	import flash.events.*;

	public class TialDriverEvent extends Event {
		public static  const CHANGE:String = "change";
		public static  const COMPLETE:String = "complete";

		public var value:*;
		public function TialDriverEvent(type:String,value:* = -1) {
			super(type);
			this.value = value;
		}
		public override function toString():String {
			return super.toString() + " value=" + value;
		}
	}
}