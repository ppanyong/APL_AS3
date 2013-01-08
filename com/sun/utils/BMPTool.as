package com.sun.utils{
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.display.BlendMode;
	import flash.display.IBitmapDrawable;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class BMPTool{
		/**参数说明:
		source:要绘制到 BitmapData 对象的显示对象或 BitmapData 对象。
		x\y\w\h:从source上截取的bmp对象的位置和大小
		*/
		public static function getBMP(source:IBitmapDrawable,x:Number,y:Number,w:Number,h:Number,transparent:Boolean = false):BitmapData {
			var bmp:BitmapData = new BitmapData(w, h, transparent, 0x00ffffff);
			var myMatrix:Matrix = new Matrix();
			var translateMatrix:Matrix = new Matrix();
			translateMatrix.translate(-x, -y);
			myMatrix.concat(translateMatrix);
			var myColorTransform:ColorTransform = new ColorTransform();
			var blendMode:String = "normal";
			var myRectangle:Rectangle = new Rectangle(0, 0, w, h);
			var smooth:Boolean = true;
			try{
				bmp.draw(source, myMatrix, myColorTransform, blendMode, myRectangle, smooth);
			}catch(e:ArgumentError){
				trace("错误:source参数不是BitmapData或DisplayObject对象.");
				return null;
			}catch(e:SecurityError ){
				trace("错误:source 对象及（就 Sprite 或 MovieClip 对象而论）其所有子对象与调用方不在同一个域中，或者不在调用方可通过调用 Security.allowDomain() 方法访问的 SWF 文件中。")
				return null;
			}catch(e:ArgumentError ){
				trace("错误:源为空或不是有效的 IBitmapDrawable 对象。")
				return null;
			}
			return bmp;
		}
		//缩放像素实现
		public static function pixScale(source_bm:Bitmap,scale:uint = 20):Bitmap{
			var bmp:BitmapData = new BitmapData(source_bm.width/scale, source_bm.height/scale, false, 0x00ffffff);
			var bm:Bitmap = new Bitmap(bmp);
			var m = new Matrix();
			m.scale(1/scale, 1/scale);
			bmp.draw(source_bm, m);
			bm.width = source_bm.width;
			bm.height = source_bm.height;
			return bm;
		}
		//把BitmapData对象根据提供的rect参数切割成几块并重组返回，主要用于调整大小的使对象不变形
		public static function convertImageTo9Grid(source:BitmapData,rect:Rectangle):Sprite {
			if (rect.width*rect.height==0) {
				throw new Error("请提供正确的Rectangle对象");
				return null;
			}
			var sprite:Sprite = new Sprite();
			if (rect.x == 0) {
				//纵向分割
				var top_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,0,rect.width,rect.y));
				var center_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,rect.y,rect.width,rect.height));
				var bottom_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,rect.y+rect.height,rect.width,source.height - rect.height - rect.y));

				center_bm.y = top_bm.height;
				bottom_bm.y = center_bm.y+center_bm.height;

				top_bm.name = "top_bm";
				center_bm.name = "center_bm";
				bottom_bm.name = "bottom_bm";

				sprite.addChild(top_bm);
				sprite.addChild(center_bm);
				sprite.addChild(bottom_bm);
			} else if (rect.y == 0) {
				//横向分割
				var left_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,0,rect.x,rect.height));
				var h_center_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x,rect.y,rect.width,rect.height));
				var right_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x+rect.width,rect.y,source.width - rect.width - rect.x,source.height));

				h_center_bm.x = left_bm.width;
				right_bm.x = h_center_bm.x+h_center_bm.width;

				left_bm.name = "left_bm";
				h_center_bm.name = "center_bm";
				right_bm.name = "right_bm";

				sprite.addChild(left_bm);
				sprite.addChild(h_center_bm);
				sprite.addChild(right_bm);
			} else {
				//纵向横向分割
				var top_left_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,0,rect.x,rect.y));
				var top_center_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x,0,rect.width,rect.y));
				var top_right_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x+rect.width,0,source.width - rect.width - rect.x,rect.y));

				var center_left_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,rect.y,rect.x,rect.height));
				var center_center_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x,rect.y,rect.width,rect.height));
				var center_right_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x+rect.width,rect.y,source.width - rect.width - rect.x,rect.height));

				var bottom_left_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,0,rect.y + rect.height,rect.x,source.height - rect.y - rect.height));
				var bottom_center_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x,rect.y + rect.height,rect.width,source.height - rect.y - rect.height));
				var bottom_right_bm:Bitmap = new Bitmap(BMPTool.getBMP(source,rect.x+rect.width,rect.y + rect.height,source.width - rect.width - rect.x,source.height - rect.y - rect.height));

				center_center_bm.x = bottom_center_bm.x = top_center_bm.x = top_left_bm.width;
				center_right_bm.x = bottom_right_bm.x = top_right_bm.x = top_center_bm.x+top_center_bm.width;
				center_left_bm.y = center_center_bm.y = center_right_bm.y = top_left_bm.height;
				bottom_left_bm.y = bottom_center_bm.y = bottom_right_bm.y = center_left_bm.y+center_left_bm.height;


				top_left_bm.name = "top_left_bm";
				top_center_bm.name = "top_center_bm";
				top_right_bm.name = "top_right_bm";
				center_left_bm.name = "center_left_bm";
				center_center_bm.name = "center_center_bm";
				center_right_bm.name = "center_right_bm";
				bottom_left_bm.name = "bottom_left_bm";
				bottom_center_bm.name = "bottom_center_bm";
				bottom_right_bm.name = "bottom_right_bm";

				sprite.addChild(top_left_bm);
				sprite.addChild(top_center_bm);
				sprite.addChild(top_right_bm);
				sprite.addChild(center_left_bm);
				sprite.addChild(center_center_bm);
				sprite.addChild(center_right_bm);
				sprite.addChild(bottom_left_bm);
				sprite.addChild(bottom_center_bm);
				sprite.addChild(bottom_right_bm);
			}
			return sprite;
		}
		//和上面对应的调整方法:sign-->1:横向；2：纵向；3：双向
		public static function NineGridObjectSizeAjust(tg:Sprite,sign:uint = 1,w:Number = 0,h:Number = 0):void{
			//可以根据里面的对象
			switch(sign){
				case 1:
					foo1(tg,w);
					break;
				case 2:
					foo2(tg,h);
					break;
				case 3:
					foo3(tg,w,h);
					break;
			}
		}
		private static function foo1(tg:Sprite,w:Number):void{
			try{
				var left_bm:Bitmap = tg.getChildByName("left_bm") as Bitmap;
				var center_bm:Bitmap = tg.getChildByName("center_bm") as Bitmap;
				var right_bm:Bitmap = tg.getChildByName("right_bm") as Bitmap;
			}catch(e:Error){
				trace("获取显示对象出错："+e);
			}
			if(w<=left_bm.width+right_bm.width){
				return;
			}
			right_bm.x = w - right_bm.width;
			center_bm.width = right_bm.x - center_bm.x;
		}
		private static function foo2(tg:Sprite,h:Number):void{
			try{
				var top_bm:Bitmap = tg.getChildByName("top_bm") as Bitmap;
				var center_bm:Bitmap = tg.getChildByName("center_bm") as Bitmap;
				var bottom_bm:Bitmap = tg.getChildByName("bottom_bm") as Bitmap;
			}catch(e:Error){
				trace("获取显示对象出错："+e);
			}
			if(h<=top_bm.height+bottom_bm.width){
				return;
			}
			bottom_bm.y = h - bottom_bm.height;
			center_bm.height = bottom_bm.y - center_bm.y;
		}
		private static function foo3(tg:Sprite,w:Number,h:Number):void{
			try{
				var top_left_bm:Bitmap = tg.getChildByName("top_left_bm") as Bitmap;
				var top_center_bm:Bitmap = tg.getChildByName("top_center_bm") as Bitmap;
				var top_right_bm:Bitmap = tg.getChildByName("top_right_bm") as Bitmap;
				var center_left_bm:Bitmap = tg.getChildByName("center_left_bm") as Bitmap;
				var center_center_bm:Bitmap = tg.getChildByName("center_center_bm") as Bitmap;
				var center_right_bm:Bitmap = tg.getChildByName("center_right_bm") as Bitmap;
				var bottom_left_bm:Bitmap = tg.getChildByName("bottom_left_bm") as Bitmap;
				var bottom_center_bm:Bitmap = tg.getChildByName("bottom_center_bm") as Bitmap;
				var bottom_right_bm:Bitmap = tg.getChildByName("bottom_right_bm") as Bitmap;
			}catch(e:Error){
				trace("获取显示对象出错："+e);
			}
			if(w>top_left_bm.width+top_right_bm.width){
				top_right_bm.x = center_right_bm.x = bottom_right_bm.x = w - bottom_right_bm.width;
				top_center_bm.width = center_center_bm.width = bottom_center_bm.width = bottom_right_bm.x - bottom_center_bm.x;
			}
			if(h>top_left_bm.height+bottom_left_bm.height){
				bottom_left_bm.y = bottom_center_bm.y = bottom_right_bm.y = h - bottom_right_bm.height;
				center_left_bm.height = center_center_bm.height = center_right_bm.height = bottom_center_bm.y - bottom_center_bm.y;
			}
		}
	}
}