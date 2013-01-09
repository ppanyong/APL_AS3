package com.flashloaded.as3{
	
	import flash.display.DisplayObject;
	import com.flashloaded.as3.IImager;
	import flash.events.EventDispatcher;
	import flash.display.LoaderInfo;
	import flash.utils.getDefinitionByName;
	
	public class ImageAttacher extends EventDispatcher implements IImager{
		private var className:String;
		
		public function ImageAttacher(className:String){
			this.className=className;
		}
		
		
		public function create():DisplayObject{
			//return the object create from the className
			var instance;
			var def=getDefinitionByName(className);
			instance=new def;
			
			return instance;
		}
		public function getContentLoaderInfo():LoaderInfo{
			return null;
		}
	}
	
}