package com.FSF.Module {
	import flash.events.IOErrorEvent;	
	import flash.events.Event;	
	import flash.net.URLLoader;	
	
	import com.FSF.Model.Nav.NavItem;	
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine.LoadLineProgressEvent;	
	import flash.events.ProgressEvent;	
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine.LoadLineEvent;	
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine.SWFLoaderLine;	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import com.FSF.Module.*;
	/**
	 * 模型基类
	 * 
	 * @author	pan
	 * @date	080506
	 * @version	0.080506
	 */	
	public class ModuleBase extends MovieClip implements IModule
	{
		//常量
		public static var LIB_CLASS : String = "com.FSF.Lib.Libaray";
		protected var swfLoaderList:SWFLoaderLine = SWFLoaderLine.GetInstance();//采用队列机制
		private var navItem : NavItem; 
		private var libClass : Class;
		private var rest:*;
		
		/**
		 * 存储NavItem信息 每一个模块应该都有一个这样的存储
		 */		
		public function get MyNavItem() : NavItem {
			return navItem;
		}
		
		public function set MyNavItem(navItem : NavItem) : void {
			this.navItem = navItem;
			if(navItem.Data!=null){
				LoadData(navItem.Data);
			}
		}
		
		/**
		 * 构造函数
		 */		
		public function ModuleBase()
		{
			super();
		}
		/**
		 * 给队列增加侦听
		 */
		private function AddEventLister():void
		{
			swfLoaderList.addEventListener(LoadLineEvent.ONLOADLINECOMPLETE,CompleteHandler);
			swfLoaderList.addEventListener(ProgressEvent.PROGRESS,ProgressHandler);
		}
		/**
		 * 队列去除侦听
		 */
		private function RemoveEventLister():void
		{
			swfLoaderList.removeEventListener(LoadLineEvent.ONLOADLINECOMPLETE,CompleteHandler);
			swfLoaderList.removeEventListener(ProgressEvent.PROGRESS,ProgressHandler);
		}
		
		/**
		 * 显示
		 * 
		 * @param p_parent	父容器
		 * @param rest		其它参数
		 */		
		public function show(p_parent : DisplayObjectContainer, ... rest) : void
		{
			//如果公共类文件没有加载 则先加载公共类库
			libClass = this.getClass(LIB_CLASS);
			this.rest=rest;
			if (libClass != null){
				if(navItem.Data==null){
					this.initUi(libClass, rest);
				}
			}
			p_parent.addChild(this);
		}
		/**
		 * 销毁
		 */		
		public function dispose() : void
		{
			if (this.parent != null) 
			{
				trace("从"+this.parent+"销毁"+this);
				this.parent.removeChild(this);
			}
		}
		
		/**
		 * 初始化用户界面，由子类具体实现
		 * 
		 * @param p_libClass	库类
		 * @param p_rest		其它参数
		 */		
		protected function initUi(p_libClass : Class, p_rest : Array = null) : void
		{
		}
		/**
		 * 添加用户界面元素
		 * 
		 * @param p_uiClass	界面元素类
		 * @param p_param	其它参数
		 * @return 			添加的界面元素实例
		 */		
		protected function addUi(p_uiClass : Class, p_param : * = null) : Object
		{
			if (p_uiClass == null) return null;
			var uiInstance : Object = p_param == null ? new p_uiClass() : new p_uiClass(p_param);
			this.addChild(uiInstance as DisplayObject);
			return uiInstance;
			
		}
		/**
		 * 获取当前ApplicationDomain内的类定义
		 * 
		 * @param p_name	类名称，必须包含完整的命名空间,如 net.eidiot.net.SWFLoader
		 * @return			获取的类定义，如果不存在返回null
		 */		
		protected function getClass(p_name : String) : Class
		{
			try
			{
				return ApplicationDomain.currentDomain.getDefinition(p_name) as Class;
			} catch (p_e : ReferenceError)
			{
				trace("error: 定义 " + p_name + " 不存在");
				return null;
			}
			return null;
		}
		
		/**
		 * 加载队列完成
		 */
		private function CompleteHandler(p_e:LoadLineEvent):void {
			//从库列表中剔除已经下载的项目
			//trace(p_e.isSuccess);
			RemoveEventLister();
			if(p_e.isSuccess){
				CompleteSuccessHandler(p_e);
			}else{
				CompleteFailHandler(p_e);
				trace("加载" + p_e.currentTragetURL + "失败");
			}
		}
		
		/**
		 * 加载队列完成 
		 * 允许子类覆盖 定义自己的处理行为
		 */
		protected function CompleteSuccessHandler(p_e:LoadLineEvent):void {
			//
		}
		/**
		 * 加载队列完成失败
		 * 允许子类覆盖 定义自己的处理行为
		 */
		protected function CompleteFailHandler(p_e:LoadLineEvent):void {
			//
		}
		
		/**
		 * 处理加载过程 
		 * 允许子类覆盖 定义自己的处理行为
		 */
		protected function ProgressHandler(p_e:LoadLineProgressEvent):void {
			
		}
		
		/**使用下载队列 
		 * 统一下载
		 * @param target 目标地址
		 * @param emergent 下载级别
		 * @deprecated 子类可以选择override 处理方法
		 */
		 protected function loadFile(target:URLRequest,emergent:Number=10):void{
		 	trace("使用下载队列 "+target.url);
		 	AddEventLister();
		 	swfLoaderList.LoadFile(target,emergent);
		}
		
		private function LoadData(path:URLRequest):void{
			var xmlLoader:URLLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,DataLoadedHandler);
			xmlLoader.addEventListener(Event.COMPLETE,DataLoadedInteralHandler);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,DataIoErrorHandler);
			xmlLoader.load(path);
		}
		
		private function DataLoadedInteralHandler(event:Event) : void {
			initUi(libClass,rest);
		}

		/**
		 * 加载Data出错处理
		 * @param event IOErrorEvent
		 */
		private function DataIoErrorHandler(event:IOErrorEvent):void {
			trace("warning:"+"数据文件读取失败！: " + event);
		}
		/**
		 * 加载Data完成，分配个配置参数到参数变量
		 * @param event Event加载的内容是event.target.data 
		 * var xml:XML=XML(event.target.data);
		 */
		protected function DataLoadedHandler(event:Event):void {
			return;
		}
		
		
	}
}