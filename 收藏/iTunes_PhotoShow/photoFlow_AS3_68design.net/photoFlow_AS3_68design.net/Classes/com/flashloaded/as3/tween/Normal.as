
package com.flashloaded.as3.tween{
	import com.flashloaded.as3.tween.Itween;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.flashloaded.as3.Points;
	
	public class Normal extends EventDispatcher implements Itween{
		
		private var _speed:Number=0.1;
		private var vx:Number=-1000;
		private var vy:Number=-1000;
		
		public function Normal(strength:Number=0.1){
			_speed=strength;
		}
		
		public function getNextPoints(p1:Points,p2:Points):Points{
			
			var arr1=p1.toArray();
			var arr2=p2.toArray();
			var arr3=[];
			
			if(vx==-1000 || vy==-1000){
				reset(arr1,arr2);
			}
			var v:Number=vx;
			
			for(var i:uint=0;i<arr1.length;i++){
				if(i%2==0) v=vx;
				else v=vy;
				   
				arr3[i]=getNextValue(arr1[i],arr2[i],v);
				
			}
			
			var p3:Points=new Points();
			p3.setArray(arr3);
			
			if(p3.equals(p2)){
				onFinish();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			return p3;
		}
		
		public function getNextValue(p:Number,t:Number,v:Number):Number{
			var d=t-p;
			var r:Number;
			
			if(Math.abs(d)>v){
				if(d<0){
					r=p-v;
				}else{
					r=p+v;
				}
				return r;
			}else{
				return t;
			}
			
		}
		
		
		
		public function set speed(sp:Number):void{
			_speed=sp;
		}
		public function get speed():Number{
			return _speed;
		}
		public function onFinish(){
			vy=vx=-1000;
			
			
		}
		private function reset(arr1:Array,arr2:Array):void{
			var d=Math.abs(arr1[0]-arr2[0]);
			if(d==0){
				d=Math.abs(arr1[6]-arr2[6]);
			}
			
			vx=d*speed;
			
			d=Math.abs(arr1[1]-arr2[1]);
			
			if(d==0){
				d=Math.abs(arr1[3]-arr2[3]);
			}
			
			vy=d*speed;
			
		}
	}
}