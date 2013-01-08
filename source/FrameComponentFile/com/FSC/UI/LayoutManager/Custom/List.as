package com.FSC.UI.LayoutManager.Custom {
	import flash.events.Event;	
	import flash.utils.setTimeout;	
	import flash.display.Shape;	
	
	import com.FSC.UI.InterActiveObject.ScrollBar;	
	import com.FSC.UI.CustomerListClass.CustomerList;	
	
	import flash.geom.Rectangle;	
	
	import com.FSC.UI.LayoutManager.LayoutContentBase;
	import com.FSC.UI.LayoutManager.ILayoutContent;
	
	/**
	 * @author andypan
	 * @deprecated 绘制使用的list
	 */
	public class List extends LayoutContentBase implements ILayoutContent {
		var test:CustomerList;
		private var child:Shape;
			private var maskshape:Shape;
		private var _borderColor : uint;
		public function List(pars : String = "") {
			super(pars);
			
		}
		
		public override function resize(cells : Array) : void {
			this.reg = cells[Number(this.position[0])][Number(this.position[1])];		
			this.x = this.reg.x;
			this.y = this.reg.y;
			child.width = this.reg.width;
			child.height = this.reg.height;
			maskshape.width = this.reg.width;
			maskshape.height = this.reg.height;
			test.x=10;
			test.y=10;
			bulidNewScroller();
		}
		
		public override function build() : void {
			this.x = this.reg.x;
			this.y = this.reg.y;
			maskshape = new Shape();
            maskshape.graphics.beginFill(0xFFFFFF);
            maskshape.graphics.lineStyle(0, _borderColor);
            maskshape.graphics.drawRect(0, 0, this.reg.width, this.reg.height);
			maskshape.graphics.endFill();
			addChild(maskshape);
				
			child = new Shape();
            child.graphics.beginFill(0xFFFFFF);
            child.graphics.lineStyle(0, _borderColor);
            child.alpha=0.5;

            
            child.graphics.drawRect(0, 0, this.reg.width, this.reg.height);
			child.graphics.endFill();
            addChild(child);
            
            test= new CustomerList("data/newsList.xml");
            test.addEventListener(Event.COMPLETE, onlistover)
            
			test.x=10;
			test.y=10;
			addChild(test);
			this.mask= maskshape;
		}
		
		private function onlistover(e:Event) : void {
			bulidNewScroller();
		}
		public function bulidNewScroller(){
			if(this.getChildByName("ScrollBar")!=null){
				this.removeChild(this.getChildByName("ScrollBar"));
			}
			var sb:ScrollBar = new ScrollBar();
			sb.name="ScrollBar";
			this.addChild(sb)
			sb.height=this.reg.height;
			sb.init(test,"easeOutBack",1,true,1);
			sb.x=this.reg.width-sb.width;
			sb.y=15;
		}

		public function get borderColor() : uint {
			return _borderColor;
		}
		
		public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
		}
	}
}
