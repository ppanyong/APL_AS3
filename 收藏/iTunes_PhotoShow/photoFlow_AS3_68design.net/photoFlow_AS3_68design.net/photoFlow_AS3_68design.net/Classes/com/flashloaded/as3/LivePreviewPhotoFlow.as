
package com.flashloaded.as3{
	import com.flashloaded.as3.LivePreviewParent;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class LivePreviewPhotoFlow extends LivePreviewParent{
		
		private var drawerMC:Sprite;
		private var drawer:Graphics;
		
		private var cx:Number;
		private var cy:Number;
		private var w:Number;
		private var h:Number;
		
		private var photos:Array;
		private var pw:Number=100;
		private var ph:Number=100;
		private var vpers:Number=10;
		private var hpers:Number=10;
		private var view:Number=0.5;
		
		
		public function LivePreviewPhotoFlow(){
			
			
		}
		
		override protected function init():void{
			pw=data.photoWidth;
			ph=data.photoHeight;
			
			cx=_w/2;
			cy=_h/2;
			
			var angle:Number=data.photoAngle*Math.PI/180;
			
			vpers=pw*Math.sin(angle);
			hpers=Math.tan(angle)*(pw-vpers);
			
			attachPhotos();
		}
		
		private function attachPhotos():void{
			
			while(numChildren>0){
				removeChildAt(0);
			}
			
			var centerPhoto:Sprite=createPhoto("center");
			
			centerPhoto.x=cx-pw/2;
			centerPhoto.y=_h-ph+data.selectedY;
			
			addChild(centerPhoto);
			
			//left
			
			var p:Sprite;
			
			for(var i:int=0;i<3;i++){
				p=createPhoto("left");
				p.x=centerPhoto.x-(i*data.spacing)-data.distance-(pw-vpers);
				p.y=_h-ph;
				addChild(p);
			}
			
			//right
			
			var h:Sprite;
			for(var j:int=0;j<3;j++){
				h=createPhoto("right");
				h.x=centerPhoto.x+pw+data.distance+(j*data.spacing);
				h.y=_h-ph;
				
				addChild(h);
			}
		}
		
		
		private function createPhoto(side:String):Sprite{
			
			var p:Sprite=new Sprite();
			
			var p1={};var p2={};var p3={};var p4={};
			
			if(side=="left"){

				p1={x:0,y:0};
				p2={x:pw-vpers,y:hpers*getView()};
				p3={x:pw-vpers,y:ph-hpers*(1-getView())};
				p4={x:0,y:ph};
				
			}else if(side=="right"){
				p1={x:0,y:hpers*view};
				p2={x:pw-vpers,y:0};
				p3={x:pw-vpers,y:ph};
				p4={x:0,y:ph-hpers*(1-getView())};
			}else{
				p1={x:0,y:0};
				p2={x:pw,y:0};
				p3={x:pw,y:ph};
				p4={x:0,y:ph};
			}
			
			
			p.graphics.lineStyle(1,0x000000,1);
			
			p.graphics.moveTo(p1.x,p1.y);
			p.graphics.lineTo(p2.x,p2.y);
			p.graphics.lineTo(p3.x,p3.y);
			p.graphics.lineTo(p4.x,p4.y);
			p.graphics.lineTo(p1.x,p1.y);
			
			return p;
		}

		
		override public function onResize():void {
			_w=stage.stageWidth;
			_h=stage.stageHeight;
			cx=_w/2;
			cy=_h/2;
			attachPhotos();
		}
		
		override protected function update(value:*=null,name:String=null):void {
			
			
		}
		
		private function getView():Number{
			return data.view/100;
		}
		
	}
}