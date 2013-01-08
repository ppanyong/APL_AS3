package com.sun.media
{
	/*
	支持http和rtmp两种协议的加载
	*/
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.media.SoundTransform;
	import flash.events.HTTPStatusEvent 
	import com.sun.events.StreamEvent;
	
	import flash.external.ExternalInterface;

	public class FLVStream extends Sprite
	{
		private var _stream:NetStream;
		private var connection:NetConnection;
		private var flvPath:String="";
		//FMS：服务器名称,包括应用程序名
		private var server:String;
		//
		private var _bufferTime:int = 2;
		private var _fullForTheFirstTime:Boolean;
		
		private var _seekError:Boolean;
		//保证只广播一次ready事件
		private var _hadReady:Boolean = false;
		//
		private var _client:CustomClient;
		
		private var loader:Loader;

		public function FLVStream()
		{
			init();
		}
		private function init():void
		{
		}
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			//trace("error:" + event);
		}
		private function ncStatusHandler(event:NetStatusEvent):void
		{
			//trace("--------------NetConnection----------------");
//			for (var i:String in event.info) {
//				trace(i+":"+event.info[i]);
//				try{
//					ExternalInterface.call("console.info","--------------NetConnection----------------");
//					ExternalInterface.call("console.info",i+"="+event.info[i]);
//				}catch(e:Error){
//					trace("调用外部JS方法错误");
//				}
//			}
			
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					_hadReady = false;
					streamInit();
					break;
				case "NetConnection.Connect.Closed" :
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_CLOSED,"NetConnection.Connect.Closed"));
					break;
				case "NetConnection.Connect.Failed" :
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR,"NetConnection.Connect.Failed"));
					break;
				case "NetConnection.Connect.Rejected" :
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR,"NetConnection.Connect.Rejected"));
					break;
				case "NetConnection.Connect.AppShutdown" :
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR,"NetConnection.Connect.AppShutdown"));
					break;
				case "NetConnection.Connect.InvalidApp" :
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR,"NetConnection.Connect.InvalidApp"));
				default :
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR,"other error"));
			}
			//
		}
		private function nsStatusHandler(event:NetStatusEvent):void
		{
			//trace("----------netStream-----------");
//			for (var i:String in event.info) {
//				trace(i+":"+event.info[i]);
//				try{
//					ExternalInterface.call("console.info","--------------netStream----------------");
//					ExternalInterface.call("console.info",i+"="+event.info[i]);
//				}catch(e:Error){
//					trace("调用外部JS方法错误");
//				}
//			}
			switch (event.info.code) {
				case "NetStream.Play.Start" :
					//trace("NetStream.Play.Start");
					if(!_hadReady){
						_hadReady = true;
						//_stream.pause();
						_seekError = false;
						_fullForTheFirstTime = false;
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_READY));
					}
					break;
				case "NetStream.Play.StreamNotFound" :
					//trace("NetStream.Play.StreamNotFound");
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_ERROR,"StreamNotFound"));
					
					if(loader==null){
						loader = new Loader();
					}
					loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
					loader.load(new URLRequest(flvPath));
														  
					break;
				case "NetStream.Buffer.Empty" :
					//try{
//						ExternalInterface.call("console.info","NetStream.Buffer.Empty:"+_fullForTheFirstTime);
//					}catch(e:Error){
//						trace("调用外部JS方法错误");
//					}
					if(_fullForTheFirstTime){
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_EMPTY));
					}
					break;
				case "NetStream.Buffer.Full" :
					//回到原来的状态
					//try{
