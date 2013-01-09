package net.andyClass.webSite.ui{
	import flash.display.MovieClip;
	import flash.events.*;
	/**
	 * 主导航的 按钮元件
	 * usage:import net.andyClass.webSite.ui.navItem;
	var i:navItem = new navItem(bg_mc,title_mc);
	i.Trigger =  true;
	i.OnClick = function (e:MouseEvent){
	trace('hh')
	};
	var i2:navItem = new navItem(bg2_mc,title2_mc);
	i2.Trigger =  true;
	i2.OnClick = function (e:MouseEvent){
	i.refresh();
	};
	 */
	public class navItem extends MovieClip {

		public var Bg_mc:MovieClip;
		public var Title_mc:MovieClip;
		private var startFrameName:String = "start";
		private var endFrameName:String ="end";
		public var onClick:Function=null;
		public var Trigger:Boolean;
		public var Message:String="";//表示导航需要传递的信息
		public function get OnClick():Function {
			return onClick;
		}
		public function set OnClick(v : Function):void {
			onClick = v;
			if(Title_mc!=null)
			Title_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		/**
		 * 构造函数
		 * 
		 * @param p_title标题
		 */
		public function navItem(bg_mc:MovieClip=null,title_mc:MovieClip=null,_startFrameName:String="start",_endFrameName:String="end") {
			super();
			startFrameName  = _startFrameName;
			endFrameName = _endFrameName;
			inti(bg_mc,title_mc);
		}
		public function inti(bg_mc,title_mc) {
			if (bg_mc!=null) {
				Bg_mc = bg_mc;
				Title_mc = title_mc;
				Title_mc.useHandCursor = true;
				Bg_mc.gotoAndStop(startFrameName);
				intiEvent();
			}
		}
		/**
		*将菜单状态返回按钮初始值
		*/
		public function refresh() {
			intiEvent();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
		}
		private function intiEvent() {
			Title_mc.addEventListener(MouseEvent.ROLL_OVER,onRollOverHandler);
			Title_mc.addEventListener(MouseEvent.ROLL_OUT,onRollOutHandler);
			Title_mc.addEventListener(MouseEvent.CLICK,onTitleClick);
		}
		private function removeEvent() {
			Title_mc.removeEventListener(MouseEvent.ROLL_OVER,onRollOverHandler);
			Title_mc.removeEventListener(MouseEvent.ROLL_OUT,onRollOutHandler);
			Title_mc.removeEventListener(MouseEvent.CLICK,onTitleClick);
		}
		private function onTitleClick(e:MouseEvent) {
			if (Trigger) {
				removeEvent();
			}
		}
		private function onRollOverHandler(e:MouseEvent) {
			Bg_mc.gotoAndStop(startFrameName);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		private function onRollOutHandler(e:MouseEvent) {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
		}
		private function onEnterFrameHandler(e:Event) {
			if (Bg_mc.currentLabel != endFrameName) {
				Bg_mc.nextFrame();
			} else {
				Bg_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		private function onEnterFrameHandlerBack(e:Event) {
			backTostartFrame();
		}
		private function backTostartFrame() {
			if (Bg_mc.currentLabel != startFrameName) {
				Bg_mc.prevFrame();
			} else {
				Bg_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}

	}
}