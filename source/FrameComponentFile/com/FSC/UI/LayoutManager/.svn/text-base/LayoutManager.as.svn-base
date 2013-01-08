package com.FSC.UI.LayoutManager {
	import flash.display.StageAlign;	
	import flash.display.DisplayObject;	
	import flash.system.ApplicationDomain;	
	import flash.display.Shape;	
	import flash.geom.Rectangle;	
	import flash.display.Stage;	
	import flash.events.Event;	
	import flash.events.IOErrorEvent;	
	import flash.events.IEventDispatcher;	
	import flash.net.URLRequest;	
	import flash.net.URLLoader;	
	import flash.display.Sprite;

	/**
	 * 布局管理类
	 * 依靠读取外部html布局定义 就是table的定义 处理界面
	 * 处理元素包括 table tr td 等属性
	 * table.cols table.style
	 * <td colspan="2" rowspan="7">&nbsp;</td> 跨2列 7行
	 * <td width="90" height="100">&nbsp;</td>列宽度取最大单元格width 高度去最大height
	 * 该类为单例 静态方法 
	 * @author andypan
	 */
	public class LayoutManager extends Sprite {
		//单例
		private static var _instance : LayoutManager;
		private var _xmldata:XML;
		private var _cols:Number;//列数
		private var _rows:Number;//行数
		private var _cellpadding:Number;
		private var _cellspacing:Number;
		private var _totwidth:Number;
		private var _totheight:Number;
		private var _cells : Array = new Array();
		private var _heights: Array;
		private var _widths: Array;

		public function LayoutManager(singletonEnforcer : SingletonEnforcer) {
			if(singletonEnforcer == null)throw new Error("singletonEnforcer");
		}
		/**
		 * 获取单例实例
		 */
		public static function getInstance() : LayoutManager {
			if(LayoutManager._instance == null) {
				LayoutManager._instance = new LayoutManager(new SingletonEnforcer());
			}
			return LayoutManager._instance;
		}
	
		/**
		 * 静态初始化配置
		 * @param config 用于配置管理的布局定义文件
		 */
		public static function Run(config:String="config.xml") {
			LayoutManager.getInstance().stage.align = StageAlign.TOP_LEFT;
			var loader:URLLoader = new URLLoader();
            getInstance().configureListeners(loader);
			var request:URLRequest = new URLRequest(config);
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
		}
		//装配xml事件
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            _xmldata = new XML(String(loader.data).replace(/px/g, ""));
   			parsexml(_xmldata);
   			bulidRectangle(_xmldata.table,true);
   			stage.addEventListener(Event.RESIZE, onStageResizehandler);
        }
        /**
         * 分析出table基本结构
         * 输出cell的尺寸与坐标
         */
        private function parsexml(xml:XML){
        	if(xml.table==null) return;
        	var table:XMLList = xml.table;		
            //计算尺寸
			this._totwidth = totleWidth(table.@width);
			this._totheight = totleHeight(table.@height);
			_heights = getRowsheightArray(table);
			_widths = getColsWidthArray(table);
			this._rows = _heights.length;
			this._cols = _widths.length;	
			//trace("行高="+_heights);
			//trace("列宽="+_widths);	
		}
		/**
		 * 当舞台拉升
		 */
		private function onStageResizehandler(event:Event) : void {
			//trace(this.stage.stageWidth);
			parsexml(_xmldata);
   			bulidRectangle(_xmldata.table);
			for(var i:Number=0;i<this.numChildren;i++){
				//trace(this.getChildAt(i))
				try{
				(this.getChildAt(i) as ILayoutContent).resize(this.cells);
				}catch(e){trace("不能转换成 ILayoutContent 接口对象")};
			}
		}

		/**
		 * 初始化数序
		 */
		private function intiCellsRectangle(){
			_cells = new Array();
			for(var n:Number=0;n<this._rows;n++){
				var tmp_r:Array = new Array();
				for(var m:Number=0;m<this._cols;m++){
					tmp_r.push(null);
				}
				_cells.push(tmp_r);
			}
		}
		
		/**
		 * 构造表格矩形
		 */
		private function bulidRectangle(table : XMLList,isbulidMClass:Boolean=false) : void {
			intiCellsRectangle();
			//从上到下 从左到右 
			var currentRowIndex:Number=0;
			var d_y:Number=0;
			for each (var tt_tr:XML in table.tr) {
				var tmp_rolarray:Array = _cells[currentRowIndex];
				var tdsindex:Number=0;//xml中td的序号
				var d_x:Number=0;
				
				for(var ii:Number =0;ii<this._cols;ii++){
					//列
					if(tmp_rolarray[ii]!=null){
						d_x+=this._widths[ii];
					}else{
						var tmp_cell:Rectangle = new Rectangle();
						var tt_td:XML = tt_tr.td[tdsindex];
						if(tt_td!=null){
							tdsindex++;
							//x
							tmp_cell.x=d_x;
							//y
							tmp_cell.y=d_y;
							var colspan:Number=1;
							if(Number(tt_td.@colspan)!=0){
								var tmp_tdcol:Number =Number(tt_td.@colspan);
								//为跨列的处理
								//trace("跨"+tmp_tdcol+"列")
								colspan=tmp_tdcol;
								for(var i:Number=ii;i<tmp_tdcol;i++){
									trace(this._widths[i])
									tmp_cell.width+=this._widths[i];
									//trace("第"+i+"列的宽度="+tmp_cell.width)
									if(Number(tt_td.@rowspan)!=0){
										//如果这个单元格跨行就向下写数据
										//trace("跨"+Number(tt_td.@rowspan)+"行");
										tmp_cell.height=0;
										for(var j:Number=0;j<Number(tt_td.@rowspan);j++){
											//trace("第"+Number(currentRowIndex+j)+"行")
											_cells[Number(currentRowIndex+j)][i]=new Rectangle();
											tmp_cell.height += this._heights[currentRowIndex+j];
											//trace("行高="+tmp_cell.height);
										}
									}
									tmp_rolarray[i]=new Rectangle();
								}
								ii+=tmp_tdcol-1;
							}else{
								tmp_cell.width = this._widths[ii];
							}	
							if(Number(tt_td.@rowspan)!=0){
									//如果这个单元格跨行
									//就向下写数据
									tmp_cell.height=0;
									for(var x:Number=0;x<Number(tt_td.@rowspan);x++){
										_cells[Number(currentRowIndex+x)][ii]=new Rectangle();
										tmp_cell.height += this._heights[currentRowIndex+x];
									}
								}else{
									tmp_cell.height = this._heights[currentRowIndex];
							}
							d_x+=tmp_cell.width;
							//trace("cell("+currentRowIndex+","+(ii-colspan+1)+")="+tmp_cell);
							tmp_rolarray[ii-colspan+1] = tmp_cell;
							//trace(tt_td.mclass.@name)
							if(isbulidMClass){
								if(String(tt_td.mclass.@name)!=""){
										var tmpclass:Class = ApplicationDomain.currentDomain.getDefinition(tt_td.mclass.@name)  as  Class;
										var tmpInstance:ILayoutContent  = new tmpclass(tt_td.mclass.@pars);
										tmpInstance.reg = tmp_cell;
										tmpInstance.position= new Array(currentRowIndex,ii-colspan+1);
										tmpInstance.build();
										addChild(tmpInstance as DisplayObject);
								}
							}
							
						}
					}
				}
				d_y += this._heights[currentRowIndex];
				//trace("第"+currentRowIndex+"行="+tmp_rolarray);
				currentRowIndex++;
			}
		}

		/**
		 * 计算列宽
		 * 规则 同一行中有百分比和固定的 以固定高度最大值为准
		 */
		private function getColsWidthArray(table:XMLList):Array{
			var currentRowIndex:Number=0;
			var gudingW:Number=0;
			var result:Array = new Array();
			var avgNo:Number=0;
			var percentLJ:Number=0
			for each (var tt_tr1:XML in table.tr) {
				var tmp_rolarray1:Array = new Array();
				if(result[0]==null){
					for each (var tt_td1:XML in tt_tr1.td){
						if(Number(tt_td1.@colspan)!=0){
							for(var z:Number=0;z<Number(tt_td1.@colspan);z++){
								tmp_rolarray1.push("null");
							}
						}else{
							tmp_rolarray1.push("null");
						}
					}
				}else{
					for(var zz:Number=0;zz<result[0].length;zz++){
							tmp_rolarray1.push("null");
					}
				}
				result.push(tmp_rolarray1);
			}
			//trace("完成一个空的表格矩阵 行="+result.length+"列="+result[0].length);
			//开始填充数据
			for each (var tt_tr:XML in table.tr) {
				var tmp_rolarray:Array = result[currentRowIndex];
				var tdsindex:Number=0;//xml中td的序号
				//trace(tt_tr.td)
				for(var ii:Number =0;ii<result[0].length;ii++){
					//定义第一行的单元格 这个td的总数就是列数
					if(String(tmp_rolarray[ii])!="null"){
					}else{
						var tt_td:XML = tt_tr.td[tdsindex];
						tdsindex++;
						if(tt_td!=null){	
							if(Number(tt_td.@colspan)!=0){
								var tmp_tdcol:Number =Number(tt_td.@colspan);
								//为跨列的处理
								for(var i:Number=ii;i<tmp_tdcol;i++){
									if(Number(tt_td.@rowspan)!=0){
										//如果这个单元格跨行就向下写数据
										for(var j:Number=1;j<=Number(tt_td.@rowspan);j++){
											result[Number(ii+j)][i]="0%Avg";
										}
									}
									tmp_rolarray[i]="0%Avg";
								}
								ii+=tmp_tdcol-1;
							}else{
								if(String(tt_td.@width)!=""){
									tmp_rolarray[ii]=tt_td.@width;
									if(Number(tt_td.@rowspan)!=0){
										trace("单列跨行")
										//如果这个单元格跨行
										//就向下写数据
										for(var x:Number=1;x<=Number(tt_td.@rowspan);x++){
											result[Number(currentRowIndex+x)][ii]=tt_td.@width;
										}
									}
								}else{
								}
							}
						}
					}	
				}
				//trace("第"+currentRowIndex+"行="+tmp_rolarray);
				currentRowIndex++;
			}
			var tmp_totlGDWidth:Number=0;
			var tmp_NumberOfAvg:Number=0;
			//开始统计各列的宽度 策略是 有固定宽度取最大值 动态宽度级别最小
			for(var k:Number=0;k<result[0].length;k++){
				var colmax:Number=0;
				var precentstr:String="null";
				var precentNo:Number=0;
				for each(var item in result){
					if(String(item[k]).indexOf("%")>0){
						if(Number(item[k].substring(0,item[k].indexOf("%")))>=precentNo){
							precentNo = Number(item[k].substring(0,item[k].indexOf("%")));
							precentstr = item[k];
						}
					}
					if(colmax<Number(item[k]))
							colmax=Number(item[k]);
				}
				for each(var item2 in result){
					if(colmax>0){
						item2[k]=colmax;	
					}else{
						if(precentstr=="null")precentstr="0%Avg";
						item2[k]=precentstr;
					}
				}
				if(colmax>0){
					tmp_totlGDWidth+=colmax;
				}else{
					tmp_NumberOfAvg++;
				}
			}
			var tmp_avg:Number = ((this.totwidth-tmp_totlGDWidth)/tmp_NumberOfAvg);
			var newoutput :Array =new Array();
			for(var kk:Number=0;kk<result[0].length;kk++){
				if(result[0][kk]=="0%Avg"){
					newoutput.push(tmp_avg);
				}else{
					var tmp_kk:String = String(result[0][kk]);
					if(tmp_kk.indexOf("%")>-1){
						result[0][kk] =((this.totwidth-tmp_totlGDWidth)*Number(tmp_kk.substring(0,tmp_kk.indexOf("%")))/100)
					}
					newoutput.push(result[0][kk]);
				}	
			}	
			return newoutput;
		}
		/**
		 * 计算行高
		 * 规则 同一行中有百分比和固定的 以固定高度最大值为准
		 */
		private function getRowsheightArray(table:XMLList):Array{
			var gudingH:Number=0;
			var result:Array = new Array();
			var avgNo:Number=0;
			var percentLJ:Number=0;
			for each (var tt_tr:XML in table.tr) {
				var tt_tr_height:Number=0;
				var tt_tr_heightPrecent:String="0%Avg";
				for each (var tt_h:String in tt_tr..@height){
					if(tt_h.indexOf("%")==-1){
						if(tt_tr_height<Number(tt_h))tt_tr_height =Number(tt_h);
					}else{
						if(Number(tt_tr_heightPrecent.substring(0,tt_tr_heightPrecent.indexOf("%")))<Number(tt_h.substring(0,tt_h.indexOf("%"))))
						tt_tr_heightPrecent = tt_h;
					}
				}
				if(tt_tr_height>0){
					result.push(tt_tr_height);
					gudingH+=tt_tr_height;
				}else{
					if(tt_tr_heightPrecent=="0%Avg"){
						avgNo++;
					}else{
						percentLJ += Number(tt_tr_heightPrecent.substring(0,tt_tr_heightPrecent.indexOf("%")));
					}
					
					result.push(tt_tr_heightPrecent);
				}
			}
			for(var i:Number=0;i<result.length;i++){
				if(result[i]=="0%Avg"){
					result[i] =(100-percentLJ)/avgNo/100*(this.totheight-gudingH);
				}else if(String(result[i]).indexOf("%")!=-1){
					result[i] = Number(Number(result[i].substring(0,result[i].indexOf("%")))/100*(this.totheight-gudingH));
				}
			}
			
			return result;
		}
		
		private function totleHeight(c:String="100%"):Number{
        	if(c=="") c="100%";
        	if(c.indexOf("%")>0){
        		//百分比尺寸
        		return Number(this.stage.stageHeight*Number(c.substring(0,c.indexOf("%")))/100);
        	}else{
        		//绝对值
        		if(c.indexOf("px")) return Number(c.substring(0,c.indexOf("px")));
        		return Number(c);
        	}
        	
        }
        private function totleWidth(c:String="100%"):Number{
        	if(c=="") c="100%";
        	if(c.indexOf("%")>0){
        		//百分比尺寸
        		return Number(this.stage.stageWidth*Number(c.substring(0,c.indexOf("%")))/100);
        	}else{
        		//绝对值
        		if(c.indexOf("px")) return Number(c.substring(0,c.indexOf("px")));
        		return Number(c);
        	}
        	
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
            throw new Error("ioErrorHandler: " + event);
		}
		
		public function get xmldata() : XML {
			return _xmldata;
		}
		
		public function set xmldata(xmldata : XML) : void {
			_xmldata = xmldata;
		}
		
		public function get cols() : Number {
			return _cols;
		}
		
		public function set cols(cols : Number) : void {
			_cols = cols;
		}
		
		public function get rows() : Number {
			return _rows;
		}
		
		public function set rows(rows : Number) : void {
			_rows = rows;
		}
		
		public function get cellpadding() : Number {
			return _cellpadding;
		}
		
		public function set cellpadding(cellpadding : Number) : void {
			_cellpadding = cellpadding;
		}
		
		public function get cellspacing() : Number {
			return _cellspacing;
		}
		
		public function set cellspacing(cellspacing : Number) : void {
			_cellspacing = cellspacing;
		}
		
		public function get totheight() : Number {
			return _totheight;
		}
		
		public function set totheight(totheight : Number) : void {
			_totheight = totheight;
		}
		
		public function get totwidth() : Number {
			return _totwidth;
		}
		
		public function set totwidth(totwidth : Number) : void {
			_totwidth = totwidth;
		}
		
		public function get cells() : Array {
			return _cells;
		}
		
		public function set cells(cells : Array) : void {
			_cells = cells;
		}
	}
}

class SingletonEnforcer {
}