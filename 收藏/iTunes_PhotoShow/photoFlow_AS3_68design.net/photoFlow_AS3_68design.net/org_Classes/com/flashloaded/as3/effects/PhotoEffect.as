package com.flashloaded.as3.effects{
	import com.flashloaded.as3.Photo;
	import com.flashloaded.as3.effects.Effect;
	import com.flashloaded.as3.Points;
	
	public class PhotoEffect extends Effect{
		
		public var right:Points;
		public var left:Points;
		public var center:Points;

		public function PhotoEffect(target:Photo){
			super(target);
		}
		
		public function initPoints():void{
			right=new Points(0,hpers*view/100,photo.photoWidth-vpers,0,photo.photoWidth-vpers,photo.photoHeight,0,photo.photoHeight-hpers*((100-view)/100));
			left=new Points(0,0,photo.photoWidth-vpers,hpers*view/100,photo.photoWidth-vpers,photo.photoHeight-hpers*((100-view)/100),0,photo.photoHeight);
			center=new Points(0,0,photo.photoWidth,0,photo.photoWidth,photo.photoHeight,0,photo.photoHeight);
		}
		
		
		
		public function transform(type:String):void{
			
			item.image.visible=false;
			if(type=="right"){
				transformMotionTo(right);
			}else if(type=="left"){
				transformMotionTo(left);
			}else if(type=="center"){
				transformMotionTo(center);
			}else{
				trace("unreconized side type");
			}
			
		}
		
		public function transformTo(type:String):void{
			
			item.image.visible=false;
			if(type=="right"){
				transformImage(right);
			}else if(type=="left"){
				transformImage(left);
			}else if(type=="center"){
				transformImage(center);
			}else{
				trace("unreconized side type");
			}
		}
		
		override public function get points():Points{
			if(_points==null){
				_points=new Points(0,0,photo.photoWidth,0,photo.photoWidth,photo.photoHeight,0,photo.photoHeight);
			}
			return _points;
		}
		
		
		public function get scaledWidth():Number{
			return vpers*photo.photoWidth;
		}
		
		public function get photo():Photo{
			return Photo(item);
		}
		
		public function get vpers():Number{
			return photo.vpers;
		}
		
		public function get hpers():Number{
			return photo.hpers;
		}
		public function get view():Number{
			return photo.sys.view;
		}
		override public function get speed():Number{
			return photo.speed;
		}
	}
}