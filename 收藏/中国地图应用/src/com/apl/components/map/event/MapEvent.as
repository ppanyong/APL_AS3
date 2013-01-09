package com.apl.components.map.event {
	import flash.display.MovieClip;	
	import flash.events.Event;

	public class MapEvent extends Event
	{
		public static var ITEMCLICK:String = "itemClick";
		public static var ITEMOVER:String="itemOver";
		public static var ITEMOUT:String="itemOut";
		public var MC:MovieClip;

		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}