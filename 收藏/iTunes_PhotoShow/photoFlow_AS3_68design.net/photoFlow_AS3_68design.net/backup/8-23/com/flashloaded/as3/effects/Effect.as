package com.flashloaded.as3.effects{
	
	import flash.utils.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	import sandy.util.DistortImage;
	import com.flashloaded.as3.Points;
	import com.flashloaded.as3.Item;
	import com.flashloaded.as3.CustomEvent;
	import com.flashloaded.as3.Points;
	import com.flashloaded.as3.tween.Easing;
	
	
	public class Effect extends EventDispatcher{
		
		protected var item:Item;
		private var _distort:DistortImage;
		private var intervalId:int;
		protected var tpoints:Points;
		protected var _points:Points;
		private var easingTween:Easing;
		private var motioning:Boolean;
		
		
		public function Effect(_item:Item=null){
			if(_item!=null){
				item=_item;
			}
			
			easingTween=new Easing(speed);
			easingTween.addEventListener(Event.COMPLETE,motionComplete);
			
		}
		
		public function init(d:Object,_item:Item):void{
	
			item=_item;
		}
		
		protected function transformImage(endPoints:Points):void{
			
			item.addChild(distort.image);
			distort.setTransform(endPoints.toArray());
			_points=endPoints;
			
		}
		
		protected function removeFromItem():void{
			if(item.contains(distort.image))
			item.removeChild(distort.image);
		}
		
		
		protected function transformMotionTo(points:Points):void{
			
			if(!motioning){
				transformMotion(this.points,points);
			}else{
				tpoints=points;
			}
		}
		
		protected function transformMotion(startPoints:Points,endPoints:Points):void{
			
			transformImage(startPoints);
			tpoints=endPoints;
			motioning=true;
			distort.image.addEventListener(Event.ENTER_FRAME,motion);
			
		}
		
		protected function motion(e:Event=null):void{
			transformImage(easingTween.getNextPoints(points,tpoints));
		}
		
		protected function motionComplete(e:Event):void{
			motioning=false;
			distort.image.removeEventListener(Event.ENTER_FRAME,motion);			
		}
		
		/*protected function transformImage(image:DisplayObject,startPoints:Points,endPoints):void{
			
			distord=new DistortImage(image);
			item.addChild(distord.image);
			
			distord.setTransform(startPoints.toArray());
			tpoints=endPoints;
			
			intervalId=setInterval(motion,speed);
		}*/
		
		
		public function get points():Points{
			return _points;
		}
		
		public function get distort():DistortImage{
			if(_distort==null){
				_distort=new DistortImage(item.image);
			}
			return _distort;
		}
		
		public function set speed(num:Number):void{
			easingTween.speed=num;
		}
		
		public function get speed():Number{
			//override
			return 0;
		}		
		
	}
}
		