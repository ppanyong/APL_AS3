package com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine
{
	import flash.events.Event;
	import flash.net.URLRequest;

	public class LoadLineEvent extends Event
	{
		public static var ONLOADLINECOMPLETE : String = "onLoadLineComplete";
		public var currentTragetURL:URLRequest;
		public var content:*;
		public var isSuccess:Boolean
		public function LoadLineEvent(type:String,URL:URLRequest,content,isSuccess:Boolean = true, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.currentTragetURL = URL;
			this.isSuccess = isSuccess;
			this.content = content;
		}
		
	}
}