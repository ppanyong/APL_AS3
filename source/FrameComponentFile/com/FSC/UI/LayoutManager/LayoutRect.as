package com.FSC.UI.LayoutManager {
	import flash.display.Shape;	
	
	import com.FSC.UI.LayoutManager.LayoutContentBase;
	import com.FSC.UI.LayoutManager.ILayoutContent;
	
	/**
	 * @author andypan
	 * @deprecated 用于绘制布局可见的结构块
	 */
	public class LayoutRect extends LayoutContentBase implements ILayoutContent {
		private var _bgColor : uint;
		private var _borderColor : uint;
		private var child:Shape;

		public function LayoutRect(pars:String="") {
			super(pars);
		}
		
		public override function resize(cells:Array) : void {			
			this.reg = cells[Number(this.position[0])][Number(this.position[1])];		
			this.x = (this.reg.x);
			this.y = this.reg.y;
			child.width = this.reg.width;
			child.height = this.reg.height;
		}
		public override function build():void{
			child = new Shape();
            child.graphics.beginFill(bgColor);
            child.graphics.lineStyle(0, borderColor);
            this.x = (this.reg.x);
			this.y = this.reg.y;
            child.graphics.drawRect(0, 0, this.reg.width, this.reg.height);
			child.graphics.endFill();
            addChild(child);
		}
		
		public function get bgColor() : uint {
			return _bgColor;
		}
		
		public function set bgColor(bgColor : uint) : void {
			_bgColor = bgColor;
		}
		
		public function get borderColor() : uint {
			return _borderColor;
		}
		
		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
		}
	}
}

