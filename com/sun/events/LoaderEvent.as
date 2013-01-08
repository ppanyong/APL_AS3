package com.sun.events{
	/**
	文件加载的事件类
	sonsun
	2008.2.22
	*/
	import flash.events.Event;

	public class LoaderEvent extends Event {
		public static  const LOAD_COMPLETE:String = "load_complete";
		public static  const LOAD_PROGRESS:String = "load_progress";
		public static  const LOAD_ERROR:String = "load_error";

		public var value:*;
		public function LoaderEvent(type:String,value:* = -1) {
			super(type);
			this.value = value;
		}
		public override function toString():String {
			return super.toString() + " value=" + value;
		}
	}
}