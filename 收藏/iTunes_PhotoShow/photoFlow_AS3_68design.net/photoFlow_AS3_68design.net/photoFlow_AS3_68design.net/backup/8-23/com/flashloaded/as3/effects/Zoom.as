
package com.flashloaded.as3.effects{
	
	import com.flashloaded.as3.Page;
	import flash.events.Event;
	import com.flashloaded.as3.effects.IEffect;
	import com.flashloaded.as3.effects.AbstractEffect;
	import com.flashloaded.as3.CustomEvent;
	import flash.filters.BlurFilter;
	import flash.display.Sprite;
	import com.flashloaded.as3.SelectionSystem;
	
	public class Zoom extends AbstractEffect implements IEffect{
		
		//private var page:Page;
		public var strength:Number=0.3;
		private var sys:SelectionSystem;
		private var tsx:Number=1.2;
		private var tsy:Number=1.2;
		private var zoomed:Boolean;
		
		public function Zoom(sys:SelectionSystem=null){
			this.sys=sys;
		}
		
		override public function init(s:Object):void{
			strength=Number(s);
			
		}
		
		override public function animate():void{
			//page.addEventListener(Event.ENTER_FRAME,onMotion);
		}
		
		
		
		override public function closePage(page:Page):void{
			
				
				this.page=page;
				
				page.removeEventListener(Event.ENTER_FRAME,onZoom);
				page.addEventListener(Event.ENTER_FRAME,onZoomOut);
			
		}
		
		override public function openPage(page:Page=null):void{
			
			this.page=page;
			
			page.removeEventListener(Event.ENTER_FRAME,onZoomOut);
			page.addEventListener(Event.ENTER_FRAME,onZoom);
			
		}
		
		private function onZoom(evt:Event):void{
			
			
			page.scaleX+=(tsx-page.scaleX)*strength;
			page.scaleY+=(tsy-page.scaleY)*strength;
			
			if(Math.abs(page.scaleX-tsx)<0.01){
				page.scaleX=page.scaleY=tsx;
				page.removeEventListener(Event.ENTER_FRAME,onZoom);
			}
			
			centerize();
			
		}
		private function onZoomOut(evt:Event):void{
			
			page.scaleX+=(1-page.scaleX)*strength;
			page.scaleY+=(1-page.scaleY)*strength;
			
			if(Math.abs(page.scaleX-1)<0.01){
				page.scaleX=page.scaleY=1;
				page.removeEventListener(Event.ENTER_FRAME,onZoomOut);
			}
			
			centerize();
		}
		private function centerize():void{
			page.x=sys.compWidth/2-page.width/2;
			page.y=sys.compHeight/2-page.height/2;
		}
		
	}
}