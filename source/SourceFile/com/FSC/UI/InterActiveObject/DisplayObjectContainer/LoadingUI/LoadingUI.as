package com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadingUI
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;

	public class LoadingUI extends Sprite implements ILoadingUI
	{
		private var m_target : String;
		public var showTxt : TextField;
		
		/**
		 * 构造函数
		 */		
		public function LoadingUI(p_parent : DisplayObjectContainer)
		{
			super();
		}
		/**
		 * 设置加载目标名称
		 * 
		 * @param p_name	加载目标名称
		 */		
		public function setTarget(p_name : String) : void
		{
			this.m_target = p_name;
			this.showInfo("0K");
		}
		/**
		 * 更新加载进度
		 * 
		 * @param p_loaded	已加载字节
		 * @param p_total	文件总字节
		 */		
		public function update(p_loaded : Number, p_total : Number) : void
		{
			this.showInfo(int(p_loaded / 10) / 100 + "K / " + int(p_total / 10) / 100 + "K");
		}
		/**
		 * @private
		 * 显示加载进度
		 * 
		 * @param p_value	当前加载进度
		 */		
		private function showInfo(p_value : String) : void
		{
			this.showTxt.text = "Loading " + this.m_target + "...\n" + p_value;
		}
	}
}