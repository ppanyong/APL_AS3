package com.FSC.UI.InterActiveObject.NavTweenButton
{
	import com.FSC.UI.InterActiveObject.TweenButton.TweenButton;

	public class NavTweenButton extends TweenButton implements INavTweenButton
	{
		/**
		 * panyong
		 * v1.080505
		 * 继承了渐变按钮 增加了在导航中需要用到的元素 xml 这是存储加载在nav.xml中的信息
		 */
		
		private var _menuTreeXML:XML;
		
		
		public function set menuTreeXML(v:XML):void
		{
			//TODO: implement function
			_menuTreeXML = v;
		}
		
		public function get menuTreeXML():XML
		{
			//TODO: implement function
			return _menuTreeXML;
		}
		
		public function NavTweenButton()
		{
			//TODO: implement function
			super();
		}
	}
}