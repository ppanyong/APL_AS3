package com.FSC.UI.DateUI {
	import flash.events.Event;	
	import flash.display.MovieClip;	
	import flash.display.SimpleButton;	
	import flash.events.MouseEvent;	
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author andypan
	 */
	public class Calendar extends Sprite {

		private var gapX : Number = 30;
		private var gapY : Number = 24;
		private var _current_date = new Date();
		private var _currentYear : Number = _current_date.getFullYear();
		private var _currentMonth : Number = _current_date.getMonth();
		private var monthdaysOlympic_arr = new Array(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		private var monthdaysNormal_arr = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		public var bPrevMonth : SimpleButton = new SimpleButton();
		public var bNextMonth : SimpleButton = new SimpleButton();
		public var bPrevYear : SimpleButton = new SimpleButton();
		public var bNextYear : SimpleButton = new SimpleButton();
		public var mList : MovieClip = new MovieClip(); 
		public var title : TextField = new TextField();
		public var selectedDateArray : Array = new Array();

		private var isStartDrag : Boolean = false;

		public function Calendar() {
			bPrevMonth.addEventListener(MouseEvent.MOUSE_DOWN, prevMonth);
			bNextMonth.addEventListener(MouseEvent.MOUSE_DOWN, nextMonth);
			bPrevYear.addEventListener(MouseEvent.MOUSE_DOWN, prevYear);
			bNextYear.addEventListener(MouseEvent.MOUSE_DOWN, nextYear);
			builtCalendar()
		}

		private function dayStart(month : Number, year : Number) : Number {
			var tmpDate : Date = new Date(year, month, 1);
			return (tmpDate.getDay());
		}

		private function daysMonth(month : Number, year : Number) : Number {
			var tmp : Number = year % 4;
			if (tmp == 0) {
				return (monthdaysOlympic_arr[month]);
			} else {
				return (monthdaysNormal_arr[month]);
			}
		}

		private function clearCalendar() : void {
			var total : Number = mList.numChildren;
			for (var i : Number = 0;i < total; i++) {
				mList.removeChildAt(0);
			}
		}

		private function builtCalendar() : void {
			clearCalendar();
			var totalDay : Number = daysMonth(_currentMonth, _currentYear);
			var firstDay : Number = dayStart(_currentMonth, _currentYear);
			var ffd : Number = 0;
			var hisY : Number = 0;
			for (var i : Number = (-firstDay + 1);i <= (totalDay - new Date(Number(_currentMonth + 1) + "/" + totalDay + "/" + _currentYear).day + 6); i++) {
				var item : DateItem = new DateItem();
				var tmp_date : Date = new Date(Number(_currentMonth + 1) + "/" + String((i < 1) ? 1 : i) + "/" + _currentYear);
				if(i <= 0) {
					tmp_date.date = tmp_date.date + i - 1; 
				}
				item.txt.text = String(tmp_date.date);
				item.date = tmp_date;
				item.x = gapX * ffd;
				item.y = hisY;
				if(tmp_date.month != _currentMonth)item.alpha = 0.5;
				item.name = "DateItem_" + i;
				if (ffd >= 6) {
					ffd = 0;
					hisY += gapY;
				} else {
					ffd++;
				}
				item.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				item.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				mList.addChild(item);
			}
			title.text = _currentYear + " - " + Number(_currentMonth + 1);
		}

		private function onMouseUpHandler(e : MouseEvent) : void {
			this.isStartDrag = false;
			var item : DateItem = e.currentTarget as DateItem;
			dealMouseOverEvent(false);
			if(selectedDateMode == "周模式") {
				selectedDateArray = new Array();
				for(var j : Number = 0;j < mList.numChildren;j++) {
					(mList.getChildAt(j) as DateItem).selected = false;
				}
				var tmp_no : Number = Number(item.name.substring(9, item.name.length));
				for(var i : Number = (tmp_no - item.date.day);i <= (tmp_no + 6 - item.date.day);i++) {
					var tmp : DateItem = (mList.getChildByName("DateItem_" + i) as DateItem);
					if(tmp != null) {
						tmp.selected = true;
						selectedDateArray.push(tmp.date);
					}else{
					}
				}
			}else {
				if(selectedDateArray.length < 2) {
					item.selected = true;
					selectedDateArray.push(item.date);
				}
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 鼠标拖车中
		 */
		private function onMouseDraging() {
		}	

		private var statrtNo : Number;
		private var selectedDateMode : String;

		private function onMouseDownHandler(e : MouseEvent) : void {
			this.isStartDrag = true;
			var item : DateItem = e.currentTarget as DateItem;
			statrtNo = Number(item.name.substring(9, item.name.length));
			if(selectedDateArray.length == 7 && selectedDateArray[0].day == 0&&(selectedDateArray.indexOf(item.date)==-1)) {
				selectedDateMode = "周模式";
				statrtNo = item.date.date - item.date.day;
			}else {
				selectedDateMode = "天模式";
				selectedDateArray = new Array();
				dealMouseOverEvent(true);
			}
		}

		/**
		 * 为Dataitem安装和移除mouseOver事件
		 */
		private function dealMouseOverEvent(on : Boolean) {
			for(var i : Number = 0;i < mList.numChildren;i++) {
				var item : DateItem = mList.getChildAt(i) as DateItem;
				if(on) {
					item.selected = false;
					item.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler)
				}else {
					item.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler)
				}
			}
		}

		/**
		 * 当鼠标拖扯中的鼠标滑过事件处理
		 */
		private function onMouseOverHandler(e : MouseEvent) : void {
			var item : DateItem = e.currentTarget as DateItem;
			var endno : Number = Number(item.name.substring(9, item.name.length)) + 1;
			selectedDateArray = new Array();
			for(var i : Number = 0;i < mList.numChildren;i++) {
				var item2 : DateItem = mList.getChildAt(i) as DateItem;
				var thisNO : Number = Number(item2.name.substring(9, item2.name.length));
				if(statrtNo < endno) {
					if(thisNO >= statrtNo && thisNO < endno) {
						item2.selected = true;
						selectedDateArray.push(item2.date);
					}else {
						item2.selected = false;
					}
				}else {
					if(thisNO <= statrtNo && thisNO >= endno - 1) {
						item2.selected = true;
						selectedDateArray.push(item2.date);
					}else {
						item2.selected = false;
					}
				}
			}
		}

		private function prevMonth(e : MouseEvent) : void {
			if (_currentMonth == 0) {
				_currentMonth = 11;
				_currentYear--;
			} else {
				_currentMonth--;
			}
			builtCalendar();
		}

		private function nextMonth(e : MouseEvent) : void {
			if (_currentMonth == 11) {
				_currentMonth = 0;
				_currentYear++;
			} else {
				_currentMonth++;
			}
			builtCalendar();
		}

		private function prevYear(e : MouseEvent) : void {
			_currentYear--;
			builtCalendar();
		}

		private function nextYear(e : MouseEvent) : void {
			_currentYear++;
			builtCalendar();
		}
	}
}