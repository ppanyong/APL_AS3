package com.sun.transition{
	/*
	基于方块的过渡效果
	sonsun
	2008.1.31
	
	把方块的选取速度和单个方块的动画速度关联起来，成为一个
	*/
	import com.sun.utils.Tool;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.sun.events.TransEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;

	public class RectTrans extends EventDispatcher {
		private var _timer1:Timer;
		private var _timer2:Timer;

		private var _viewWidth:Number;
		private var _viewHeight:Number;
		private var _rectWidth:Number;
		private var _rectHeight:Number;

		private var _scaleX:Number;
		private var _scaleY:Number;
		//原来生成的BM对象的数组
		private var _bmArr:Array;
		//用于过渡的BM数组
		private var _transBMArr:Array;
		private var _maxRows:uint;
		private var _maxCols:uint;
		private var _container:DisplayObjectContainer;
		private var _isTransing:Boolean = false;
		//单个方块变化类型:1,alpha渐变;2,alpha和模糊渐变;3,缩放渐变
		private var _transType:uint = 1;
		//
		private var _addType:int;
		//表明是显示还是隐藏
		private var _hide:Boolean = false;
		//对于BitmapData对象,在使用结束后调用dispose()方法释放内存
		private var _bmpSource:BitmapData;
		
		private var _ms:MotionSelector;

		public function RectTrans(ct:DisplayObjectContainer,src:BitmapData,rw:Number=20,rh:Number=15,
		  vw:Number=400,vh:Number=300,at:int=1,tt:uint=1,hide:Boolean = false) {
			//对参数不进行检查,用的时候自觉点~~
			_container = ct;
			_bmpSource = src;
			_viewWidth = vw;
			_viewHeight = vh;
			_rectWidth = rw;
			_rectHeight = rh;
			_transType = tt;
			_addType = at;
			_hide = hide;
			//计算其它变量
			_scaleX = _bmpSource.width/_viewWidth;
			_scaleY = _bmpSource.height/_viewHeight;
			_maxRows = Math.ceil(_viewHeight/_rectHeight);
			_maxCols = Math.ceil(_viewWidth/_rectWidth);
			//
			_bmArr = new Array();
			_transBMArr = new Array();
			//创建BM对象列表
			_bmArr = createBM();
			//循环次数是可以预测的,根据行列来,但应该没必要,反正都要检查结束
			_timer1 = new Timer(10,0);
			_timer2 = new Timer(50,0);
			//
			setDataPutDalayTime();
			
			_ms = new MotionSelector(_bmArr,at,_maxRows,_maxCols);
		}
		private function createBM():Array {
			var a:Array = new Array();
			//如果是隐藏的,删除_container 0位置的显示对象
			try{
				_container.removeChildAt(0);
			}catch(e:RangeError){
				trace("RectTrans,移除显示对象出错:"+e);
			}
			for (var i:int = _maxRows-1; i>=0; i--) {
				var b:Array = new Array();
				for (var j:int = _maxCols-1; j>=0; j--) {
					var obj:Object = createBMHandler(i,j);
					obj.bm.alpha = _hide?1:0;
					var bm:Bitmap = obj.bm;
					_container.addChild(bm);
					bm.x = obj.x;
					bm.y = obj.y;
					b.unshift(obj);
				}
				a.unshift(b);
			}
			return a;
		}
		//动画的速度
		public function set motionDalayTime(t:uint):void{
			try{
				_timer1.delay = t;
			}catch(e:Error){
				trace("参数错误:"+e);
			}
			//
			setDataPutDalayTime();
		}
		private function setDataPutDalayTime():void{
			//根据motionDalayTime和过渡类型设置dataPutDalayTime时间
			/*
			追加方式:1 横向:按顺序从前头开始追加(1); 按顺序从后头追加(-1);
   					 2 纵向:按顺序从前头开始追加(2); 按顺序从后头追加(-2);
 					 3 按行从上往下追加(3);按行从下往上追加(-3)
 			 		 4 按列从左往又追加(4);按列从左往右追加(-4)
					 5 随机取
			*/
			//分单个追加、行、随机取3种情况
			/*
			1属性修改的速度:alpha:0.05,最大值为1；width:_rectWidth/20;height:_rectHeight/20==》完成修改的时间都是20
			==>完成动画的时间为20*motionDalayTime
			2motionDalayTime单个方块的动画速度
			3dataPutDalayTime添加新的运动时间的时间间隔
			4_addType影响方块的添加数
			*/
			/*
			多个添加的情况：取20*motionDalayTime的2/3；
			单个的情况：保证有3行的方块参与过渡,则要求在20*motionDalayTime内输出3行/列的方块，间隔就是Math.round(20*motionDalayTime/3*_maxRows)
			*/
			var t:uint = 0;
			switch(Math.abs(_addType)){
				case 1:
					t = Math.round(20*_timer1.delay/(3*_maxRows));
					break;
				case 2:
					t = Math.round(20*_timer1.delay/(3*_maxCols));
					break;	
				case 3:
				case 4:
					t = Math.round(20*_timer1.delay/2);
					break;
				case 5:
					//随机取个数的计算：Math.round(_maxRows*_maxCols/50);
					t = Math.round(20*_timer1.delay/5);
					break;
			}
			try{
				_timer2.delay = t;
			}catch(e:Error){
				trace("参数错误:"+e);
			}
		}
		//修改数组的速度
		public function set dataPutDalayTime(t:uint):void{
			/*try{
				_timer2.delay = t;
			}catch(e:Error){
				trace("参数错误:"+e);
			}*/
		}
		public function transStart():void{
			if(_isTransing){
				//在没停止之前不允许执行多次transStart调用
				return;
			}
			_isTransing = true;
			_timer1.addEventListener(TimerEvent.TIMER,motionHandler);
			_timer2.addEventListener(TimerEvent.TIMER,putDataHandler);
			_timer1.start();
			_timer2.start();
			dispatchEvent(new TransEvent(TransEvent.TRANS_START));
		}
		public function transStop():void{
			if(!_isTransing){
				//说明已经执行过渡结束
				return;
			}
			_isTransing = false;
			if(_timer1.running){
				_timer1.stop();
				_timer1.removeEventListener(TimerEvent.TIMER,motionHandler);
			}
			if(_timer2.running){
				_timer2.stop();
				_timer2.removeEventListener(TimerEvent.TIMER,putDataHandler);
			}
			//结束处理
			transCompletedHandler(true);
		}
		private function putDataHandler(event:TimerEvent):void{
			//负责定时从_bmArr中转移数据到_transBMArr
			var currRect:Object = _transBMArr.length==0?null:_transBMArr[_transBMArr.length-1];
			var a:Array = _ms.getMotionTargets(currRect);
			if(a==null){
				_timer2.stop();
				_timer2.removeEventListener(TimerEvent.TIMER,putDataHandler);
			}else{
				//缩放的时候修改初始大小
				if(!_hide&&_transType==3){
					var len:uint = a.length;
					//如果把i设置为unit,那如果len==1的时候,i=0;i--就会出问题
					for(var i:int = len-1;i>=0;i--){
						a[i]["bm"].alpha = 1;
						a[i]["bm"].width = 0;
						a[i]["bm"].height = 0;
					}
				}
				_transBMArr = _transBMArr.concat(a);
			}
			event.updateAfterEvent();
		}
		private function motionHandler(event:TimerEvent):void{
			if(!_isTransing){
				return;
			}
			if (_transBMArr.length>0) {
				var len:uint = _transBMArr.length;
				for (var i:int = len-1; i>=0; i--) {
					if (!_transBMArr[i]["stop"]) {
						//单个方块变化类型:1,alpha渐变;2,undefined;3,缩放渐变(缩小的时候添加模糊滤镜);
						propertyChange(_transBMArr[i]);
					} else {
						if (i==len-1) {
							_timer1.stop();
							_timer1.removeEventListener(TimerEvent.TIMER,motionHandler);
							_isTransing = false;
							//结束处理
							transCompletedHandler(false);
							dispatchEvent(new TransEvent(TransEvent.TRANS_STOP));
						}
						break;
					}
				}
			}
			event.updateAfterEvent();
		}
		private function propertyChange(tg:Object):void{
			var speed:Number = _hide?-1:1;
			switch(_transType){
				case 1:
					tg["bm"].alpha+=0.05*speed;
					if(speed==-1){
						if(tg["bm"].alpha<=0){
							//释放bmp对象的内存
							tg["bm"].bitmapData.dispose();
							tg["stop"] = true;
						}
					}else{
						if (tg["bm"].alpha>=1) {
							tg["stop"] = true;
						}
					}
					break;
				case 2:
					break;
				case 3:
					//缩放
					if(tg["bm"].filters.length==0){
						//添加滤镜
						var myFilters:Array = new Array();
            			myFilters.push(new BlurFilter(1, 1, BitmapFilterQuality.HIGH));
						tg["bm"].filters = myFilters;
					}
					tg["bm"].width+=speed*tg.wSpeed;
					tg["bm"].height+=speed*tg.hSpeed;
					if(speed==-1){
						if(tg["bm"].width<=1){
							tg["bm"].filters = []; 
							tg["bm"].width = 0;
							tg["bm"].height = 0;
							tg["bm"].bitmapData.dispose();
							tg["stop"] = true;
						}
					}else{
						if(tg["bm"].width>=_rectWidth){
							tg["bm"].filters = []; 
							tg["bm"].width = _rectWidth;
							tg["bm"].height = _rectHeight;
							tg["stop"] = true;
						}
					}
					//移动位置
					tg["bm"].x = tg.x+(_rectWidth - tg["bm"].width)/2;
					tg["bm"].y = tg.y+(_rectHeight - tg["bm"].height)/2;
					break;
			}
		}
		//过渡结束调用
		//s:判断是自然结束还是调用transStop()后结束
		private function transCompletedHandler(s:Boolean):void{
			if(s){
				for (var i:uint = _maxRows-1; i>=0; i--) {
					for (var j:uint = _maxCols-1; j>=0; j--) {
						var bm:Bitmap =_bmArr[i][j].bm;
						if(!_bmArr[i][j].stop){
							_container.removeChild(bm);
							bm.bitmapData.dispose();
						}
					}
				}
			}
			var big_bm:Bitmap = new Bitmap(_bmpSource);
			big_bm.width = _viewWidth;
			big_bm.height = _viewHeight;
			if(!_hide){
				//添加大的显示对象,恢复到过渡前的状态
				_container.addChildAt(big_bm,0);
			}
		}
		private function createBMHandler(row:uint,col:uint):Object {
			var obj:Object = new Object();
			obj.x = col*_rectWidth;
			obj.y = row*_rectHeight;
			obj.wSpeed = _rectWidth/20;
			obj.hSpeed = _rectHeight/20;
			obj.row = row;
			obj.col = col;
			obj.bm = new Bitmap(Tool.getBMP(_bmpSource,obj.x*_scaleX,obj.y*_scaleY,_rectWidth*_scaleX,_rectHeight*_scaleY));
			obj.bm.width = _rectWidth;
			obj.bm.height = _rectHeight;
			obj.stop = false;
			return obj;
		}
	}
}
class MotionSelector{
	/*
	追加方式:1 横向:按顺序从前头开始追加(1); 按顺序从后头追加(-1);
   			 2 纵向:按顺序从前头开始追加(2); 按顺序从后头追加(-2);
 			 3 按行从上往下追加(3);按行从下往上追加(-3)
 			 4 按列从左往又追加(4);按列从左往右追加(-4)
			 5 随机取
	*/
	private var _addType:int = 1;
	private var _maxRows:uint;
	private var _maxCols:uint;
	private var _allBMs:Array;
	private var _ranNum:uint;
	public function MotionSelector(bms:Array,type:int,rs:uint,cs:uint){
		_maxRows = rs;
		_maxCols = cs;
		if(type==5){
			//把二维数组变成一维数组
			_ranNum = Math.round(_maxRows*_maxCols/50);
			_allBMs = arrayChangeHandler(bms);
		}else{
			_allBMs = bms;
		}
		_addType = type;
	}
	public function getMotionTargets(currRect:Object):Array{
		var a:Array = new Array();
		switch(_addType){
			case 1:
			case -1:
				a = h(_addType,currRect);
				break;
			case 2:
			case -2:
				a = z(_addType,currRect);
				break;
			case 3:
			case -3:
				a = hRow(_addType,currRect);
				break;
			case 4:
			case -4:
				a = zCol(_addType,currRect);
				break;
			case 5:
				a =  rRan();
				break;
			default:
		}
		return a;
	}
	private function arrayChangeHandler(a:Array):Array{
		var newA:Array = new Array();
		for(var i:uint = 0;i<_maxRows;i++){
			for(var j:uint = 0;j<_maxCols;j++){
				newA.push(a[i][j]);
			}
		}
		return newA;
	}
	private function rRan():Array{
		//每次取_ranNum个
		if(_allBMs.length==0){
			return null;
		}
		var a:Array = new Array();
		var len:uint = _allBMs.length>_ranNum?_ranNum:_allBMs.length;
		for(var i:uint = 0;i<len;i++){
			var id:int = Math.round(Math.random()*(_allBMs.length-1));
			a.push(_allBMs[id]);
			_allBMs.splice(id,1);
			if(_allBMs.length==0){
				break;
			}
		}
		return a;
	}
	//行向单个取的处理函数(1,-1)
	private function h(type:int,currRect:Object):Array {
		var row:int;
		var col:int;
		//获取将要追加的方块的行列位置
		if (currRect==null) {
			//正负拆分
			if (type/Math.abs(type)==1) {
				row = 0;
				col = 0;
			} else {
				row = _maxRows-1;
				col = _maxCols-1;
			}
		} else {
			//正负拆分
			if (type/Math.abs(type)==1) {
				row = currRect["row"];
				col = currRect["col"]+1;
				if (col>=_maxCols) {
					col = 0;
					row = currRect["row"]+1;
					if (row>=_maxRows) {
						return null;
					}
				}
			} else {
				row = currRect["row"];
				col = currRect["col"]-1;
				if (col<0) {
					col = _maxCols-1;
					row = currRect["row"]-1;
					if (row<0) {
						return null;
					}
				}
			}
		}
		//创建方块
		return [_allBMs[row][col]];
	}
	//横向整行取(3,-3)
	private function hRow(type:int,currRect:Object):Array {
		var row:int;
		var col:int;
		var a:Array = new Array();
		//获取将要追加的方块的行列位置
		if(type/Math.abs(type)==1){
			if(currRect==null){
				row = 0;
			}else{
				row = currRect["row"]+1;
			}
			if (row>=_maxRows) {
				return null;
			}
			for(var i1:uint = 0;i1<_maxCols;i1++){
				a.push(_allBMs[row][i1]);
			}
		}else{
			if(currRect==null){
				row = _maxRows-1;
			}else{
				row = currRect["row"]-1;
			}
			if (row<0) {
				return null;
			}
			for(var i2:int = _maxCols-1;i2>=0;i2--){
				a.push(_allBMs[row][i2]);
			}
		}
		//创建方块
		return a;
	}
	//纵向单个取(2,-2)
	private function z(type:int,currRect:Object):Array {
		var row:int;
		var col:int;
		//获取将要追加的方块的行列位置
		if (currRect==null) {
			//正负拆分
			if (type/Math.abs(type)==1) {
				row = 0;
				col = 0;
			} else {
				row = _maxRows-1;
				col = _maxCols-1;
			}
		} else {
			//正负拆分
			if (type/Math.abs(type)==1) {
				row = currRect["row"]+1;
				col = currRect["col"];
				if (row>=_maxRows) {
					row = 0;
					col = currRect["col"]+1;
					if (col>=_maxCols) {
						return null;
					}
				}
			} else {
				row = currRect["row"]-1;
				col = currRect["col"];
				if (row<0) {
					col = currRect["col"]-1;
					row = _maxRows-1;
					if (col<0) {
						return null;
					}
				}
			}
		}
		//创建方块
		return [_allBMs[row][col]];
	}
	//横向整行取(4,-4)
	private function zCol(type:int,currRect:Object):Array {
		var row:int;
		var col:int;
		var a:Array = new Array();
		//获取将要追加的方块的行列位置
		if(type/Math.abs(type)==1){
			if(currRect==null){
				col = 0;
			}else{
				col = currRect["col"]+1;
			}
			if (col>=_maxCols) {
				return null;
			}
			for(var i1:uint = 0;i1<_maxRows;i1++){
				a.push(_allBMs[i1][col]);
			}
		}else{
			if(currRect==null){
				col = _maxCols-1;
			}else{
				col = currRect["col"]-1;
			}
			if (col<0) {
				return null;
			}
			for(var i2:int = _maxRows-1;i2>=0;i2--){
				a.push(_allBMs[i2][col]);
			}
		}
		//创建方块
		return a;
	}
}