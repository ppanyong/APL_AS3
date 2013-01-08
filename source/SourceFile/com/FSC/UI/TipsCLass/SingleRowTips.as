package com.FSC.UI.TipsCLass {
	import flash.text.TextField;	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;	

	/**
	 * 提示类
	 * @author Andy
	 * @version 1.080519
	 */
	public class SingleRowTips extends MovieClip {
		
		private var bgMc : Sprite;
		private var tipsText : TextField;
		private var content:String;
		private var minWidth : Number = 50;

		
		public function SingleRowTips(t:String="") {
			super();
			Show(t);
		}
		
		public function get BgMc() : Sprite {
			return bgMc;
		}
		
		public function set BgMc(bgMc : Sprite) : void {
			this.bgMc = bgMc;
		}
		
		public function get TipsText() : TextField {
			return tipsText;
		}
		
		public function set TipsText(tipsText : TextField) : void {
			this.tipsText = tipsText;
		}
		
		public function get Content() : String {
			return content;
		}
		
		public function set Content(content : String) : void {
			this.content = content;
		}
		
		public function get MinWidth() : Number {
			return minWidth;
		}
		
		public function set MinWidth(minWidth : Number) : void {
			this.minWidth = minWidth;
		}
		
		private function SetWidth(width : Number): void {
			if (width<minWidth) {
					width = minWidth;
			}
			if(bgMc!=null){
				bgMc.scale9Grid = SetTipsBGScale9Grid();
				bgMc.width += (bgMc.width - SetTipsBGScale9Grid().width);
			}
			
		}
		
		protected function SetTipsBGScale9Grid() : Rectangle {
			var r:Rectangle = new Rectangle(8,4,158,32);
			return r;
		}
		
		protected function Show(txt:String):void{
			if(txt=="")
				return;
			var l:Number = txt.length;
			var w:Number = l*(this.tipsText.getTextFormat().size as Number);
			this.tipsText.width = w+20;
			this.tipsText.text =txt;
			SetWidth(w);
		}
	}
}
