package com.apl.components.map.view {
	import com.apl.components.map.event.MapEvent;	
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ChinaMap extends MovieClip {
		
		private var mapConfig:Object;
		private var mapArea:MapArea;
		private var own:MovieClip;
		
		public function ChinaMap(){	
			own = this;
			mapConfig = new Object();
			drawUI();
		}
		
		private function drawUI():void {
			mapArea = new MapArea();
			mapArea.x  = mapArea.y = 20;
			this.addChild(mapArea);
			stopAll(mapArea.map);
			registAction(mapArea.map);
		}
		
		
		private function registAction(c:DisplayObjectContainer):void {
			for(var i:uint = 0; i<c.numChildren; i++) {
				var tmp:MovieClip = c.getChildAt(i) as MovieClip;
				if(tmp is MovieClip && tmp.name != "bg") {
					tmp.alpha = 1;
					tmp.buttonMode=true;
					
					tmp.addEventListener(MouseEvent.MOUSE_OVER,mapOverHandler);
					tmp.addEventListener(MouseEvent.MOUSE_OUT,mapOutHandler);
					tmp.addEventListener(MouseEvent.CLICK,mapClipHandler);
				}
			}
			function mapOverHandler(e:MouseEvent):void {
				(e.currentTarget as MovieClip).gotoAndStop(2);
				 var new_e:MapEvent = new MapEvent(MapEvent.ITEMOVER)
				 new_e.MC = (e.currentTarget as MovieClip);
				e.target.parent.parent.parent.dispatchEvent(new_e);
			}
			function mapOutHandler(e:MouseEvent):void {
				(e.currentTarget as MovieClip).gotoAndStop(1);
				 var new_e:MapEvent = new MapEvent(MapEvent.ITEMOUT)
				new_e.MC = (e.currentTarget as MovieClip);
				e.target.parent.parent.parent.dispatchEvent(new_e);
				
			}
			function mapClipHandler(e:MouseEvent):void {
				(e.currentTarget as MovieClip).gotoAndStop(1);
				 var new_e:MapEvent = new MapEvent(MapEvent.ITEMCLICK)
				new_e.MC = (e.currentTarget as MovieClip);
				e.target.parent.parent.parent.dispatchEvent(new_e);
			}
		}
		
		private function stopAll(c:DisplayObjectContainer):void {
			var me:DisplayObject;
			for(var i:uint = 0; i<c.numChildren; i++) {
				me = c.getChildAt(i);
				if(me is MovieClip) {
					(me as MovieClip).stop();
				}
			}
		}
	}
}
