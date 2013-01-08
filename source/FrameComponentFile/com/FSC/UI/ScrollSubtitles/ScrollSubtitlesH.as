package com.FSC.UI.ScrollSubtitles {
	import flash.text.TextFieldAutoSize;	
	import flash.events.MouseEvent;	
	import flash.events.Event;	
	import flash.text.TextFormat;	
	import flash.display.Sprite;	
	import flash.text.TextField;	
	import flash.display.MovieClip;
	import flash.text.TextLineMetrics;	

	/**
	 * 垂直滚动
	 * @author andypan
	 */
	public class ScrollSubtitlesH extends MovieClip {
		private var _sstr:String;
		private var _speed:Number;
		private var _textformat:TextFormat;
		private var _txtname:String="txt";
		private var _isCanSelected:Boolean =false;
		private var _textHeight:Number;
		private var _textWidth:Number;
		
		private var _mask:Sprite ;
		private var defaulttextformat:TextFormat = new TextFormat("宋体",12,0x000000);
		private var _tempspeed:Number;
		private var _isScorll:Boolean = true;
		
		
		/**
		 * @param s 滚动内容
		 * 内容使用 /r/n换行或者使用<br/>换行
		 * @param speed 滚动速度 默认5
		 */
		public function ScrollSubtitlesH(s:String,h:Number = 150,w:Number=150,speed:Number=2) {
			this._textHeight = h;
			this._textWidth = w;
			this.subtitles = s;
			this.speed = speed;
			init();
			startMove();
		}
		
		public function init():void{
			if(gettxt()!=null) this.removeChild(gettxt());
			var txt:TextField = new TextField();
			txt.wordWrap=true;
			txt.name=_txtname;
			txt.width= _textWidth;
			txt.selectable = this._isCanSelected;
			txt.multiline=true;
			txt.htmlText = this.subtitles;
			txt.condenseWhite = true;
			txt.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(txt);
			this.textformat = defaulttextformat;
			//mask
			txt.mask = creatMask();
			
			configMask();
			txt.y = this._mask.height;
			
		}
		
		private function startMove() : void {
			this.addEventListener(Event.ENTER_FRAME, listener);
			this.addEventListener(MouseEvent.MOUSE_OVER, overlistener);
			this.addEventListener(MouseEvent.MOUSE_OUT, outlistener)
		}
		
		private function outlistener(e:MouseEvent) : void {
			this.speed =_tempspeed;

			this.addEventListener(Event.ENTER_FRAME, listener);
		}

		private function overlistener(e:MouseEvent) : void {
			if(_isScorll){
			_tempspeed = this.speed
			this.speed=0;
			trace("over")
			this.removeEventListener(Event.ENTER_FRAME, listener);
			}else{
				this.speed=0;
				gettxt().y = 0;
			}
		}

		private function listener(event:Event) : void {
			if(gettxt()==null) return;
			if(_isScorll){
			if(gettxt().height <= this._textHeight){
				this.speed=0;
				gettxt().y = 0;
			}else{
				gettxt().y -= this.speed;
			
			}
			if(gettxt().y<(-gettxt().height)){
				gettxt().y = this._mask.height;
			}
			}else{
				this.speed=0;
				gettxt().y = 0;
			}
		}

		private function configMask() : void {
			if(_mask!=null){
				//trace(gettxt().getLineMetrics(0).height)
				_mask.height = this._textHeight;
				_mask.width = this.textWidth;
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
				gettxt().height =gettxt().textHeight;
				if(gettxt().maxScrollV>1){
					//gettxt().height = gettxt().numLines* (gettxt().getLineMetrics(0).descent+gettxt().getLineMetrics(0).ascent+gettxt().getLineMetrics(0).height)+(gettxt().maxScrollV-gettxt().bottomScrollV)*gettxt().getLineMetrics(0).height;
				}else{
					gettxt().height =gettxt().textHeight;
					//gettxt().height = gettxt().numLines* (gettxt().getLineMetrics(0).descent+gettxt().getLineMetrics(0).ascent+gettxt().getLineMetrics(0).height);
				}
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
		
		public function get isScorll() : Boolean {
			return _isScorll;
		}
		
		public function set isScorll(isScorll : Boolean) : void {
			_isScorll = isScorll;
		}
	}
}
