package com.apl.components.map{
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.text.TextField;	
	import flash.display.MovieClip;
	
	/**
	 * @author andypan
	 */
	public class MapTip extends MovieClip {
		public static var t:Timer = new Timer(1500);
		public var initY = 7
		public var initX = 21
		public var pagen:Number = 10;
		public var tot:Number = 10;
		public var currentPage:Number=1;
		public var a:Array = new Array();
		public var data:XML;
		/*public var city_cn_txt:TextField = new TextField();
		public var city_en_txt:TextField = new TextField();
		public var ppercent_txt:TextField = new TextField();
		public var pnum_txt:TextField = new TextField();*/
		public function MapTip(city_cn:String="",city_en:String="",data:XML= null) {
			setText(city_cn,configen(city_en));
			if(data!=null){
				this.data = data;
				tot=data.city.length() ;
				trace(tot)
				bulidlist();
				
				t.addEventListener(TimerEvent.TIMER, ontimer);
			}

		}
		private function configen(s:String):String{
			if(s=="Shannxi"){
				return "Shanxi"
			}
			if(s=="shannxi"){
				return "Shanxi"
			}
			return s;
		}
		
		private function ontimer(t:TimerEvent) : void {
			if(currentPage<Math.ceil(tot/pagen)){
				currentPage++
			}else{
				currentPage=1;
			}
			bulidlist();
		}

		public function setText(city_cn:String="",city_en:String="") {
			this.city_cn_txt.text = city_cn
			this.city_en_txt.text = city_en;
			//this.ppercent_txt.text = pp.toString().substr(0,5)+"%";
			//this.pnum_txt.text = pn.toString()+"人";
			currentPage=1;
			t.reset();
			t.start();
		}
		public function bulidlist(){
			clear();
			var l:Number;
			if(currentPage*pagen<=tot){
				l = pagen
			}else{
				l = tot%pagen;
			}
			for(var i:Number=0;i<l;i++){
				var ct:cityitem = new cityitem();
				ct.x = initX;
				ct.y = initY + i*ct.height;
				ct.cityname = data.city[(i+(currentPage-1)*pagen)].@name
				ct.smile = data.city[(i+(currentPage-1)*pagen)].@smile;
				a.push(this.addChild(ct));
				this.bg_mc.height = initY + (i+1)*ct.height+10+36;
			}
			
		}
		private function clear(){
			for(var i:Number =0;i<a.length;i++){
				this.removeChild(a[i]);
			}
			a = new Array();
		}
	}
}
