/*
=================================================================================================
地图类，功能分为以下几个方面：
1，根据接受的地图数据生成地图，包括各个地图元素和人物。
2，根据鼠标的点击，计算出点击的X和Y值【X和Y对应地图数组的索引】。通过SearchRoad类找出路径，并发出WalkEvent事件，
   由GameHuman类的实例侦听。
	
=================================================================================================
*/
package com.kamon.Astar{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	public class Maps extends Sprite {
		private var isoW:uint;//地图元素的宽度
		private var isoH:uint;//地图元素的高度
		private var nowX:uint;//地图中人物的初始X值,X和Y代表地图数组中的索引
		private var nowY:uint;//地图中人物的初始Y值
		private var nowId:uint;//地图编号
		private var mapArray:Array;//地图数组
		private var eleArray:Array;//地图元素数组
		private var walkArray:Array;//定义一个用来接受路径的数组
		private var human:GameHuman;//定义一个人物类
		private var foeman:Foeman;//定义一个敌人类
	    private var isNotClick:Boolean;
		//=================================================================================================
		////参数含义：地图中人物的X值，人物的Y值，地图数据，元素数据，地图中的出入口数据
		public function Maps(nx:uint,ny:uint,mArray:Array,eleArr:Array,id:uint) {
			nowX=nx;
			nowY=ny;
			mapArray=mArray;
			eleArray=eleArr;
			nowId=id;
			init();

		}
		//=================================================================================================
		//生成地图函数
		private function createMaps() {
			var mapBg:Sprite=new eleArray[0]();
			var mapEle:Sprite;
			mapBg.mouseEnabled=false;
			addChild(mapBg);
			var mapY:uint=mapArray.length;
			var mapX:uint=mapArray[0].length;
			for (var a:uint=0; a < mapY; a++) {
				for (var b:uint=0; b < mapX; b++) {
					if (a==nowX&&b==nowY) {
						human=new GameHuman(nowX,nowY,nowId);
						human.x=(isoW/2)*(nowX-nowY);
						human.y=(isoH/2)*(nowX+nowY);
						x=MapData.STAGE_X/2-human.x;
						y=MapData.STAGE_Y/2-human.y;
						addChild(human);
					}
					//------------------------------------------------------------
					//创建四个不受你控制的人物,如果觉得占用CPU，就注释掉。
					else if(a%8==0&&b%8==0&&a==b){
						foeman=new Foeman(a,b,mapArray);
						foeman.x=0;
						foeman.y=isoH*a;
						addChild(foeman);
					}
					//------------------------------------------------------------
					mapEle=new eleArray[mapArray[a][b]+1]();
					mapEle.name="element"+b+"_"+a;
					mapEle.x = (isoW/2)*(b-a);
					mapEle.y = (isoH/2)*(b+a);
					mapEle.mouseEnabled=false;
					addChild(mapEle);
				}
			}
			cacheAsBitmap=true;
		}
		//=================================================================================================
		private function init():void {
			isoW=MapData.ISO_W;
			isoH=MapData.ISO_H;
			isNotClick=true;
			//this.mouseChildren=false;
			addEventListener(MouseEvent.MOUSE_DOWN,mouseClick);
			addEventListener(NotClickEvent.WALK_END,setIsNotClick);
			createMaps();
		}
		//=================================================================================================
		private function mouseClick(evt:MouseEvent):void {
			//获得单击鼠标时，鼠标的X和Y值
			if(evt.target==this){
			var clickedX:int = Math.floor(evt.localX/MapData.ISO_W+evt.localY/MapData.ISO_H);
			var clickedY:int = Math.floor(evt.localY/MapData.ISO_H-evt.localX/MapData.ISO_W);
			nowX=human.nowXindex;
			nowY=human.nowYindex;
				if (mapArray[clickedY][clickedX]==0&&isNotClick) {
					isNotClick=false;
					var walkEvent:WalkEvent=new WalkEvent();
					walkEvent.walkArray=SearchRoad.startSearch(mapArray,clickedX,clickedY,nowX,nowY);
					addEventListener(WalkEvent.WALK_START,human.walking);
					dispatchEvent(walkEvent);
					removeEventListener(WalkEvent.WALK_START,human.walking);
				}
			}
		}
		private function setIsNotClick(evt:NotClickEvent){
			isNotClick=true;
		}

	}
}