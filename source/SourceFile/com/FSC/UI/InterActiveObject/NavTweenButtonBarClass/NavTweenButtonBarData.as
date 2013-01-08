package com.FSC.UI.InterActiveObject.NavTweenButtonBarClass {
	import com.FSC.XML.MyXML;	
	import flash.display.MovieClip;
	import flash.net.*;
	import flash.events.Event;

	/**菜单数据类
	 * 通过分析xml 输出菜单的目录结构
	 * @author	panyong 
	 * @date	080505
	 * @version	1.0.080513
	 */
	public class NavTweenButtonBarData extends MovieClip
	{
		private var data:XML;
		private var xmlLoader:URLLoader;
		
		/**
		 * source是数据xml地址或者是xml的字符串内容
		 * @param source xml地址或内容
		 */
		public function NavTweenButtonBarData(source:String=null)
		{
			if(!MyXML.checkXMLOrPath(source)){
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, XmlLoadedHandler);
				xmlLoader.load(new URLRequest(source));
			}else{
				data = new XML(source);
				ThrowCompleteEvent();
			}
			
		}
		
		private function XmlLoadedHandler(event:Event):void {
			data = XML(xmlLoader.data);
			ThrowCompleteEvent();
		}
		
		private function ThrowCompleteEvent():void{
			this.dispatchEvent( new Event(Event.COMPLETE,true));
		}
		/**
		 * @param tagString		需要从xml中筛选的tag的名字 默认值为root
		 * @deprecated 返回某一子叶的 菜单
		 * @deprecated 返回第level层的菜单 root表示根 这里存在和nav.xml极大的耦合性！
		 * */
		public function getMenuXMLByTag(tagString:String="root"):XMLList{
			if(tagString=="root"){
				return data.children();
			}else{
				if(data.navItem!=null)			
            	return data.navItem.(@tag==tagString);
   			}
   			return null;
		}
		
	}
}