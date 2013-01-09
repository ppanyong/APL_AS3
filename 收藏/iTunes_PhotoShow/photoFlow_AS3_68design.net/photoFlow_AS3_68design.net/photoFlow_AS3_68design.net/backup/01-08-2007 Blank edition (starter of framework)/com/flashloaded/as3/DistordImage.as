

package com.flashloaded.as3{
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;

	public class DistordImage {
		private var _mc:MovieClip;
		private var _w:Number;
		private var _h:Number;
		// -- skew and translation matrix
		private var _sMat:Matrix;
		private var _tMat:Matrix;
		private var _xMin, _xMax, _yMin, _yMax:Number;
		private var _hseg:Number;
		private var _vseg:Number;
		private var _hsLen:Number;
		private var _vsLen:Number;
		private var _p:Array;
		private var _tri:Array;
		private var _texture:BitmapData;

		private var v:Number = 0;

		private var _p1:Object;
		private var _p2:Object;
		private var _p3:Object;
		private var _p4:Object;
		private var type:String;

		private var p:Object;
		private var interId:Number;

		private var vx=0;
		private var vx1 = 0;
		private var vx2 = 0;
		private var vx3 = 0;
		private var vx4 = 0;

		private var vy=0;
		private var vy1 = 0;
		private var vy2 = 0;
		private var vy3 = 0;
		private var vy4 = 0;


		private var f = 1-friction/10;
		private var sp = effectStrength/10;



		private var sys:MovieClip;

		/* Constructor
		 *
		 * @param mc MovieClip :  the movieClip containing the distorded picture
		 * @param symbolId String : th link name of the picture in the library
		 * @param vseg Number : the vertical precision
		 * @param hseg Number : the horizontal precision
		 */

		public function DistordImage(_sys) {
			this.sys = _sys;

		}
		public function make(mc:MovieClip, holder_mc:MovieClip, vseg:Number, hseg:Number, type:String):Void {

			this.type = type;

			_mc = mc;
			_texture = new BitmapData(holder_mc._width, holder_mc._height, true, 0x00ffff);
			_texture.draw(holder_mc);
			_vseg = vseg;
			_hseg = hseg;
			_w = _texture.width;
			_h = _texture.height;


			__init(holder_mc);
			//holder_mc.unloadMovie();
			//_mc._visible=false;


		}
		private function __init(holder:MovieClip):Void {
			_p = new Array();
			_tri = new Array();
			var ix:Number;
			var iy:Number;
			var w2:Number = _w/2;
			var h2:Number = _h/2;
			_xMin = _yMin=0;
			_xMax = _w;
			_yMax = _h;
			_hsLen = _w/(_hseg+1);
			_vsLen = _h/(_vseg+1);
			var x:Number, y:Number;
			// -- we create the points
			for (ix=0; ix<_vseg+2; ix++) {
				for (iy=0; iy<_hseg+2; iy++) {
					x = ix*_hsLen;
					y = iy*_vsLen;
					_p.push({x:x, y:y, sx:x, sy:y});
				}
			}
			// -- we create the triangles
			for (ix=0; ix<_vseg+1; ix++) {
				for (iy=0; iy<_hseg+1; iy++) {
					_tri.push([_p[iy+ix*(_hseg+2)], _p[iy+ix*(_hseg+2)+1], _p[iy+(ix+1)*(_hseg+2)]]);
					_tri.push([_p[iy+(ix+1)*(_hseg+2)+1], _p[iy+(ix+1)*(_hseg+2)], _p[iy+ix*(_hseg+2)+1]]);
				}
			}
			_p1 = {x:0, y:0};
			_p2 = {x:holder._width, y:0};
			_p3 = {x:holder._width, y:holder._height};
			_p4 = {x:0, y:holder._height};

			__render();

		}
		public function setTransform(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String):Void {
			interId = setInterval(this, "transform1", speed, x0, y0, x1, y1, x2, y2, x3, y3, side);
		}
		private function transform1(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String) {
			_p1.x = coutSp(_p1.x, x0);
			_p1.y = coutSp(_p1.y, y0);

			_p2.x = coutSp(_p2.x, x1);
			_p2.y = coutSp(_p2.y, y1);

			_p3.x = coutSp(_p3.x, x2);
			_p3.y = coutSp(_p3.y, y2);

			_p4.x = coutSp(_p4.x, x3);
			_p4.y = coutSp(_p4.y, y3);

			setBlurXY(_p4.x,x3,_p4.y,y3);


			if (checkPos(x0, y0, x1, y1, x2, y2, x3, y3)) {
				setTransform2(_p1.x,_p1.y,_p2.x,_p2.y,_p3.x,_p3.y,_p4.x,_p4.y);
			} else {
				onEndMotion();
				clearInterval(interId);

			}
		}
		public function setTransform3(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String):Void {

			vx1 = 0;
			vx2 = 0;
			vx3 = 0;
			vx4 = 0;

			vy1 = 0;
			vy2 = 0;
			vy3 = 0;
			vy4 = 0;

			f = 1-friction/10;
			sp = effectStrength/10;

			interId = setInterval(this, "transform3", speed, x0, y0, x1, y1, x2, y2, x3, y3, side);

		}
		private function transform3(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String) {
			var ax = (x0-_p1.x)*sp;
			vx1 += ax;
			vx1 *= f;

			var ay = (y0-_p1.y)*sp;
			vy1 += ay;
			vy1 *= f;
			//
			_p1.x += vx1;
			_p1.y += vy1;
			//
			var ax = (x1-_p2.x)*sp;
			vx2 += ax;
			vx2 *= f;

			var ay = (y1-_p2.y)*sp;
			vy2 += ay;
			vy2 *= f;

			//
			_p2.x += vx2;
			_p2.y += vy2;
			//
			var ax = (x2-_p3.x)*sp;
			vx3 += ax;
			vx3 *= f;

			var ay = (y2-_p3.y)*sp;
			vy3 += ay;
			vy3 *= f;
			//
			_p3.y += vy3;
			_p3.x += vx3;
			//

			var ax = (x3-_p4.x)*sp;
			vx4 += ax;
			vx4 *= f;

			var ay = (y3-_p4.y)*sp;
			vy4 += ay;
			vy4 *= f;

			//
			_p4.y += vy4;
			_p4.x += vx4;
			//

			setBlurXY(_p4.x,x3,_p4.y,y3);

			if (checkPos2(vx4, ax, vy4, ay)) {

				setTransform2(_p1.x,_p1.y,_p2.x,_p2.y,_p3.x,_p3.y,_p4.x,_p4.y);
			} else {

				onEndMotion();
				clearInterval(interId);

			}
		}
		public function setTransform4(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String):Void {

			var d=Math.abs(_p3.x-x2);
			if (d==0) {
				d=Math.abs(_p1.x-x0);
			}
			vx=d/(10-effectStrength);

			var d=Math.abs(_p2.y-y1);
			if (d==0) {
				d=Math.abs(_p4.y-y3);
			}
			vy=d/(10-effectStrength);

			interId = setInterval(this, "transform4", speed+50, x0, y0, x1, y1, x2, y2, x3, y3, side);
		}
		private function transform4(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String) {

			_p1.x = meanSpeedX(_p1.x, x0);
			_p2.x = meanSpeedX(_p2.x, x1);
			_p3.x = meanSpeedX(_p3.x, x2);
			_p4.x = meanSpeedX(_p4.x, x3);

			_p1.y = meanSpeedY(_p1.y, y0);
			_p2.y = meanSpeedY(_p2.y, y1);
			_p3.y = meanSpeedY(_p3.y, y2);
			_p4.y = meanSpeedY(_p4.y, y3);

			setBlurXY(_p4.x,x3,_p4.y,y3);

			if (checkPos(x0, y0, x1, y1, x2, y2, x3, y3)) {
				setTransform2(_p1.x,_p1.y,_p2.x,_p2.y,_p3.x,_p3.y,_p4.x,_p4.y);
			} else {
				onEndMotion();
				clearInterval(interId);
			}
		}
		private function meanSpeedX(n,t):Number {

			var b:Boolean=(t-n)<0;
			var d=Math.abs(t-n);

			if (d<1) {
				return t;
			}
			var v=vx;

			if (b) {
				return n - v;
			} else {
				return n + v;

			}
		}
		private function meanSpeedY(n,t):Number {

			var b:Boolean=(t-n)<0;
			var d=Math.abs(t-n);
			if (d<1) {
				return t;
			}
			var v=vy;

			if (b) {
				return n - v;
			} else {
				return n + v;

			}
		}
		private function onEndMotion() {

			sys.onEndMotion(_mc);
		}
		private function checkPos(p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y) {
			var p1xb = extreme(p1x, _p1.x);
			var p1yb = extreme(p1y, _p1.y);
			var p2xb = extreme(p2x, _p2.x);
			var p2yb = extreme(p2y, _p2.y);
			var p3xb = extreme(p3x, _p3.x);
			var p3yb = extreme(p3y, _p3.y);
			var p4xb = extreme(p4x, _p4.x);
			var p4yb = extreme(p4y, _p4.y);

			if (p1xb && p1yb && p2xb && p2yb && p3xb && p3yb && p4xb && p4yb) {
				return false;
			}
			return true;
		}
		private function checkPos2(n1:Number, n2:Number, n3:Number, n4:Number) {
			var nb1 = extreme(n1, 0);
			var nb2 = extreme(n2, 0);
			var nb3 = extreme(n3, 0);
			var nb4 = extreme(n4, 0);

			if (nb1 && nb2 && nb3 && nb4) {
				return false;
			}
			return true;
		}
		private function extreme(n1:Number, n2:Number) {
			if (Math.abs(n1-n2)<1) {
				return true;
			}
			return false;
		}
		public function setBlurXY(x1, x2, y1, y2) {
			var bx = Math.abs(x1-x2);
			var by = Math.abs(y1-y2);
			var d = blur/10;

			if (bx>by) {
				_mc.filters = [new BlurFilter(bx*d, 0, 10)];
			} else {
				_mc.filters = [new BlurFilter(0, by*d, 10)];
			}
		}
		public function coutSp(n:Number, t:Number) {

			var d = n-t;

			if (Math.abs(d)>3) {
				n -= d*effectStrength/10;

			} else {
				return t;
			}
			return n;
		}
		public function setTransform2(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, side:String):Void {

			var w:Number = _w;
			var h:Number = _h;
			var dx30:Number = x3-x0;
			var dy30:Number = y3-y0;
			var dx21:Number = x2-x1;
			var dy21:Number = y2-y1;
			var l:Number = _p.length;
			while (--l>-1) {
				var point:Object = _p[l];
				var gx = (point.x-_xMin)/w;
				var gy = (point.y-_yMin)/h;
				var bx = x0+gy*(dx30);
				var by = y0+gy*(dy30);
				point.sx = bx+gx*((x1+gy*(dx21))-bx);
				point.sy = by+gx*((y1+gy*(dy21))-by);
			}
			_p1.x = x0;
			_p1.y = y0;
			_p2.x = x1;
			_p2.y = y1;
			_p3.x = x2;
			_p3.y = y2;
			_p4.x = x3;
			_p4.y = y3;

			__render();

		}
		private function __render(Void):Void {
			var t:Number;
			var vertices:Array;
			var p0, p1, p2:Object;
			var c:MovieClip = _mc;
			var a:Array;
			c.clear();
			_sMat = new Matrix();
			_tMat = new Matrix();
			var l:Number = _tri.length;
			while (--l>-1) {
				a = _tri[l];
				p0 = a[0];
				p1 = a[1];
				p2 = a[2];
				var x0:Number = p0.sx;
				var y0:Number = p0.sy;
				var x1:Number = p1.sx;
				var y1:Number = p1.sy;
				var x2:Number = p2.sx;
				var y2:Number = p2.sy;
				var u0:Number = p0.x;
				var v0:Number = p0.y;
				var u1:Number = p1.x;
				var v1:Number = p1.y;
				var u2:Number = p2.x;
				var v2:Number = p2.y;
				_tMat.tx = u0;
				_tMat.ty = v0;
				_tMat.a = (u1-u0)/_w;
				_tMat.b = (v1-v0)/_w;
				_tMat.c = (u2-u0)/_h;
				_tMat.d = (v2-v0)/_h;
				_sMat.a = (x1-x0)/_w;
				_sMat.b = (y1-y0)/_w;
				_sMat.c = (x2-x0)/_h;
				_sMat.d = (y2-y0)/_h;
				_sMat.tx = x0;
				_sMat.ty = y0;
				_tMat.invert();
				_tMat.concat(_sMat);
				c.beginBitmapFill(_texture,_tMat,false,false);
				c.moveTo(x0,y0);
				c.lineTo(x1,y1);
				c.lineTo(x2,y2);
				c.endFill();

			}
		}
		public function get clip():MovieClip {
			return _mc;
		}
		public function get speed() {
			return 0;
		}
		public function get friction() {
			return 0;
		}
		public function get effectStrength() {
			return 0;
		}
		public function get blur() {
			return 0;
		}
	}
}