/*
=================================================================================================
人物类，功能分为以下几个方面：
1，函数walking 根据传入的路径数据，到达目的地。
	
=================================================================================================
*/
package com.kamon.Astar{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	public class GameHuman extends Sprite {
		private var Human:Class;
		private var human:MovieClip;
		private var walkArray:Array;
		private var changeMapArray:Array;
		private var step:uint;
		private var flag:uint;
		private var nowX:uint;
		private var nowY:uint;
		private var direct:String;
		private var isWalk:Boolean;
		public function GameHuman(nx:uint,ny:uint,id:uint) {
			nowX=nx;
			nowY=ny;
			changeMapArray=MapData.MAP_PASSAGEWAY[id]
			init();
		}
		private function init():void {
			Human=getDefinitionByName("Human")  as  Class;
			human=new Human();
			//human.stop();
			human.gotoAndStop(MapData.DIRECT_ARRAY[changeMapArray[0][3]]+"Stop");
			addChild(human);
		}
		public function walking(evt:WalkEvent):void {
			isWalk=true;
			step=1;
			flag=0;
			walkArray=evt.walkArray;
			addEventListener(Event.ENTER_FRAME,startMove);
		}
		public function get nowXindex():uint {
			return nowX;
		}
		public function get nowYindex():uint {
			return nowY;
		}
		private function startMove(evt:Event):void {
			var dirX:int=walkArray[step][0] - nowX;
			var dirY:int=walkArray[step][1] - nowY;
			this.x+= 3.4 * (dirX - dirY);
			this.y+= 1.7 * (dirX + dirY);
			parent.x-= 3.4 * (dirX - dirY);
			parent.y-= 1.7 * (dirX + dirY);
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
				//重新计算深度
				parent.setChildIndex(this,parent.getChildIndex(parent.getChildByName("element" + walkArray[step][0] + "_" + walkArray[step][1])));
			} else if (flag == 10) {
				nowX=walkArray[step][0];
				nowY=walkArray[step][1];
				this.x=34*(nowX-nowY);
				this.y=17*(nowX+nowY);
				step++;
				flag=0;
				isWalk=true;
			}
			if (step == walkArray.length) {
				human.gotoAndStop(direct+"Stop");
				walkEnd();//本次行走结束
				changeMap();//检测是否需要更换地图
				this.removeEventListener(Event.ENTER_FRAME,startMove);
			}
		}
		//========================================================================================
		private function changeMap():void {
			for (var i in changeMapArray) {
				if (nowX==changeMapArray[i][0]&&nowY==changeMapArray[i][1]) {
					var changeMapEvent:ChangeMapEvent=new ChangeMapEvent();
					changeMapEvent.nextMapId=changeMapArray[i][2];
					dispatchEvent(changeMapEvent);
					break;
				}
			}
		}
		private function walkEnd():void{
			 var notClickEvent:NotClickEvent=new NotClickEvent();
			dispatchEvent(notClickEvent);
		}
	}
}