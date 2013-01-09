
package com.flashloaded.as3{

	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.*;
	
	import com.flashloaded.as3.FlipNavEvent;

	public class Component extends MovieClip{
	// Constants:
	public static  var INIT:String="onInitPhotoFlow";
	// Public Properties:
	// Private Properties:
		private var _funcs:Array;
		
	// Protected Properties:
	
		protected var _w:Number;
		protected var _h:Number;
		protected var _ctr:Sprite;
		
	// Initialization:
		public function Component() {
			_funcs=new Array();
			
		}

	
	// Public Methods:
	// Semi-Private Methods:
	// Private Methods:
		protected function removeChildren(){
			//call from subclass init
			while(numChildren>0){
				removeChildAt(0);
			}
		}
		
	//	Protected
		protected function doInvalidate(evt:Event):void{
			draw();
			_ctr.removeEventListener(Event.ENTER_FRAME,doInvalidate);
		}
		
		protected function doLater(func:Function,args:Array=null):void{
			_ctr.addEventListener(Event.ENTER_FRAME,doFunction);
			_funcs.push({func:func,args:args});
		}
		
		private function doFunction(evt:Event):void{
			var i:uint;
			var func:Function;
			var args:Array;
			
			for(i=0;i<_funcs.length;i++){
				
				func=_funcs[i].func;
				args=_funcs[i].args;
				
				func.apply(this,args);
				
				
			}
			_funcs=[];
			_ctr.removeEventListener(Event.ENTER_FRAME,doFunction);
		}
		
		public function initComp():void{
			
			// call from subclass init
			
			//sprite for invalidate use
			_ctr=new Sprite();
			addChild(_ctr);
			
			//width,height,scale
			_w=width;
			_h=height;
			scaleX=scaleY=1;
			
			createChildren();
			doLater(draw);
			
		}
		
		protected function createChildren():void{
			//override
			
			
		}
		protected function draw():void{
			//override
			
		}
		
		protected function invalidate():void{
			_ctr.addEventListener(Event.ENTER_FRAME,doInvalidate);
			
		}
		
		protected function dispatch(evt:String,info:Object=null):void{
			
				//dispatch event
				var evtObj:FlipNavEvent=new FlipNavEvent(evt,info);
				dispatchEvent(evtObj);
			
		}
		
		public function debug(str:*,obj:Object=null):void{
			if(!str is String){
				str+="";
			}
			if(obj!=null){
				trace(getQualifiedClassName(obj)+":"+str);
			}else{
				trace(getQualifiedClassName(this)+":"+str);
			}
		}
	
	}
}