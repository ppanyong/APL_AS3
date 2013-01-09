package com.flashloaded.as3{
	import flash.events.Event;

	dynamic public class PhotoFlowEvent  extends Event{
		
		//none
		public static var INIT:String="oninitPhotoFlow";
		//none
		public static var PHOTOS_LOADED:String="onLoadPhotosComplete";
		
		//id,data,index
		public static var PHOTO_LOADED:String="onPhotoLoaded";
		
		//id,data,index
		public static var CLICK_SELECTED:String="onSingleClick";
		
		//progressObject,id,data,index
		public static var PHOTO_LOAD_PROGRESS:String="onLoadProgress";
		
		//id,data,index
		public static var PHOTO_MOUSE_OVER:String="onMouseOverPhoto";
		
		//id,data,index
		public static var PHOTO_MOUSE_OUT:String="onMouseOutPhoto";
		
		//id,data,index
		public static var SELECT:String="onSelectPhoto";
		
		//id,data,index
		public static var ADD:String="onAddPhoto";
		
		//id,data,index
		public static var REMOVE:String="onRemovePhoto";
		
		//none
		public static var UPDATE:String="onUpdate";
		
		public function PhotoFlowEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false){
			super(type,bubbles,cancelable);
		}
		
	}
}