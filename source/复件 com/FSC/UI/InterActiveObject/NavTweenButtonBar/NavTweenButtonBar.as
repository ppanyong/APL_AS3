package com.FSC.UI.InterActiveObject.NavTweenButtonBar
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.xml.XMLNode;
	import flash.events.MouseEvent;
	import com.FSC.UI.InterActiveObject.NavTweenButton.*;
	import com.FSC.UI.InterActiveObject.NavTweenButtonBar.NavTweenButtonBarData;
	/**菜单类
	 * * panyong
	 * v1.0805
	 * 渐变按钮的集合 就是一般意义上的导航条
	 */
	public dynamic class NavTweenButtonBar extends Sprite implements INavTweenButtonBar
	{
		//存储数据
		private var _menuData:NavTweenButtonBarData;
		
		/**构造函数
		 * @param dataXml		内容也可以是文件地址
		 */
		public function NavTweenButtonBar(dataXml:String)
		{
			super();
			_menuData = new NavTweenButtonBarData(dataXml);
			_menuData.addEventListener(Event.COMPLETE,onDataLoaded);
			
		}
		
		/**
		 * 导航按钮按下响应
		 */
		private function itemClick(e:MouseEvent){
			//trace(e.currentTarget.menuTreeXML)
			this.dispatchEvent(new NavTweenButtonBarEvent(NavTweenButtonBarEvent.NavClick,e.currentTarget.menuTreeXML))
		}
		/**
		 * 绘制菜单 定义了菜单的排列形式
		 */
		public function  bulidMenu(){
			//读取根目录
			var _xmllist:XMLList = _menuData.getMenuXMLByTag();
			//得到一级目录
			var x:Number = 0;
			//这里与data存在耦合 由于没有集合类 变通的办法是将bar的数据类型作为xmlnode的扩展
			for each(var xmlnode:XML in _xmllist){
				var tempOb:Sprite = XMLtoNavTweenButton(xmlnode) as Sprite;
				tempOb.x=x;
				this.addChild(tempOb);
				x = tempOb.x+tempOb.width;
			}
		}
		
		/**
		 * 装配不同的menuItem类实例
		 */
		public function getInstance(){
			return new NavTweenButton();
		}
		private function onDataLoaded(e:Event){
			bulidMenu();
		}
		/**
		 * 从data提取的xml与button数据模型的对应关系
		 */
		public function XMLtoNavTweenButton(xml:XML):INavTweenButton{
			var mImenuItem:INavTweenButton = getInstance();
			mImenuItem.Title = xml.display;
			mImenuItem.menuTreeXML = xml;
			mImenuItem.Trigger = false;
			mImenuItem.OnClick = itemClick;
			return mImenuItem;
		}
		
	}
}