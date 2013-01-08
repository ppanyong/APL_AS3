package com.FSC.UI.LightBox {
	import flash.display.MovieClip;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	
	import flash.display.Sprite;
	
	/**
	 * 模式显示界面UI
	 * @author Andy
	 * @version 1.080515
	 * @deprecated 使用Loader下载结构
	 */
	public class LightBox extends Sprite {
		
		private var ldr:Loader;
		private var picPath:URLRequest;
		private var myHeight:Number;
		private var myWidth:Number;
		private var bgColor:uint = 0xFFFFFF;
		public var bgMc:MovieClip;
		
		/**
		 * 背景颜色
		 */
		public function get BgColor():uint {
			return bgColor;
		}
		public function set BgColor(v : uint):void {
			bgColor = v;
		}
		/**
		 * 构造函数
		 * @param path 需要加载的文件路径
		 */
		public function LightBox(path:String) {
			ldr  = new Loader();
			picPath = new URLRequest(path);
			bgMc.visible=false;
			//configureListeners(ldr.contentLoaderInfo);
			//loadPhoto();
		}
		public function loadPhoto():void {
			myHeight =stage.stageHeight;
			myWidth = stage.stageWidth;
			ldr.load(picPath);
			configureListeners(ldr.contentLoaderInfo);
			addEventListener(MouseEvent.CLICK,clickHandler);
			//addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			//addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			//addChild(ldr);
			 SetBlackBG();
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);


		}
		private var tmp_tween:Object;
		private var tmp_tween2:Object;
		private function completeHandler(event:Event):void {
			var tmp_x = -25.2
			var tmp_y = -112.6
			var tmp:Rectangle  = ldr.getRect(this) 
			trace(tmp);
			ldr.content.y = tmp_y+myHeight/2-ldr.content.height/2;
			//ldr.content.x = tmp_x+m_width/2-ldr.content.width/2-localToGlobal(new Point(tmp.x,0)).x;
			ldr.content.x = 117;
			bg_mc.visible=false;
			//bg_mc.y = ldr.y
			//bg_mc.x = ldr.x
			//setChildIndex(bg_mc,this.numChildren-1)
			//tmp_tween = new Tween(bg_mc, "alpha", Strong.easeOut, 0, 1, 10, false);
			addChildAt(ldr,this.numChildren);
			

			tmp_tween2 = new Tween(ldr, "alpha", Strong.easeOut, 0, 1, 10, false);

		}
		private function ioErrorHandler(e:IOErrorEvent){
			bg_mc.visible=false;
			delete this;
			
		}
		private function SetBlackBG():void{
			var tmp_x = -25.2;
			var tmp_y = -112.6;
			var bg:Shape = new Shape();
			bg.graphics.clear();
			bg.graphics.beginFill(bgColor);
			bg.graphics.drawRect(0, 0, myWidth,myHeight);
			bg.graphics.endFill();
			bg.alpha=0;
			bg.x = tmp_x;
			bg.y = tmp_y;
			addChild(bg);
			setChildIndex(bg_mc,this.numChildren-1)
			bg_mc.visible = true;
			bg_mc.y = tmp_y+myHeight/2-50;
			bg_mc.x = tmp_x+myWidth/2;
		}
		private function clickHandler(event:MouseEvent):void {
			//trace("clickHandler:捕获鼠标点击" + event);
			//this.dispatchEvent(new Event("OnPicClick",true));
			this.visible =false;
			delete this;

		}
	}
}