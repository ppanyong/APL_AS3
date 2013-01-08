package com.FSC.UI.InterActiveObject.NavTweenButtonBarClass
{
	import com.FSC.UI.InterActiveObject.NavTweenButtonClass.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.NavTweenButtonBarData;
	/**菜单类 基类
	 * * panyong
	 * v1.080516
	 * 使用css定位按钮位置和按钮布局
	 * 渐变按钮的集合 就是一般意义上的导航条
	 */
	public dynamic class NavTweenButtonBarBase extends Sprite implements INavTweenButtonBar
	{
		//存储数据
		private var menuData:NavTweenButtonBarData;
		private var navButtonArray:Array = new Array();
		private var triget:Boolean = true;
		private var selectedButton:INavTweenButton;
		//预选中导航名称
		private var preSelectedNavTagName:String;
		
		public function set PreSelectedNavTagName(v:String):void
		{
			preSelectedNavTagName = v;
		}
		
		public function get PreSelectedNavTagName():String
		{
			return preSelectedNavTagName;
		}
		
		/**
		 * 构造函数
		 * @param dataXml 文件内容或文件地址
		 * 
		 */
		public function NavTweenButtonBarBase(dataXml:String)
		{
			super();
			menuData = new NavTweenButtonBarData(dataXml);
			menuData.addEventListener(Event.COMPLETE,OnDataLoaded);
		}
		
		/**
		 * 导航按钮按下响应
		 */
		private function OnNavTweenButtonClickHandler(e:MouseEvent):void{
			//如果是多选一按钮列
			if(this.triget && selectedButton!=null){
				selectedButton.Refresh();
			}
			selectedButton = e.currentTarget as INavTweenButton;
			DispatchNavEvent(selectedButton);
			this.setChildIndex(selectedButton as DisplayObject, this.numChildren-1);
		}
		
		private function DispatchNavEvent(b:INavTweenButton){
			this.dispatchEvent(new NavTweenButtonBarEvent(NavTweenButtonBarEvent.NavClick,b.NavTreeXML));
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
			//如果预设了默认选项则激活
			if(PreSelectedNavTagName!=null){
				SelectNavByTagName(PreSelectedNavTagName);
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
		private function SelectNavByTagName(name:String):INavTweenButton{
			if(navButtonArray.length==0)
				return null ;
			for each(var mImenuItem:INavTweenButton in navButtonArray){
				if(mImenuItem.NavTreeXML.@tag == name ){
					mImenuItem.Selected();
					selectedButton = mImenuItem;
					DispatchNavEvent(selectedButton);
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