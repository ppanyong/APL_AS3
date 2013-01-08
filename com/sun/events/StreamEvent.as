package com.sun.events{
	/**
	自定义NetStream类的事件类
	*/
	import flash.events.Event;
	
	public class StreamEvent extends Event{
		public static const STREAM_READY:String = "stream_ready";
		public static const STREAM_START_PLAY:String = "stream_start_play";
		public static const STREAM_EMPTY:String = "stream_empty";
		public static const STREAM_FULL:String = "stream_full";
		public static const STREAM_STOP:String = "stream_stop";
		public static const STREAM_ERROR:String = "stream_error";
		public static const STREAM_404:String = "stream_404";
		
		public static const STREAM_NOTIFY:String = "stream_notify";
		public static const STREAM_START_READY:String = "stream_start_ready";
		//提供值
		public static const STREAM_INVALIDTIME:String = "stream_invalidTime";
		//
		public static const STREAM_STATUS:String = "stream_status";
		//提供值
		public static const STREAM_MD:String = "stream_metaData";
		//这些事件是给NetConnection的
		public static const STREAM_NC_ERROR:String = "stream_nc_error";
		public static const STREAM_NC_CLOSED:String = "stream_nc_closed";
		//由于上面两个要提供值,所有构造函数接受一个不定类型的参数
		
		public var value:*;
		public function StreamEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}