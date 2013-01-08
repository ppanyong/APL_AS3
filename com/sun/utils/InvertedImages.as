package com.sun.utils
{
	/*
	负责加载并创建具有倒影效果的图片对象
	*/
	import com.sun.loader.FileLoader;
	import com.sun.events.LoaderEvent;
	//import com.sun.utils.ImgUrl;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.events.Event;

	public class InvertedImages extends Sprite
	{
		public static const CREATE_COMPLETE:String = "create_complete";
		
		private var fld:FileLoader;
		private var _data:Array;
		private var imgs:Array;
		private var temp_id:uint;
		private var _img_w:uint = 80;
		private var _img_h:uint = 60;
		private var _path:String = "";
		
		public function InvertedImages()
		{
		}
		//根据提供的数据对象创建
		private function ovdLoaded(dt:Array):void
		{
			_data = new Array();
			_data = dt;
			
			imgs = new Array();
			fld = new FileLoader();
			fld.addEventListener(LoaderEvent.LOAD_COMPLETE,completeHandler);
			fld.addEventListener(LoaderEvent.LOAD_ERROR,errorHandler);
			temp_id = 0;
			loadImage();
		}
		private function completeHandler(event:LoaderEvent):void
		{
			fldLoaded(event.value.loader,true);
		}
		private function errorHandler(event:LoaderEvent):void
		{
			fldLoaded(null,false);
		}
		private function fldLoaded(loader:Loader,rl:Boolean):void
		{
			var sp:Sprite = imgs[imgs.length-1];
			var n:String = temp_id%2==0?"img":"ref";
			var sp_tg:Sprite = sp.getChildByName(n) as Sprite;
			var ct:Sprite = sp_tg.getChildByName("ct") as Sprite;
			var border:Sprite = sp_tg.getChildByName("border") as Sprite;
			
			border.alpha = 0;
			//边框的宽度为1
			ct.x = ct.y = 1;
			
			if(rl){
				//加载成功
				loader.width = _img_w - 2;
				loader.height = _img_h - 2;
				ct.addChild(loader);
			}else{
				//加载失败
				//绘制一个白色方块
				ct.graphics.beginFill(0xCCCCCC,100);
				ct.graphics.drawRect(0,0,_img_w-2,_img_h-2);
				ct.graphics.endFill();
			}
			
			if(temp_id%2==1){
				//处理遮罩
				var mask:Sprite = sp.getChildByName("mask") as Sprite;
				drawGradientShape(mask, _img_w, _img_h/2);
				//调整位置
				sp_tg.scaleY = -1;
				mask.y = sp_tg.height;
				sp_tg.y = sp_tg.height*2;
			}
			if (temp_id>(_data.length-1)*2) {
				fld.removeEventListener(LoaderEvent.LOAD_COMPLETE,completeHandler);
				fld.removeEventListener(LoaderEvent.LOAD_ERROR,errorHandler);
				//fld.removeEventListener(LoaderEvent.LOAD_PROGRESS,progressHandler);
				fld = null;
				//
				trace("全部图片加载完成");
				dispatchEvent(new Event(InvertedImages.CREATE_COMPLETE));
			} else {
				temp_id++;
				loadImage();
			}
		}
		private function loadImage():void
		{
			var id:uint = Math.floor(temp_id/2);
			if (temp_id%2==0) {
				imgs.push(getItem(id));
			}
			if(id>=_data.length){
				return;
			}
			//提供一个路径的数组
			fld.load(_data[id]);
			//fld.load(ImgUrl.getURL(_data[id]["i"],".png"));
		}
		//返回组装好的图片容器对象
		private function getItem(id:uint):MovieClip
		{
			var sp:MovieClip = new MovieClip();
			//包含3个Sprite对象
			var img:Sprite = new Sprite();
			var img_ct:Sprite = new Sprite();
			var img_border:Sprite = new Sprite();
			img_ct.name = "ct";
			img_border.name = "border";
			img.name = "img";
			
			drawBorder(img_border,_img_w,_img_h);
			
			img.addChild(img_border);
			img.addChild(img_ct);
			sp.addChild(img);
			var ref:Sprite = new Sprite();
			var ref_ct:Sprite = new Sprite();
			var ref_border:Sprite = new Sprite();
			
			ref_ct.name = "ct";
			ref_border.name = "border";
			ref.name = "ref";
			
			drawBorder(ref_border,_img_w,_img_h);
			
			ref.addChild(ref_border);
			ref.addChild(ref_ct);
			sp.addChild(ref);
			var mask:Sprite = new Sprite();
			mask.name = "mask";
			sp.addChild(mask);
			ref.cacheAsBitmap = true;
			mask.cacheAsBitmap = true;
			ref.mask = mask;
			return sp;
		}
		private function drawBorder(tg:Sprite,w:uint,h:uint):void{
			tg.graphics.beginFill(0xFFFFFF,1);
			tg.graphics.drawRect(0,0,w,h);
			tg.graphics.endFill();
		}
		//绘制渐变矩形
		private function drawGradientShape(sp:Sprite, w:Number, h:Number):void
		{
			var colors = [0x000000, 0x000000];
			var fillType = "linear";
			var alphas = [0.5, 0];
			var ratios = [0, 0xFF];
			var spreadMethod = "pad";
			var interpolationMethod = "RGB";
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w,h,Math.PI/2,0,0);
			sp.graphics.beginGradientFill(fillType,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod);
			sp.graphics.drawRect(0,0,w,h);
			sp.graphics.endFill();
		}
		//判断提供的一个数是否是整数
//		private function isInteger(i:Number):Boolean
//		{
//			if (i/Math.round(i)==0) {
//				return true;
//			} else {
//				return false;
//			}
//		}
		//API
		public function createImages(dt:Array,img_w:uint = 80,img_h:uint = 60):void
		{
			_img_w = img_w;
			_img_h = img_h;
			ovdLoaded(dt);
		}
		public function showBorder(tg:MovieClip,b:Boolean):void{
			var img:Sprite = tg.getChildByName("img") as Sprite;
			var ref:Sprite = tg.getChildByName("ref") as Sprite;
			var img_border:Sprite = img.getChildByName("border") as Sprite;
			var ref_border:Sprite = ref.getChildByName("border") as Sprite;
			if(b){
				img_border.alpha = ref_border.alpha = 1;
			}else{
				img_border.alpha = ref_border.alpha = 0;
			}
		}
		//public function get data():Array{
//			return _data;
//		}
		public function get imageItems():Array{
			return imgs;
		}
	}
}