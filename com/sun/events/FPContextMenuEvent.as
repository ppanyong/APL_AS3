package com.sun.events{
	import flash.events.Event;
	
	public class FPContextMenuEvent extends Event{
		public static const MENU_SELECTED:String = "menu_selected";
		
		public var value:*;
		public function FPContextMenuEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}