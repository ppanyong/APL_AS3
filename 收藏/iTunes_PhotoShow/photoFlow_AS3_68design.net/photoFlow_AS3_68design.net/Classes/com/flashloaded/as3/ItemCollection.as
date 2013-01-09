
package com.flashloaded.as3{
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.Iterator;
	
	
	public class ItemCollection extends Collection{
		public function ItemCollection(_data:Object=null){
			super(_data);
			
		}
		// Public Methods:
		
		override public function getData(obj:Object):Array {
			
			//implement getData from xml,array
			var retArr:Array;
			
			if (obj is Array) {
				return obj.concat();
				
			} else if (obj is Collection) {
				return obj.toArray();
				
			}else if(obj is XML){
				
				var _xml:XML=obj as XML;
				_xml.ignoreWhite=true;
				var arr:Array=[];
				
				var newsItem:Object;
				
				for each(var item:XML in _xml.item){
					
					newsItem={};
					
					for each(var j:XML in item.@*){
						
						newsItem[j.name()+""]=j;
						
					}
					
					for each(var i:XML in item.*){
						newsItem[i.name()]=i;
					}
					
					arr.push(newsItem);
				}
				
				
				return arr;
				
			}else {
				throw new TypeError("MenuItemColl: Can not parse object.");
				return null;
			}
			
			
			
		}
		// Semi-Private Methods:
		// Private Methods:

	}
}