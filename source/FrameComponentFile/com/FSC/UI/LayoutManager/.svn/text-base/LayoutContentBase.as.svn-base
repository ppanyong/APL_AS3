package com.FSC.UI.LayoutManager {
	import flash.utils.describeType;	
	
	import Lii.tools.ransack;	
	
	import flash.geom.Rectangle;	
	import flash.display.Sprite;
	
	import com.FSC.UI.LayoutManager.ILayoutContent;
	
	/**
	 * @author andypan
	 * 容器基类
	 */
	public class LayoutContentBase extends Sprite implements ILayoutContent {
		private var _reg:Rectangle;
		private var _postion:Array;
		
		public function LayoutContentBase(pars:String="") {
			this.prasepars(pars);
		}
		
		/**
		 * @deprecated 分析xml中的pars参数
		 */
		function prasepars(s:String):void{
			var pars:Array = s.split(";");
			for each(var vk:String in pars){
				if(vk.indexOf(":")>0){
					var vkd:Array = vk.split(":");
					try{
					this[vkd[0]]=vkd[1];
					}catch(e){trace("无法为"+this+"创建属性"+vkd[0]+"值="+vkd[1]);}
					
				}
			}
		}
		
		public function resize(cells:Array) : void {
			this.reg = cells[Number(this.position[0])][Number(this.position[1])];
		}
		
		public function get reg() : Rectangle {
			return _reg;
		}
		
		public function set reg(reg : Rectangle) : void {
			_reg = reg;
		}
		
		public function build() : void {
		}
		/**
		 * @deprecated 存储在cells数组中的位置
		 */
		public function get position() : Array {
			return _postion;
		}
		
		public function set position(postion : Array) : void {
			_postion = postion;
		}
	}
}
