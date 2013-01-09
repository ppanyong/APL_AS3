package com.flashloaded.as3{
	import com.flashloaded.as3.PreloadHolder;
	import com.flashloaded.as3.Photo;
	import com.flashloaded.as3.Points;
	import flash.events.Event;
	public class PhotoPreloadHolder extends PreloadHolder{
		
		private var p1:Object;
		private var p2:Object;
		private var p3:Object;
		private var p4:Object;
		private var tx:Number=0;
		private var ty:Number=0;
		
		public function PhotoPreloadHolder(item:Photo,preloaderClass:String){
			super(item,preloaderClass);
		}
		
		
		override protected function drawHolder():void{
			var pw:Number=photo.sys.photoWidth;
			var ph:Number=photo.sys.photoHeight;
			
			var vpers=photo.vpers;
			var hpers=photo.hpers;
			
			var view:Number=photo.sys.view/100;
			
			if(photo.side=="left"){
				p1={x:0,y:0};
				p2={x:pw-vpers,y:hpers*view};
				p3={x:pw-vpers,y:ph-hpers*(1-view)};
				p4={x:0,y:ph};
				
			}else if(photo.side=="right"){
				p1={x:0,y:hpers*view};
				p2={x:pw-vpers,y:0};
				p3={x:pw-vpers,y:ph};
				p4={x:0,y:ph-hpers*(1-view)};
			}else{
				p1={x:0,y:0};
				p2={x:pw,y:0};
				p3={x:pw,y:ph};
				p4={x:0,y:ph};
			}
			var a:Number=1;
			var b:Number=photo.sys.preloadHolderBorder;
			if(photo.sys.preloadHolderBorder==0){
				b=1;
				a=0;
			}
			
			graphics.lineStyle(b,photo.sys.preloadHolderBorderColor,a);
			graphics.beginFill(photo.sys.preloadHolderColor,photo.sys.preloadHolderAlpha/100);
			graphics.moveTo(p1.x,p1.y);
			graphics.lineTo(p2.x,p2.y);
			graphics.lineTo(p3.x,p3.y);
			graphics.lineTo(p4.x,p4.y);
			graphics.lineTo(p1.x,p1.y);
			graphics.endFill();
			//initPosition();
		}
		
		override protected function placePreloader():void{
			
		}
		
		private function initPosition():void{
			
		}
		
		public function get photo():Photo{
			return Photo(item);
		}
		public function get sys():*{
			return photo.sys;
		}
		public function get index():int{
			return photo.index;
		}
		
		public function set preloaderSide(side:String):void{
			
			if(photo.side!=side){
				
				this.side=side;
				photo.side=side;
			}
		}
		
		public function positionPreloader():void{
			
			var dindex:int=index-sys.selectedIndex;
			
			if(dindex<0){
				preloaderSide="left";
				photo.depth=dindex*2;
				dindex=Math.abs(dindex)-1;

				photo.tx=sys.leftX-sys.distance-(dindex*sys.spacing)-sys.getPhotoAt(sys.selectedIndex-1).vWidth;
				photo.ts=1;
				photo.ty=sys.compHeight-sys.photoHeight;

			}else if(dindex>0){
				preloaderSide="right";
				photo.depth=(dindex*-2+1);
				dindex=Math.abs(dindex)-1;
				photo.tx=sys.rightX+photo.getStackX();
				photo.ty=sys.compHeight-sys.photoHeight;
				photo.ts=1;
				
			}else{
				preloaderSide="center";
				photo.depth=3;
				photo.tx=photo.cx-(photo.photoWidth*sys.selectedScale)/2;
				photo.ty=sys.selectedY+sys.compHeight-sys.photoHeight;
				photo.ts=sys.selectedScale;
				
			}
			sys.sortDepths();
			photo.addEventListener(Event.ENTER_FRAME,photo.motion);
		}
		
		
		public function initPositionPreloader():void{
			
			var dindex:int=photo.index-photo.sys.selectedIndex;
			
			if(dindex<0){
				photo.depth=dindex*2;
				dindex=Math.abs(dindex)-1;
				photo.tx=photo.sys.leftX-photo.sys.distance-(dindex*photo.sys.spacing)-photo.sys.getPhotoAt(photo.sys.selectedIndex-1).vWidth;
				photo.ts=1;
				photo.ty=photo.sys.compHeight-photo.sys.photoHeight;
				
				
			}else if(dindex>0){
				
				photo.depth=(dindex*-2+1);
				dindex=Math.abs(dindex)-1;
				photo.tx=photo.sys.rightX+photo.getStackX();
				photo.ty=photo.sys.compHeight-photo.sys.photoHeight;
				photo.ts=1;
				
			}else{
				
				photo.depth=3;
				photo.tx=photo.cx-(photo.photoWidth*photo.sys.selectedScale)/2;
				photo.ty=photo.sys.selectedY+photo.sys.compHeight-photo.sys.photoHeight;
				photo.ts=photo.sys.selectedScale;
				
			}
			photo.sys.sortDepths();
			photo.x=photo.tx;
			photo.y=photo.ty;
			photo.scaleX=photo.scaleY=photo.ts;
			

		}
		
		public function set side(s:String):void{
			graphics.clear();
			var pw:Number=photo.sys.photoWidth;
			var ph:Number=photo.sys.photoHeight;
			
			var vpers=photo.vpers;
			var hpers=photo.hpers;
			
			var view:Number=photo.sys.view/100;
			if(s=="left"){
				p1={x:0,y:0};
				p2={x:pw-vpers,y:hpers*view};
				p3={x:pw-vpers,y:ph-hpers*(1-view)};
				p4={x:0,y:ph};
				
			}else if(s=="right"){
				p1={x:0,y:hpers*view};
				p2={x:pw-vpers,y:0};
				p3={x:pw-vpers,y:ph};
				p4={x:0,y:ph-hpers*(1-view)};
			}else{
				p1={x:0,y:0};
				p2={x:pw,y:0};
				p3={x:pw,y:ph};
				p4={x:0,y:ph};
			}
			var a:Number=1;
			var b:Number=photo.sys.preloadHolderBorder;
			if(photo.sys.preloadHolderBorder==0){
				b=1;
				a=0;
			}
			
			graphics.lineStyle(b,photo.sys.preloadHolderBorderColor,a);
			graphics.beginFill(photo.sys.preloadHolderColor,photo.sys.preloadHolderAlpha/100);
			graphics.moveTo(p1.x,p1.y);
			graphics.lineTo(p2.x,p2.y);
			graphics.lineTo(p3.x,p3.y);
			graphics.lineTo(p4.x,p4.y);
			graphics.lineTo(p1.x,p1.y);
			graphics.endFill();
			
			if(photo.preloader!=null)
			photo.preloader.align();
		}
	}
	
}