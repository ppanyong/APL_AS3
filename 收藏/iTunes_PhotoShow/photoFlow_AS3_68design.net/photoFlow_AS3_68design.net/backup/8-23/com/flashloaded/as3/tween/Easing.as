
package com.flashloaded.as3.tween{
	import com.flashloaded.as3.tween.Itween;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.flashloaded.as3.Points;
	
	public class Easing extends EventDispatcher implements Itween{
		
		private var _speed:Number=0.1;
		
		
		public function Easing(strength:Number=0.1){
			_speed=strength;
		}
		
		public function getNextPoints(p1:Points,p2:Points):Points{
			var arr1=p1.toArray();
			var arr2=p2.toArray();
			var arr3=[];
			
			for(var i:uint=0;i<arr1.length;i++){
				
				arr3[i]=getNextValue(arr1[i],arr2[i]);

			}
			
			var p3:Points=new Points();
			p3.setArray(arr3);
			
			if(p3.equals(p2)){
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			return p3;
		}
		
		public function getNextValue(p:Number,t:Number,dispatchComplete:Boolean=false,proxi:Number=1):Number{
			var d=t-p;
			if(Math.abs(d)>proxi){
				var r:Number=p+d*speed;
				return r;
			}else{
				if(dispatchComplete){
					dispatchEvent(new Event(Event.COMPLETE));
				}
				
				return t;
			}
			
		}
		
		public function checkFinish(v1:Number,v2:Number):Boolean{
			if(v1==v2)
				return true;
			else 
				return false;
		}
		public function set speed(sp:Number):void{
			_speed=sp;
		}
		public function get speed():Number{
			return _speed;
		}
	}
}