
package com.flashloaded.as3{
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.flashloaded.as3.ImageContainer;
	import com.flashloaded.as3.SelectionSystem;
	
	public class Item extends MovieClip{
		
		private var _data:Object;
		private var _index:int;
		private var _depth:uint;
		
		private var _xpos:Number=0;
		private var _ypos:Number=0;
		
		private var _sys:SelectionSystem;
		private var _inited:Boolean;
		private var _image:DisplayObject;
		
		public function Item(){
			
		}
		
		public function init(sys:SelectionSystem,data:Object=null,index:int=undefined){
			_data=data;
			_index=index;
			setSys(SelectionSystem(sys));
			
			createGraphic();
		}
		
		protected function createGraphic():void{
			trace("create graphic");
			//override
			
		}
		
		protected function initPreloadVars():void{
			trace("init vars before create graphic");
			//override
		}
		
		protected function imageReady(e:Event):void{
			//override
			
			dispatchEvent(new Event(Event.INIT));
			_inited=true;
		}
		
		//create child automatically from data //from data.className and data.url
		protected function addDataGraphic():Boolean{
			var imageCon:ImageContainer=new ImageContainer(data); //it will decide to load or to attach
			return addChildIfValid(imageCon.create());
		}
	
		protected function addChildIfValid(child:DisplayObject):Boolean{
			if(child!=null){
				addChild(child);
				return true;
			}
			return false;			
		}
		
		protected function setImage(image:DisplayObject):void{
			_image=image;
		}
		
		public function get image():DisplayObject{
			return _image;
		}
		
		protected function resizeImage(image:DisplayObject,type:String,w:Number,h:Number):void{
			
			if(type!="none"){
				if(type=="toFit"){
					var p:Number;
					if(image.width>image.height){
						p=image.width/w;
						image.width=w;
						image.height=image.height/p;
						
					}else{
						p=image.height/h;
						image.height=h;
						image.width=image.width/p;
					}
				}else if(type=="toFill"){
					image.width=w;
					image.height=h;
				}
			}
		}
		
		public function get data():Object{
			return _data;
		}
		public function set data(data:Object):void{
			_data=data;
		}
		
		public function get index():int{
			return _index;
		}
		public function set index(index:int):void{
			_index=index;
		}
		
		public function get id():String{
			return data.id;
		}
		public function set id(id:String):void{
			data.id=id;
		}
		
		public function set depth(num:uint){
			_depth=num;
		}
		public function get depth():uint{
			return _depth;
		}
		
		public function get xpos():Number{
			return _xpos;
		}
		public function set xpos(pos:Number):void{
			_xpos=pos;
		}
		
		public function get ypos():Number{
			return _ypos;
		}
		public function set ypos(pos:Number):void{
			_ypos=pos;
		}
		
		public function render():void{
			renderPosition();
			renderGraphic();
		}
		
		public function renderPosition():void{
			x=_xpos;
			y=_ypos;
		}
		
		public function renderGraphic():void{
			//override
		}
		
		public function createImage():void{
			//override
		}
		
		public function set selected(boo:Boolean):void{
			if(boo){
				onSelection();
			}else{
				onRemoveSelection();
			}
		}
		protected function onSelection():void{
			//override
		}
		protected function onRemoveSelection():void{
			//override
		}
		
		public function get selected():Boolean{
			return (sys.selectedIndex==index);
		}
		private function setSys(sys:SelectionSystem):void{
			_sys=sys;
		}
		public function get sys():*{
			return _sys;
		}
		public function get inited():Boolean{
			return _inited;
		}
	}
}
		