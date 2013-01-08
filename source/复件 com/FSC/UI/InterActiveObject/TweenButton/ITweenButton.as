package com.FSC.UI.InterActiveObject.TweenButton
{
	/*渐变按钮接口规范*/
	/*@pan yong*/
	/*v 1.080505*/
	public interface ITweenButton
	{
		//按钮的显示标题
		function get Title():String; 
		function set Title(v : String):void;
		//按钮的鼠标单击响应函数
		function set OnClick(v : Function):void;
		function get OnClick():Function;
		//设置按钮是否是单向的
		function set Trigger(v :Boolean):void ;
		function get Trigger():Boolean;
		//设置按钮的宽度
		function setWidth();
		//reset按钮状态为初始状态
		//function refresh();
	}
}