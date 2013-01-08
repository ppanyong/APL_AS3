package com.FSC.UI.ScrollSubtitles {
	import flash.events.MouseEvent;	
	import flash.events.Event;	
	import flash.display.Sprite;	
	import flash.display.DisplayObject;	
	import flash.text.TextField;	
	import flash.text.TextFormat;	
	import flash.display.MovieClip;
	import flash.text.TextLineMetrics;	

	/**
	 * 水平单行滚动字幕
	 * @author andypan
	 * 输入文字后 直接使用
	 * 可以设置滚动速度 和 字体样式
	 */
	public class ScrollSubtitles extends MovieClip {
		private var _sstr:String;
		private var _speed:Number;
		private var _textformat:TextFormat;
		private var _txtname:String="txt";
		private var _isCanSelected:Boolean =false;
		private var _textWidth:Number;
		private var _mask:Sprite ;
		private var defaulttextformat:TextFormat = new TextFormat("宋体",12,0x000000);
		private var _tempspeed:Number;
		
		/**
		 * @param s 滚动内容
		 * @param speed 滚动速度 默认5
		 */
		public function ScrollSubtitles(s:String,w:Number = 150,speed:Number=2) {
			this._textWidth = w;
			this.subtitles = s;
			this.speed = speed;
			init();
			startMove();
		}
		
		public function init():void{
			if(gettxt()!=null) this.removeChild(gettxt());
			var txt:TextField = new TextField();
			txt.wordWrap=false;
			txt.name=_txtname;
			txt.selectable = this._isCanSelected;
			txt.htmlText = this.subtitles;
			this.addChild(txt);
			this.textformat = defaulttextformat;
			//mask
			txt.mask = creatMask();
			configMask();
			txt.x = this._mask.width;
			
		}
		
		private function startMove() : void {
			this.addEventListener(Event.ENTER_FRAME, listener);
			this.addEventListener(MouseEvent.MOUSE_OVER, overlistener);
			this.addEventListener(MouseEvent.MOUSE_OUT, outlistener)
		}
		
		private function outlistener(e:MouseEvent) : void {
			this.speed =_tempspeed;
			trace("out")
			this.addEventListener(Event.ENTER_FRAME, listener);
		}

		private function overlistener(e:MouseEvent) : void {
			_tempspeed = this.speed
			this.speed=0;
			trace("over")
			this.removeEventListener(Event.ENTER_FRAME, listener);
		}

		private function listener(event:Event) : void {
			if(gettxt()==null) return;
			gettxt().x -= this.speed;
			if(gettxt().x<(-gettxt().width)){
				gettxt().x = this._mask.width;
			}
			if(gettxt().width<this._textWidth){
				this.speed=0;
				gettxt().x=0
			}
		}

		private function configMask() : void {
			if(_mask!=null){
				//trace(gettxt().getLineMetrics(0).height)
				_mask.height = gettxt().getLineMetrics(0).height+2;
			}
		}

		private function creatMask() : Sprite {
			if(_mask==null){
				_mask = new Sprite();
				_mask.graphics.beginFill(0xFFCC00);
        		_mask.graphics.drawRect(0, 0,this.textWidth, 14);
        		_mask.graphics.endFill();
				this.addChild(_mask);
			}
			return _mask;
		}

		private function gettxt():TextField{
		    if(this.getChildByName(_txtname)!=null)
		    	return	this.getChildByName(_txtname) as TextField
		    return null;
		}
		
		public function get subtitles() : String {
			return _sstr;
		}
		
		public function set subtitles(sstr : String) : void {
			_sstr = sstr;
		}
		
		public function get speed() : Number {
			return _speed;
		}
		
		public function set speed(speed : Number) : void {
			_speed = speed;
		}
		
		public function get textformat() : TextFormat {
			return _textformat;
		}
		
		public function set textformat(textformat : TextFormat) : void {
			_textformat = textformat;
			if(gettxt()!=null){
				gettxt().setTextFormat(textformat);
				gettxt().width = gettxt().width + (gettxt().maxScrollH);
				configMask();
			}
		}
		
		public function get isCanSelected() : Boolean {
			return _isCanSelected;
		}
		
		public function set isCanSelected(isCanSelected : Boolean) : void {
			_isCanSelected = isCanSelected;
			gettxt().selectable = _isCanSelected;
		}
		
		public function get textWidth() : Number {
			return _textWidth;
		}
		
		public function set textWidth(textWidth : Number) : void {
			_textWidth = textWidth;
			gettxt().width = _textWidth;
		}
	}
}
