
package com.flashloaded.as3{
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.Iterator;
	
	
	public class PhotoCollection extends Collection{
		public function PhotoCollection(_data:Object=null){
			super(_data);
			
		}
		// Public Methods:		
		
		public function resetIndex(startIndex:int=0):void{
			var itr:Iterator=iterator(startIndex);
			
			while(itr.hasNext()){
				var i:int=itr.currentIndex();
				itr.next().index=i;
			}
			
		}
		
		public function addPhoto(p:Photo,index:uint):void{
			addItemAt(p,index);
			resetIndex(index);
		}
		
		public function removePhoto(index:uint):Photo{
			
			var p:Object=removeItemAt(index);
			resetIndex(index);
			return Photo(p);
		}
		
		public function getItemById(id:String):Object{
			for(var i:uint=0;i<data.length;i++){
				if(data[i].id==id){
					return data[i];
				}
			}
			return null;
		}
		
		public function removeItemById(id:String):Object{
			var item:Object=getItemById(id);
			return removeItem(item);
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
				_xml.ignoreWhitespace=true;
				var arr:Array=[];
				
				var p:Object;
				var path:String=_xml.@path;
				
				for each(var photo:XML in _xml.photo){
						
						p={};
						
						for each(var att:XML in photo.@*){
							if(att.name()=="url"){
								p.url=path+att;
							}else{
								p[att.name()+""]=att;
							}
						}
						
						for each(var i:XML in photo.*){
							
							p[i.name()]=i;
							
						}
						
						arr.push(p);
					
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