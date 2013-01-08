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
		private var title:String;
		
		public var Title_txt:TextField;
		public var Bg_mc:MovieClip;
		//是否是状态转换按钮
		private var trigger:Boolean = true ;
		private var onClickHandler:Function=null;
		
		
		//需要与界面绑定的元素
		public var title_txt:TextField;
		public var bg_mc:MovieClip;
		//常量 开始和结束
		public static var STARTFRAMENAME:String = "start";
		public static var ENDFRAMENAME:String ="end";
		
		public function get Title():String {
			return title;
		}
		public function set Title(v : String):void {
			title = v;
			title_txt.text = title;
			SetWidth();
		}
		public function set ClickHandler(v : Function):void {
			onClickHandler = v;
			if(bg_mc!=null)
				this.addEventListener(MouseEvent.CLICK,onClickHandler);
		}
		public function get ClickHandler():Function {
			return onClickHandler;
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
				IntiEvent();
			}else{
				trace("warning：没有在库中装配上Bg_mc.");
			}
		}
		/**
		 * 设置该菜单按钮宽度 可针对不同情况被OverRide
		 */
		public function SetWidth():void{
			//默认状态
			if(title!=null){
				title_txt.width = title_txt.textWidth*1.5;
				bg_mc.width = title_txt.width;
			}
		} 
		/**
		*将菜单状态返回按钮初始值
		*/
		public function Refresh():void {
			IntiEvent();
			this.addEventListener(Event.ENTER_FRAME, EnterFrameHandlerBack);
		}
		private function IntiEvent():void {
			addEventListener(MouseEvent.ROLL_OVER,RollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,RollOutHandler);
			addEventListener(MouseEvent.CLICK,SelfClickHandler);
		}
		private function RemoveEvent():void {
			removeEventListener(MouseEvent.ROLL_OVER,RollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,RollOutHandler);
			removeEventListener(MouseEvent.CLICK,SelfClickHandler);
		}
		private function SelfClickHandler(e:MouseEvent) :void{
			if (trigger) {
				RemoveEvent();
			}
		}
		private function RollOverHandler(e:MouseEvent):void {
			RollOverDo();
		}
		private function RollOverDo():void{
			bg_mc.gotoAndStop(STARTFRAMENAME);
			this.removeEventListener(Event.ENTER_FRAME, EnterFrameHandlerBack);
			this.addEventListener(Event.ENTER_FRAME, EnterFrameHandler);
		}
		
		public function Selected():void{
			RollOverDo();
			RemoveEvent();
		}
		private function RollOutHandler(e:MouseEvent) :void{
			this.removeEventListener(Event.ENTER_FRAME, EnterFrameHandler);
			this.addEventListener(Event.ENTER_FRAME, EnterFrameHandlerBack);
		}
		private function EnterFrameHandler(e:Event):void {
			if (bg_mc.currentLabel != ENDFRAMENAME) {
				bg_mc.nextFrame();
			} else {
				bg_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME, EnterFrameHandler);
			}
		}
		private function EnterFrameHandlerBack(e:Event):void {
			BackTostartFrame();
		}
		private function BackTostartFrame():void {
			if (bg_mc.currentLabel != STARTFRAMENAME) {
				bg_mc.prevFrame();
			} else {
				bg_mc.stop();
				this.removeEventListener(Event.ENTER_FRAME, EnterFrameHandlerBack);
			}
		}
		
	}
}