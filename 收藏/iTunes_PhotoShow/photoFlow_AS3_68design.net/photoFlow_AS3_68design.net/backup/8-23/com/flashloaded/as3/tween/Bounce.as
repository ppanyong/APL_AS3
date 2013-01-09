
package com.flashloaded.as3.tween{
	import com.flashloaded.as3.tween.Itween;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.flashloaded.as3.Points;
	
	public class Bounce extends EventDispatcher implements Itween{
		
		private var _friction:Number=0.1;
		private var _strength:Number=0.1;
		
		private var _vpoints:Points;
		
		public function Bounce(strength:Number=0.1,friction:Number=0.1){
			_friction=friction;
			_strength=strength;
			reset();
		}
		
		public function getNextPoints(p1:Points,p2:Points):Points{
			var arr1=p1.toArray();
			var arr2=p2.toArray();
			
			var arr3=[];
			var arrv=_vpoints.toArray();
			
			var ax:Number;
			var t:Number;
			var p:Number;
			
			var finish:Boolean=true;
			
			for(var i:uint=0;i<arr1.length;i++){
				t=arr2[i];
				p=arr1[i];
				
				ax=(t-p)*strength;
				arrv[i]+=ax;
				arrv[i]*=(1-friction);
				
				arr3[i]=p+arrv[i];
				
				if(Math.abs(ax)>0.2 || Math.abs(arrv[i])>0.2){
					finish=false;
				}else{
					arr3[i]=t;
				}
				
			}
			
			if(finish){
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			var p3:Points=new Points();
			p3.setArray(arr3);
			
			return p3;
		}

		
		public function set friction(sp:Number):void{
			_friction=sp;
		}
		public function get friction():Number{
			return _friction;
		}
		
		public function set strength(sp:Number):void{
			_strength=sp;
		}
		public function get strength():Number{
			return _strength;
		}
		public function reset():void{
			_vpoints=new Points();
		}
	}
}