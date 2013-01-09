
package com.flashloaded.as3{
	
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.display.LoaderInfo;
	
	import com.flashloaded.as3.IImager;
	import com.flashloaded.as3.ImageContainer;
	
	public class ImageLoader extends Loader implements IImager{
		private var url:String;
		
		
		public function ImageLoader(url:String){
			
			this.url=url;
		}
		
		public function create():DisplayObject{			
			//return the Loader Object
			var req:URLRequest=new URLRequest(url);
			load(req);
			return this;
		}
		
		public function getContentLoaderInfo():LoaderInfo{
			return contentLoaderInfo;
		}
	}

	
}