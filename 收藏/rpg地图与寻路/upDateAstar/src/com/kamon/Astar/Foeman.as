package com.kamon.Astar{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	public class Foeman extends Sprite {
		private var Human:Class;
		private var human:MovieClip;
		private var walkArray:Array;
		private var mapArray:Array;
		private var step:uint;
		private var flag:uint;
		private var nowX:uint;
		private var nowY:uint;
		private var direct:String;
		private var isWalk:Boolean;
		private var isNot:Boolean=false;
		public function Foeman(nx:uint,ny:uint,arr:Array) {
			nowX=nx;
			nowY=ny;
			mapArray=arr;
			init();
		}
		private function init():void {
			Human=getDefinitionByName("Human")  as  Class;
			human=new Human();
			human.stop();
			addChild(human);
			walking(SearchRoad.startSearch(mapArray,Math.round(Math.random()*39),Math.round(Math.random()*39),nowX,nowY));
		}
		private function walking(arr:Array):void {
			isWalk=true;
			step=1;
			flag=0;
			isNot=true;
			walkArray=arr;
			addEventListener(Event.ENTER_FRAME,startMove);
		}
		private function startMove(evt:Event):void {
			if (isNot) {
				var dirX:int=walkArray[step][0] - nowX;
				var dirY:int=walkArray[step][1] - nowY;
				x+= 3.4 * (dirX - dirY);
				y+= 1.7 * (dirX + dirY);
				if (isWalk) {
					isWalk=false;
					if (dirX==1&&dirY==1) {
						direct="down";
					} else if (dirX==1&&dirY==0) {
						direct="rightDown";
					} else if (dirX==1&&dirY==-1) {
						direct="right";
					} else if (dirX==0&&dirY==-1) {
						direct="rightUp";
					} else if (dirX==-1&&dirY==-1) {
						direct="up";
					} else if (dirX==-1&&dirY==0) {
						direct="leftUp";
					} else if (dirX==-1&&dirY==1) {
						direct="left";
					} else if (dirX==0&&dirY==1) {
						direct="leftDown";
					}
					human.gotoAndPlay(direct);
				}
				flag++;
				if (flag==5) {
					parent.setChildIndex(this,parent.getChildIndex(parent.getChildByName("element" + walkArray[step][0] + "_" + walkArray[step][1])));
				} else if (flag == 10) {
					nowX=walkArray[step][0];
					nowY=walkArray[step][1];
					x=34*(nowX-nowY);
					y=17*(nowX+nowY);
					step++;
					flag=0;
					isWalk=true;
				}
			}
			if (step == walkArray.length) {
				human.gotoAndStop(direct+"Stop");
				if (Math.round(Math.random()-0.49)==1) {
					removeEventListener(Event.ENTER_FRAME,startMove);
					walking(SearchRoad.startSearch(mapArray,Math.round(Math.random()*39),Math.round(Math.random()*39),nowX,nowY));
				}else{
					isNot=false;
				}
			}
		}
		//========================================================================================
	}
}