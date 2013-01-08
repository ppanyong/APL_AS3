package com.sun.utils {
	import flash.events.EventDispatcher;

	/**
	 * @author jiajialiu
	 */
	public class ImgUrl extends EventDispatcher {
		private static var  _url : String;

		public function ImgUrl() {				
		}

		public static function getURL(vid : String,type : String) : String {	
					
			var uint_max : Number = 0x00ffffffff + 1;
			var uin : Number;
			var hash_bucket : Number = 10000 * 10000;
			var svid : String = vid;
			var t : String = type;
			//trace("getpicURL:" + svid);
			var inx : Number;
			var tot : Number = 0;
			for (inx = 0;inx < svid.length; inx++) {
				var char_num : Number = svid.charCodeAt(inx);
				//trace("index: " + inx + ", char_num: " + char_num);
				tot = (tot * 32) + tot + char_num;
				if (tot >= uint_max) {
					tot = tot % uint_max;
				}
			}
			uin = tot % hash_bucket;
			_url = "http://vpic.video.qq.com/" + uin + "/" + vid + t;
			//trace("getpicURL:" + _url);
			return _url;
		}
	}
}
