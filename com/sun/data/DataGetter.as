package com.sun.data
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.sun.loader.FileLoader;
	import com.sun.events.LoaderEvent;
	
	public class DataGetter extends EventDispatcher
	{
		private var fld:FileLoader;
		private var _imgData:Array;
		public function dataGetter(){
			
		}
		public function loadData(path:String):void
		{
			if(path==""){
				return;
			}
			if(fld!=null){
				fld = new FileLoader();
			}
			_imgData = new Array();
			
			fld = new FileLoader();
			fld.addEventListener(LoaderEvent.LOAD_COMPLETE,dataCompleteHandler);
			fld.addEventListener(LoaderEvent.LOAD_ERROR,dataErrorHandler);
			fld.load(path,"URLRequest");
		}
		public function get imgsData():Array
		{
			return _imgData;
		}
		private function dataCompleteHandler(event:LoaderEvent):void
		{
			fld.removeEventListener(LoaderEvent.LOAD_COMPLETE,dataCompleteHandler);
			fld.removeEventListener(LoaderEvent.LOAD_ERROR,dataErrorHandler);
			
			dataAnalyse(new XML(event.value.data));
			
			dispatchEvent(new Event("dataOk"));
		}
		private function dataAnalyse(xml:XML):void
		{
			var img:Object = xml.list.img;
			var len:uint = img.length();
			
			for(var i:uint = 0;i<len;i++){
				var tg:XML = img[i];
				var item:Object = new Object();
				var temp:Array = new Array();
				item.burl = tg.burl.toString();
				
				item.bw = xml.list.@bw;
				item.bh = xml.list.@bh;
				
				item.surl = tg.surl.toString();
				//使用的时候，检查为undefined或者为空
				item.sw = xml.list.@sw;
				item.sh = xml.list.@sh;
				
				item.link = tg.link.toString();
				//拆分vid和ext
				temp = tg.uname.toString().split(".");
				item.vid = temp[0];
				item.ext = temp[1];
				
				item.vt = tg.vt.toString();
				
				_imgData.push(item);
			}
		}
		
		private function dataErrorHandler(event:LoaderEvent):void
		{
			trace("dataErrorHandler");
			fld.removeEventListener(LoaderEvent.LOAD_COMPLETE,dataCompleteHandler);
			fld.removeEventListener(LoaderEvent.LOAD_ERROR,dataErrorHandler);
			
			dispatchEvent(new Event("dataError"));
		}
	}
}