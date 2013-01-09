package com.flashloaded.as3{
	import com.flashloaded.as3.ItemCollection;
	import flash.display.Sprite;
	import com.flashloaded.as3.Iterator;
	import flash.display.DisplayObject;
	
	public class DepthManager {
		private var _originalItems:Collection;
		private var items:Collection;
		private var container:Sprite;
		
		public function DepthManager(items:Collection,container:Sprite){
			_originalItems=items;
			this.container=container;
			resetItems();
		}
		
		public function resetItems():void{
			items=new ItemCollection(_originalItems);
		}
		
		public function sortDepths():void{
			
			items.sortOn("depth",Array.NUMERIC);
			var itr:Iterator=items.iterator();
			
			while(itr.hasNext()){
				var d:int=itr.currentIndex();
				container.addChildAt(DisplayObject(itr.next()),d);
				
			}
		}
		
	}
	
}