package com.flashloaded.as3{
	
	dynamic public class PhotoItem {
		
		[Inspectable(category="a")]
		public var id:String;
		
		[Inspectable(category="b")]
		public var caption:String;
		
		[Inspectable(category="d")]
		public var className:String;
		
		[Inspectable(category="c")]
		public var url:String;
		
		public function PhotoItem(){};
		
		public function toString():String {
			return "[PhotoItem: "+id+"]";	
		}
	}
}