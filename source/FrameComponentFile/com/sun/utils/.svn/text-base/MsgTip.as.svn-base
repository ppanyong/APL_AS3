package com.sun.utils{
	import com.sun.utils.BMPTool;
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.text.TextField;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class MsgTip extends Sprite
	{
		private var bg_sp:Sprite;
		private var bm:Bitmap;
		private var mask_sp:Shape;
		private var msg_txt:TextField;
		//显示或者隐藏的速度
		private var speed:Number = 0.1;
		
		private var timer:Timer;
		
		private var _textColor:uint = 0xcccccc;
		private var _bgColor:uint = 0x333333;
		
		public function MsgTip(w:uint=100,h:uint=20)
		{
			init(w,h);
		}
		private function init(w:uint=100,h:uint=20):void
		{
			bg_sp = new Sprite();
			mask_sp = new Shape();
			bm = new Bitmap();
			
			bm.mask = mask_sp;
			bm.x = 5;
			bm.y = 2;
			
			drawRect(bg_sp,w,h,_bgColor,0.6);
			drawRect(mask_sp,w,h,0xff0000,1);
			
			
			textInit(h);
			
			bm.alpha = 0;
			bg_sp.alpha = 0;
			
			addChild(bg_sp);
			addChild(bm);
			addChild(mask_sp);
		}
		private function textInit(h:uint):void
		{
			msg_txt = new TextField();
			msg_txt.autoSize = "left";
			msg_txt.height = h;
			msg_txt.textColor = _textColor;
			msg_txt.cacheAsBitmap = true;
			
		}
		private function drawRect(tg:*,w:uint,h:uint,c:uint,a:Number):void
		{
			tg.graphics.beginFill(c,a);
			tg.graphics.drawRect(0,0,w,h);
			tg.graphics.endFill();
		}
		private function timerHandler(event:TimerEvent):void
		{
			if(bm.alpha<0){
				bm.alpha = 0;
			}
			if(bg_sp.alpha<0){
				bg_sp.alpha = 0;
			}
			if(bm.alpha>1){
				bm.alpha = 1;
			}
			if(bg_sp.alpha>0.6){
				bg_sp.alpha = 0.6;
			}
			if(speed<0){
				if(bm.alpha==0&&bg_sp.alpha==0){
					timer.stop();
					bm.bitmapData = null;
					return;
				}
			}
			if(speed>0){
				if(bm.alpha==1&&bg_sp.alpha==0.6){
					timer.stop();
					return;
				}
			}
			bm.alpha+=speed;
			bg_sp.alpha+=speed;
		}
		public function showTip(msg:String):void{
			msg_txt.text = msg;
			bm.bitmapData = BMPTool.getBMP(msg_txt,msg_txt.x,msg_txt.y,msg_txt.width,msg_txt.height,true);
			if(timer==null){
				timer = new Timer(100,0);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
			}
			if(!timer.running){
				timer.start();
			}
			speed = 0.1;
		}
		
		public function hideTip():void
		{
			if(timer==null){
				timer = new Timer(100,0);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
			}
			if(!timer.running){
				timer.start();
			}
			speed = -0.1;
		}
		public function setWidth(w:Number):void
		{
			mask_sp.width = bg_sp.width = w;
		}
	}
}