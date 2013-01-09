
package com.flashloaded.as3{
	import flash.display.*;
	import flash.external.*;
	import flash.utils.*;
	import com.flashloaded.as3.Collection;
	import flash.events.Event;
	
	public class LivePreviewParent extends MovieClip{
	// Constants:
		public static var CLASS_REF = com.flashloaded.as3.LivePreviewParent;
	// Public Properties:
	// Private Properties:
		private var myInstance:Sprite;
		
	// Initialization:
		public function LivePreviewParent() {
			
		}
		
		protected function init():void{
			
			try{
				stage.align=StageAlign.TOP_LEFT;
				stage.scaleMode=StageScaleMode.NO_SCALE;
				//myInstance=getChildAt(0);
				onResize(stage.width,stage.height);
				
				if(ExternalInterface.available){
					
					ExternalInterface.addCallback("onResize",onResize);
					ExternalInterface.addCallback("onUpdate",onUpdate);
				}
			}catch(e:*){
				trace(e.toString());
			}
			
			
		}
		
		public function onResize(width:Number,height:Number):void{
			//override
		}
		
		public function onUpdate(...updateArray:Array):void{
			
			
			for (var i:int = 0; i + 1 < updateArray.length; i += 2) {
				try {
					var name:String = String(updateArray[i]);
					var value:* = updateArray[i+1];
					
					updateProperty(value,name);
					
				} catch (e:Error) {
					
				}
			}
			
			
		}
	
	// Public Methods:
	// Semi-Private Methods:
	// Private Methods:
		protected function updateCollection(value:Object,name:String):void{
			//override
		}
		protected function updateProperty(value:*,name:String):void{
			//override
		}
		
	}
	
}