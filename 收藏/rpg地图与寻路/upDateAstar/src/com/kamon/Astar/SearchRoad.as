/*
=================================================================================================
寻路静态类，功能分为以下几个方面：
1，函数startSearch 根据传入的地图数据；终点和起点的X和Y值 计算出合适的路径。寻路时间在1-2毫秒。
=================================================================================================
*/
package com.kamon.Astar{
	//import flash.utils.ByteArray;
	//import flash.utils.getTimer;
	public class SearchRoad {
		private static var isPathFind:Boolean;
		private static var closeA:Array;
		private static var findA:Array;
		private static var dirA:Array=[[1,0,10],[0,1,10],[-1,0,10],[0,-1,10],[1,1,14],[-1,1,14],[-1,-1,14],[1,-1,14]];
		private static var openA:Array;
		private static var walkA:Array;
		private static var endX:uint;
		private static var endY:uint;
		//private static var timer:uint;
		public static function startSearch(mapArr:Array,ex:uint,ey:uint,sx:uint,sy:uint):Array {
			var emptyArray:Array;
			//timer=getTimer();
			endX=ex;
			endY=ey;
			isPathFind=false;
			/*var findAB:ByteArray=new ByteArray;
			findAB.writeObject(mapArr);
			findAB.position=0;
			findA=findAB.readObject()  as  Array;
			*/
			setFindA(mapArr);
			openA=new Array();
			closeA=new Array();
			searchPath(sx,sy,sx,sy,0);
			if (isPathFind) {
				return getPath();
			}
			return emptyArray;
		}
		private static function setFindA(mapArr:Array):void {
			findA=new Array();
			for (var i in mapArr) {
				findA[i]=new Array();
				for (var j in mapArr[i]) {
					if(mapArr[i][j]==0){
					findA[i][j]=0;
					}else{
					findA[i][j]=1;
					}
				}
			}
		}
		private static function getPath():Array {
			var i:uint=closeA.length - 1;
			var n:uint=0;
			walkA=new Array();
			walkA[0]=new Array(2);
			walkA[0][0]=closeA[i][0];
			walkA[0][1]=closeA[i][1];
			var px:uint=closeA[i][2];
			var py:uint=closeA[i][3];
			for (var j=i - 1; j >= 0; j--) {
				if (px == closeA[j][0] && py == closeA[j][1]) {
					n++;
					walkA[n]=new Array(2);
					walkA[n][0]=closeA[j][0];
					walkA[n][1]=closeA[j][1];
					px=closeA[j][2];
					py=closeA[j][3];
				}
			}
			walkA.reverse();
			//trace("timer is " + (getTimer() - timer));
			//trace(walkA);
			return walkA;
		}
		private  static function searchPath(nx:uint,ny:uint,px:uint,py:uint,g:uint) {
			var hval:uint=0;
			var gval:uint=0;
			var min:uint=0;
			var len:uint=0;
			findA[ny][nx]=1;
			closeA.push([nx,ny,px,py]);
			for (var n:uint=0; n < 8; n++) {
				var adjX=nx + dirA[n][0];
				var adjY=ny + dirA[n][1];
				if (adjX < 0 || adjX >= findA.length || adjY < 0 || adjY >= findA.length) {
					continue;
				}
				if (adjX == endX && adjY == endY) {
					closeA.push([adjX,adjY,nx,ny]);
					isPathFind=true;
					return;
				}
				if (findA[adjY][adjX] == 0) {
					hval=10 * (Math.abs(endX - adjX) + Math.abs(endY - adjY));
					gval=g + dirA[n][2];
					findA[adjY][adjX]=gval;
					openA.push([adjX,adjY,nx,ny,gval + hval,gval]);
				} else if (findA[adjY][adjX] > 1) {
					gval=g + dirA[n][2];
					if (gval < findA[adjY][adjX]) {
						hval=10 * (Math.abs(endX - adjX) + Math.abs(endY - adjY));
						for (var j:uint=1; j < openA.length; j++) {
							if (openA[j][0] == adjX && openA[j][1] == adjY) {
								openA[j]=[adjX,adjY,nx,ny,gval + hval,gval];
								findA[adjY][adjX]=gval;
								break;
							}
						}
					}
				}
			}
			if (openA.length < 1) {
				//trace("No Path");
				isPathFind=false;
				return;
			} else {
				len=openA.length;
				for (var m=0; m < len; m++) {
					if (openA[min][4] > openA[m][4]) {
						min=m;//获取最小F值
					}
				}
				var moveToCloseA:Array=openA.splice(min,1);
				searchPath(moveToCloseA[0][0],moveToCloseA[0][1],moveToCloseA[0][2],moveToCloseA[0][3],moveToCloseA[0][5]);
			}
		}
	}
}