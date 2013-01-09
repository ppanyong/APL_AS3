package com.flashloaded.as3{
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.ExternalDataLoader;
	import com.flashloaded.as3.Iterator;
	import com.flashloaded.as3.Item;
	
	import flash.events.Event;
	
	public class SelectionSystem extends ExternalDataLoader{
		
		protected var inited:Boolean=false;
		protected var _currIndex:int;
		
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
				items.addItem(createItem(itr.next(),itr.currentIndex()));
			}
			
			sortItems();
			addChilds();
			
			inited=true;
			listItems=null;
		}
		protected function sortItems():void{
			items.sortOnDepth();
		}
		
		protected function sortChldsDepth():void{
			sortItems();
			for(var i:uint=0;i<this.numChildren;i++){
				var itm:Item=Item(this.getChildAt(i));
				setChildIndex(itm,i);
			}
		}
								
		
		protected function addChilds():void{
			var itr:Iterator=items.iterator();
			
			while(itr.hasNext()){
				var itm:Item=Item(itr.next());
				addChildAt(itm,itm.depth);
			}
			
			
		}
		
		protected function createItem(data:Object,index:int):Object{
			return null;
		}
		
		override protected function xmlLoaded(evt:Event):void{
			super.xmlLoaded(evt);
			attachItems();
		}
		
		public function setSelection(index:int):void{
			_currIndex=index;
		}
		
		protected function makeItem(_data:Object):Object{
			//*override
			trace("please override makeItem function");
			return null;
		}
		
		protected function prepareItemsData():void{
			//*override to create systemData object
			
			loadFromInspector();
			loadXML(_xmlURL);
			
		}
		
		protected function get currIndex():int{
			return _currIndex;
		}
		
		protected function get currItem():Item{
			return Item(items.getItemAt(_currIndex));
		}
		
		
	}
}