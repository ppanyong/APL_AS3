package com.flashloaded.as3{
	import flash.display.MovieClip;
	
	public class Item extends MovieClip{
		
		private var _data:Object;
		private var _index:int;
		private var _depth:uint;
		
		private var _xpos:Number=0;
		private var _ypos:Number=0;
		
		public function Item(data:Object=null,index:int=undefined){
			_data=data;
			_index=index;
			
			createGraphic();
		}
		
		protected function createGraphic():void{
			
			//override
			
		}
		
		
		
		
		public function get data():Object{
			return _data;
		}
		public function set data(data:Object):void{
			_data=data;
		}
		
		public function get index():int{
			return _index;
		}
		public function set index(index:int):void{
			_index=index;
		}
		
		public function set depth(num:uint){
			_depth=num;
		}
		public function get depth():uint{
			return _depth;
		}
		
		public function get xpos():Number{
			return _xpos;
		}
		public function set xpos(pos:Number):void{
			_xpos=pos;
		}
		
		public function get ypos():Number{
			return _ypos;
		}
		public function set ypos(pos:Number):void{
			_ypos=pos;
		}
		
		public function render():void{
			renderPosition();
			renderGraphic();
		}
		
		public function renderPosition():void{
			x=_xpos;
			y=_ypos;
		}
		
		public function renderGraphic():void{
			//override
		}
		
	}
}
		