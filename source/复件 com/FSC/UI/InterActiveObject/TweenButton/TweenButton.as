package com.FSC.UI.InterActiveObject.TweenButton
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;

	/**渐变按钮
	*需要与显示元件绑定 
	*@pan yong
	/*v 1.080505*/
	public dynamic class TweenButton extends Sprite implements ITweenButton
	{
		/*私有成员*/
		private var _title:String;
		public var Title_txt:TextField;
		public var Bg_mc:MovieClip;
		//是否是状态转换按钮
		private var trigger:Boolean = true ;
		private var onClick:Function=null;
		
		
		//需要与界面绑定的元素
		public var title_txt:TextField;
		public var bg_mc:MovieClip;
		//常量 开始和结束
		public static var STARTFRAMENAME:String = "start";
		public static var ENDFRAMENAME:String ="end";
		
		public function get Title():String {
			return _title;
		}
		public function set Title(v : String):void {
			_title = v;
			title_txt.text = _title
			setWidth();
		}
		public function set OnClick(v : Function):void {
			onClick = v;
			if(bg_mc!=null)
				this.addEventListener(MouseEvent.CLICK,onClick);
		}
		public function get OnClick():Function {
			return onClick;
		}
		public function set Trigger(v :Boolean):void {
			trigger = v;
		}
		public function get Trigger():Boolean {
			return trigger;
		}
		
		public function TweenButton()
		{
			super();
			//如果库中有绑定的素材 则在这里进行绑定。
			if(Title_txt!=null)
			{
				title_txt = Title_txt;
			}else{
				trace("warning：没有在库中装配上Title_txt.");
			}	
			if(Bg_mc!=null)
			{
				bg_mc = Bg_mc;
				try { 
					bg_mc.gotoAndStop(STARTFRAMENAME);
				} 
				catch (myError:Error) { 
				 	trace("error caught: "+myError.message+"bg_mc中没有按照约定定义帧标签"); 
				} 
				intiEvent();
			}else{
				trace("warning：没有在库中装配上Bg_mc.")
			}
		}
		/**
		 * 设置该菜单按钮宽度 可针对不同情况被OverRide
		 */
		public function setWidth(){
			//默认状态
			if(_title!=null){
				title_txt.width = title_txt.textWidth*1.5;
				bg_mc.width = title_txt.width;
			}
		} 
		/**
		*将菜单状态返回按钮初始值
		*/
		private function refresh() {
			intiEvent();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
		}
		private function intiEvent() {
			addEventListener(MouseEvent.ROLL_OVER,onRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,onRollOutHandler);
			addEventListener(MouseEvent.CLICK,onSelfClick);
		}
		private function removeEvent() {
			removeEventListener(MouseEvent.ROLL_OVER,onRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,onRollOutHandler);
			removeEventListener(MouseEvent.CLICK,onSelfClick);
		}
		private function onSelfClick(e:MouseEvent) {
			if (trigger) {
				removeEvent();
			}
		}
		private function onRollOverHandler(e:MouseEvent) {
			bg_mc.gotoAndStop(STARTFRAMENAME);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		private function onRollOutHandler(e:MouseEvent) {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
		}
		private function onEnterFrameHandler(e:Event) {
			if (bg_mc.currentLabel != ENDFRAMENAME) {
				bg_mc.nextFrame();
			} else {
				bg_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		private function onEnterFrameHandlerBack(e:Event) {
			backTostartFrame();
		}
		private function backTostartFrame() {
			if (bg_mc.currentLabel != STARTFRAMENAME) {
				bg_mc.prevFrame();
			} else {
				bg_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandlerBack);
			}
		}
		
	}
}