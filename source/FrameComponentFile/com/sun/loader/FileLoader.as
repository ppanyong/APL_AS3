package com.sun.loader{
	/**
	负责加载外部数据的类，只加载不分析
	sonsun
	2008.2.22
	*/
	import flash.display.Loader;
	import flash.net.*;
	import flash.events.*;
	import com.sun.events.LoaderEvent;
	
	/*
	var url:String = "http://www.[yourDomain].com/application.jsp";
            var request:URLRequest = new URLRequest(url);
            var variables:URLVariables = new URLVariables();
            variables.exampleSessionId = new Date().getTime();
            variables.exampleUserLabel = "guest";
            request.data = variables;
	*/

	public class FileLoader extends EventDispatcher {
		private var _loader:*;
		private var _isLoading:Boolean;
		private var _listener:IEventDispatcher;
		/*
		说明：不允许同步加载，即如果当前加载的东西还没有结果或者没有被停止的情况下，不允许用相同
		的实例加载下一个东西，如果加载了，则放弃当前的加载操作
		*/
		public function FileLoader() {
			_isLoading = false;
		}
		/*
		@param path:要加载的文件的路径
		@dataFormat:如果加载的是数据，则指定数据的格式化方式
		@type:加载内容类型，loader是Loader类型的，其它是URLRequest类型
		*/
		public function load(path:String,type:String = "Loader",dataFormat:String = URLLoaderDataFormat.TEXT,
							 data:Object=null,method:String = "POST"):void {
			if (_isLoading) {
				//取消先前的事件侦听
				removeEvents(_listener);
				//放弃当前的加载
				try {
					_loader.close();
				} catch (e:Error) {
					trace("数据加载取消出错："+e);
				}
			}
			if (type=="Loader") {
				_loader = new Loader();
				_listener = _loader.contentLoaderInfo;
				configureListeners(_loader.contentLoaderInfo);
			} else {
				_loader = new URLLoader();
				_loader.dataFormat = dataFormat;
				_listener = _loader;
				configureListeners(_loader);
			}
			trace("加载URL="+path);
			try {
				var request:URLRequest = new URLRequest(path); 
				if(data!=null){
					 var variables:URLVariables = new URLVariables();
					 for(var i:String in data){
						variables[i] = data[i]; 
					}
					request.method = method;
					request.data = variables;
				}
				_loader.load(request);
			} catch (error:Error) {
				//trace("Unable to load requested document");
				dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,"Unable to load requested document."));
			}
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function removeEvents(dispatcher:IEventDispatcher):void{
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		//加载事件处理
		private function completeHandler(event:Event):void {
			removeEvents(_listener);
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE,event.target));
			_isLoading = false;
		}
		private function progressHandler(event:ProgressEvent):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_PROGRESS,{bytesLoaded:event.bytesLoaded,bytesTotal:event.bytesTotal}));
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			removeEvents(_listener);
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,"securityErrorHandler"));
			_isLoading = false;
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			removeEvents(_listener);
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,"ioErrorHandler"));
			_isLoading = false;
		}
	}
}