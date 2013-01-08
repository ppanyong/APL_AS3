package com.sun.events{
	import flash.events.Event;
	
	public class ListControlEvent extends Event{
		public static const SELECTED_CHANGE:String = "selected_change";
		
		public var value:*;
		public function ListControlEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}