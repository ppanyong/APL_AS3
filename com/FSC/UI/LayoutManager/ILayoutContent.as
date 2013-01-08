package com.FSC.UI.LayoutManager {
	import flash.geom.Rectangle;	
	
	/**
	 * @author andypan
	 * 容器接口
	 */
	public interface ILayoutContent {
		function resize(cells:Array):void;
		function build():void;
		function get reg() : Rectangle;
		function set reg(reg : Rectangle) : void;
		function get position() : Array ;
		function set position(postion : Array) : void;
	}
}
