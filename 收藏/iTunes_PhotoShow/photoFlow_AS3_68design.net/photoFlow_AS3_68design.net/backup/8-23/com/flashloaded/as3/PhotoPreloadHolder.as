package com.flashloaded.as3{
	import com.flashloaded.as3.PreloadHolder;
	import com.flashloaded.as3.Photo;
	import com.flashloaded.as3.Points;
	
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
			var vpers:Number=photo.vpers;
			var hpers:Number=photo.hpers;
			
			if(photo.side=="left"){
				p1={x:0,y:0};
				p2={x:pw-vpers,y:hpers};
				p3={x:pw-vpers,y:ph-hpers};
				p4={x:0,y:ph};
				
			}else if(photo.side=="right"){
				p1={x:0,y:0};
				p2={x:pw-vpers,y:hpers};
				p3={x:pw-vpers,y:ph-hpers};
				p4={x:0,y:ph};
			}else{
				p1={x:0,y:0};
				p2={x:pw-vpers,y:hpers};
				p3={x:pw-vpers,y:ph-hpers};
				p4={x:0,y:ph};
			}
			graphics.lineStyle(1,0x000000,1);
			graphics.moveTo(p1.x,p1.y);
			graphics.lineTo(p2.x,p2.y);
			graphics.lineTo(p3.x,p3.y);
			graphics.lineTo(p4.x,p4.y);
			graphics.lineTo(p1.x,p1.y);
			initPosition();
		}
		
		override protected function placePreloader():void{
			
		}
		
		private function initPosition():void{
			
		}
		
		public function get photo():Photo{
			return Photo(item);
		}
		
		
	}
	
}