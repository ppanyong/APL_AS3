package com.kamon.Astar{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	public class MainProgram extends Sprite {
		private var nowId:uint;
		private var mapArray:Array;//定义存储地图数据二维数组
		private var eleArray:Array;//定义地图元素数组
		private var maps:Maps;//定义一个地图类
		//=================================================================================================
		public function MainProgram() {
			init();
		}
		//=================================================================================================
		private function init():void {
			nowId=1;
			initArray();
			//------------------------------------------------------
			//生成一个700*500的矩形显示区域。
			var window:Rectangle = new Rectangle(0, 0, 700, 500);
			scrollRect = window;
			//------------------------------------------------------
			
			maps=new Maps(0,0,mapArray,eleArray,nowId);
			addChild(maps);//让地图显示
			addEventListener(ChangeMapEvent.CHANGE_MAP,goNextMap);//自定义ChangeMapEvent事件是由人物GameHuman类的实例发出的。本类是在冒泡阶段捕获。
		}
		//=================================================================================================
		//定义加载下一个地图函数。
		private function goNextMap(evt:ChangeMapEvent):void{
			var id=evt.nextMapId;
			removeChild(maps);
			nowId=id;
			initArray();
			maps=new Maps(MapData.MAP_PASSAGEWAY[id][0][0],MapData.MAP_PASSAGEWAY[id][0][1],mapArray,eleArray,nowId);
			addChild(maps);
		}
		private function initArray():void{
			mapArray=MapData.createMapData(nowId);
			eleArray=MapData.createEleArray(nowId,MapData.MAP_ELEARRAY[nowId][1]);
		}
	}
}