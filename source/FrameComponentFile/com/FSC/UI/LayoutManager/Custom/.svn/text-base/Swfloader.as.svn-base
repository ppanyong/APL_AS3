package com.FSC.UI.LayoutManager.Custom {
	import flash.net.URLRequest;	
	import flash.display.Shape;	
	import flash.display.Loader;	
	
	import com.FSC.UI.LayoutManager.LayoutContentBase;
	import com.FSC.UI.LayoutManager.ILayoutContent;
	
	/**
	 * @author andypan
	 * @deprecated 作用是：加载一个swf文件 并显示；
	 */
	public class Swfloader extends LayoutContentBase implements ILayoutContent {
		private var _url:String;
		private var child:Shape;
		private var maskshape:Shape;
		private var _borderColor : uint;
		
		
		public function Swfloader(pars : String = "") {
			super(pars);
		}
		
		public override function resize(cells : Array) : void {
			this.reg = cells[Number(this.position[0])][Number(this.position[1])];		
			this.x = (this.reg.x);
			this.y = this.reg.y;
			child.width = this.reg.width;
			child.height = this.reg.height;
			maskshape.width = this.reg.width;
			maskshape.height = this.reg.height;
		}
		
		public override function build() : void {
			child = new Shape();
            child.graphics.beginFill(0xFFFFFF);
            child.graphics.lineStyle(0, _borderColor);
            
            
            maskshape = new Shape();
            maskshape.graphics.beginFill(0xFFFFFF);
            maskshape.graphics.lineStyle(0, _borderColor);
            
            this.x = (this.reg.x);
			this.y = this.reg.y;
            child.graphics.drawRect(0, 0, this.reg.width, this.reg.height);
			child.graphics.endFill();
			maskshape.graphics.drawRect(0, 0, this.reg.width, this.reg.height);
			maskshape.graphics.endFill();
            addChild(child);
            if(_borderColor){
            	addChild(maskshape);
            }
            var ldr:Loader = new Loader();
			ldr.mask = child;
			var urlReq:URLRequest = new URLRequest(url);
			ldr.load(urlReq);
			addChild(ldr);
		}
		
		public function get url() : String {
			return _url;
		}
		
		public function set url(url : String) : void {
			_url = url;
		}
		
		public function get borderColor() : uint {
			return _borderColor;
		}
		
		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
		}
	}
}
