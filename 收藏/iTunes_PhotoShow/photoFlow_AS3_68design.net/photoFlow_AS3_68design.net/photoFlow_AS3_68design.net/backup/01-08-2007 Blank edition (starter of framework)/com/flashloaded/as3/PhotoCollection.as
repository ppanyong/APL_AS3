
package com.flashloaded.as3{
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.Iterator;
	
	
	public class PhotoCollection extends Collection{
		public function PhotoCollection(_data:Object=null){
			super(_data);
			
		}
		// Public Methods:
		override public function sortOnDepth():void{
			
			data.sort(sortOnDepthCom);
			
		}
		override public function iterator():Iterator{
			return new Iterator(data);
		}
		
		public function getItemById(id:String):Object{
			for(var i:uint=0;i<data.length;i++){
				if(data[i].regName==id){
					return data[i];
				}
			}
			return null;
		}
		
		public function removeItemById(id:String):Object{
			var item:Object=getItemById(id);
			return removeItem(item);
		}
		
		private function sortOnDepthCom(a:Object,b:Object):Number {
			return 0;
		}
		
		override public function getData(obj:Object):Array {
			//implement getData from xml,array
			var retArr:Array;
			
			if (obj is Array) {
				return obj.concat();
				
			} else if (obj is PhotoCollection) {
				return obj.toArray();
				
			}else if(obj is XML){
				
				var _xml:XML=obj as XML;
				_xml.ignoreWhite=true;
				var arr:Array=[];
				
				var pht:Object;
				var path:String=_xml.@path;
				
				for each(var photo:XML in _xml.photo){
					pht={};
					if(photo.@url!=undefined){
						pht.desc=photo;
						
						for each(var att:XML in photo.@*){
							pht[att.name()+""]=att;
						}
						
						arr.push(pht);
						
					}
					
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