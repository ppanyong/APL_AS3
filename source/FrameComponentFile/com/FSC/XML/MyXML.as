package com.FSC.XML {
	/**
	 * @author Andy
	 * @deprecated 扩展xml 增加了一些自定义功能
	 */
	public class MyXML {
		
		public function MyXML(value : Object = null) {
			
		}
		
		/**
		 *@deprecated 静态方法判别是xml地址还是内容串 
		 *@param s 待检查字符串
		 */
		static public function checkXMLOrPath(s:String):Boolean{
			if(s.indexOf("http")>-1){
				return false;
			}
			if((s.indexOf("<")<0)&&(s.indexOf(".xml")>0))
				return false;
			if(s.indexOf(".asp")>0){
				return false;
			}
			
			return true;
		}
	}
}
