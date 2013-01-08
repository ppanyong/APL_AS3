package com.FSC.UI.SmileField {
	import flash.text.TextFormat;	
	import flash.events.Event;	
	import flash.text.TextLineMetrics;	
	
	
	
	import flash.text.TextField;	
	import flash.display.Sprite;
	
	/**
	 * @author andypan
	 * 代表情的文本框
	 */
	public class smileField extends Sprite {
		public static var SMILESIZE:Number=17;
		
		private var targetField:TextField;
		private var smilesArray:Array;
		private var text:String="";
		
		public function smileField() {
			smilesArray = new Array();
		}
		
		private function drawSmile(){
			
		}
		/**
		 * 定位到表情符
		 */
		public function posSmileWord(){
			clearSM();
			
			var pattern:RegExp = /\[sm\d+\]/g;
			var resultArray:Array = text.match(pattern);
			if(resultArray!=null){
				var sta:int=0;
				for each(var s:String in resultArray ){
					sta = bulidSmile(s,sta);
				}
			}else{
				trace("==没有匹配的表情符");
			}		
		}
		
		private function clearSM() : void {
			if(this.smilesArray!=null){
				for each(var sm:Smile in this.smilesArray){
					this.removeChild(sm);
					
				}
				
			}
			this.smilesArray = new Array();
			
		}

		private function bulidSmile(str:String,staIndex:int):int{
			var startNum:Number = this.text.indexOf(str,staIndex);
			var r = this.TargetField.getCharBoundaries(startNum);
			if(r==null) return startNum+1;

			if(this.targetField.getLineIndexOfChar(startNum)>(this.targetField.bottomScrollV-1)) return this.text.length;
			//todo：将文字的表情符进行隐藏
			//this.targetField.text =this.targetField.text.substring(0,staIndex)+"   "+this.targetField.text.substring(staIndex+str.length,this.targetField.text.length) 
			//this.targetField.replaceText(startNum,startNum+str.length-1,"    ")
			var format:TextFormat = new TextFormat();
            format.color = 0xFFFFFF;
			format.size=8;
			this.targetField.setTextFormat(format,startNum,startNum+str.length);
			//定位表情位置
			var newSm:Smile = new Smile(str);
			this.smilesArray.push(newSm);
			newSm.x = r.x;
			newSm.y= r.y-(this.targetField.scrollV-1)*this.targetField.getLineMetrics(0).height;
			if(newSm.x>(this.targetField.x+this.targetField.width)) newSm.visible=false;
			newSm.Type=str;
			trace(newSm.Type)
			this.addChild(newSm);
			return startNum+1;
			//return startNum+5;
		}

		public function get TargetField() : TextField {
			return targetField;
		}
		
		public function set TargetField(targetField : TextField) : void {
			this.targetField = targetField;
			this.targetField.addEventListener(Event.SCROLL , onTrageFieldScrollHandler);
			this.x = this.targetField.x;
			this.y = this.targetField.y;
			if(this.targetField.getLineMetrics(0).height<smileField.SMILESIZE){
				trace("建议调整行高，适应表情图片");
			}
			
			this.text = this.targetField.text;
		}
		
		private function onTrageFieldScrollHandler(e:Event) : void {
			posSmileWord();
		}
	}
}
