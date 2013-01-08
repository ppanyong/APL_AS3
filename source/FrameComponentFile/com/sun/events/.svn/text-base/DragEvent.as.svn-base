package com.sun.events{
	import flash.events.Event;
	
	public class DragEvent extends Event{
		public static const DRAG_START:String = "drag_start";
		public static const DRAG_STOP:String = "drag_stop";
		public static const DRAGING:String = "draging";
		
		public var value:*;
		public function DragEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}