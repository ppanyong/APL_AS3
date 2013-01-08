package com.sun.events{
	import flash.events.Event;
	
	public class PlayEvent extends Event{
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		
		public var value:*;
		public function PlayEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}