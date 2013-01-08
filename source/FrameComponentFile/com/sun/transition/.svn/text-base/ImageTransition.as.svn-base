package com.sun.transition{
	/*
	单例模式创建这个类，在使用的时候保证只创建一个实例,单例不可以在document class 中使用
	图片过渡效果类
	sonsun
	2008.2.21
	*/
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import com.sun.events.TransEvent;
	
	public class ImageTransition extends Sprite {
		//private static var _INSTANCE:ImageTransition;
//		private static var _INIT:Boolean = false;
//		private static var _ALLOW:Boolean=false;
		public static var TRANS_TYPES:Array = [
											   	{desc:"从上到下按单个显示",value:1,realValue:1},
											  	{desc:"从下到上按单个显示",value:2,realValue:-1},
												{desc:"从左到右按单个显示",value:3,realValue:2},
												{desc:"从右到左按单个显示",value:4,realValue:-2},
												{desc:"从上到下按行显示",value:5,realValue:3},
												{desc:"从下到上按行显示",value:6,realValue:-3},
												{desc:"从左到右按行显示",value:7,realValue:4},
												{desc:"从右到左按行显示",value:8,realValue:-4},
												{desc:"随机显示",value:9,realValue:5},
												{desc:"像素缩放显示",value:10,realValue:1},
												{desc:"像素溶解显示",value:11,realValue:2}
												]
		private var _myTrans:*;
		private var _isTransing:Boolean;
		public function ImageTransition() {
			/*if(!_INIT){
				_INIT = true;
				init();
			}
			if (!_ALLOW) {
				throw new Error("不能通过new创建实例！");
			}
			return;*/
			init();
		}
		private function init():void {
			//初始化其它东西
			//trace("init");
		} 
		private function stopHandler(event:TransEvent):void{
			event.target.removeEventListener(TransEvent.TRANS_STOP,stopHandler);
			//过渡完成
			_isTransing = false;
			dispatchEvent(new TransEvent(TransEvent.TRANS_STOP));
		}
		private function startHandler(event:TransEvent):void{
			//过渡开始
			event.target.removeEventListener(TransEvent.TRANS_START,startHandler);
			dispatchEvent(new TransEvent(TransEvent.TRANS_START));
		}
		//==================================================
		/*public static function getInstance():ImageTransition{
			if(_INSTANCE == null){
				_ALLOW = true;
				_INSTANCE = new ImageTransition();
			}
			return _INSTANCE;
		}*/
		//只提供显示对象的过渡，所以不提供最后一个参数的设置
		public function transInit(ct:DisplayObjectContainer,src:BitmapData,vw:Number=400,vh:Number=300,
								  rw:Number=20,rh:Number=15,type:uint = 1,tt:uint=1):void{
			//RectTrans(ct:DisplayObjectContainer,src:BitmapData,rw:Number=20,rh:Number=15,
		 	//vw:Number=400,vh:Number=300,at:int=1,tt:uint=1,hide:Boolean = false)
			//PixTrans(ct:DisplayObjectContainer,src:BitmapData,vw:Number=400,vh:Number=300,tt:uint = 0,isIn:Boolean = true)
			_isTransing = false;
			var t:int = ImageTransition.TRANS_TYPES[type-1]["realValue"];
			trace(t);
			if(type<10){
				_myTrans = new RectTrans(ct,src,rw,rh,vw,vh,t,tt,false);
			}else{
				_myTrans = new PixTrans(ct,src,vw,vh,t,true);
			}
			_myTrans.addEventListener(TransEvent.TRANS_STOP,stopHandler);
			_myTrans.addEventListener(TransEvent.TRANS_START,startHandler);
		}
		public function setMoutionTime(t:uint=10):void{
			if(_myTrans is RectTrans){
				_myTrans.motionDalayTime = t;
			}
		}
		public function transStart():void{
			if(!_isTransing){
				_isTransing = true;
				_myTrans.transStart();
			}
		}
		public function transStop():void{
			if(_isTransing){
				_isTransing = false;
				_myTrans.transStop();
			}	
		}
	}
}