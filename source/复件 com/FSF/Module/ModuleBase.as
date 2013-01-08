package com.FSF.Module
{
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
		public static var LIB_CLASS : String = "com.FSF.Lib.Library";
		/**
		 * 构造函数
		 */		
		public function ModuleBase()
		{
			super();
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
			var libClass : Class = this.getClass(LIB_CLASS);
			if (libClass != null)
				this.initUi(libClass, rest);
			p_parent.addChild(this);
		}
		/**
		 * 销毁
		 */		
		public function dispose() : void
		{
			if (this.parent != null) this.parent.removeChild(this);
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
		/**使用下载队列 
		 * 统一下载
		 * @param target 目标地址
		 * @param handler 下载完成后的处理函数
		 * @param errorHandler 下载完成后失败的处理函数
		 */
		 protected function loadFile(target:URLRequest,handler:Function,errorHandler:Function=null){
		 	
		 }
	}
}