package com.apl.util {
	import flash.events.EventDispatcher;

	import com.apl.util.Iterator;

	/**
	 * 集合类
	 * @author andypan
	 * @deprecated 2010 集合类
	 */
	public class Collection extends EventDispatcher {
		// Constants:
		public static var CLASS_REF : Class = com.apl.util.Collection;
		//记录数组
		protected var data : Array;

		/**
		 * 构造函数
		 * @param _data 导入以后数据集合 导入后将采用getData函数处理，该函数必须被覆盖定义
		 */
		public function Collection(_data : Object = null) {
			if(_data == null) {
				data = [];
			}else {
				data = getData(_data);
			}
		}

		// Public Methods:
		/**
		 * 获取指定元素的序列号
		 * @param item 需要查找的元素对象
		 * @return 序列号 int
		 */
		public function getIndex(item : Object) : int {
			var itr : Iterator = iterator();
			while(itr.hasNext()) {
				var i : int = itr.currentIndex();
				var o : Object = itr.next();
				if(o == item) {
					return i;
				}
			}
			return -1;
		}

		/**
		 * 得到集合长度
		 * @return 集合长度值 uint
		 */
		public function getLength() : uint {
			var l : uint;
			try {
				l = data.length;
			}
			catch(e) {
				l = 0;
			}
			return l;
			//return data.length;
		}

		/**
		 * 将指定元素插入到位置
		 * @param item 元素 object
		 * @param index 序列号 uint
		 */
		public function addItemAt(item : Object,index : uint) : void {
			checkIndex(index, data.length);
			data.splice(index, 0, item);
		}

		/**
		 * 增加集合中元素到末端
		 * @param item 元素
		 */
		public function addItem(item : Object) : void {
			data.push(item);
		}

		/**
		 * 增加元素集合到集合中
		 * @param items 集合对象
		 * @param index 序列号 uint
		 */
		public function addItemsAt(items : Object,index : uint) : void {
			checkIndex(index, data.length);
			var arr : Array = getData(items);
			data.splice.apply(data, [index,0].concat(arr));
		}

		/**
		 * 增加集合到集合末端
		 * @param items 集合
		 */
		public function addItems(items : Object) : void {
			addItemsAt(items, data.length);
		}

		/**
		 * 添加集合到顶端
		 */
		public function concat(items : Object) : void {
			addItems(items);
		}

		/**
		 * 合并集合 将集合分拆存入现有集合中
		 * @param newData 新集合数据
		 */
		public function merge(newData : Object) : void {
			var arr : Array = getData(newData);
			var l : uint = arr.length;
			var startLength : uint = data.length;
			
			for(var i : uint = 0;i < l;i++) {
				var item : Object = arr[i];
				if(getItemIndex(item) == -1) {
					data.push(item);
				}
			}
		}

		/**
		 * 获取指定index数据
		 */
		public function getItemAt(index : uint) : Object {
			checkIndex(index, data.length - 1);
			return data[index];
		}

		/**
		 * 检索数据位置
		 */
		public function getItemIndex(item : Object) : int {
			return data.indexOf(item);
		}

		/**
		 * 删除指定位置元素
		 * @param index 位置 uint
		 */
		public function removeItemAt(index : uint) : Object {
			var arr : Array = data.splice(index, 1);
			return arr[0];
		}

		/**
		 * 删除指定元素 只删除找到的第一个匹配元素
		 * @param item 待删除元素
		 */
		public function removeItem(item : Object) : Object {
			var index : int = getItemIndex(item);
			if(item != -1) {
				return removeItemAt(index);
			}
			return null;
		}

		/**
		 * 删除全部数据
		 */
		public function removeAll() : void {
			data = [];
		}

		/**
		 * 
		 */
		public function getItem(data : Object) : Object {
			var itr : Iterator = iterator();
			while(itr.hasNext()) {
				var itm : Object = itr.next();
				if(itm.data == data) {
					return itm;
				}
			}
			return null;
		}

		/**
		 * 替换元素 替换找到的第一个元素
		 * @param newItem 新元素
		 * @param oldItem 替换元素
		 * @return 替换的旧数据
		 */
		public function replaceItem(newItem : Object,oldItem : Object) : Object {
			var index : int = getItemIndex(oldItem);
			if(index != -1) {
				return replaceItemAt(newItem, index);
			}
			return null;
		}

		/**
		 * 替换指定位置的元素
		 * @param index 位置
		 * @param newItem 新元素
		 * @return 旧元素
		 */
		public function replaceItemAt(newItem : Object,index : uint) : Object {
			checkIndex(index, data.length - 1);
			var obj : Object = data[index];
			data[index] = newItem;
			return obj;
		}

		/**
		 * 排序
		 * @param sortArgs 排序参数 参考array.sort.apply
		 */
		public function sort(...sortArgs : Array) : * {
			var returnValue : Array = data.sort.apply(data, sortArgs);
			return returnValue;
		}

		/**
		 * 指定字段排序 参考array.sortOn
		 */
		public function sortOn(fieldName : Object,options : Object = null) : * {
			var returnValue : Array = data.sortOn(fieldName, options);
			
			return returnValue;
		}

		/**
		 * 深度排序（待override）
		 */
		public function sortOnDepth() : void {
			//override
		}

		public function clone() : Collection {
			return new Collection(data);
		}

		/**
		 * 生成索引
		 */
		public function iterator(startIndex : int = 0) : Iterator {
			//override
			return new Iterator(data, startIndex);
		}

		public function toArray() : Array {
			return data.concat();
		}

		override public function toString() : String {
			return "Collection [" + data.join(", ") + "]";
		}

		/**
		 * 序列化对象数据 to array
		 * @return 返回一个结构话数组
		 * 覆盖的范例
		 * override public function getData(obj:Object):Array {
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
		 */
		public function getData(obj : Object) : Array {
			//override
			trace("Collection : getData much be override and implement by its subclass.");
			return [];
		}

		protected function checkIndex(index : int,max : int) : void {
			if(index > max || index < 0) {
				throw new RangeError("Collection : item " + index + " not in range 0 - " + max);
			}
		}
		
	// Semi-Private Methods:
	// Private Methods:
	}
}