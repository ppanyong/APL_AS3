package com.FSF.Module {
	import com.FSF.Model.Nav.NavItem;	
	
	import flash.display.DisplayObjectContainer;

	/**
	 * 标准加载模块接口
	 * 
	 * @authorpan
	 * @date0804
	 * @version0.0804
	 */
	public interface IModule
	{
		//可能需要加入显示子模块的函数
		//在父级显示本模块
		function show(p_parent : DisplayObjectContainer, ... rest):void;
		//销毁自己
		function dispose():void;
		function addEventListener(type : String, 
		listener : Function, 
		useCapture : Boolean = false, 
		priority : int = 0, 
		useWeakReference : Boolean = false):void;
		function removeEventListener(type : String, 
		listener : Function, 
		useCapture : Boolean = false):void;
		function get MyNavItem() : NavItem ;
		function set MyNavItem(navItem : NavItem) : void ;
	}
}