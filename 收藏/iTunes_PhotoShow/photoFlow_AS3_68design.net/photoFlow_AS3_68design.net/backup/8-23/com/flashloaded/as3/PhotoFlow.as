package com.flashloaded.as3{
	import flash.display.MovieClip;
	import com.flashloaded.as3.SelectionSystem;
	import com.flashloaded.as3.PhotoCollection;
	import com.flashloaded.as3.Photo;
	import com.flashloaded.as3.PreloadSetManager;
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.PhotoItem;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	public class PhotoFlow extends SelectionSystem{
		
		private var preloadSetManager:PreloadSetManager;
		private var _spacing:Number=30;
		private var _distance:Number=20;
		private var _cx:Number;
		private var _cy:Number;
		private var _sideScale:Number=0.8;
		private var _resizeImage:String="none";
		private var _hpers:Number=30;
		private var _vpers:Number=100;
		private var _view:Number=50;

		private var _photoWidth:Number=150;
		private var _photoHeight:Number=150;
		private var _speed:Number=0.5;
		
		//reflection
		private var _reflectionExtend:Number=50;
		private var _selectedAlpha:Number=70;
		private var _notSelectedAlpha:Number=30;
		private var _selectedDepth:Number=100;
		private var _notSelectedDepth:Number=70;
		private var _photoAngle:Number=10;
		
		//mouse event
		private var _useMouseWheel:Boolean=true;
		
		//other parameters
		private var _selectedY:Number=30;
		private var _defaultIndex:Number=0;
		private var _preloadSet:Number=3;
		private var _autoFlip:Boolean=false;
		private var _autoFlipDelay:Number=1;
		private var autoFlipStep:Number=1;
		private var _autoFlipPause:Boolean=false;
		private var _navigating:Boolean=false;
		private var _showReflection:Boolean=true;
		
		//other parameters 2
		private var _sound:Sound;
		private var _flipSoundClass:String;
		private var _playSound:Boolean=true;
		private var _selectedScale:Number=1;
		
		public function PhotoFlow(){
			
		}
		
		override protected function prepareItemsData():void{
			//*override to create systemData object
			
			items=new PhotoCollection();
			listItems=new PhotoCollection();
			_cx=width/2;
			_cy=height/2;
			
			if(_flipSoundClass!="" && _flipSoundClass!=null){
				var def=getDefinitionByName(_flipSoundClass);
				_sound=new def;
			}
			
			super.prepareItemsData();
			
		}
		
		private function playSound(e:Event):void{
			if(_sound!=null){
				_sound.play();
			}
		}
		
		override protected function createItem(data:Object,index:int):Item{
			var p:Photo=new Photo();
			p.init(this,data,index);
			
			return p;
		}
		
		override protected function startCreateImages():void{
			//override
			setEvent();
			setSelection(_defaultIndex);
			preloadSetManager=new PreloadSetManager(_preloadSet,items,true);
			
			
		}
		
		public function setEvent():void{
			if(_useMouseWheel){
				this.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			}
			if(_autoFlip){
				setInterval(autoFlipNext,_autoFlipDelay*1000);
			}
		}
		
		private function autoFlipNext():void{
			if(!_navigating){
				if(!_autoFlipPause){
					if(autoFlipStep>0){
						next();
					}else{
						previous();
					}
				}
			}else{
				_navigating=false;
			}
		}
		
		public function delayAutoFlip():void{
			_navigating=true;
		}
		
		private function mouseWheelHandler(e:MouseEvent):void{
			delayAutoFlip();
			if(e.delta>0){
				previous();
			}else{
				next();
			}
		}
		
		public function previous():void{
			
			setSelection(selectedIndex-1);
		}
		public function next():void{
			setSelection(selectedIndex+1);
		}
		
		
		public function positionPhotos():void{
			var itr:Iterator=photos.iterator();
			
			while(itr.hasNext()){
				var p:Photo=Photo(itr.next());
				if(p.inited){
					p.position();
				}
			}
		}
		
		override public function setSelection(index:int):void{
			if(index>=0 && index<photos.getLength()-1){
				super.setSelection(index);
				positionPhotos();
				if(index==0){
					autoFlipStep=1;
				}else if(index==photos.getLength()-2){
					autoFlipStep=-1;
				}
				if(_playSound){
					dispatchEvent(new Event(Event.SELECT));
				}
			}
			
		}
		public function get selectedPhoto():Photo{
			return Photo(photos.getItemAt(selectedIndex));
		}
		public function get selectedWidth():Number{
			
			return getPhotoWidth(selectedIndex);
		}
		
		public function getPhotoWidth(index:int):Number{
			
			return photos.getItemAt(index).photoWidth;
		}
		
		public function getPhotoSideWidth(index:int):Number{
			return photos.getItemAt(index).sideWidth;
		}
		
		public function get photos():PhotoCollection{
			return PhotoCollection(items);
		}
		
		[Inspectable(category="c_photo",type=Number,defaultValue=10)]
		public function get spacing():Number{
			return _spacing;
		}

		public function set spacing(s:Number):void{
			_spacing;
		}
		
		public function get cx():Number{
			return _cx;
		}
		
		public function get cy():Number{
			return _cy;
		}
		
		
		public function get sideScale():Number{
			return _sideScale;
		}
		public function getPhotoAt(index:int):Photo{
			return Photo(items.getItemAt(index));
		}
		
		public function get leftX():Number{			
			return cx-(selectedWidth*selectedScale)/2;
		}
		
		public function get rightX():Number{
			return cx+(selectedWidth*selectedScale)/2;
		}
		
		[Inspectable(category="c_photo",type=String,enumeration="none,toFit,toFill",defaultValue="none")]
		public function get resizeImage():String{
			return _resizeImage;
		}
		
		public function set resizeImage(type:String):void{
			_resizeImage=type;
		}
		
		[Inspectable(category="c_photo",type=Number,defaultValue=50)]
		public function get view():Number{
			return _view*100;
		}
		public function set view(v:Number):void{
			_view=v/100;
		}
		
		[Inspectable(category="c_photo",type=Number,defaultValue=20)]
		public function set distance(d:Number):void{
			_distance=d;
		}
		public function get distance():Number{
			return _distance;
		}
		
		[Inspectable(category="c_photo",type=Number,defaultValue=150)]
		public function get photoHeight():Number{
			return _photoHeight;
		}
		
		public function set photoHeight(h:Number):void{
			_photoHeight=h;
		}
		
		[Inspectable(category="c_photo",type=Number,defaultValue=150)]
		public function get photoWidth():Number{
			return _photoWidth;
		}
		
		public function set photoWidth(w:Number):void{
			_photoWidth=w;
		}
		
		[Inspectable(category="g_reflection",type=Number,defaultValue=50)]
		public function get reflectionExtend():Number{
			return _reflectionExtend;
		}
		public function set reflectionExtend(num:Number):void{
			_reflectionExtend=num;
		}
		
		[Inspectable(type=Number,defaultValue=0.5)]
		public function get speed():Number{
			return _speed;
		}
		public function set speed(s:Number):void{
			_speed=s;
		}
		
		[Inspectable(category="g_reflection",type=Number,defaultValue=70)]
		public function get selectedReflectionAlpha():Number{
			return _selectedAlpha;
		}
		public function set selectedReflectionAlpha(num:Number):void{
			_selectedAlpha=num;
		}
		
		[Inspectable(category="g_reflection",type=Number,defaultValue=30)]
		public function get reflectionAlpha():Number{
			return _notSelectedAlpha;
		}
		public function set reflectionAlpha(a:Number):void{
			_notSelectedAlpha=a;
		}
		[Inspectable(category="g_reflection",type=Number,defaultValue=70)]
		public function get reflectionDepth():Number{
			return _notSelectedDepth;
		}
		public function set reflectionDepth(a:Number):void{
			_notSelectedDepth=a;
		}
		[Inspectable(category="g_reflection",type=Number,defaultValue=100)]
		public function get selectedReflectionDepth():Number{
			return _selectedDepth;
		}
		public function set selectedReflectionDepth(a:Number):void{
			_selectedDepth=a;
		}
		
		[Collection(category="a_comp",name="Photos",collectionClass="com.flashloaded.as3.Collection",collectionItem="com.flashloaded.as3.PhotoItem",identifier="id")]
		public function get itemData():Collection{
			return inspectorData;
		}
		public function set itemData(coll:Collection):void{
			inspectorData=coll;
		}
		
		private var photoItem:PhotoItem;
		private var Coll:Collection;
		
		[Inspectable(category="c_photo",type=Number,defaultValue="20")]
		public function get photoAngle():Number{
			
			return _photoAngle;
		}
		public function set photoAngle(angle:Number):void{
			if(angle>90){
				angle=90;
			}else if(angle<0){
				angle=0;
			}
			
			_photoAngle=angle;
		}
		public function getPhotoAngle():Number{
			return _photoAngle*Math.PI/180;
		}
		public function getVpers():Number{
			return _vpers/100;
		}
		
		[Inspectable(type=Number,defaultValue="30")]
		
		public function get selectedY():Number{
			return _selectedY;
		}
		public function set selectedY(num:Number):void{
			_selectedY=num;
		}
		
		[Inspectable(type=Number,defaultValue="0")]
		public function get defaultIndex():int{
			return _defaultIndex;
		}
		public function set defaultIndex(index:int):void{
			_defaultIndex=index;
		}
		
		[Inspectable(type=Boolean,defaultValue="true")]
		public function get useMouseWheel():Boolean{
			return _useMouseWheel;
		}
		public function set useMouseWheel(u:Boolean):void{
			if(u!=_useMouseWheel){
				_useMouseWheel=u;
				if(!u){
					this.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
				}else{
					this.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
				}
			}
		}
		//0: loadAll -1: dontload
		[Inspectable(type=Number,defaultValue="0")]
		public function get preloadSet():int{
			return _preloadSet;
		}
		public function set preloadSet(s:int):void{			
			_preloadSet=s;
		}
		
		public function set autoFlipPause(p:Boolean):void{
			_autoFlipPause=true;
		}
		public function get autoFlipPause():Boolean{
			return _autoFlipPause;
		}
		
		[Inspectable(type=Boolean,defaultValue="true")]
		public function get showReflection():Boolean{
			return _showReflection;
		}
		
		public function set showReflection(ref:Boolean):void{
			_showReflection=ref;
			
		}
		
		[Inspectable(type=String,defaultValue="")]
		public function get flipSoundClass():String{
			return _flipSoundClass;
		}
		public function set flipSoundClass(sound:String):void{
			_flipSoundClass=sound;
		}
		
		[Inspectable(type=Boolean,defaultValue="true")]
		public function get playFlipSound():Boolean{
			return _playSound;
		}
		
		public function set playFlipSound(s:Boolean):void{
			if(s){
				this.addEventListener(Event.SELECT,playSound);
			}else{
				this.removeEventListener(Event.SELECT,playSound);
			}
			_playSound=s;
		}
		[Inspectable(type=Number,defaultValue="1")]
		public function get selectedScale():Number{
			return _selectedScale;
		}
		public function set selectedScale(s:Number):void{
			_selectedScale=s;
		}
					 
		
	}
}