//						ExternalInterface.call("console.info","NetStream.Buffer.Full:"+_fullForTheFirstTime);
//					}catch(e:Error){
//						trace("调用外部JS方法错误");
//					}
					if (!_fullForTheFirstTime) {
						_fullForTheFirstTime = true;
						_stream.bufferTime = _bufferTime;
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_START_READY));
					}else{
						//第一次full不触发，因为没有第一应的empty事件
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_FULL));
					}
					break;
				case "NetStream.Buffer.Flush" :
					break;
				case "NetStream.Seek.Notify" :
					if(_seekError){
						_seekError = false;
					}
					break;
				case "NetStream.Seek.InvalidTime":
					_seekError = true;
					break;
				case "NetStream.Play.Stop" :
					if(_seekError){
						return;
					}
					//回到原来的状态
					if(server==null){
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_STOP));
					}
					break;
			}
			dispatchEvent(new StreamEvent(StreamEvent.STREAM_STATUS,event.info));
		}
		/*
		播放结束后事件的触发顺序:
		NetStream.Buffer.Flush
		NetStream.Play.Stop
		NetStream.Buffer.Empty
		说明:Flush有可能连续触发几次,Flush是否只在播放结束后触发,在Empty后时候触发?
		Stop可能不触发
		Empty最后触发
		*/
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			if(event.target==loader.contentLoaderInfo){
				dispatchEvent(new StreamEvent(StreamEvent.STREAM_ERROR,"securityError"));
			}
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		private function ioError(event:IOErrorEvent):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		private function httpStatus(event:HTTPStatusEvent):void
		{
			if(event.status==404){
				dispatchEvent(new StreamEvent(StreamEvent.STREAM_404));
				loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
			}
		}
		private function splitRMPTURL(uri:String):Object
		{
			var o:Object = new Object();
			var a:Array = uri.split("/");
			var len:uint = a.length;
			var s:String = "";
			var n:String = "";
			for (var i:uint=0; i<len; i++) {
				if (i<4) {
					s += a[i]+"/";
				} else {
					if (i==len-1) {
						//对最后一个进行处理
						var tmp:String = a[i];
						if(tmp.lastIndexOf(".mp4")>=0){
							if(tmp.indexOf("mp4:")!=0){
								tmp = "mp4:"+tmp;
							}
						}
						n+=tmp;
					} else {
						n+=a[i]+"/";
					}
				}
			}
			//去掉后缀名
			n  = n.substr(0,n.length - 4);
			
			o.server = s;
			o.flvname = n;
			return o;
		}
		private function connectionInit():void
		{
			connection = new NetConnection()  ;
			connection.addEventListener(NetStatusEvent.NET_STATUS,ncStatusHandler);
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//
			if (flvPath.indexOf("rtmp://")>=0) {
				//拆分服务器和文件名
				//rtmp://server/app/folder/streamname.flv;
				var temp:Object = splitRMPTURL(flvPath);
				server = temp.server;
				flvPath = temp.flvname;
			}
			connection.connect(server);
		}
		private function streamInit():void
		{
			_stream=new NetStream(connection);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, nsStatusHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			_stream.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			
			_client = new CustomClient();
			
			_stream.client = _client;
			
			_fullForTheFirstTime = false;
			
			_stream.bufferTime = 2;
			
			try{
				_stream.play(flvPath);
			}catch(e:Error){
				
			}
		}
		private function netObjDestroy():void
		{
			if (_stream!=null) {
				_stream.close();
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, nsStatusHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				if(loader!=null){
					loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
				}
				_stream = null;
				
				if(loader!=null){
					loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
				}
			}
			if (connection!=null) {
				connection.close();
				connection.removeEventListener(NetStatusEvent.NET_STATUS,ncStatusHandler);
				connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				
				connection = null;
			}
		}
		public function load(path:String,bt:int=2):void
		{
			if (path=="") {
				throw new Error("不能提供空的路径");
				return;
			}
			_bufferTime = bt;
			flvPath = path;
			//flvPath = "http://v.video.qq.com/s_test.flv";
			server = null;
			netObjDestroy();

			connectionInit();
		}
		//===API
		public function get NStream():NetStream
		{
			return _stream;
		}
		public function closeVideo():void
		{
			netObjDestroy();
		}
		public function set volume(v:Number):void
		{
			if (_stream!=null) {
				var transfrom:SoundTransform = _stream.soundTransform;
				transfrom.volume = v/100;
				_stream.soundTransform = transfrom;
			}
		}
		public function get volume():Number
		{
			if (_stream!=null) {
				var transfrom:SoundTransform = _stream.soundTransform;
				return transfrom.volume * 100;
			} else {
				return 0;
			}
		}
		public function set bufferTime(bt:int):void
		{
			_bufferTime = bt;
			if(bt>10){
				bt=10;
			}
			if(bt<2){
				bt=2;
			}
			if(_fullForTheFirstTime){
				_stream.bufferTime = bt;
			}
		}
		public function get bufferTime():int
		{
			return _bufferTime;
		}
		
		public function get client():CustomClient
		{
			return _client;
		}
	}
}

import flash.external.ExternalInterface;
class CustomClient extends flash.display.Sprite
{
	public function CustomClient()
	{
	}
	public function onMetaData(info:Object):void
	{
		//trace("广播onMetaData");
//		try{
//			ExternalInterface.call("console.info","FLVStream::CustomClient:"+info["duration"]);
//		}catch(e:Error){
//			trace("调用外部JS方法错误");
//		}
		dispatchEvent(new com.sun.events.StreamEvent(com.sun.events.StreamEvent.STREAM_MD,info));
	}
	public function onPlayStatus(info:Object):void {
        //trace("--------handling playstatus here----------");
//		for(var i:String in info){
//			trace(i+":"+info[i]);
//		}
		if(info.code == "NetStream.Play.Complete"){
			dispatchEvent(new com.sun.events.StreamEvent(com.sun.events.StreamEvent.STREAM_STOP));
		}
    }
}