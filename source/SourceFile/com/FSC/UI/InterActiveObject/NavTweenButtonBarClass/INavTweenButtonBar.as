package com.FSC.UI.InterActiveObject.NavTweenButtonBarClass {
	import com.FSC.UI.InterActiveObject.NavTweenButtonClass.INavTweenButton;
	import flash.display.DisplayObject;	
	/**
	 * @author Andy
	 * @deprecated 渐变导航的接口
	 * @version 1.080517
	 */
	public interface INavTweenButtonBar 
	{
		/**
		 * 设置每个导航按钮的样式
		 * @param displayObject 导航按钮实例对象
		 */
		function SetEveryNavButtonCSS(displayObject:DisplayObject):void;
		/**
		 * 返回装配的导航按钮 必须符合INavTweenButton接口
		 * @return 实例类 new NavTweenButton()
		 */
		function GetInstance():INavTweenButton;
		/**
		 * 定义Nav.xml中标签与NavTweenButton的对应关系
		 * @param xml NavButton对应的XML段
		 */
		function XMLtoNavTweenButton(xml:XML):INavTweenButton;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		
		function set PreSelectedNavTagName(v:String):void;
		function get PreSelectedNavTagName():String;
	}
}