
package com.flashloaded.as3.effects{
	import com.flashloaded.as3.Photo;
	import com.flashloaded.as3.effects.Effect;
	import com.flashloaded.as3.Points;

	
	//
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ReflectionEffect extends Effect{
		
		private var selectedPoints:Points;
		private var notSelectedPointsLeft:Points;
		private var notSelectedPointsRight:Points;
		
		private var gradient:Sprite;
		private var updateInt:Number;
		private var distance:Number = 0;
		private var bounds:Object;

		private var bitmapData:BitmapData;
		private var bitmap:Bitmap;
		//
		private var fillType:String=GradientType.LINEAR;
		private var colors:Array=[0xffffff,0xffffff];
		
		private var currAlpha:Number;
		private var talpha:Number;
		
		private var tratio:Number;
		private var ratio:Number;
		
		private var spreadMethod:String=SpreadMethod.PAD;
		private var side:String;
		
		public function ReflectionEffect(target:Photo){
			super(target);
			
		}
		
		public function initPoints():void{
		
			
			selectedPoints=new Points(0,ph+hpers,pw+extend*2,ph+hpers,pw+extend,hpers,extend,hpers);
			
			notSelectedPointsLeft=new Points(extend,ph+hpers,pw-vpers+extend,ph-hpers*(1-view),pw-vpers+extend,hpers*view,extend,hpers);
			notSelectedPointsRight=new Points(extend,ph-hpers*(1-view),pw-vpers+extend,ph+hpers,pw-vpers+extend,hpers,extend,hpers*view);
			
			distort.image.y=photo.photoHeight-hpers;
			distort.image.x=-extend;
			
			
			gradient=new Sprite();
			gradient.cacheAsBitmap =true;
			
			
		}
		
		public function transform(side:String):void{
			this.side=side;
			
			if(!photo.selected){
				tratio=notSelectedRatio;
				talpha=notSelectedAlpha;
			}else{
				tratio=selectedRatio;
				talpha=selectedAlpha;
			}
			
			if(side=="right"){

				transformMotionTo(notSelectedPointsRight);
			}else if(side=="left"){
		
				transformMotionTo(notSelectedPointsLeft);
			}else{
				
				transformMotionTo(selectedPoints);
			}
			
			
			
			//trace(distort.image.x);
		}
		
		public function transformTo(side:String):void{
			this.side=side;
			
			if(side=="center"){
				
				transformImage(selectedPoints);
			}else if(side=="right"){
				
				transformImage(notSelectedPointsRight);
			}else{
				
				transformImage(notSelectedPointsLeft);
			}
			
			//init
			
			bitmapData=new BitmapData(reflectWidth,reflectHeight,true,0xffffff);
			bitmapData.draw(distort.image);
			
			if(photo.selected){
				ratio=tratio=selectedRatio;
				talpha=currAlpha=selectedAlpha;
			}else{
				ratio=tratio=notSelectedRatio;
				talpha=currAlpha=notSelectedAlpha;
			}
			
			resetGradient();
			
			bitmap=new Bitmap(bitmapData);
			gradient.y=bitmap.y=distort.image.y;
			gradient.x=bitmap.x=-extend;
			
			photo.addChild(bitmap);
			bitmap.cacheAsBitmap=true;
			
			photo.addChild(gradient);
			
			bitmap.mask=gradient;
			
			distort.image.visible=false;
			
		}
		
		override protected function motion(e:Event=null):void{
			super.motion(e);
			resetBitmap();
		}
		
		public function resetGradient():void{
			var matr:Matrix = new Matrix();
			
			var p:Points=photo.points;
			
			var dx:Number=p.getX(2)-p.getX(3);
			
			var dy:Number=p.getY(2)-p.getY(3);
			var r:Number=Math.atan2(dy,dx)+Math.PI/2;
			
			//trace(r*180/Math.PI);
			//var r:Number=45/180*Math.PI;
			matr.createGradientBox(reflectWidth, reflectHeight,r, 0, 0);
			
			gradient.graphics.clear();
			gradient.graphics.beginGradientFill(fillType,colors,[getNextAlpha()/100,0],[0,getNextRatio()],matr,spreadMethod); 
			gradient.graphics.drawRect(0,0,reflectWidth,reflectHeight);

		}
		
		public function get reflectWidth():Number{
			return distort.image.width+extend*3;
		}
		
		public function get reflectHeight():Number{
			
			return distort.image.height*3;
			
		}
		public function resetBitmap():void{
			
			resetGradient();
			
			bitmapData.dispose();
			bitmapData=new BitmapData(reflectWidth+extend,reflectHeight,true,0xffffff);
			bitmapData.draw(distort.image);
			bitmap.bitmapData=bitmapData;
			
		}
		
		public function get ph():Number{
			return photo.photoHeight;
		}
		public function get pw():Number{
			return photo.photoWidth;
		}
		
		public function get photo():Photo{
			return Photo(item);
		}
		override public function get points():Points{
			if(_points==null){
				_points=new Points();
			}
			return _points;
		}
		
		public function get vpers():Number{
			return photo.vpers;
		}
		public function get hpers():Number{
			return photo.hpers;
		}
		public function getNextAlpha():Number{
			var a:Number=currAlpha+((talpha-currAlpha)*speed);
			currAlpha=a;
			
			return a;
		}
		
		private function getNextRatio():Number{
			var r:Number=ratio+((tratio-ratio)*speed);
			ratio=r;
			
			return r;
		}
			
		public function get extend():Number{
			return photo.sys.reflectionExtend;
		}
		public function get notSelectedAlpha():Number{
			return photo.sys.reflectionAlpha;
		}
		
		public function get selectedAlpha():Number{
			return photo.sys.selectedReflectionAlpha;
		}
		
		public function get selectedRatio():Number{
			return photo.sys.selectedReflectionDepth;
		}
		public function get notSelectedRatio():Number{
			return photo.sys.reflectionDepth;
		}
		public function get view():Number{
			return photo.sys.view/100;
		}
		
		override public function get speed():Number{
			return photo.speed;
		}
		
	}
}