package com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadingUI
{
	public interface ILoadingUI
	{
		//设置与该组件关联的下载目标地址或名称
		function setTarget(p_name : String) : void;
		//显示下载过程的实现
		function update(p_loaded : Number, p_total : Number) : void
	}
}