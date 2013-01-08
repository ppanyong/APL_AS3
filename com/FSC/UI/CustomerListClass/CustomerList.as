package com.FSC.UI.CustomerListClass {
	import flash.events.MouseEvent;	
	
	import com.FSC.UI.CustomerListItemClass.CustomerListItemBase;	
	
	import flash.display.DisplayObject;	
	
	import com.FSC.UI.CustomerListItemClass.ICustomerListItem;	
	
	import flash.events.Event;	
	import flash.display.MovieClip;
	
	/**
	 * 自定义列表类
	 * @author Andy
	 * 
	 */
	public class CustomerList extends MovieClip {
		
		private var listData : CustomerListData;
		private var _itemlenght:Number;
		public function CustomerList(dataXml:String) {
			super();
			trace("CustomerList 初始化"+dataXml);
			listData = new CustomerListData(dataXml);
			listData.addEventListener(Event.COMPLETE,OnDataLoaded);
		}
		
		public function getData(data:XML):XMLList{
			return data.news;
		}
		
		/**
		 * 但数据完成 构造
		 * @param e 加载完成
		 */
		private function OnDataLoaded(e:Event):void{
			BulidListByData();
		}
		/**
		 * 绘制List
		 */
		protected function  BulidListByData():void{
			//读取根目录
			var xmlList:XMLList = getData(listData.data);
			trace(xmlList)
			var y:Number = 0;
			_itemlenght = xmlList.length();

			for each(var xmlnode:XML in xmlList){
				var tempOb:MovieClip = XMLtoIListItem(xmlnode) as MovieClip;
				this.addChild(tempOb);
				tempOb.buttonMode=true;
				tempOb.y=y;
				tempOb.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				tempOb.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
				tempOb.addEventListener(MouseEvent.CLICK, mouseClickHandler)
				y = tempOb.y+tempOb.height;
				SetListItemCSS(tempOb);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function mouseOutHandler(e:MouseEvent) : void {
		}

		protected function mouseOverHandler(e:MouseEvent) : void {
		}
		protected function mouseClickHandler(e:MouseEvent) : void {
		}

		/**
		 * 从data提取的xml与button数据模型的对应关系
		 */
		public function XMLtoIListItem(xml : XML) : ICustomerListItem {
			var mIListItem:ICustomerListItem = GetInstance();
			if(xml.title!=null){
				//trace(xml);
				mIListItem.Content = unescape(xml.@title);//非错误 xml动态查找
			}
			if(xml.id!=null){
				mIListItem.Id = unescape(xml.@id);//非错误 xml动态查找
			}
			return mIListItem;
		}
		/**
		 * 装配不同的menuItem类实例
		 */
		public function GetInstance():ICustomerListItem{
			return new CustomerListItemBase();
		}
		/**
		 * 初始化选中
		 */
		public function Select(i:Number){
			for(var i:Number=0;i<this.numChildren;i++){
				var mIListItem:ICustomerListItem = this.getChildAt(i) as ICustomerListItem;
				mIListItem.Selected;
			}
		}
		
		/**
		 * 类似css 定位每一个按钮的具体位置
		 */
		public function SetListItemCSS(displayObject:DisplayObject):void{
		}
		
		public function get itemlenght() : Number {
			return _itemlenght;
		}
	}
}
