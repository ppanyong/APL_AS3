package com.flashloaded.as3{
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.ExternalDataLoader;
	import com.flashloaded.as3.Iterator;
	import com.flashloaded.as3.Item;
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	public class SelectionSystem extends ExternalDataLoader{
		
		protected var _inited:Boolean=false;
		protected var _currIndex:int=0;
		protected var _itemsParent:Sprite;
		
		public function SelectionSystem(){
			initComp();
		}
		
		override protected function createChildren() :void{
			
		}
		
		override protected function draw() :void{
			//init data
			prepareItemsData();
		}
		
		private function attachItems():void{
			
			var itr:Iterator=listItems.iterator();
			
			while(itr.hasNext()){
				
				items.addItem(createItem(itr.next(),itr.currentIndex()-1));
				
			}
			
			addChilds();
			startCreateImages();
			_inited=true;
			listItems=null;
			onInited();
		}
		
		protected function onInited():void{
			//override
			
		}
		
		protected function removeItem(item:*):void{
			if(!inited){
				if(item is Object){
					listItems.removeItem(item);
				}
			}else{
				var itm:Item;
				if(item is int){
					itm=Item(items.getItemAt(item));
				}else{
					itm=Item(items.getItem(item));
					
				}
				if(itm!=null){
					if(itm.index<currIndex){
						_currIndex--;
					}
					
					items.removeItem(itm);
					removeChild(itm);
					
				}
			}
		}
		
		protected function addItem(item:Object):Item{
			if(!inited){
				listItems.addItem(item);
				return null;
			}else{
				var itm:Item=createItem(item,items.getLength());
				items.addItem(itm);
				_itemsParent.addChildAt(itm,itm.depth);
				return itm;
			}
			return null;
		}
		
		protected function sortItems():void{
			items.sortOnDepth();
		}
		protected function startCreateImages():void{
			//override
		}
		protected function sortChldsDepth():void{
			sortItems();
			for(var i:uint=0;i<this.numChildren;i++){
				var itm:Item=Item(this.getChildAt(i));
				setChildIndex(itm,i);
			}
		}
		
		
		
		protected function addChilds():void{
			_itemsParent=new Sprite();
			
			var itr:Iterator=items.iterator();
			
			while(itr.hasNext()){
				var itm:Item=Item(itr.next());
				_itemsParent.addChildAt(itm,itm.depth);
			}
			addChild(_itemsParent);
		}
		
		protected function addNewItem(item:Item):void{
			_itemsParent.addChildAt(item,0);
		}
		
		protected function createItem(data:Object,index:int):*{
			return null;
		}
		
		override protected function xmlLoaded(evt:Event):void{
			trace("SelectionSys xmlLoaded!!")
			super.xmlLoaded(evt);
			attachItems();
		}
		
		public function setSelection(index:int):void{
			//override
			_currIndex=index;
		}
		
		protected function prepareItemsData():void{
			//*override to create systemData object
			
			loadFromInspector();
			loadXML(_xmlURL);
			
		}
		
		protected function get currIndex():int{
			return _currIndex;
		}
		
		protected function get currentItem():Item{
			return Item(items.getItemAt(_currIndex));
		}
		
		public function get selectedIndex():int{
			
			return _currIndex;
		}
		
		public function get inited():Boolean{
			return _inited;
		}
		
		public function get itemsParent():Sprite{
			return _itemsParent;
		}
		
		/*public function resetSelection(index:int):void{
			
			if(index<items.getLength()){
				_currIndex=index;
			}else{
				_currIndex=items.getLength()-1;
			}
			
		}*/
		
		/*
		public function set selectedIndex(index:int):void{
			_currIndex=index;
		}
		*/
	}
}