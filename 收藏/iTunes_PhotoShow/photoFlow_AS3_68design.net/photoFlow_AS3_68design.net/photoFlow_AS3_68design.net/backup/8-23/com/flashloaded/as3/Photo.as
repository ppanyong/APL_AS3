package com.flashloaded.as3{
	import com.flashloaded.as3.PhotoFlow;
	import flash.events.Event;
	import com.flashloaded.as3.ImageContainer;
	import flash.events.ProgressEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import com.flashloaded.as3.tween.Easing;
	import com.flashloaded.as3.Points;
	import com.flashloaded.as3.effects.ReflectionEffect;
	import com.flashloaded.as3.effects.PhotoEffect;
	
	import com.flashloaded.as3.PhotoPreloadHolder;
	
	public class Photo extends Item{
		
		private var imageCon:ImageContainer;
		private var imgCon:DisplayObject;
		private var _photoWidth:Number=-1;
		private var _photoHeight:Number=-1;
		private var tx:Number=0;
		private var ty:Number=0;
		private var ts:Number=1;
		private var eff:PhotoEffect;
		private var tween:Easing;
		private var _side:String;
		private var _hpers:Number=0;
		private var _vpers:Number=0;
		
		//reflection
		private var reflectEffect:ReflectionEffect;
		
		//preloadHolder
		private var preloadHolder:PhotoPreloadHolder;
		
		public function Photo(){

		}
		
		override protected function createGraphic():void{
			imageCon=new ImageContainer(data); 
			
		}
		
		override protected function initPreloadVars():void{
			var dindex:int=index-sys.selectedIndex;
			
			if(dindex<0){
				_side="left";
			}else if(dindex>0){
				_side="right";
			}else{
				_side="center";
			}
			_vpers=sys.photoWidth*Math.sin(sys.getPhotoAngle());
			_hpers=Math.tan(sys.getPhotoAngle())*(sys.photoWidth-_vpers);
			
		}
		
		override public function createImage():void{
			initPreloadVars();
			initPosition();
			
			try{
				
				if(imageCon.getInfo()!=null){
					
					preloadHolder=new PhotoPreloadHolder(this,"preloader");
					
					imageCon.getInfo().addEventListener(Event.COMPLETE,imageReady);
					imageCon.getInfo().addEventListener(ProgressEvent.PROGRESS,loadProgress);
					imgCon=imageCon.create();
					
				}else{
					
					imgCon=imageCon.create();
					imageReady(new Event(Event.COMPLETE));
					
				}
				
			}catch(e){
				
			}
			
			
		}
		
		private function loadProgress(e:ProgressEvent):void{
			
		}
		
		private function initVars():void{
			
			tween=new Easing(speed);
			eff=new PhotoEffect(this);
			eff.initPoints();
			
			if(showReflect){
				reflectEffect=new ReflectionEffect(this);
			}
			
		}
		
		override protected function imageReady(e:Event):void{
		
			resizeImage(imgCon,sys.resizeImage,sys.photoWidth,sys.photoHeight);
			setImage(imgCon);
			
			setPhotoSize(image.width,image.height);
			
			this.y=sys.compHeight-image.height;
			_vpers=image.width*Math.sin(sys.getPhotoAngle());
			_hpers=Math.tan(sys.getPhotoAngle())*(image.width-vpers);
			initVars();			
			
			if(reflectEffect!=null){
				reflectEffect.initPoints();
			}
			
			
			addChild(image);
			setEvent();
			super.imageReady(e);		
			
		}
		
		public function setEvent():void{
			this.addEventListener(MouseEvent.MOUSE_DOWN,select);
		}
		
		private function select(e:MouseEvent):void{
			if(!selected){
				
				sys.setSelection(index);
				sys.delayAutoFlip();
			}
		}
		
		private function initPosition():void{
			var dindex:int=index-sys.selectedIndex;
			var numChild:int=parent.numChildren;
			
			if(dindex<0){
				
				initSide("left");
				
				dindex=Math.abs(dindex)-1;
				depth=sys.selectedIndex+1-dindex;
				
				tx=sys.leftX-sys.distance-(dindex*sys.spacing)-sys.getPhotoAt(sys.selectedIndex-1).vWidth;
				ts=1;
				ty=sys.compHeight-photoHeight;
				sys.itemsParent.addChildAt(this,depth);
			}else if(dindex>0){
				initSide("right");
				
				dindex=Math.abs(dindex)-1;
				
				depth=(parent.numChildren-1)-dindex;
				
				tx=sys.rightX+getStackX();
				ty=sys.compHeight-photoHeight;
				ts=1;
				sys.itemsParent.addChildAt(this,depth);
			}else{
				initSide("center");
				depth=parent.numChildren;
				tx=cx-(photoWidth*sys.selectedScale)/2;
				
				ty=sys.selectedY+sys.compHeight-photoHeight;
				ts=sys.selectedScale;
				sys.addChild(this);
			}
			
			
			x=tx;
			y=ty;
			scaleX=scaleY=ts;
		}
		public function position(){
			var dindex:int=index-sys.selectedIndex;
			var numChild:int=parent.numChildren;
			
			if(dindex<0){
				
				side="left";
				dindex=Math.abs(dindex)-1;
				depth=sys.selectedIndex+1-dindex;
				
				tx=sys.leftX-sys.distance-(dindex*sys.spacing)-sys.getPhotoAt(sys.selectedIndex-1).vWidth;
				ty=sys.compHeight-photoHeight;
				ts=1;
				
				sys.itemsParent.addChildAt(this,depth);
				
			}else if(dindex>0){
				
				side="right";
				dindex=Math.abs(dindex)-1;
				depth=(parent.numChildren-1)-dindex;
				
				tx=sys.rightX+getStackX();
				ty=sys.compHeight-photoHeight;
				ts=1;
				sys.itemsParent.addChildAt(this,depth);
				
			}else{
				
				side="center";
				depth=parent.numChildren;
				tx=cx-(photoWidth*sys.selectedScale)/2;
				ts=sys.selectedScale;
				ty=sys.selectedY+sys.compHeight-photoHeight;
				
				sys.addChild(this);
				
			}
			
			this.addEventListener(Event.ENTER_FRAME,motion);
		}
		
		
		private function motion(e:Event=null):void{
			tx=Math.round(tx);
			ty=Math.round(ty);
			
			var nx:Number=tween.getNextValue(x,tx,false);
			var ny:Number=tween.getNextValue(y,ty,false);
			var ns:Number=tween.getNextValue(scaleX,ts,false,0.001);
			
			x=nx;
			y=ny;
			scaleX=scaleY=ns;
			
			if(tween.checkFinish(x,tx) && tween.checkFinish(y,ty) && tween.checkFinish(scaleX,ts)){
				motionComplete();
			}
														
			
		}
		
		private function motionComplete():void{
			
			this.removeEventListener(Event.ENTER_FRAME,motion);
		}
		
		override public function get sys():*{
			return PhotoFlow(super.sys);
		}
		
		override public function toString():String{
			return "photo:"+index;
		}
		
		public function get cx():Number{
			return sys.cx;
		}
		
		private function initSide(str:String):void{
			if(eff!=null){
				eff.transformTo(str);
			}
			if(reflectEffect!=null){
				reflectEffect.transformTo(str);
			}
			_side=str;
		}
		
		public function get side():String{
			return _side;
		}
										   
		public function set side(str:String):void{
			if(str!=_side){
				
					eff.transform(str);
				
				if(reflectEffect!=null){
					reflectEffect.transform(str);
				}
				_side=str;
			}
		}
		public function get photoWidth():Number{
			var v:Number;
			if(_photoWidth!=-1){
				v=_photoWidth;
			}else{
				v=sys.photoWidth;
			}
			
			return v;
			
		}
		public function get photoHeight():Number{
			return _photoHeight;
		}
		public function setPhotoSize(w:Number,h:Number):void{
			_photoWidth=w;_photoHeight=h;
			sys.positionPhotos();
			
		}
		public function get points():Points{
			return eff.points;
		}
		
		public function get hpers():Number{
			return _hpers;
		}
		
		public function get vpers():Number{
			return _vpers;
		}
		
		public function get vWidth():Number{
			
			return photoWidth-vpers;
			
			
		}
		public function getStackX():Number{
			
			if(index!=sys.selectedIndex+1){
				var pPhoto:Photo=sys.getPhotoAt(sys.selectedIndex+1);
				return sys.distance+pPhoto.vWidth-vWidth+(sys.spacing*(index-sys.selectedIndex-1));
			}else{
				
				return sys.distance;
			}
			
		}
		
		public function set speed(num):void{
			
			tween.speed=num;
			eff.speed=num;
			if(reflectEffect!=null)
			reflectEffect.speed=num;
		}
		
		public function get speed():Number{
			return sys.speed;
		}
		
		public function get showReflect():Boolean{
			return sys.showReflection;
		}
		public function get effect():PhotoEffect{
			return eff;
		}
	}
}