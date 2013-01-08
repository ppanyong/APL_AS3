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
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.SWFLoader.*
	
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
		private var _timer:Timer;
		/*监控时间*/
		private var _dtime:Number=10000;
		private var _currentUrl:String;
		private var context : LoaderContext;
		private var loader : Loader;
		
		public function get content():*{
			return loader.content;
		}
		
		public function set dTime(v:Number):void
		{
			_dtime = v;
			if(_timer==null){
				_timer = new Timer(_dtime)
			}else{
				_timer.stop();
				_timer.delay = _dtime;
				_timer.reset();
			}
		}
		
		public function get dTime():Number
		{
			return _dtime;
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
		public function load(p_url : String, p_target = "child") : void
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
			_currentUrl = p_url;	
			_try();
		}
		
		/**
		 * 轮询下载过程中的变化
		 */
		private function onTimer(e:TimerEvent){
			if(e.currentTarget.currentCount>2){
				//trace("warning:下载超时");
				//removeLoadEvent(loader.loaderInfo);
				//loader.close();
				this.dispatchEvent(new LoadEvent(LoadEvent.OVERTIME,null));
			}	
		}
		
		public function close(){
			if(loader!=null)
				loader.close();
		}
		
		private function _try(){
			this.initLoadEvent(loader.contentLoaderInfo);
			loader.load(new URLRequest(_currentUrl), context);
		}
		
		/**
		 * 获取当前ApplicationDomain内的类定义
		 * 
		 * @param p_name	类名称，必须包含完整的命名空间,如 net.eidiot.net.SWFLoader
		 * @param p_info	加载swf的LoadInfo，不指定则从当前域获取
		 * @return			获取的类定义，如果不存在返回null
		 */		
		public function getClass(p_name : String, p_info : LoaderInfo = null) : Class
		{
			try
			{
				if (p_info == null)
					return ApplicationDomain.currentDomain.getDefinition(p_name) as Class;
				return p_info.applicationDomain.getDefinition(p_name) as Class;
			} catch (p_e : ReferenceError)
			{
				trace("warning:定义 " + p_name + " 不存在");
				return null;
			}
			return null;
		}
		/**
		 * 允许用户重试下载
		 */
		public function reTry():void
		{
			_try();
			if(_timer!=null){
				_timer.reset();
				_timer.start();
			}
		}
		
		/**
		 * @private
		 * 监听加载事件
		 * 
		 * @param p_info	加载对象的LoaderInfo
		 */		
		private function initLoadEvent(p_info : LoaderInfo) : void
		{
			_timer = new Timer(_dtime);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			p_info.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
			p_info.addEventListener(Event.COMPLETE, this.onComplete);
			p_info.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
			p_info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
		}
		/**
		 * @private
		 * 移除加载事件
		 * 
		 * @param p_info	加载对象的LoaderInfo
		 */	
		private function removeLoadEvent(p_info : LoaderInfo) : void
		{
			if(_timer!=null)
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
			p_info.removeEventListener(Event.COMPLETE, this.onComplete);
			p_info.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
			p_info.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
			p_info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
		}
		
		/* 加载事件 */
		private function onComplete(p_e : Event) : void
		{
			var info : LoaderInfo = p_e.currentTarget as LoaderInfo;
			this.removeLoadEvent(info);
			this.dispatchEvent(new LoadEvent(LoadEvent.COMPLETE, info));
		}
		/**
		 * 下载过程
		 */
		private function onProgress(p_e : ProgressEvent) : void
		{
			if(_timer!=null){
				_timer.reset();
				_timer.start();
			}
			this.dispatchEvent(p_e);
		}
		private function onError(p_e : Event) : void
		{
			var info : LoaderInfo = p_e.currentTarget as LoaderInfo;
			this.removeLoadEvent(info);
			this.dispatchEvent(p_e);
		}
	}
}