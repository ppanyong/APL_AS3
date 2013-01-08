package com.FSC.UI.DateUI {
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;	
	import flash.text.TextField;	
	import flash.display.Sprite;
	
	/**
	 * @author andypan
	 */
	public class DateItem extends Sprite {
		public var txt:TextField;
		public var bg:MovieClip = new MovieClip();
		public var mouseOverbg:MovieClip = new MovieClip();
		private var _selected:Boolean;
		private var _date:Date;
		
		public function DateItem() {
			this.buttonMode=true;
			this.bg.gotoAndStop(1);
			this.mouseOverbg.gotoAndStop(1);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
		}
		
		private function onMouseOutHandler(event:MouseEvent) : void {
			this.mouseOverbg.gotoAndStop(1);
		}

		private function onMouseOverHandler(event:MouseEvent) : void {
			this.mouseOverbg.gotoAndStop(2);
		}
		
		public function get selected() : Boolean {
			return _selected;
		}
		
		public function set selected(selected : Boolean) : void {
			_selected = selected;
			if(_selected){
				this.bg.gotoAndStop(2);
			}else{
				this.bg.gotoAndStop(1);
			}
		}
		
		public function get date() : Date {
			return _date;
		}
		
		public function set date(date : Date) : void {
			_date = date;
		}
	}
}
