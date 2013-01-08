package com.FSF.Module.Shell
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.*;
	import com.FSF.Module.*;
	import com.FSF.Module.ModuleBase;
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadingUI.*;
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.SWFLoader.*;
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine.*;
	import com.FSF.Lib.*;
	import com.FSC.UI.InterActiveObject.NavTweenButtonBar.*;
	import flash.text.AntiAliasType;
	
	/**
	 * 主程序 原型
	 * 
	 * @authorpan
	 * @date080428
	 * @version1.0.080428
	 */
	public class ShellBase extends ModuleBase 
	{
		private var m_loader:SWFLoader;//已经增加了超时属性 c
		private var m_libList:Array;//存储库文件列表 m
		private var m_SwfLoaderList:SWFLoaderLine;//采用队列机制 m
		private var m_loading:ILoadingUI;//显示的类元件实例 需要在舞台上定义 该类应该可以摆在lib中但是怕下载延时大。 v
		private var m_isLoading:Boolean=false;//是否在加载的标志 c
		private var m_shellConfigXmlPath="config/config.xml";//配置文件相对路径 m
		/**装配需要的类 c 
		 * --允许继承重写
		 */
		protected function getLoadUI(){
			//return new LoadingUI(this);
			return new LoadingProgressUI(this);
		}
		/**
		 * 构造函数
		 */
		public function ShellBase() {
			this.init();
		}
		/**
		 * 初始化 这是使用队列的下载逻辑 c
		 */
		private function init():void {
			this.m_libList= new Array();
			m_SwfLoaderList = SWFLoaderLine.getInstance();
			m_SwfLoaderList.addEventListener(LoadLineEvent.ONLOADLINECOMPLETE,onComplete);
			m_SwfLoaderList.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loadConfig(m_shellConfigXmlPath)
		}
		/**
		 * 加载config c
		 * @path config文档路径
		 */
		private function loadConfig(path){
			var xmlLoader:URLLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,configXmlLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,configXmlIoErrorHandler);
			xmlLoader.load(new URLRequest(path));
		}
		/**
		 * 加载config出错处理 c
		 */
		private function configXmlIoErrorHandler(event:IOErrorEvent):void {
			trace("warning:"+m_shellConfigXmlPath+"配置文件读取失败！: " + event);
		}
		/**
		 * 当配置文件读取完成，分配个配置参数到参数变量 c
		 */
		private function configXmlLoaded(event:Event):void {
			var xml:XML=XML(event.target.data);
			//填充2个数组 作为加载文件的文件列表
			for (var i:int=0; i < xml.lib.item.length(); i++) {
				m_libList.push(xml.lib.item[i].toString());
				m_SwfLoaderList.loadFile(new URLRequest(xml.lib.item[i]));
			}
			this.m_loading= getLoadUI();
			this.addChild(m_loading as DisplayObject);
		}
		/**
		 * 显示模块的逻辑 c
		 *  --允许继承重写
		 */
		protected function showModule(p_module:IModule):void {
			p_module.show(this);
		}
		
		/**
		 * 初始化导航，具体的定义根据导航类的bulidMenu m c
		 * 也可以将这个导航作为单独的Module加载后再处理 
		 * 可重构出去由外部处理表现形式
		 */
		private function bulidMainNav(m_loader:SWFLoader){
			var mainNav:NavTweenButtonBar = this.addUi(m_loader.getClass(Libaray.NavTweenButtonBar_NAME),"data/nav.xml") as NavTweenButtonBar;
			mainNav.addEventListener(NavTweenButtonBarEvent.NavClick,onNavClickHandler);
			this.mainNavShow(mainNav as DisplayObject);
		}
		/**
		 * 主导航的表现形式 v
		 * @param p 显示对象
		 */
		protected function mainNavShow(p:DisplayObject){
			p.x=0;
			p.y=0;
		}
		/**
		 * 导航点击处理函数 c
		 */
		private function onNavClickHandler(e:NavTweenButtonBarEvent){
			navByXml(e.menuTreeXML);
		}
		/**
		 * 根据xml参数导航 c
		 * <navItem tag="contact" isMain="true" printable="true" email="true" printWidth="650">
			  <descrip><![CDATA[ 联系我们  ]]></descrip>
			  <display><![CDATA[联系我们]]></display>
			  <headline><![CDATA[如果您有任何疑问或想知道更多的资料，请联系:]]></headline>
			  <emailName><![CDATA[Reuters press page]]></emailName>
			  <swf>contact.swf</swf>
			  <data>contact.xml</data>
			</navItem>
			 *  --允许继承重写
 		*/
		protected function navByXml(_xml:XML){
			var tmpXml:XML = _xml;
			//trace(tmpXml.swf)
			if(tmpXml.swf!=""){
				m_SwfLoaderList.loadFile(new URLRequest(tmpXml.swf));
			}
		}
		
		/**
		 * 加载模块完成 c
		 */
		private function onComplete(p_e:LoadLineEvent):void {
			//从库列表中剔除已经下载的项目
			trace(p_e.isSuccess)
			if(p_e.isSuccess){
				(m_loading as DisplayObject).visible = false;
				if(m_libList.length>0){
					m_libList.splice(m_libList.indexOf(p_e.currentTragetURL),1);
					//如果库为空则先生成导航栏
					if(m_libList.length==0){
						bulidMainNav(p_e.content as SWFLoader);
					}
				}else{
					//下载指定模块
					var tmpLoaderSwf:SWFLoader = p_e.content as SWFLoader;
					this.showModule(tmpLoaderSwf.content  as  IModule);
				}
			}else{
				trace("加载" + p_e.currentTragetURL + "失败");
			}
		}
		
		/**
		 * 处理加载过程 c
		 */
		private function onProgress(p_e:LoadLineProgressEvent):void {
			(m_loading as DisplayObject).visible = true;
			this.m_loading.setTarget(p_e.currentTragetURL.url);
			this.m_loading.update(p_e.bytesLoaded,p_e.bytesTotal);
		}
	}
}