
package com.flashloaded.as3{
	import flash.display.*;
	import flash.external.*;
	import flash.utils.*;
	import com.flashloaded.as3.Collection;
	import flash.events.Event;
	import flash.utils.Timer;
	
	public class LivePreviewParent extends MovieClip {
		// Constants:
		public static  var CLASS_REF = com.flashloaded.as3.LivePreviewParent;
		// Public Properties:
		// Private Properties:
		private var myInstance:Sprite;
		private var _data:Object;
		protected var _w:Number;
		protected var _h:Number;
		private var intervalId:int;
		
		// Initialization:
		
		protected function init():void{
			//override
		}
		public function onResize():void {
			//override
		}
		protected function update(value:*=null,name:String=null):void{
			//override
		}
		
		public function LivePreviewParent() {
			_data={};
			_w=stage.stageWidth;
			_h=stage.stageHeight;
			setEvent();	
			
		}
		
		private function setEvent():void {
			
			try {
				stage.align=StageAlign.TOP_LEFT;
				stage.scaleMode=StageScaleMode.NO_SCALE;
				//myInstance=getChildAt(0);

				if (ExternalInterface.available) {

					ExternalInterface.addCallback("onResize",onResizeStage);
					ExternalInterface.addCallback("onUpdate",onUpdate);
					
				}
			} catch (e:*) {
				trace(e.toString());
			}
		}
		
		private function onResizeStage(w:Number,h:Number):void{
			_w=w;
			_h=h;
			onResize();				  
		}
		public function onUpdate(...updateArray:Array):void {


			for (var i:int = 0; i + 1 < updateArray.length; i += 2) {
				try {
					var name:String = String(updateArray[i]);
					var value:* = updateArray[i+1];
					if(data[name]!=value){
						updateProperty(value,name);
					}

				} catch (e:Error) {

				}
			}
			
			initLive();
			
		}
		
		
		
		
		private function updateProperty(value:*,name:String):void {
			data[name]=value;
			update(value,name);
		}
		
		
		
		private function initLive():void{			
			init();
			onResize();
		}
		
		public function get data():Object{
			return _data;
		}
		public function set data(obj:Object):void{
			_data=obj;
		}
	}
}