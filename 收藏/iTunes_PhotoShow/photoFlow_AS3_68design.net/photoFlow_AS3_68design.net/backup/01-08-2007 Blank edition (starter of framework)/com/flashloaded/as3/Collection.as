package com.flashloaded.as3{
	import flash.events.EventDispatcher;
	import com.flashloaded.as3.Iterator;
	
	public class Collection extends EventDispatcher{
	// Constants:
		public static var CLASS_REF = com.flashloaded.as3.Collection;
	// Public Properties:
	// Private Properties:
		protected var data:Array;
		
	// Initialization:
		public function Collection(_data:Object=null) {
			if(_data==null){
				data=[];
			}else{
				data=getData(_data);
			}
		}
	
	// Public Methods:
	
		public function getLength():uint{
			return data.length;
		}
		public function addItemAt(item:Object,index:uint):void{
			checkIndex(index,data.length);
			data.splice(index,0,item);
		}
		public function addItem(item:Object):void{
			data.push(item);
		}
		public function addItemsAt(items:Object,index:uint):void{
			checkIndex(index,data.length);
			var arr=getData(items);
			data.splice.apply(data,[index,0].concat(arr));
			
		}
		public function addItems(items:Object):void{
			addItemsAt(items,data.length);
		}
		
		public function concat(items:Object):void{
			addItems(items);
		}
		
		public function merge(newData:Object):void{
			var arr:Array=getData(newData);
			var l:uint=arr.length;
			var startLength:uint=data.length;
			
			for(var i:uint=0;i<l;i++){
				var item:Object=arr[i];
				if(getItemIndex(item)==-1){
					data.push(item);
				}
			}
		}
		
		public function getItemAt(index:uint):Object{
			checkIndex(index,data.length-1);
			return data[index];
		}
		
		public function getItemIndex(item:Object):int{
			return data.indexOf(item);
		}
		public function removeItemAt(index:uint):Object{
			var arr:Array=data.splice(index,1);
			return arr[0];
		}
		public function removeItem(item:Object):Object{
			var index:int=getItemIndex(item);
			if(item!=-1){
				return removeItemAt(index);
			}
			return null;
		}
		public function removeAll():void{
			data=[];
		}
		public function replaceItem(newItem:Object,oldItem:Object):Object{
			var index:int=getItemIndex(oldItem);
			if(index!=-1){
				return replaceItemAt(newItem,index);
			}
			return null;
		}
		public function replaceItemAt(newItem:Object,index:uint):Object{
			checkIndex(index,data.length-1);
			var obj:Object=data[index];
			data[index]=newItem;
			return obj;
		}
		public function sort(...sortArgs:Array):*{
			var returnValue:Array=data.sort.apply(data,sortArgs);
			return returnValue;
		}
		public function sortOn(fieldName:Object,options:Object=null):*{
			var returnValue:Array=data.sortOn(fieldName,options);
			
			return returnValue;
		}
		
		public function sortOnDepth():void{
			//override
		}
		
		public function clone():Collection{
			return new Collection(data);
		}
		
		public function iterator():Iterator{
			//override
			return null;
		}
		
		public function toArray():Array{
			return data.concat();
		}
		
		override public function toString():String{
			return "Collection ["+data.join(", ")+"]";
		}
		
		public function getData(obj:Object):Array{
			//override
			trace("Collection : getData much be override and implement by its subclass.");
			return [];
		}
		
		protected function checkIndex(index:int,max:int):void{
			if(index>max || index<0){
				throw new RangeError("Collection : item not in range 0 - "+max);
			}
		}
		
	// Semi-Private Methods:
	// Private Methods:
	
	}
}