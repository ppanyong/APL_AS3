package com.FSC.UI.RockNum {
	import flash.events.Event;	
	import flash.display.MovieClip;
	
	/**
	 * @author andypan
	 * @deprecated one number letter
	 */
	public class Numitem extends MovieClip {
		private var totframes:Number ;
		private var t:Number=0;
		private var time:Number=0;
		
		public function Numitem(targetnum:Number) {
			t= targetnum;
			if(t>4) time=1;
			if(t==-1) time=99999;
			this.addEventListener(Event.ADDED_TO_STAGE, listener)
		}
		
		private function listener(e:Event) : void {
			totframes = this.totalFrames;
			this.removeEventListener(Event.ADDED_TO_STAGE, listener)
			this.addEventListener(Event.ENTER_FRAME, onenterframelistener);
		}
		
		private function onenterframelistener(e:Event) : void {
			if(time==1){
				if(this.currentFrame==(totframes/10)*(t+1)){
					this.gotoAndStop((totframes/10)*(t+1))
					this.removeEventListener(Event.ENTER_FRAME, onenterframelistener);
					return;
				}
			}else{
				if(this.currentFrame== this.totframes)time++;
			}
		}
		public function run(){
			time=99999;
			this.play();
			this.addEventListener(Event.ENTER_FRAME, onenterframelistener);
		}
		
		public function get num() : Number {
			return t;
		}
		
		public function set num(t : Number) : void {
			this.t = t;
			if(this.t>4) time=1;
			if(this.t==-1) time=99999;
			listener(new Event(""));
		}
	}
}
