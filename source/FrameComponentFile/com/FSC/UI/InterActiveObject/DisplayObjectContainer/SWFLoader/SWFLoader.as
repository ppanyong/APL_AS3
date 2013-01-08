package com.FSC.UI.InterActiveObject.DisplayObjectContainer.SWFLoader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	/**
	 * SWF加载器 增加了超时判断
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @author  扩展 andypan 
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class SWFLoader extends EventDispatcher
	{
		/** 加载到子域 */
		public static var TARGET_CHILD : String = "child";
		/** 加载到同域 */
		public static var TARGET_SAME : String = "same";
		/** 加载到新域 */
		public static var TARGET_NEW : String = "new";
		
		/*计时器*/
		private var timer:Timer;
		/*监控时间*/
		private var dtime:Number=10000;
		private var currentUrl:String;
		private var context : LoaderContext;
		private var loader : Loader;
		
		public function get content():*{
			return loader.content;
		}
		
		public function set DTime(v:Number):void
		{
			dtime = v;
			if(timer==null){
				timer = new Timer(dtime);
			}else{
				timer.stop();
				timer.delay = dtime;
				timer.reset();
			}
		}
		
		public function get DTime():Number
		{
			return dtime;
		}
		
		/**
		 * 构造函数
		 */		
		public function SWFLoader()
		{
			super();
		}
		
		/**
		 * 加载SWF
		 * 
		 * @param p_url		SWF地址
		 * @param p_target	加载到哪个ApplicationDomain
		 */		
		public function load(p_url : String, p_target:String = "child") : void
		{
			loader = new Loader();
			context = new LoaderContext();
			switch (p_target)
			{
				case SWFLoader.TARGET_CHILD :
					context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					break;
				case SWFLoader.TARGET_SAME :
					context.applicationDomain = ApplicationDomain.currentDomain;
					break;
				case SWFLoader.TARGET_NEW :
					context.applicationDomain = new ApplicationDomain();
					break;
			}
			currentUrl = p_url;	
			Try();
		}
		
		/**
		 * 轮询下载过程中的变化
		 */
		private function onTimerHandler(e:TimerEvent):void{
			var tmp:Timer = e.currentTarget as Timer;
			if(tmp.currentCount>2){
				this.dispatchEvent(new LoadEvent(LoadEvent.OVERTIME,null));
			}	
		}
		
		public function CloseLoader():void{
			if(loader!=null)
				loader.close();
		}
		
		private function Try():void{
			this.InitLoadEvent(loader.contentLoaderInfo);
			loader.load(new URLRequest(currentUrl), context);
		}
		
		/**
		 * 获取当前ApplicationDomain内的类定义
		 * 
		 * @param p_name	类名称，必须包含完整的命名空间,如 net.eidiot.net.SWFLoader
		 * @param p_info	加载swf的LoadInfo，不指定则从当前域获取
		 * @return			获取的类定义，如果不存在返回null
		 */		
		public function GetClass(p_name : String, p_info : LoaderInfo = null) : Class
		{
			try
			{
				if (p_info == null)
					return ApplicationDomain.currentDomain.getDefinition(p_name) as Class;
				return p_info.applicationDomain.getDefinition(p_name) as Class;
			} catch (p_e : ReferenceError)
			{
				trace("warning:定义 " + p_name + " 不存在" + p_e.message);
				return null;
			}
			return null;
		}
		/**
		 * 允许用户重试下载
		 */
		public function ReTry():void
		{
			Try();
			if(timer!=null){
				timer.reset();
				timer.start();
			}
		}
		
		/**
		 * @private
		 * 监听加载事件
		 * 
		 * @param p_info	加载对象的LoaderInfo
		 */		
		private function InitLoadEvent(p_info : LoaderInfo) : void
		{
			timer = new Timer(dtime);
			timer.addEventListener(TimerEvent.TIMER,onTimerHandler,false,0,true);
			p_info.addEventListener(ProgressEvent.PROGRESS, this.ProgressHandler,false,0,true);
			p_info.addEventListener(Event.COMPLETE, this.CompleteHandler,false,0,true);
			p_info.addEventListener(IOErrorEvent.IO_ERROR, this.ErrorHandler,false,0,true);
			p_info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ErrorHandler,false,0,true);
		}
		/**
		 * @private
		 * 移除加载事件
		 * 
		 * @param p_info	加载对象的LoaderInfo
		 */	
		private function RemoveLoadEvent(p_info : LoaderInfo) : void
		{
			if(timer!=null)
				timer.removeEventListener(TimerEvent.TIMER,onTimerHandler);
			p_info.removeEventListener(Event.COMPLETE, this.CompleteHandler);
			p_info.removeEventListener(ProgressEvent.PROGRESS, this.ProgressHandler);
			p_info.removeEventListener(IOErrorEvent.IO_ERROR, this.ErrorHandler);
			p_info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ErrorHandler);
		}
		
		/* 加载事件 */
		private function CompleteHandler(p_e : Event) : void
		{
			var info : LoaderInfo = p_e.currentTarget as LoaderInfo;
			this.RemoveLoadEvent(info);
			this.dispatchEvent(new LoadEvent(LoadEvent.COMPLETE, info));
		}
		/**
		 * 下载过程
		 */
		private function ProgressHandler(p_e : ProgressEvent) : void
		{
			if(timer!=null){
				timer.reset();
				timer.start();
			}
			this.dispatchEvent(p_e);
		}
		private function ErrorHandler(p_e : Event) : void
		{
			var info : LoaderInfo = p_e.currentTarget as LoaderInfo;
			this.RemoveLoadEvent(info);
			this.dispatchEvent(p_e);
		}
		
		public function get url() : String {
			return currentUrl;
		}
		
		public function set url(currentUrl : String) : void {
			this.currentUrl = currentUrl;
		}
	}
}