package com.flashloaded.as3{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flashloaded.as3.PhotoFlowEvent;
	
	public class PhotoFlowScrollBar extends MovieClip{
		
		private var intervalId:Number;
		private var _photoFlow:MovieClip;
		
		private var arrow_left:MovieClip;
		private var arrow_right:MovieClip;
		
		private var bar_left:MovieClip;
		private var bar_right:MovieClip;
		private var bar_middle:MovieClip;
		
		private var bg_left:MovieClip;
		private var bg_middle:MovieClip;
		private var bg_right:MovieClip;
		private var bar:Sprite;
		
		private var compWidth:Number;
		private var compHeight:Number;
		
		private var xMin:Number;
		private var xMax:Number;
		private var availableWidth:Number;
		
		private var currentIndex:int=0;
		private var total:int=0;
		
		private var inter:Number;
		private var _speed:Number=5;
		
		private var barMax:Number;
		private var barWidth:Number;
		
		private var draging:Boolean;
		private var dx:Number;
		
		
		public function PhotoFlowScrollBar(){
			
			compWidth=this.width;
			compHeight=this.height;
			scaleX=scaleY=1;
			
			while(numChildren>0)
			removeChildAt(0);
			
			
			visible=false;
			stop();
			init();
		}
		
		private function init():void{
			
			if(_photoFlow!=null){
				if(!_photoFlow.inited){
					intervalId=setInterval(init2,200);
				}else{
					init2();
				}
			}
			
		}
		
		private function init2():void{
			clearInterval(intervalId);
			
			createChildren();
			draw();
			setListeners();
			setEvent();
			
			visible=true;
		}
		
		private function setListeners():void{
			_photoFlow.addEventListener(PhotoFlowEvent.SELECT,listenUpdate);
			arrow_left.addEventListener(MouseEvent.MOUSE_DOWN,leftArrow);
			arrow_right.addEventListener(MouseEvent.MOUSE_DOWN,rightArrow);
		}
		
		private function leftArrow(e:MouseEvent):void{
			_photoFlow.autoFlipPause=true;
			goIndex(currentIndex-1,true);
		}
		private function rightArrow(e:MouseEvent):void{
			_photoFlow.autoFlipPause=true;
			goIndex(currentIndex+1,true);
			
		}
		private function listenUpdate(e:PhotoFlowEvent):void{
			goIndex(_photoFlow.selectedIndex);
		}
		
		private function setEvent():void{
			_photoFlow.addEventListener("onUpdate",invalidate);
			
			bar.addEventListener(MouseEvent.MOUSE_DOWN,clickBar);
			bg_middle.addEventListener(MouseEvent.MOUSE_DOWN,clickBg);
			bg_left.addEventListener(MouseEvent.MOUSE_DOWN,clickBg);
			bg_right.addEventListener(MouseEvent.MOUSE_DOWN,clickBg);
		}
		
		private function clickBg(e:MouseEvent):void{
			if(mouseX<bar.x){
				_photoFlow.delayAutoFlip();
				goIndex(currentIndex-3,true);
				
			}else if(mouseX>bar.getBounds(this).right){
				_photoFlow.delayAutoFlip();
				goIndex(currentIndex+3,true);
			}
		}
		
		private function clickBar(e:MouseEvent):void{
			_photoFlow.autoFlipPause=true;
			dx=bar.x-mouseX;
			bar.addEventListener(MouseEvent.MOUSE_MOVE,dragBar);
			bar.addEventListener(MouseEvent.MOUSE_UP,releaseBar);
		}
		
		private function releaseBar(e:MouseEvent):void{
			_photoFlow.autoFlipPause=false;
			bar.removeEventListener(MouseEvent.MOUSE_UP,releaseBar);
			bar.removeEventListener(MouseEvent.ROLL_OUT,releaseBar);
			bar.removeEventListener(MouseEvent.MOUSE_MOVE,dragBar);
		}
		
		private function dragBar(e:MouseEvent):void{
			
			var nx:Number=mouseX+dx;
			if(nx>xMax-barWidth){
				nx=xMax-barWidth;
			}else if(nx<xMin){
				nx=xMin;
			}
			
			bar.x=nx;
			update();
			
		}
		
		private function update():void{
			var p:Number=bar.x-xMin;
			var i:Number=Math.round(p/inter);
			
			if(currentIndex!=i){
				goIndex(i,true);
			}
		}
		
		public function goIndex(index:int,external:Boolean=false):void{
			if(index<0) index=0; else if(index>total-1) index=total-1;
			
			if(external){
				_photoFlow.setSelection(index);
				currentIndex=index;
			}else{
				currentIndex=index;	
				setBarPos(index);
			}
			
		}
		
		private function createChildren():void{
			
			arrow_left=new Arrow_left();
			arrow_right=new Arrow_right();
			
			bar_left=new Bar_left();
			bar_right=new Bar_right();
			bar_middle=new Bar_middle();
			
			bg_left=new Bg_left();
			bg_middle=new Bg_middle();
			bg_right=new Bg_right();
			
			bar=new Sprite();
			
			bar.addChild(bar_left);
			bar.addChild(bar_right);
			bar.addChild(bar_middle);
			
			addChild(bg_left);
			addChild(arrow_left);
			addChild(arrow_right);
			addChild(bg_right);
			addChild(bg_middle);
			addChild(bar);
			
			
		}
		
		private function draw(e:Event=null):void{
			this.removeEventListener(Event.ENTER_FRAME,draw);
			
			bg_left.x=arrow_left.getBounds(this).right;
			
			bg_middle.width=compWidth-(arrow_left.width+arrow_right.width+bg_left.width+bg_right.width);
			bg_middle.x=bg_left.getBounds(this).right;
			bg_right.x=bg_middle.getBounds(this).right;
			arrow_right.x=bg_right.getBounds(this).right;
			
			xMin=bg_left.getBounds(this).left;
			xMax=bg_right.getBounds(this).right;
			
			availableWidth=xMax-xMin;
			
			resetBar();
			
		}
		
		private function resetBar():void{
			getInfo();
			
			var maxInter=(availableWidth*0.8)/total;
			if(maxInter>1){
				inter=(maxInter-1)/10*(11-_speed);
			}else{
				inter=(maxInter-0.3)/_speed;
			}
			
			var l=(total-1)*inter;
			setBarWidth(availableWidth-l);
			setBarPos(currentIndex);
		}
		
		private function setBarWidth(num:Number):void{
			barWidth=num;
			barMax=xMax-barWidth;
			drawBar();
		}
		
		private function drawBar():void{
			var bw=barWidth-bar_left.width-bar_right.width;
			
			if(bw>0){
				bar_middle.width=bw;
				bar_middle.visible=true;
			}else{
				bar_middle.visible=false;
			}
			
			bar_middle.x=bar_left.x+bar_left.getBounds(bar).right;
		
			bar_right.x=barWidth-bar_right.width;
			
			bar.x=100;
		}
		
		private function setBarPos(num:int):void{
			
			
			if(!draging)
			bar.x=(num*inter)+xMin;
		}
		
		private function getInfo():void{
			total=_photoFlow.totalPhotos;
			currentIndex=_photoFlow.selectedIndex;
			
		}
		
		public function setSize(w:Number,h:Number):void{
			compWidth=w;
			compHeight=h;
			
			invalidate();
		}
		
		private function invalidate(e:Event=null):void{
			this.addEventListener(Event.ENTER_FRAME,draw);
		}
		
		
		
		[Inspectable(type=String,defaultValue="")]
		public function get photoFlow():String{
			return _photoFlow.name;
		}
		
		public function set photoFlow(nam:String):void{
			
			_photoFlow=parent[nam];
			init();
			
		}
		
		
	}
	
}