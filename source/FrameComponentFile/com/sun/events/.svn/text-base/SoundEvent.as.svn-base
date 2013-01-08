package com.sun.events{
	import flash.events.Event;
	
	public class SoundEvent extends Event{
		public static const SOUND_CHANGE:String = "sound_change";
		public static const SOUND_MUTE:String = "sound_mute";
		public static const SOUND_UNMUTE:String = "sound_unmute";
		
		public var value:*;
		public function SoundEvent(type:String,value:* = -1){
			super(type);
			this.value = value;
		}
		public override function toString():String{
			return super.toString() + " value=" + value;
		}
	}
}