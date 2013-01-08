package com.FSC.UI.CustomerListItemClass {
	import flash.text.TextField;	
	import flash.display.MovieClip;
	
	/**
	 * 自定义列表 表项
	 * @author Andy
	 * @version 1.080520
	 */
	public class CustomerListItemBase extends MovieClip implements ICustomerListItem
	{	
		protected var content:String;
		protected var id:String;
		public var contentTxt : TextField;
		protected var _selected:Boolean

		public function CustomerListItemBase() {
			super();
		}
		/**
		 * 列表项显示的内容
		 */
		public function get Content() : String {
			return content;
		}
		
		public function set Content(content : String) : void {
			this.content = content;
			if(contentTxt!=null){
				contentTxt.text = content;
			}
		}
		/**
		 * 列表项唯一标识
		 */
		public function get Id() : String {
			return id;
		}
		
		public function set Id(id : String) : void {
			this.id = id;
		}
		
		public function get Selected() : Boolean {
			return _selected;
		}
		
		public function set Selected(s : Boolean) : void {
			this._selected = s;
		}
	}
}
