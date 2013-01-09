package net.andyClass.webSite{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.*;

	import net.andyClass.webSite.ui.LoadingUi;
	import net.andyClass.net.LoadEvent;
	import net.andyClass.net.SWFLoader;
	import net.andyClass.webSite.navEvent;
	/**
	 * 主程序 原型
	 * 
	 * @authorpan
	 * @date080428
	 * @version1.0.080428
	 */
	public class ShellBase extends MovieClip {
		protected var m_libList:Array;//需要加载的公共类
		protected var m_moduleList:Array;//业务模块类
		private var m_loader:SWFLoader;
		private var m_loading:LoadingUi;//显示的类元件实例 需要在舞台上定义 该类应该可以摆在lib中但是怕下载延时大。
		private var m_isLoading:Boolean=false;//是否在加载的标志
		private var m_shellConfigXmlPath="config/config.xml";//配置文件相对路径
		/**
		 * 构造函数
		 */
		public function ShellBase() {
			this.init();
		}
		private function init():void {
			//移植到读配置文档
			//读外部文档
			var xml:XML;
			var xmlList:XMLList;
			var xmlLoader:URLLoader=new URLLoader();
			this.m_libList= new Array();
			this.m_moduleList= new Array();
			xmlLoader.addEventListener(Event.COMPLETE,configXmlLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,configXmlIoErrorHandler);
			xmlLoader.load(new URLRequest(m_shellConfigXmlPath));
		}
		private function configXmlIoErrorHandler(event:IOErrorEvent):void {
			trace(m_shellConfigXmlPath+"配置文件读取失败！: " + event);
		}

		//当配置文件读取完成，分配个配置参数到参数变量
		private function configXmlLoaded(event:Event):void {
			var xml:XML=XML(event.target.data);
			//填充2个数组 作为加载文件的文件列表
			for (var i:int=0; i < xml.lib.item.length(); i++) {
				this.m_libList.push(xml.lib.item[i]);
			}
			for (var j:int=0; j < xml.module.item.length(); j++) {
				this.m_moduleList.push(xml.module.item[j]);
			}
			this.m_loader=new SWFLoader  ;
			//封装的 以域的方式加载swf 可以读取其中的类
			this.m_loading=new LoadingUi(this);
			this.loadSwf();
		}
		protected function loadSwf():void {
			//如果加载的模块文件为空则直接返回
			if (this.m_moduleList.length == 0) {
				trace("加载的模块文件列表为空，主程序结束");
				return;
			}
			var url:String;
			var target:String;
			//先加载类库文件
			if (this.m_libList.length > 0) {
				url=this.m_libList[0];
				//类库加载在同域
				target=SWFLoader.TARGET_SAME;
			} else {
				url=this.m_moduleList[0];
				target=SWFLoader.TARGET_CHILD;
			}
			if (! this.m_isLoading) {
				//显示加载
				this.addChild(this.m_loading);
				this.initLoadEvent();
				this.m_isLoading=true;
			}
			this.m_loader.load(url,target);
			this.m_loading.setTarget(url);
		}
		private function initLoadEvent():void {
			this.m_loader.addEventListener(LoadEvent.COMPLETE,this.onComplete);
			this.m_loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
			this.m_loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this.m_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
		}
		protected function showModule(p_module:IModule):void {
			//下面是网页内部业务逻辑
			//override
		}
		private function removeLoadEvent():void {
			this.m_loader.removeEventListener(LoadEvent.COMPLETE,this.onComplete);
			this.m_loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
			this.m_loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this.m_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
		}
		private function addNavEventListener(p_module:IModule){
			p_module.addEventListener(navEvent.ONNAVCLICK,this.nav);
			p_module.show(this)
		}
		protected function nav(e:navEvent){
			// override trace(e.navInfo)
		}
		
		private function onComplete(p_e:LoadEvent):void {
			if (this.m_libList.length > 0) {
				if (this.m_libList[0] == "main_nav.swf") {
					//增加对主导航的侦听
					/*
					需要进一步抽象
					*/
					this.addNavEventListener(p_e.loaderInfo.content  as  IModule)
				}
				this.m_libList.shift();
				this.loadSwf();
			} else {
				this.removeLoadEvent();
				if (this.m_isLoading) {
					this.removeChild(this.m_loading);
					this.m_isLoading=false;
				}
				//下面是网页内部业务逻辑
				this.showModule(p_e.loaderInfo.content  as  IModule);
				this.m_moduleList.shift();
			}
		}
		private function onProgress(p_e:ProgressEvent):void {
			this.m_loading.update(p_e.bytesLoaded,p_e.bytesTotal);
		}
		private function onError(p_e:Event):void {
			var s:String=this.m_libList.length > 0?this.m_libList[0]:this.m_moduleList[0];
			trace("加载" + s + "失败");
		}
	}
}