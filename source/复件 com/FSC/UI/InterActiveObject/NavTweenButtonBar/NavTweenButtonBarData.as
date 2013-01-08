package com.FSC.UI.InterActiveObject.NavTweenButtonBar
{
	import flash.display.MovieClip;
	import flash.xml.*;
	import flash.net.*;
	import flash.events.Event;

	/**菜单数据类
	 * 通过分析xml 输出菜单的目录结构
	 * @author	panyong 
	 * @date	080505
	 * @version	1.0.080505
	 */
	public class NavTweenButtonBarData extends MovieClip
	{
		private var _data:XML;
		private var _xmlLoader:URLLoader;
		
		/**
		 * source是数据xml地址或者是xml的字符串内容
		 */
		public function NavTweenButtonBarData(source:String=null)
		{
			if(!checkXMLOrPath(source)){
				_xmlLoader = new URLLoader();
				_xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
				_xmlLoader.load(new URLRequest(source));
			}else{
				_data = new XML(source);
				throwEvent();
			}
			
		}
		private function xmlLoaded(event:Event):void {
			_data = XML(event.target.data);
			throwEvent();
		}
		private function throwEvent(){
			this.dispatchEvent( new Event(Event.COMPLETE,true));
		}
		/**
		 *静态方法判别是xml地址还是内容串 
		 */
		static public function checkXMLOrPath(s:String):Boolean{
			if((s.indexOf("<")<0)&&(s.indexOf(".xml")>0))
				return false;
			return true;
		}
		/**
		 * @param tagString		需要从xml中筛选的tag的名字
		 * 返回某一子叶的 菜单
		 * 返回第level层的菜单 root表示根 这里存在和nav.xml极大的耦合性！
		 * */
		public function getMenuXMLByTag(tagString:String="root"):XMLList{
			if(tagString=="root"){
				return _data.children();
			}else{			
            return _data.navItem.(@tag==tagString);
   			}
		}
		
	}
}