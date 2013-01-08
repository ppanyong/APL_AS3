package com.FSC.Model {
	import flash.events.IOErrorEvent;	
	import flash.display.MovieClip;	
	import flash.net.URLRequest;	
	import flash.events.Event;	
	
	import com.FSC.XML.MyXML;	
	
	import flash.net.URLLoader;	
	
	/**
	 * MVC中M部分 基类
	 * @author Andy
	 * @version 1.080520
	 */
	public class ModelDataBase extends MovieClip {
		public var data:XML;
		private var xmlLoader:URLLoader;
		
		/**
		 * source是数据xml地址或者是xml的字符串内容
		 * @param source xml地址或内容
		 */
		public function ModelDataBase(source:String=null)
		{
			trace("加载xml="+source);
			if(!MyXML.checkXMLOrPath(source)){
				trace("loader load");
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, XmlLoadedHandler);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				xmlLoader.load(new URLRequest(source));
			}else{
				trace("doc")
				data = new XML(source);
				ThrowCompleteEvent();
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent) : void {
			trace("err"+e);
		}

		private function XmlLoadedHandler(event:Event):void {
			if(xmlLoader.data!=null){
				//trace(xmlLoader.data);
				data = XML(xmlLoader.data);
				ThrowCompleteEvent();
			}
		}
		
		private function ThrowCompleteEvent():void{
			this.dispatchEvent( new Event(Event.COMPLETE,true));
		}
	}
}