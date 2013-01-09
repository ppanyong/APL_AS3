package com.flashloaded.as3{
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.Item;
	import com.flashloaded.as3.ItemCollection;
	import flash.events.Event;
	import com.flashloaded.as3.CustomEvent;
	import flash.events.EventDispatcher;
	import com.flashloaded.as3.Iterator;
	
	public class PreloadSetManager extends EventDispatcher{
		
		private var items:ItemCollection;
		private var nextLoadIndex:uint=0;
		private var preloadSet:int;
		//-i is don load, 0 is load all
		
		public function PreloadSetManager(ps:int=-1,_items:Collection=null,startNow:Boolean=false){
			
			preloadSet=ps;
			items=new ItemCollection();
			
			if(_items!=null){
				addItems(_items);
			}
			if(startNow){
				startLoad();
			}
		}
		public function addItems(items:Collection):void{
			var itr:Iterator=items.iterator();
			while(itr.hasNext()){
				addItem(Item(itr.next()));
			}
		}
		public function addItem(item:Item):void{
			
			items.addItem(item);
			item.addEventListener(Event.INIT,onLoaded);
		}
		
		
		
		private function onLoaded(e:Event):void{
			var index:int=items.getItemIndex(e.target);
			if(index<nextLoadIndex){
				e.target.removeEventListener(Event.INIT,onLoaded);
				loadNextItem();
			}else{
				removeItem(Item(e.target));
			}
			//dispatch event: FLIP
			var evt:CustomEvent=new CustomEvent(Event.OPEN);
			evt.item=e.target;
			dispatchEvent(evt);
				
		}
		public function removeItem(item:Item):void{
			items.removeItem(item);
		}
		
		public function loadNextItem(){
			if(nextLoadIndex<items.getLength()){
				items.getItemAt(nextLoadIndex++).createImage();
			}else{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function startLoad():void{
			if(preloadSet>0){
				while(nextLoadIndex<preloadSet){
					loadNextItem();
				}
			}else if(preloadSet==0){
				while(nextLoadIndex<items.getLength()){
					loadNextItem();
				}
			}					 
		}
		
	}
}