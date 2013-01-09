package com.kamon.Astar{
	import flash.events.Event;
	public class ChangeMapEvent extends Event {
		public static  const CHANGE_MAP:String="CHANGE_MAP";
		private var _nextMapId:uint;
		public function ChangeMapEvent() {
			super(CHANGE_MAP,true);
		}
		public function set nextMapId(changeId:uint):void {
			_nextMapId=changeId;
		}
		public function get nextMapId():uint {
			return _nextMapId;
		}
	}
}