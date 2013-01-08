package com.FSC.UI.InterActiveObject {
	import gs.TweenLite;	
	
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;	
	import flash.geom.Rectangle;	
	import flash.display.Sprite;
	
	/**
	 * @author andypan
	 */
	public class ScrollBar extends Sprite {
		private var target:MovieClip;
		private var top:Number;
		private var bottom:Number;
		private var dragBot:Number;
		private var range:Number;
		private var ratio:Number;
		private var sPos:Number;
		private var sRect:Rectangle;
		private var ctrl:Number;//This is to adapt to the target's position
		private var trans:String;
		private var timing:Number;
		private var isUp:Boolean;
		private var isDown:Boolean;
		private var isArrow:Boolean;
		private var arrowMove:Number;
		private var upArrowHt:Number;
		private var downArrowHt:Number;
		private var sBuffer: Number;
		public var track : MovieClip;
		public var upArrow : MovieClip;
		public var downArrow : MovieClip;
		public var scroller : MovieClip;

		public function ScrollBar():void {
			
			this.addEventListener(Event.ADDED_TO_STAGE, oninitstage);
		}

		function oninitstage(e:Event){
			//trace("----------"+stage)
			scroller.addEventListener(MouseEvent.MOUSE_DOWN, dragScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			
		}
		//
		public function init(t:MovieClip, tr:String,tt:Number,sa:Boolean,b:Number):void {
			
			target = t;
			trans = tr;
			timing = tt;
			isArrow = sa;
			sBuffer = b;
			if (target.height <= track.height) {
				this.visible = false;
			}			

			//
			upArrowHt = upArrow.height;
			downArrowHt = downArrow.height;
			if (isArrow) {
				top = scroller.y;
				dragBot = (scroller.y + track.height) - scroller.height;
				bottom = track.height - (scroller.height/sBuffer);

			} else {
				top = scroller.y;
				dragBot = (scroller.y + track.height) - scroller.height;
				bottom = track.height - (scroller.height/sBuffer);

				upArrowHt = 0;
				downArrowHt = 0;
				removeChild(upArrow);
				removeChild(downArrow);
			}
			range = bottom - top;
			sRect = new Rectangle(0,top,0,dragBot);
			ctrl = target.y;
			//set Mask
			isUp = false;
			isDown = false;
			arrowMove = 10;
			
			if (isArrow) {
				upArrow.addEventListener(Event.ENTER_FRAME, upArrowHandler);
				upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upScroll);
				upArrow.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
				//
				downArrow.addEventListener(Event.ENTER_FRAME, downArrowHandler);
				downArrow.addEventListener(MouseEvent.MOUSE_DOWN, downScroll);
				downArrow.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			}
			if(parent.getChildByName("com.FSC.UI.InterActiveObject.ScrollBar.mask")!=null){
				parent.removeChild(parent.getChildByName("com.FSC.UI.InterActiveObject.ScrollBar.mask"));
			}
			var square:Sprite = new Sprite();
			square.name="com.FSC.UI.InterActiveObject.ScrollBar.mask"
			square.graphics.beginFill(0xFF0000);
			square.graphics.drawRect(target.x, target.y, target.width+5, (track.height+upArrowHt+downArrowHt));
			parent.addChild(square);			
			target.mask = square;
			
			
		}
		public function upScroll(event:MouseEvent):void {
			isUp = true;
		}
		public function downScroll(event:MouseEvent):void {
			isDown = true;
		}
		public function upArrowHandler(event:Event):void {
			if (isUp) {
				if (scroller.y > top) {
					scroller.y-=arrowMove;
					if (scroller.y < top) {
						scroller.y = top;
					}
					startScroll();
				}
			}
		}
		//
		public function downArrowHandler(event:Event):void {
			if (isDown) {
				if (scroller.y < dragBot) {
					scroller.y+=arrowMove;
					if (scroller.y > dragBot) {
						scroller.y = dragBot;
					}
					startScroll();
				}
			}
		}
		//
		public function dragScroll(event:MouseEvent):void {		
			scroller.startDrag(false, sRect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveScroll);
		}
		//
		public function mouseWheelHandler(event:MouseEvent):void {
			if (event.delta < 0) {
				if (scroller.y < dragBot) {
					scroller.y-=(event.delta*2);
					if (scroller.y > dragBot) {
						scroller.y = dragBot;
					}
					startScroll();
				}
			} else {
				if (scroller.y > top) {
					scroller.y-=(event.delta*2);
					if (scroller.y < top) {
						scroller.y = top;
					}
					startScroll();
				}
			}
		}
		//
		public function stopScroll(event:MouseEvent):void {
			try{
				isUp = false;
				isDown = false;
				scroller.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveScroll);
			}catch(e){};	
		}
		//
		public function moveScroll(event:MouseEvent):void {
			startScroll();

		}
		public function startScroll():void {
			ratio = (target.height - range)/range;
			sPos = (scroller.y * ratio)-ctrl;
			TweenLite.to(target, timing, {y:-sPos});
		}
		/**
		 * 将滚动条定位到
		 * @param n 百分比 0~1
		 */
		public function setScroll(n:Number):void{
			scroller.y = dragBot* n + this.track.y;
			startScroll();
		}
		public override function set height(h : Number) : void {
			var oldh = this.track.height;
			this.track.height = h - this.upArrow.height - this.downArrow.height;
			this.downArrow.y = this.track.height;
			this.scroller.height = this.track.height*0.3;
		}
	}
}
