package com.tc.andypan.SmileField.Smile {
	import flash.display.MovieClip;
	
	/**
	 * @author andypan
	 * 表情1号 内容就是在lib中描述
	 */
	public class Smile extends MovieClip {
		private var type:String;
		public function Smile(str) {
			this.type = str;
		}

		public function get Type() : String {
			return type;
		}
		
		public function set Type(type : String) : void {
			this.type = type;
			var e = this.type.indexOf("]",0);
			this.gotoAndStop(Number(type.substring(3,e)));
		}
	}
}
