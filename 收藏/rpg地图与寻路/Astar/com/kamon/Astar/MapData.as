package com.kamon.Astar{
	import flash.utils.getDefinitionByName;
	public class MapData {
		public static  const MAP_X:uint=40;
		public static  const MAP_Y:uint=40;
		public static  const STAGE_X:uint=700;
		public static  const STAGE_Y:uint=500;
		public static  const ISO_W:uint=68;//地图元素的宽度
		public static  const ISO_H:uint=34;//地图元素的高度
		public static  const MAP_PASSAGEWAY:Array=[[],[[39,19,2,5]],[[0,19,1,1]]];//地图出入口
		public static  const MAP_ELEARRAY:Array=[[],[1,13],[2,11]];//每个地图的组成元素
		public static  const DIRECT_ARRAY:Array=["down","rightDown","right","rightUp","up","leftUp","left","leftDown"];
		//=======================================================================================================
		/*随机生成地图数据,数值范围根据库中地图元素的个数而定。
		例如：库中“地图1”文件夹中有Element11【命名规则：“Element”+地图编号+元素编号】至Element113 共13个元素，
		其中：“Element10”是地图1的背景图不算在内，如果有10个元素 那么mapArray[i][j]= Math.round(Math.random()*9);
		
		*/
		public static function createMapData(id:uint):Array {
			var mapData:Array=new Array(MAP_Y);
			for (var i:uint=0; i<MAP_Y; i++) {
				mapData[i]=new Array(MAP_X);
				for (var j:uint=0; j<MAP_X; j++) {
					if (Math.round(Math.random()-0.4)==1) {
						mapData[i][j]= Math.round(Math.random()*(MAP_ELEARRAY[id][1]-1));
					} else {
						mapData[i][j]=0;
					}
					if (mapData[i][j]==1&&id==1) {
						mapData[i][j]=11;
					} else if (mapData[i][j]==12&&id==1) {
						mapData[i][j]=0;
					}
				}
			}
			//-------------------------------------------------------------------------------------------------
			//生成地图1中间的房子,如果是固定的地图数据，就不要这么麻烦了。
			if (id==1) {
				for (j=18; j<21; j++) {
					for (i=20; i<22; i++) {
						mapData[i][j]=1;
					}
				}
				mapData[20][20]=12;
				mapData[21][17]=1;
				mapData[21][16]=5;
				//-------------------------------------------------------------------------------------------------
				mapData[0][0]=0;
				
			}
			mapData[MAP_PASSAGEWAY[id][0][1]][MAP_PASSAGEWAY[id][0][0]]=0;
			//trace("map is="+mapData);
			return mapData;
		}
		//=======================================================================================================
		public static function createEleArray(id:uint,maxNum:uint):Array {
			var arr:Array=new Array();
			for (var i:uint=0; i<=maxNum; i++) {
				arr.push(getDefinitionByName("Element"+id+i)  as  Class);
			}
			return arr;
		}
	}
}