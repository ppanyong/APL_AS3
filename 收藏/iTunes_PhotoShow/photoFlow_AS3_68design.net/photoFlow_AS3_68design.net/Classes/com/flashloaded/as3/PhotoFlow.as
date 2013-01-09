package com.flashloaded.as3{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.flashloaded.as3.SelectionSystem;
	import com.flashloaded.as3.PhotoCollection;
	import com.flashloaded.as3.Photo;
	import com.flashloaded.as3.PreloadSetManager;
	import com.flashloaded.as3.Collection;
	import com.flashloaded.as3.PhotoItem;
	import com.flashloaded.as3.DepthManager;
	
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import flash.events.KeyboardEvent;
	import com.flashloaded.as3.PhotoFlowEvent;
	
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
		//
		private var depthManager:DepthManager;
		private var _zoomType:String="none";
		private var _zoomScale:Number=1.1;
		//other parameters 3
		
		private var _nametf:TextField;
		private var _nameColor:Number=0x000000;
		private var _namePosition:String="bottom center";
		private var _nameFont:String="Arial";
		private var _nameEmbed:Boolean=false;
		private var _nameItalic:Boolean=false;
		private var _nameBold:Boolean=false;
		private var _nameDistance:Number=0;
		private var _nameSize:Number=20;
		private var _showName:Boolean=false;
		private var _tf:TextFormat;
		
		//other parameters 4
		
		private var _preloadHolderColor:Number=0xffffff;
		private var _preloadHolderBorder:Number=1;
		private var _preloadHolderBorderColor:Number=0x000000;
		private var _preloadHolderAlpha:Number=70;
		private var _useKeyboard:Boolean=true;
		private var photoFlowEvent:PhotoFlowEvent;
		
		
		public function PhotoFlow(){
			
		}
		/**
		 * 准备item数据
		 * 初始化 items listItems 加载xml数据
		 */
		override protected function prepareItemsData():void{
			//*override to create systemData object
			
			items=new PhotoCollection();
			listItems=new PhotoCollection();//这是基类的数据集合 在xnl后会填充
			_cx=compWidth/2;
			_cy=compHeight/2;
			
			if(_flipSoundClass!="" && _flipSoundClass!=null){
				var def=getDefinitionByName(_flipSoundClass);
				_sound=new def;
			}
			
			//调用基类加载xml数据
			super.prepareItemsData();
			
		}
		
		private function playSound(e:Event):void{
			if(_sound!=null){
				_sound.play();
			}
		}
		
		override protected function onInited():void{
			dispatchEvent(new PhotoFlowEvent(PhotoFlowEvent.PHOTOS_LOADED));
		}
		
		/**
		 * 增加item 生成photo实力填充集合
		 */
		override protected function createItem(data:Object,index:int):*{
			
			var p:Photo=new Photo();
			trace("+++"+data)
			p.init(this,data,index);
			
			return p;
		}
		
		public function addPhoto(obj:Object,index:int=-1):void{
			if(index==-1){
				index=photos.getLength();
			}
			
			var p=createItem(obj,index);
			photos.addPhoto(p,index);
			
			addNewItem(p);
			p.resetDepth();
			
			p.createImage();
			
			dispatchEvent(new PhotoFlowEvent(PhotoFlowEvent.UPDATE));
			resetDepthManager();
			sortDepths();
			
		}
		
		private function resetDepthManager():void{
			depthManager.resetItems();
		}
		
		public function removePhoto(index:uint):void{
			if(index<=selectedIndex){
				setSelection(selectedIndex-1);
			}
			if(index<photos.getLength()){
				trace("start remove index="+index);
				
				var p:Photo=photos.removePhoto(index);
				itemsParent.removeChild(p);
				dispatchEvent(new PhotoFlowEvent(PhotoFlowEvent.UPDATE));
				resetDepthManager();
				positionPhotos();
			}
			
		}
		
		override protected function startCreateImages():void{
			
			
			//create photos
			setEvent();
			//这里是加载默认位置 但是也是顺序加载
			//这里仅仅是将当前index指向 没有实质操作！！ 
			super.setSelection(_defaultIndex);
			
			depthManager=new DepthManager(photos,itemsParent);
			
			_vpers=photoWidth*Math.sin(getPhotoAngle());
			
			_hpers=Math.tan(getPhotoAngle())*(photoWidth-_vpers);
			//与加载管理器
			preloadSetManager=new PreloadSetManager(_preloadSet,items,true);
			
			//create name text field
			nameTextField();
			updateName();
			//初始化完成 还没有开始加载过程
			dispatchEvent(new PhotoFlowEvent(PhotoFlowEvent.INIT));
		}
		
		private function nameTextField():void{
			if(_showName){
				if(_nametf==null){
					_nametf=new TextField();
				}
				
				_nametf.embedFonts=_nameEmbed;
				_nametf.antiAliasType=AntiAliasType.ADVANCED;
				_nametf.autoSize=TextFieldAutoSize.CENTER;
				
				if(_tf==null){
					updateNameFormat();
				}
				addChild(_nametf);
			}
		}
		
		private function updateNameFormat():void{
			if(showName){
				_tf=new TextFormat();
				_tf.font=_nameFont;
				_tf.size=_nameSize;
				_tf.bold=_nameBold;
				_tf.color=_nameColor;
				_tf.italic=_nameItalic;
				_nametf.setTextFormat(_tf);
				
			}
			
		}
		
		public function updateName():void{
			if(_showName){
				if(currentItem.data.name!=undefined){
					_nametf.text=currentItem.data.name;
					_nametf.setTextFormat(_tf);
					positionName();
				}else{
					_nametf.text="";
				}
			}
		}
		
		private function positionName():void{
			if(_namePosition=="bottom center"){
				setCenter(_nametf);
				setBottom(_nametf);
			}else if(_namePosition=="bottom left"){
				setLeft(_nametf);
				setBottom(_nametf);
			}else if(_namePosition=="bottom right"){
				setBottom(_nametf);
				setRight(_nametf);
			}else if(_namePosition=="top center"){
				setTop(_nametf);
				setCenter(_nametf);
			}else if(_namePosition=="top left"){
				setLeft(_nametf);
				setTop(_nametf);
			}else if(_namePosition=="top right"){
				setTop(_nametf);
				setRight(_nametf);
			}
		}
		
		private function setBottom(obj:Object):void{
			_nametf.y=compHeight+_nameDistance;
		}
		private function setTop(obj:Object):void{
			_nametf.y=-_nametf.height-_nameDistance;
		}
		private function setCenter(obj:Object):void{
			obj.x=compWidth/2-obj.width/2;
		}
		private function setLeft(obj:Object):void{
			obj.x=0;
		}
		private function setRight(obj:Object):void{
			obj.x=compWidth-obj.width;
		}
		/**
		 * a安装时间
		 */
		public function setEvent():void{
			if(_useMouseWheel){
				this.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			}
			if(_autoFlip){
				setInterval(autoFlipNext,_autoFlipDelay*1000);
			}
			if(_useKeyboard){
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			}
			
		}
		private function keyDownHandler(e:KeyboardEvent):void{
			
			if(e.keyCode==37 || e.keyCode==38){
				//left
				previous();
			}else if(e.keyCode==39 || e.keyCode==40){
				//right
				next();
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
		
		/**
		 * 处理全部图片定位位置函数 如果没有加载 先定位于加载容器的位置 positionPreloader（）
		 */
		public function positionPhotos():void{
			var itr:Iterator=photos.iterator();
							
			while(itr.hasNext()){
					
				var p:Photo=Photo(itr.next());
				if(Math.abs(this._currIndex-p.index)<5){
					p.isload=true;
				}
				if(p.loaded){
					p.position();
				}else{
					//定位于加载容器的位置
					p.positionPreloader();
				}
					
			}
			
		}
		
		public function sortDepths():void{
			depthManager.sortDepths();
		}
		/**
		 * 这是选中
		 */
		override public function setSelection(index:int):void{
			if(index>=0 && index<photos.getLength()){
				
				
				super.setSelection(index);
				
				
				if(index==0){
					autoFlipStep=1;
				}else if(index==photos.getLength()-1){
					autoFlipStep=-1;
				}
				if(_playSound){
					dispatchEvent(new Event(Event.SELECT));
				}
				
				positionPhotos();
				
				updateName();
				
				var evt:PhotoFlowEvent=new PhotoFlowEvent(PhotoFlowEvent.SELECT);
				evt.id=selectedPhoto.id;
				evt.data=selectedPhoto.data;
				evt.index=selectedPhoto.index;
				dispatchEvent(evt);
				//this.preloadSetManager.
				
				//preloadSetManager.startLoad();
			}
			
		}
		public function get vpers():Number{
			return _vpers;
		}
		public function get hpers():Number{
			return _hpers;
		}
		public function get selectedPhoto():Photo{
			return Photo(photos.getItemAt(selectedIndex));
		}
		public function get selectedWidth():Number{
			
			return getPhotoWidth(selectedIndex);
		}
		public function get totalPhoto():int{
			return photos.getLength();
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
		
		[Inspectable(category="c_photo",type=Number,defaultValue=30)]
		public function get spacing():Number{
			return _spacing;
		}

		public function set spacing(s:Number):void{
			_spacing=s;
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
		
		[Inspectable(category="c_photo",type=Number,defaultValue=5)]
		public function get motionSpeed():Number{
			return speed*10;
		}
		public function set motionSpeed(s:Number):void{
			if(s>10){
				s=10;
			}else if(s<=0){
				s=1;
			}
			speed=s/10;
		}
		
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
		
		[Inspectable(category="d_control",type=Number,defaultValue="30")]
		
		public function get selectedY():Number{
			return _selectedY;
		}
		public function set selectedY(num:Number):void{
			_selectedY=num;
		}
		
		[Inspectable(category="b_photo",type=Number,defaultValue="0")]
		public function get defaultIndex():int{
			return _defaultIndex;
		}
		public function set defaultIndex(index:int):void{
			_defaultIndex=index;
		}
		
		[Inspectable(category="d_control",type=Boolean,defaultValue="true")]
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
		[Inspectable(category="d_control",type=Number,defaultValue="0")]
		public function get preloadSet():int{
			return _preloadSet;
		}
		public function set preloadSet(s:int):void{			
			_preloadSet=s;
		}
		
		[Inspectable(category="d_control",type=Boolean,defaultValue="false")]
		public function get autoFlip():Boolean{
			return _autoFlip;
		}
		public function set autoFlip(t:Boolean):void{
			_autoFlip=t;
		}
		
		[inspectable(category="d_control",type=Number,defaultValue="1")]
		public function get autoFlipDelay():Number{
			return _autoFlipDelay;
		}
		public function set autoFlipDelay(d:Number):void{
			_autoFlipDelay=d;
		}
		
		public function set autoFlipPause(p:Boolean):void{
			_autoFlipPause=p;
		}
		public function get autoFlipPause():Boolean{
			return _autoFlipPause;
		}
		
		[Inspectable(category="b_photo",type=Boolean,defaultValue="true")]
		public function get showReflection():Boolean{
			return _showReflection;
		}
		
		public function set showReflection(ref:Boolean):void{
			_showReflection=ref;
			
		}
		
		[Inspectable(category="d_control",type=String,defaultValue="")]
		public function get flipSoundClass():String{
			return _flipSoundClass;
		}
		public function set flipSoundClass(sound:String):void{
			_flipSoundClass=sound;
		}
		
		[Inspectable(category="d_control",type=Boolean,defaultValue="true")]
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
		[Inspectable(category="d_control",type=Number,defaultValue="1")]
		public function get selectedScale():Number{
			return _selectedScale;
		}
		public function set selectedScale(s:Number):void{
			_selectedScale=s;
		}
		
		[Inspectable(category="d_control",type=String,enumeration="none,all,selected,notSelected",defaultValue="none")]
		public function get zoomType():String{
			return _zoomType;
		}
		public function set zoomType(type:String):void{
			_zoomType=type;
		}
		
		[Inspectable(category="d_control",type=Number,defaultValue="1.1")]
		public function get zoomScale():Number{
			return _zoomScale;
		}
		public function set zoomScale(s:Number):void{
			_zoomScale=s;
		}
		
		[Inspectable(category="c_name",type=Boolean,defaultValue="false")]
		public function get showName():Boolean{
			return _showName;
		}
		public function set showName(sn:Boolean):void{
			_showName=sn;
		}
		
		[Inspectable(category="c_name",type=Color,defaultValue="#000000")]
		public function get nameColor():Number{
			return _nameColor;
		}
		public function set nameColor(color:Number):void{
			_nameColor=color;
		}
		
		[Inspectable(category="c_name",type=String,enumeration="top center,top left,top right,bottom center,bottom left,bottom right",defaultValue="bottom center")]
		public function get namePosition():String{
			return _namePosition;
		}
		public function set namePosition(pos:String):void{
			_namePosition=pos;
		}
		
		[Inspectable(category="c_name",type="Font Name",defaultValue="Arial")]
		public function get nameFont():String{
			return _nameFont;
		}
		public function set nameFont(font:String):void{
			_nameFont=font;
		}
		
		[Inspectable(category="c_name",type=Boolean,defaultValue="false")]
		public function get nameEmbed():Boolean{
			return _nameEmbed;
		}
		
		public function set nameEmbed(embed:Boolean):void{
			_nameEmbed=embed;
		}
		
		[Inspectable(category="c_name",type=Boolean,defaultValue="false")]
		public function get nameItalic():Boolean{
			return _nameItalic;
		}
		
		public function set nameItalic(italic:Boolean):void{
			_nameItalic=italic;
		}
		
		[Inspectable(category="c_name",type=Boolean,defaultValue="false")]
		public function get nameBold():Boolean{
			return _nameBold;
		}
		public function set nameBold(bold:Boolean):void{
			_nameBold=bold;
		}
		
		[Inspectable(category="c_name",type=Number,defaultValue="0")]
		public function get nameDistance():Number{
			return _nameDistance;
		}
		public function set nameDistance(dis:Number):void{
			_nameDistance=dis;
		}
		
		[Inspectable(category="c_name",type=Number,defaultValue=20)]
		public function get nameSize():Number{
			return _nameSize;
		}
		public function set nameSize(size:Number):void{
			_nameSize=size;
		}
		
		[Inspectable(category="d_holder",type=Color,defaultValue="#ffffff")]
		public function get preloadHolderColor():Number{
			return _preloadHolderColor;
		}
		public function set preloadHolderColor(color:Number):void{
			_preloadHolderColor=color;
			
		}
		
		[Inspectable(category="d_holder",type=Number,defaultValue="70")]
		public function get preloadHolderAlpha():Number{
			return _preloadHolderAlpha;
		}
		public function set preloadHolderAlpha(a:Number):void{
			_preloadHolderAlpha=a;
		}
		
		[Inspectable(category="d_holder",type=Color,defaultValue="#000000")]
		public function get preloadHolderBorderColor():Number{
			return _preloadHolderBorderColor;
		}
		public function set preloadHolderBorderColor(c:Number):void{
			_preloadHolderBorderColor=c;
		}
		
		[Inspectable(category="d_holder",type=Number,defaultValue="1")]
		public function get preloadHolderBorder():Number{
			return _preloadHolderBorder;
		}
		public function set preloadHolderBorder(b:Number):void{
			_preloadHolderBorder=b;
		}
		
		[Inspectable(category="g_control",type=Boolean,defaultValue="true")]
		public function get useKeyboard():Boolean{
			return _useKeyboard;
		}
		public function set useKeyboard(b:Boolean):void{
			_useKeyboard=b;
		}
		//
		public function get totalPhotos():uint{
			
			return photos.getLength();
			
		}
		
		
	
	}
}