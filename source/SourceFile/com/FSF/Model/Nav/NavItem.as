package com.FSF.Model.Nav {
	import flash.net.URLRequest;	
	
	/**
	 * @author Andy
	 * @deprecated 导航数据模型
	 * @version 1.080516
	 */
	public class NavItem {
		private var descrip:String;
		private var display:String;
		private var swf:URLRequest;
		private var data: URLRequest;
		private var tagName : String;
		private var subNavXml:XML;

		public function NavItem(xml : XML=null) {
			if (xml==null) return;
			if(xml.swf!=null) this.Swf = new URLRequest(xml.swf);
			if(xml.data!=null) this.Data =new URLRequest(xml.data);
			if(xml.descrip!=null) this.Descrip = xml.descrip;
			if(xml.display!=null) this.Display = xml.display;
			if(xml.@tag!=null) this.TagName = xml.@tag;
			if(xml.navItem!=null) this.SubNavXml = xml.navItem as XML;
		}
		
		/**
		 * 获取Nav表述
		 */
		public function get Descrip() : String {
			return descrip;
		}
		/**
		 * 设置Nav描述
		 */
		public function set Descrip(descrip : String) : void {
			this.descrip = descrip;
		}
		
		/**
		 * 获取Nav显示标题
		 */
		public function get Display() : String {
			return display;
		}
		
		/**
		 * 设置Nav显示标题
		 */
		public function set Display(display : String) : void {
			this.display = display;
		}
		
		/**
		 * 获取Nav导航目标swf文件地址
		 */
		public function get Swf() : URLRequest {
			return swf;
		}
		/**
		 * 设置Nav导航目标swf文件地址
		 */
		public function set Swf(swf : URLRequest) : void {
			this.swf = swf;
		}
		/**
		 * 获取Nav指向的数据文件地址
		 */
		public function get Data() : URLRequest {
			return data;
		}
		/**
		 * 设置Nav指向的数据文件地址
		 */
		public function set Data(data : URLRequest) : void {
			this.data = data;
		}
		
		/**
		 * 获取Nav的Tag
		 */
		public function get TagName() : String {
			return tagName;
		}
		
		public function set TagName(tagName : String) : void {
			this.tagName = tagName;
		}
		
		/**
		 * 包含在导航xml中的子导航内容
		 */
		public function get SubNavXml() : XML {
			return subNavXml;
		}
		
		public function set SubNavXml(subNavXml : XML) : void {
			this.subNavXml = subNavXml;
		}
	}
}
