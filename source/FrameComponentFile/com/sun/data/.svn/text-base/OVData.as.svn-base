package com.sun.data{
	import flash.events.EventDispatcher;
	import com.sun.loader.FileLoader;
	//事件就用这个类
	import com.sun.events.LoaderEvent;
	
	public class OVData extends EventDispatcher{
		private var _data:Array;
		private var _nt:uint;
		private var fld:FileLoader;
		
		public function load(path:String):void{
			_data = new Array();
			
			if(fld==null){
				fld = new FileLoader();
				fld.addEventListener(LoaderEvent.LOAD_COMPLETE,completeHandler);
				fld.addEventListener(LoaderEvent.LOAD_ERROR,errorHandler);
			}
			fld.load(path,"URLRequest");
		}
		
		private function completeHandler(event:LoaderEvent):void{
			try{
				var xml:XML = new XML(event.value.data);
			}catch(e:Error){
				trace("创建XML文件失败:"+e);
				return;
			}
			xml.ignoreWhitespace = true;
			var len:uint = xml.vd.vi.length();
			try{
				_nt = uint(xml.vd.nt.toString());
			}catch(e:Error){
				trace("OVData::completeHandler:"+e);
			}
			for(var i:uint=0;i<len;i++){
				_data.push(getVINodeData(xml.vd.vi[i]));
			}
			
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE,_data));
		}
		private function errorHandler(event:LoaderEvent):void{
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,"data load error"));
		}
		private function getVINodeData(vi:XML):Object{
			var _vi:Object = new Object();
			var len:uint = vi.children().length();
			
			for(var i:uint = 0;i<len;i++){
				_vi[vi.children()[i].name().toString()] = vi.children()[i].toString();
			}
//			for(var k:String in _vi){
//				trace(k+":"+_vi[k]);
//			}
			return _vi;
		}
		
		public function get data():Array{
			return _data;
		}
		public function get nt():uint{
			return _nt;
		}
	}
}