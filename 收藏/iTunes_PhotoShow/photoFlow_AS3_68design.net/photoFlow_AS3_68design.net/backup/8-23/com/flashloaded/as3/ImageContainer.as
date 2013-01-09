
package com.flashloaded.as3{
	import com.flashloaded.as3.IImager;
	import com.flashloaded.as3.ImageLoader;
	import com.flashloaded.as3.ImageAttacher;
	import flash.display.DisplayObject;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.LoaderInfo;
	
	public class ImageContainer extends EventDispatcher{
		
		private var imager:IImager;
		
		public function ImageContainer(data:Object){
			
			if(data.url!=undefined && data.url!="" && data.url!=null){
				imager=new ImageLoader(data.url);
			}else{
				imager=new ImageAttacher(data.className);
				
			}
				
			
		}
		
		public function create(immediately:Boolean=false):DisplayObject{
			//havnt implement preload manager
			
			return imager.create();
		}
		
		
		
		public function getInfo():LoaderInfo{
			return imager.getContentLoaderInfo();
		}
		
	}
	
}