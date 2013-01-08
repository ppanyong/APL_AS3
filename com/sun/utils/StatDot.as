package com.sun.utils
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;

	import flash.events.EventDispatcher;

	public class StatDot extends EventDispatcher
	{
		public static function dataForServer(data:Object,path:String,method:String="POST"):void
		{
			////暂时不做统计
//			try{
//				trace("提交统计:"+data.flag3);
//			}catch(e:Error){
//				trace("访问data.code出错:"+e);
//			}
//			return;
			
			var request:URLRequest = new URLRequest(path);
			//如果不需要处理返回结果，用Loader来加载数据，可以避免跨域访问问题
			var loader:Loader = new Loader();
			var variables:URLVariables = new URLVariables();
			if (data!=null) {
				for (var i:String in data) {
					variables[i] = data[i];
				}
				request.method = method;
				request.data = variables;
			}
			request.method = method;
			request.data = variables;
			try{
				loader.load(request);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}catch(e:Error){
				trace("条用loader.load()方法出错："+e);
			}
		}
		private static function ioErrorHandler(event:IOErrorEvent):void
		{
			
		}
	}
}