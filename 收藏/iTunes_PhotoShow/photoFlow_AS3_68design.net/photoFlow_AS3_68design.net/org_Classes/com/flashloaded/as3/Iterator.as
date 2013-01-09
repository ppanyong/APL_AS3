package com.flashloaded.as3{
	public class Iterator {
	// Constants:
		public static var CLASS_REF = com.flashloaded.as3.Iterator;
	// Public Properties:
	// Private Properties:
		private var index:int;
		private var arr:Array;
	// Initialization:
		public function Iterator(data:Array,startIndex:int=0) {
			arr=data;
			index=startIndex;
		}
		
		public function hasPrevious():Boolean{
			if(index>-1){
				return true;
			}else{
				return false;
			}
		}
		
		public function hasNext():Boolean{
			if(index<=arr.length-1){
				return true;
			}
			return false;
		}
		
		public function next():Object{
			return arr[index++];
		}
		public function currentIndex():int{
			return index;
		}
		public function reset():void{
			index=0;
		}
	// Public Methods:
	// Semi-Private Methods:
	// Private Methods:
	
	}
}