
package com.flashloaded.as3.effects{
	
	import com.flashloaded.as3.Page;
	import flash.events.Event;
	import com.flashloaded.as3.effects.IEffect;
	import com.flashloaded.as3.effects.AbstractEffect;
	import com.flashloaded.as3.CustomEvent;
	import flash.filters.BlurFilter;
	import flash.display.Sprite;
	
	public class Blur {
		
		private var target:IEffect;
		public var strength:Number=3;
		
		public function Blur(s:Number=0){
			strength=s;
		}
		
		public function setEffect(eff:IEffect):void{
			this.target=eff;
			
			init();
		}
		
		
		public function init():void{
			target.addEventListener(Event.CHANGE,animate);
		}
		
		public function animate(evt:CustomEvent):void{
			
			var blur:BlurFilter;
			
			if(type=="horizontal"){
				
				var dx:Number=Math.abs((evt.newPoints.getX(0)-evt.oldPoints.getX(0)));
				
				blur=new BlurFilter();
				blur.blurX=dx*strength;
				blur.blurY=0;
				evt.target.image.filters=[blur];
				
			}else if(type=="vertical"){
				var dy:Number=Math.abs((evt.newPoints.getY(0)-evt.oldPoints.getY(0)));
				
				blur=new BlurFilter();
				blur.blurX=0;
				blur.blurY=dy*strength;
				evt.target.image.filters=[blur];
			}
		}
		
		public function get type():String{
			return target.getType();
		}
		
		
	}
}