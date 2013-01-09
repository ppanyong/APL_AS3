package com.flashloaded.as3 {
	import com.flashloaded.as3.PhotoFlow;

	import flash.events.Event;

	import com.flashloaded.as3.ImageContainer;

	import flash.events.ProgressEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import com.flashloaded.as3.tween.Easing;
	import com.flashloaded.as3.Points;
	import com.flashloaded.as3.effects.ReflectionEffect;
	import com.flashloaded.as3.effects.PhotoEffect;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import com.flashloaded.as3.PhotoPreloadHolder;
	import com.flashloaded.as3.PhotoFlowEvent;

	public class Photo extends Item {

		private var imageCon : ImageContainer;
		private var imgCon : DisplayObject;
		private var _photoWidth : Number = -1;
		private var _photoHeight : Number = -1;
		public var tx : Number = 0;
		public var ty : Number = 0;
		public var ts : Number = 1;
		private var eff : PhotoEffect;
		private var tween : Easing;
		private var _side : String;
		private var _hpers : Number = -1;
		private var _vpers : Number = -1;
		private var _depth : Number = 0;
		public var loaded : Boolean = false;
		private var _zoom : Boolean = false;

		private var _isload : Boolean = false;

		
		//reflection
		private var reflectEffect : ReflectionEffect;

		//preloadHolder
		private var preloadHolder : PhotoPreloadHolder;
		private var _preloader : MovieClip;

		public function Photo() {
			this.buttonMode = true;
		}

		override protected function createGraphic() : void {
			trace("dat.url="+data.url)
			imageCon = new ImageContainer(data);
			
		}

		private function createPreloaderHolder() : void {

			tween = new Easing(speed);
			preloadHolder.initPositionPreloader();
			preloadHolder.positionPreloader();
			setEvent();
		}

		override public function createImage() : void {

			if (preloadHolder == null) {
				preloadHolder = new PhotoPreloadHolder(this, "preloader");
				createPreloaderHolder();
				createPreloader();
			}
			try {
				if (this._isload) {
					if (imageCon.getInfo() != null) {
					
						imageCon.getInfo().addEventListener(Event.COMPLETE, imageReady);
						imageCon.getInfo().addEventListener(ProgressEvent.PROGRESS, loadProgress);
						//当islaod时
							imgCon = imageCon.create();
					} else {
						imgCon = imageCon.create();
						imageReady(new Event(Event.COMPLETE));
					
					//imgCon=imageCon.create();
					//imageReady(new Event(Event.COMPLETE));
					}
				}
			} catch (e) {
			}
		}

		public function get preloader() : MovieClip {
			return _preloader;
		}

		private function createPreloader() : void {
			_preloader = new PhotoFlowPreloader();
			preloader.init();
			addChild(preloader);
			preloader.align();
		}

		private function loadProgress(e : ProgressEvent) : void {
			preloader.loadProgress(e);
			var evt : PhotoFlowEvent = new PhotoFlowEvent(PhotoFlowEvent.PHOTO_LOAD_PROGRESS);
			evt.id = id;
			evt.data = data;
			evt.index = index;
			evt.progressObject = e;

			sys.dispatchEvent(evt);
		}

		public function setEvent() : void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, select);
		}

		private function mouseOutHandler(e : MouseEvent) : void {
			zoomOut();
			var evt : PhotoFlowEvent = new PhotoFlowEvent(PhotoFlowEvent.PHOTO_MOUSE_OUT);
			evt.id = id;
			evt.data = data;
			evt.index = index;
			sys.dispatchEvent(evt);
		}

		private function mouseOverHandler(e : MouseEvent) : void {

			if (zoomType != "none") {
				if (zoomType == "all") {
					zoom();
				} else if (zoomType == "selected") {
					if (selected) {
						zoom();
					}
				} else if (zoomType == "notSelected") {
					if (!selected) {
						zoom();
					}
				}
			}
			var evt : PhotoFlowEvent = new PhotoFlowEvent(PhotoFlowEvent.PHOTO_MOUSE_OVER);
			evt.id = id;
			evt.data = data;
			evt.index = index;
			sys.dispatchEvent(evt);
		}

		private function zoom() : void {
			_zoom = true;
			this.eff.image.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);

			position();
		}

		private function zoomOut() : void {
			_zoom = false;
			this.eff.image.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);

			position();
		}

		private function select(e : MouseEvent) : void {
			if (!selected) {

				sys.setSelection(index);
				sys.delayAutoFlip();
			} else {
				var evt : PhotoFlowEvent = new PhotoFlowEvent(PhotoFlowEvent.CLICK_SELECTED);
				evt.id = id;
				evt.data = data;
				evt.index = index;

				sys.dispatchEvent(evt);
			}
		}

		public function positionPreloader() : void {
			if (preloadHolder != null) {
				preloadHolder.positionPreloader();
			}
		}

		private function initVars() : void {


			eff = new PhotoEffect(this);
			eff.initPoints();

			if (showReflect) {
				reflectEffect = new ReflectionEffect(this);
			}
			if (reflectEffect != null) {
				reflectEffect.initPoints();
			}
		}

		override protected function imageReady(e : Event) : void {
			var il : ImageLoader = e.target.loader as ImageLoader;
			trace("eeeeee="+il.contentLoaderInfo.url)
			if(preloadHolder != null)
			preloadHolder.remove();
			if(preloader != null)
			preloader.remove();

			resizeImage(imgCon, sys.resizeImage, sys.photoWidth, sys.photoHeight);
			setImage(imgCon);

			setPhotoSize(image.width, image.height);

			this.y = sys.compHeight - image.height;
			_vpers = image.width * Math.sin(sys.getPhotoAngle());
			_hpers = Math.tan(sys.getPhotoAngle()) * (image.width - vpers);

			initVars();
			initSides();

			addChild(image);
			loaded = true;
			sys.positionPhotos();

			this.eff.image.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);

			super.imageReady(e);

			var evt : PhotoFlowEvent = new PhotoFlowEvent(PhotoFlowEvent.PHOTO_LOADED);
			evt.id = id;
			evt.data = data;
			evt.index = index;
			sys.dispatchEvent(evt);
		}

		public function resetDepth() : void {
			var dindex : int = index - sys.selectedIndex;
			if (dindex < 0) {
				depth = dindex * 2;
			} else if (dindex > 0) {
				depth = (dindex * -2 + 1);
			} else {
				depth = 3;
			}
			sys.sortDepths();
		}

		public function position() {

			var dindex : int = index - sys.selectedIndex;

			if (dindex < 0) {
				depth = dindex * 2;
				side = "left";
				dindex = Math.abs(dindex) - 1;

				tx = sys.leftX - sys.distance - (dindex * sys.spacing) - sys.getPhotoAt(sys.selectedIndex - 1).vWidth;

				if (!_zoom) {
					ts = 1;
					ty = sys.compHeight - photoHeight;
				} else {
					ty = sys.compHeight - photoHeight * zoomScale;
					ts = zoomScale;
				}
			} else if (dindex > 0) {
				depth = (dindex * -2 + 1);
				side = "right";
				dindex = Math.abs(dindex) - 1;

				//tx = sys.rightX + getStackX();
				//andy修改 调整了右侧对齐的算法
				tx = sys.rightX + sys.distance + (dindex * sys.spacing) + sys.getPhotoAt(sys.selectedIndex ).vWidth-vWidth;

				if (!_zoom) {
					ts = 1;
					ty = sys.compHeight - photoHeight;
				} else {
					ts = zoomScale;
					ty = sys.compHeight - photoHeight * zoomScale;
				}
			} else {
				depth = 3;
				side = "center";


				if (!_zoom) {
					tx = cx - (photoWidth * sys.selectedScale) / 2;
					ts = sys.selectedScale;
					ty = sys.selectedY + sys.compHeight - photoHeight * sys.selectedScale;
				} else {
					tx = cx - (photoWidth * zoomScale) / 2;
					ts = zoomScale;
					ty = sys.selectedY + sys.compHeight - photoHeight * zoomScale;
				}
			}
			sys.sortDepths();
			this.addEventListener(Event.ENTER_FRAME, motion);
		}

		override public function get depth() : Number {
			return _depth;
		}

		override public function set depth(num : Number) : void {
			_depth = num;
		}

		private function initSides() : void {

			var dindex : int = index - sys.selectedIndex;
			if (dindex < 0) {
				initSide("left");
			} else if (dindex > 0) {
				initSide("right");
			} else {
				initSide("center");
			}
		}

		public function motion(e : Event = null) : void {

			tx = Math.round(tx);
			ty = Math.round(ty);


			var nx : Number = tween.getNextValue(x, tx, false);
			var ny : Number = tween.getNextValue(y, ty, false);
			var ns : Number = tween.getNextValue(scaleX, ts, false, 0.001);

			x = nx;
			y = ny;
			scaleX = scaleY = ns;

			if (tween.checkFinish(x, tx) && tween.checkFinish(y, ty) && tween.checkFinish(scaleX, ts)) {
				motionComplete();
			}
			if (this.x + vWidth < 0) {
				visible = false;
			} else if (this.x > sys.compWidth) {
				visible = false;
			} else {
				visible = true;
			}
		}

		private function motionComplete() : void {

			this.removeEventListener(Event.ENTER_FRAME, motion);
		}

		override public function get sys() : * {
			return PhotoFlow(super.sys);
		}

		override public function toString() : String {
			return "photo:" + index;
		}

		public function get cx() : Number {
			return sys.cx;
		}

		private function initSide(str : String) : void {
			if (eff != null) {
				eff.transformTo(str);
			}
			if (reflectEffect != null) {
				reflectEffect.transformTo(str);
			}
			_side = str;
		}

		public function get side() : String {
			return _side;
		}

		public function set side(str : String) : void {
			if (str != _side) {
				if (eff != null) {
					eff.transform(str);

					if (reflectEffect != null) {
						reflectEffect.transform(str);
					}
				}
				_side = str;
			}
		}

		public function get photoWidth() : Number {
			var v : Number;

			if (_photoWidth != -1) {
				v = _photoWidth;
			} else {
				v = sys.photoWidth;
			}
			return v;
		}

		public function get photoHeight() : Number {
			return _photoHeight;
		}

		public function setPhotoSize(w : Number,h : Number) : void {
			_photoWidth = w;
			_photoHeight = h;
		}

		public function get points() : Points {
			return eff.points;
		}

		public function get hpers() : Number {
			if (_hpers != -1) {
				return _hpers;
			} else {
				return sys.hpers;
			}
		}

		public function get vpers() : Number {
			if (_vpers != -1) {
				return _vpers;
			} else {
				return sys.vpers;
			}
		}

		public function get vWidth() : Number {

			return photoWidth - vpers;
		}

		public function getStackX() : Number {

			if (index != sys.selectedIndex + 1) {
				var pPhoto : Photo = sys.getPhotoAt(sys.selectedIndex + 1);
				//tx = sys.rightX + sys.distance + (dindex * sys.spacing) + sys.getPhotoAt(sys.selectedIndex + 1).vWidth;
				return sys.distance + pPhoto.vWidth - vWidth + sys.spacing * index - sys.selectedIndex - 1;
			} else {

				return sys.distance;
			}
		}

		public function set speed(num) : void {

			tween.speed = num;
			eff.speed = num;
			if (reflectEffect != null) {
				reflectEffect.speed = num;
			}
		}

		public function get speed() : Number {
			return sys.speed;
		}

		public function get showReflect() : Boolean {
			return sys.showReflection;
		}

		public function get effect() : PhotoEffect {
			return eff;
		}

		public function get zoomType() : String {
			return sys.zoomType;
		}

		public function get zoomScale() : Number {
			return sys.zoomScale;
		}

		public function get isload() : Boolean {
			return _isload;
		}

		public function set isload(isload : Boolean) : void {
			_isload = isload;
			
			if (_isload && (imageCon.getInfo() != null)) {
				
				createImage();
				//imageCon.create(true);
				//trace("_isload=" + imageCon.getInfo().loaderURL);
				//imgCon=imageCon.create();
			}
		}
	}
}