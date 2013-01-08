package com.FSC.UI.InterActiveObject.NavTweenButtonBar
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import com.FSC.UI.InterActiveObject.NavTweenButton.*;
	import com.FSC.UI.InterActiveObject.NavTweenButtonBar.NavTweenButtonBarData;
	/**菜单类
	 * * panyong
	 * v1.080516
	 * 使用css定位按钮位置和按钮布局
	 * 渐变按钮的集合 就是一般意义上的导航条
	 */
	public dynamic class NavTweenButtonBar extends Sprite implements INavTweenButtonBar
	{
		//存储数据
		private var menuData:NavTweenButtonBarData;
		private var navButtonArray:Array = new Array();
		private var triget:Boolean = true;
		private var selectedButton:INavTweenButton;
		
		/**
		 * 构造函数
		 * @param dataXml		内容也可以是文件地址
		 * 
		 */
		public function NavTweenButtonBar(dataXml:String)
		{
			super();
			menuData = new NavTweenButtonBarData(dataXml);
			menuData.addEventListener(Event.COMPLETE,OnDataLoaded);
			
		}
		
		/**
		 * 导航按钮按下响应
		 */
		private function OnNavTweenButtonClickHandler(e:MouseEvent):void{
			//trace(e.currentTarget.NavTreeXML);
			//var tmp:NavTweenButton = e.currentTarget as NavTweenButton;
			//如果是多选一按钮列
			if(this.triget && selectedButton!=null){
				selectedButton.Refresh();
			}
			selectedButton = e.currentTarget as INavTweenButton;
			this.setChildIndex(selectedButton as DisplayObject, this.numChildren-1);
			this.dispatchEvent(new NavTweenButtonBarEvent(NavTweenButtonBarEvent.NavClick,e.currentTarget.NavTreeXML));
		}
		
		/**
		 * 绘制菜单 定义了菜单数量
		 */
		private function  BulidMenuByData():void{
			//读取根目录
			var xmlList:XMLList = menuData.getMenuXMLByTag();
			//得到一级目录
			var x:Number = 0;
			//这里与data存在耦合 由于没有集合类 变通的办法是将bar的数据类型作为xmlnode的扩展
			for each(var xmlnode:XML in xmlList){
				var tempOb:DisplayObject = XMLtoNavTweenButton(xmlnode) as DisplayObject;
				this.addChild(tempOb);
				tempOb.x=x;
				SetEveryNavButtonCSS(tempOb);
				x = tempOb.x+tempOb.width;
			}
		}
		
		/**
		 * 类似css 定位每一个按钮的具体位置
		 */
		public function SetEveryNavButtonCSS(displayObject:DisplayObject):void{
			displayObject.x+=0;	
		}
		
		/**
		 * 装配不同的menuItem类实例
		 */
		public function GetInstance():INavTweenButton{
			return new NavTweenButton();
		}
		
		/**
		 * 通过nav.xml的tagname 定位激活按钮
		 * @param name nav导航名称
		 */
		public function SelectNavByTagName(name:String):INavTweenButton{
			//trace("激活的导航名="+name);
			if(navButtonArray.length==0)
				return null ;
			for each(var mImenuItem:INavTweenButton in navButtonArray){
				if(mImenuItem.NavTreeXML.@tag == name ){
					mImenuItem.Selected();
					return mImenuItem;
				}
			} 
			
			return null;
		}
		
		/**
		 * 但数据分析完成 构造导航
		 * @param e 加载完成
		 */
		private function OnDataLoaded(e:Event):void{
			BulidMenuByData();
		}
		/**
		 * 从data提取的xml与button数据模型的对应关系
		 */
		public function XMLtoNavTweenButton(xml:XML):INavTweenButton{
			var mImenuItem:INavTweenButton = GetInstance();
			if(xml.display!=null){
				mImenuItem.Title = xml.display;//非错误 xml动态查找
			}
			mImenuItem.NavTreeXML = xml;
			mImenuItem.Trigger = triget;
			mImenuItem.ClickHandler = OnNavTweenButtonClickHandler;
			navButtonArray.push(mImenuItem);
			return mImenuItem;
		}
		
	}
}