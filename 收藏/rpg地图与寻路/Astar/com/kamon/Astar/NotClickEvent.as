package com.kamon.Astar{
	import flash.events.Event;
	public class NotClickEvent extends Event {
		public static  const WALK_END:String="WALK_END";
		public function NotClickEvent() {
			super(WALK_END,true);
		}
	}
}