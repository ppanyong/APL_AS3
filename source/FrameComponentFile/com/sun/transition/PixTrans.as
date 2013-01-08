package com.sun.transition{
	/*
	基于像素的过渡效果
	sonsun
	2008.2.18
	*/
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.display.DisplayObjectContainer;
	import com.sun.events.TransEvent;
	public class PixTrans extends EventDispatcher {
		private var _source_bmp:BitmapData;
		private var _timer:Timer;
		private var _scale:uint;
		private var _in:Boolean;
		private var _bmW:Number;
		private var _bmH:Number;
		private var _container:DisplayObjectContainer;
		private var _randomNum:uint;
		private var _numberOfPixels:uint;
		private var _totalDissolved:uint;
		private var _pixSoureBMP:BitmapData;
		private var _pixBMP:BitmapData;
		/*
		切换类型：
		1 像素缩放
		2 像素溶解,像素溶解只支持像素溶解显示，溶解消失时，会留有背景，没找到处理背景的方式
		*/
		private var _transType:uint;
		//要兼容RectTrans类，所以提供下面的构造函数参数
		public function PixTrans(ct:DisplayObjectContainer,src:BitmapData,vw:Number=400,vh:Number=300,tt:uint = 0,isIn:Boolean = true) {
			_source_bmp = src;
			_container = ct;
			_in = isIn;
			_bmW = vw;
			_bmH = vh;
			_transType = tt;
			if (_transType==2) {
				_in = true;
			}
			_scale = isIn?100:1;
			//
			init();
		}
		private function init():void {
			_timer = new Timer(10,0);
			if (_transType==1) {
				_timer.addEventListener(TimerEvent.TIMER,pixScaleHandler);
			} else {
				//不直接操作源BMP对象，因为pixelDissolve回修改BMP对象
				_pixSoureBMP = _source_bmp.clone();
				_randomNum = Math.round(Math.random()*_pixSoureBMP.width*_pixSoureBMP.height);
				_numberOfPixels = Math.round(_source_bmp.height*_source_bmp.width/80);
				_totalDissolved = 0;
				_timer.addEventListener(TimerEvent.TIMER,pixDissolveHandler);
			}
		}
		//像素缩放过渡
		private function pixScaleHandler(event:TimerEvent):void {
			if (_container.numChildren>1) {
				_container.removeChildAt(0);
			}
			var bmp:BitmapData = new BitmapData(_source_bmp.width/_scale, _source_bmp.height/_scale, false, 0x00ffffff);
			var bm:Bitmap = new Bitmap(bmp);
			var m = new Matrix();
			m.scale(1/_scale, 1/_scale);
			bmp.draw(_source_bmp, m);

			bm.width = _bmW;
			bm.height = _bmH;

			if (_in) {
				_scale--;
				if (_scale==0) {
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER,pixScaleHandler);
					dispatchEvent(new TransEvent(TransEvent.TRANS_STOP));
				}
			} else {
				_scale++;
				if (_scale>=100) {
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER,pixScaleHandler);
					outStopHandler(true);
				}
			}
			_container.addChild(bm);
			event.updateAfterEvent();
		}
		//@param end:标志是否是正常结束，即是用户强制直接还是过渡自然结束
		private function outStopHandler(end:Boolean = true):void {
			if (!end) {
				//非正常结束，进行初始化处理
				if (_in) {
					//显示
					if (_container.numChildren>1) {
						_container.removeChildAt(0);
					}
					var bm:Bitmap = new Bitmap(_source_bmp);
					bm.width = _bmW;
					bm.height = _bmH;
					_container.addChild(bm);
				}
			}
			dispatchEvent(new TransEvent(TransEvent.TRANS_STOP));
		}
		//像素溶解过渡
		private function pixDissolveHandler(event:TimerEvent):void {
			var rect:Rectangle = _source_bmp.rect;
			var pt:Point = new Point(0, 0);

			var red:uint = 0x00FF0000;
			try {
				_randomNum = _pixBMP.pixelDissolve(_pixSoureBMP, rect, pt, _randomNum, _numberOfPixels, red);
			} catch (e:Error) {
				trace("出错误:"+e);
			}
			_totalDissolved+=_numberOfPixels;
			if (_totalDissolved>=_source_bmp.width*_source_bmp.height) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,pixDissolveHandler);
				//结束
				outStopHandler(true);
			}
			event.updateAfterEvent();
		}
		public function transStart():void {
			if (_timer.running) {
				return;
			}
			if (_transType==2) {
				_pixBMP = new BitmapData(_source_bmp.width,_source_bmp.height,true,0x00000000);
				var bm:Bitmap = new Bitmap(_pixBMP);
				bm.width = _bmW;
				bm.height = _bmH;
				if (_container.numChildren>1) {
					_container.removeChildAt(0);
				}
				_container.addChild(bm);
			}
			_timer.start();
			dispatchEvent(new TransEvent(TransEvent.TRANS_START));
		}
		public function transStop():void {
			if (!_timer.running) {
				return;
			}
			_timer.stop();
			if (_transType==1) {
				_timer.removeEventListener(TimerEvent.TIMER,pixScaleHandler);
			} else {
				_timer.removeEventListener(TimerEvent.TIMER,pixDissolveHandler);
			}
			outStopHandler(false);
		}
	}
}