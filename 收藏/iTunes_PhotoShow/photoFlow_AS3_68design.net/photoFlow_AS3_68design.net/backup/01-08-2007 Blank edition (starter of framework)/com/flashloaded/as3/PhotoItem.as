package com.flashloaded.as3{
	
	dynamic public class PhotoItem {
		
		[Inspectable()]
		public var name:String;
		
		[Inspectable()]
		public var title:String;
		
		[Inspectable()]
		public var className:String;
		
		[Inspectable()]
		public var url:String;
		
		
		public function PhotoItem(){};
		
		public function toString():String {
			return "[PhotoItem: "+name+"]";	
		}
	}
}