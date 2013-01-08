package com.sun.events{
	/**
	自定义单双击事件
	*/
	import flash.events.Event;
	
	public class ClickEvent extends Event{
		public static const CLICK:String = "click";
		public static const DOUBLE_CLICK:String = "double_click";
		
		public var value:*;
		public function ClickEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}