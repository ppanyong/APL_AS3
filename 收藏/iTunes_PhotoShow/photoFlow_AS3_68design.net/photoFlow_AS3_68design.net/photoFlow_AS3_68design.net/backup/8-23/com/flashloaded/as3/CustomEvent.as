package com.flashloaded.as3{
	import flash.events.Event;
	
	
	dynamic public class CustomEvent extends Event{
		
		
		public function CustomEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false){
			super(type,bubbles,cancelable);
		}
	}
}