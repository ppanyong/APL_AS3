package com.FSC.UI.TipsCLass {
	import gs.TweenLite;	
	
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadingUI.LoadingUI;	

	import flash.display.DisplayObject;	
	import flash.text.TextFormat;	
	import flash.text.TextField;		
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/**
	 * 提示类 待修改
	 * @author Andy
	 * @version 1.080519
	 */
	public class SingleRowTips extends MovieClip implements ISingleRowTips{
		
		public var bgMc : MovieClip;
		public var tipsText : TextField;
		private var content:String;
		private var minWidth : Number = 120;
		//public var center_mc : MovieClip;
		public var left_mc : MovieClip;
		public var right_mc : MovieClip;

		
		public function SingleRowTips(t:String="") {
			super();
			var tf:TextFormat = new TextFormat();
			tf.size = 12;
			tipsText.setTextFormat(tf);
			Show(t);
		}
		
		public function get BgMc() : MovieClip {
			return bgMc;
		}
		
		public function set BgMc(bgMc : MovieClip) : void {
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
			left_mc.alpha=0;
			TweenLite.to(left_mc, 0.3, {alpha:1});
			/*if(bgMc!=null){
				var grid:Rectangle = new Rectangle(20, 20, 60, 60);
				
				bgMc.scale9Grid = grid;
				bgMc.width += (bgMc.width - SetTipsBGScale9Grid().width);
			}*/
			/*this.center_mc.width = 1;
			center_mc.alpha=0;
			TweenLite.to(center_mc, 0.5, {width:(width-this.left_mc.width-this.right_mc.width+5), alpha:1});*/
			this.right_mc.alpha=0;
			//var t :Tween = new Tween(right_mc,"x",None.easeNone,0,this.left_mc.width+this.center_mc.width-5,10,false);
			this.right_mc.x=left_mc.x+10;
			//this.right_mc.x = this.left_mc.width+this.center_mc.width-5;
			TweenLite.to(right_mc, 0.3, {x:left_mc.x+this.left_mc.width-2, y:right_mc.y,width:width-this.left_mc.width+5, alpha:1});
		}
		
		public function SetTipsBGScale9Grid() : Rectangle {
			//var r:Rectangle = new Rectangle(8,4,158,32);
			return new Rectangle(8,4,158,32);
		}
		
		public function Show(txt:String):void{
			if(txt=="")
				return;
			var l:Number = txt.length;
			//var w:Number = l*(this.tipsText.getTextFormat().size as Number);
			var w:Number = l*(16);
			
			//this.tipsText.width = w+20;
			this.tipsText.text =txt;
			this.tipsText.width = 1;
			w = this.tipsText.width + (this.tipsText.maxScrollH)+20;
			this.tipsText.width = w;
			SetWidth(w);
		}
	}
}
