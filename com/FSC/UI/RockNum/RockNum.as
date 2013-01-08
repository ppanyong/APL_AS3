package com.FSC.UI.RockNum {
import flash.filters.BitmapFilterQuality;	
	import flash.filters.GradientGlowFilter;	
	import flash.filters.BitmapFilter;	
	import flash.utils.setTimeout;	
	import flash.display.MovieClip;

	/**
	 * @author andypan
	 * @version 1.0
	 * @deprecated Roll Number 
	 * @param _numspace is Kerning each num-letter
	 * @param _timeinterval is the time interval of display num-letter
	 * @example
	 * var rn:RockNum = new RockNum(n);
	   this.addChild(rn);
	   you can change font-family in fla's lib
	 */
	public class RockNum extends MovieClip {
		//Number value
		private var _num : Number;
		//
		private var letterNu:Number;
		
		//the space each num-letter
		private var _numspace:Number=14;
		//time interval display num-letter
		private var _timeinterval:Number=400;
		
		private var numArray:Array;
		private var _isrun:Boolean=false;
		private var align:String;

		public function RockNum(n : Number,align:String="left",letterNu:Number=0) {
			this.align =align;
			numArray = new Array();
			this.letterNu = (String(n).length>letterNu)?String(n).length:letterNu;
			this.num = n;
			
		}
		/**
		 * Number value
		 */
		public function get num() : Number {
			return _num;
		}
		public function set num(num : Number) : void {
			_num = num;
			//_timeinterval=0;
			bulid();
		}
		/**
		 * bulid num
		 */
		private function bulid() : void {
			clearnum();
			var sn : String = this._num.toString();
			var t=letterNu-sn.length;
			if(sn.length<letterNu){
				for(var z:Number=0;z<t;z++){
						sn="0"+sn;
				}
			}
			trace('滚动数字='+sn)
			if(this.align=="left"){
				for(var i : Number = 0;i < sn.length;i++) {	
					//bulid every numletter one by one
					setTimeout(additem, _timeinterval * i, i, sn)
				}
			}else{
				for(var j : Number = sn.length-1;j >-1;j--) {	
					//bulid every numletter one by one
					setTimeout(additem, _timeinterval * j, j, sn)
				}
			}
		}
		
		/**
		 * draw one numletter
		 * @param i current letter index
		 * @param sn totle number string
		 */
		private function additem(i:Number,sn:String) : void {
			var ni : Numitem ;
			
			if(this.align=="left"){
				ni = new Numitem(Number(sn.substr(i, 1)));
				ni.x = i * _numspace;
			}else{
				trace(sn.length-i)
				ni  = new Numitem(Number(sn.substr(sn.length-i-1, 1)));
				ni.x = -i * _numspace;
			}
			numArray.push(this.addChild(ni));
			ni.cacheAsBitmap=true
			if(i==this._num.toString().length-1){
				if(_isrun){
					alwaysrun();
				}
			}
			
		}
		/**
		 * remove all displayobject
		 */
		private function clearnum() : void {

			if(numArray.length==0){
				
				return;
			}
			for(var i : Number = 0;i < numArray.length;i++) {
				this.removeChild(numArray[i]);
				trace(i)
			}
		}
		public function alwaysrun():void{
			_isrun=true;
			for(var i : Number = 0;i < this.numChildren;i++) {
				var ni:Numitem = this.getChildAt(i) as Numitem;
				//ni.num=-1;
				ni.run();
			}
		}
		
		public function get numspace() : Number {
			return _numspace;
		}
		
		public function set numspace(numspace : Number) : void {
			_numspace = numspace;
		}
		
		public function get timeinterval() : Number {
			return _timeinterval;
		}
		
		public function set timeinterval(timeinterval : Number) : void {
			_timeinterval = timeinterval;
		}
		
		public function get isrun() : Boolean {
			return _isrun;
		}
		
		public function set isrun(isrun : Boolean) : void {
			_isrun = isrun;
		}
	}
}