package com.sun.events {
	import flash.events.Event;

	/**
	 * @author jiajialiu
	 */
	public class VidUrlEvent extends Event {

		private var  _url_vid : String = "";
		private var  _url_lnk : String = "";
		private var _cdn : Boolean = false;
		public static const VID_URL : String = "vidtourl";

		
		public function VidUrlEvent() {
			super(VID_URL);
		}

		public function set VID(u : String) : void {
		
			_url_vid = u;
		}

		public function get VID() : String {
		
			return _url_vid;
		}	

		public function set URL_LNK(u : String) : void {
		
			_url_lnk = u;
		}

		public function get URL_LNK() : String {
		
			return _url_lnk;
		}

		public function set CDN(c : Boolean) : void {
			_cdn = c;
		}

		public function get CDN() : Boolean {
			return _cdn;
		}
	}
}
