package com.sun.utils 
{
	//获取视频的审核的数据信息
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.events.EventDispatcher;
	import com.sun.loader.FileLoader;
	import com.sun.events.LoaderEvent;
	
	public class CheckupInfor extends EventDispatcher
	{
		public static const STATE_LOADED:String = "state_loaded";
		
		private var fld:FileLoader;
		//http://video.qq.com/v1/vstatus/vstat?vid=5kkRF6tv5iG&ran=0%2E062332451809197664
		private var url:String = "http://video.qq.com/v1/vstatus/vstat";
		
		private var _state:int = 2;
		
		public function CheckupInfor()
		{
			fld = new FileLoader();
		}
		
		public function getFLVState(vid:String):void
		{
			fld.addEventListener(LoaderEvent.LOAD_COMPLETE,fldCompleted);
			fld.addEventListener(LoaderEvent.LOAD_ERROR,fldError);
			//http://video.qq.com/v1/vstatus/vstat?vid=2z8bpPWpiCs
			//trace(url+":"+vid);
			fld.load(url,"URLRequest",URLLoaderDataFormat.TEXT,{vid:vid,ran:Math.random()},"GET");
		}
		
		private function fldCompleted(event:LoaderEvent):void
		{
			//trace(url+":"+event.value.data);
			_state = getState(event.value);
			dispatchEvent(new Event(CheckupInfor.STATE_LOADED));
		}
		private function fldError(event:LoaderEvent):void
		{
			//数据加载失败默认不可以播放视频
			_state = 0;
			dispatchEvent(new Event(CheckupInfor.STATE_LOADED));
		}
		private function getState(data:Object):uint
		{
			try{
				var xml:XML = new XML(data.data);
			}catch(e:Error){
				trace("XML对象创建失败");
				//return;
			}
			if(xml==null){
				return 0;
			}
			var z:* = xml..z;
			if(z==undefined){
				z = 0;
			}else{
				z = int(z);
			}
			return z;
		}
		
		public function get flvState():int
		{
			return _state;
		}
	}
}