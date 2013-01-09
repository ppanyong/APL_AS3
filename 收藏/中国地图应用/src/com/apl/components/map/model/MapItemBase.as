package com.apl.components.map.model {
	import flash.display.MovieClip;
	
	/**
	 * @author andypan
	 */
	public class MapItemBase extends MovieClip implements IMapItem {
		private var _title:String;
		private var _value:String;
		private var _id:String;
		private var _itemmc:MovieClip;
		public function MapItemBase() {
		}
		//<area id="beijing" title="北京" value="" url="test.html" target="_blank"></area>
		public function prase(xml:XML):void{
			id=name=xml.@id;
			title = xml.@title;
			value = xml.@value;
		}

		public function get title() : String {
			return _title;
		}
		
		public function set title(title : String) : void {
			_title = title;
		}
		
		public function get value() : String {
			return _value;
		}
		
		public function set value(value : String) : void {
			_value = value;
		}
		
		public function get itemmc() : MovieClip {
			return _itemmc;
		}
		
		public function set itemmc(itemmc : MovieClip) : void {
			_itemmc = itemmc;
		}
		
		public function get id() : String {
			return _id;
		}
		
		public function set id(id : String) : void {
			_id = id;
		}
	}
}
