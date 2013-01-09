package com.flashloaded.as3{
	import flash.display.Sprite;
	import com.flashloaded.as3.Item;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	public class PreloadHolder extends Sprite{
		
		protected var item:Item;
		protected var preloader:DisplayObject;
		
		public function PreloadHolder(item:Item,preloaderClass:String){
			
			this.item=item;
			//var def=getDefinitionByName(preloaderClass);
			//preloader=new def;			
			
			item.addChild(this);
			init();
		}
		
		private function init():void{
			drawHolder();
			placePreloader();
		}
		
		protected function drawHolder():void{
			//override
		}
		
		protected function placePreloader():void{
			
			//override
		}
		
	}
}