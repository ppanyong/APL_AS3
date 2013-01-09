package com.kamon.Astar{
	import flash.events.Event;
	public class WalkEvent extends Event {
		public static  const WALK_START:String="walkStart";
		private var _walkArray:Array;
		public function WalkEvent() {
			super(WALK_START);
		}
		public function set walkArray(walkArr:Array):void {
			_walkArray=walkArr;
		}
		public function get walkArray():Array {
			return _walkArray;
		}
	}
}