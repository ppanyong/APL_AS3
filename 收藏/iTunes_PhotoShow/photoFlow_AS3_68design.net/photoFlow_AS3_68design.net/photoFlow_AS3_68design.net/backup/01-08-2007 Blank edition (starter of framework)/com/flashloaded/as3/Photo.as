
package com.flashloaded.as3{
	public class Photo extends Item{
		
		private var _side:String;
		
		public function Photo(data:Object,index:int){
			super(data,index);
			
		}
		
		override protected function createGraphic():void{
			
		}
		
		override public function renderGraphic():void{
			//if side equal left/right
		}
		
		public function get side():String{
			return _side;
		}
		
		public function set side(side:String):void{
			_side=side;
		}
		
	}
}
