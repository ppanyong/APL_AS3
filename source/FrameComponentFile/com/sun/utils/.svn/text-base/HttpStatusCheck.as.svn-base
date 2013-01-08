package com.sun.utils
{
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class HttpStatusCheck extends EventDispatcher
	{
		private var urlLoader:URLLoader;
		
		public function HttpStatusCheck()
		{
		}
		public function stCheck(path:String):void
		{
			if(urlLoader==null){
				urlLoader = new URLLoader(new URLRequest(path));
			}
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,security);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			urlLoader.addEventListener(Event.OPEN,open);
		}
		private function httpStatus(event:HTTPStatusEvent):void
		{
			
		}
		private function security(event:SecurityErrorEvent):void
		{
			
		}
		private function ioError(event:IOErrorEvent):void
		{
			
		}
		private function open(event:Event):void
		{
			
		}
	}
}