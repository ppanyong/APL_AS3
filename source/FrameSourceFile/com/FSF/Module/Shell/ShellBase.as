package com.FSF.Module.Shell {
	import com.FSF.Model.Nav.NavItem;	
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.INavTweenButtonBar;	
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.NavTweenButtonBarBase;	
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.NavTweenButtonBarEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.*;
	import com.FSF.Module.*;
	import com.FSF.Module.ModuleBase;
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadingUI.*;
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.SWFLoader.*;
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine.*;
	import com.FSF.Lib.*;
	
	/**
	 * 主程序 原型
	 * 
	 * @authorpan
	 * @date080428
	 * 继承自ModuleBase的子类 利用了父类的队列加载 
	 * 利用 libList和moduleList将 事件的响应范围控制在ShellBase层面上
	 * 例如，加载的模块如果利用到了loadfile 则shell则不会响应队列的事件消息。
	 * @version1.0.080519
	 */
	public class ShellBase extends ModuleBase implements IModule
	{
		private var libList:Array;//存储库文件列表
		private var moduleList:Array = new Array();//存储加载的模块列表
		private var selectedNavItem : NavItem;//存储选中的参数信息
		protected var loading:ILoadingUI;//显示的类元件实例 需要在舞台上定义		
		/**
		 * Config文件路径 可覆盖定义
		 */
		protected var shellConfigXmlPath:String="config/config.xml";//配置文件相对路径 
		/**
		 * Shell中放置加载进来的模块的容器 使用接口
		 */
		protected var moduleShowContent:IModule;
		/**
		 * 构造函数
		 */
		public function ShellBase() {
			this.init();
		}
		/**
		 * 装配下载进度条显示元件类 要实现ILoadingUI
		 */
		protected function GetLoadUI():ILoadingUI{
			return new LoadingProgressUI(this);
		}
		/**
		 * 1. 初始化 使用队列的下载逻辑
		 * 2. 加载Config文件 
		 */
		private function init():void {
			this.libList= new Array();
			this.loading= GetLoadUI();
			this.addChild(loading as DisplayObject);
			LoadConfig(shellConfigXmlPath);
			ShowLoadingUI();
		}
		/**
		 * **********************加载Config*****************************
		 */
		 
		/**
		 * 加载config 
		 * @path config文档路径
		 */
		private function LoadConfig(path:String):void{
			var xmlLoader:URLLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,ConfigXmlLoadedHandler);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,ConfigXmlIoErrorHandler);
			xmlLoader.load(new URLRequest(path));
		}
		/**
		 * 加载config出错处理
		 * @param event IOErrorEvent
		 */
		private function ConfigXmlIoErrorHandler(event:IOErrorEvent):void {
			trace("warning:"+shellConfigXmlPath+"配置文件读取失败！: " + event);
		}
		/**
		 * 加载config完成，分配个配置参数到参数变量
		 * @param event Event
		 */
		private function ConfigXmlLoadedHandler(event:Event):void {
			var xml:XML=XML(event.target.data);
			if(xml==null) return;
			for (var i:int=0; i < xml.lib.item.length(); i++) {
				libList.push(xml.lib.item[i].toString());
				this.loadFile(new URLRequest(xml.lib.item[i]));
			}
		}
		/**
		 * ************************加载Config结束***************************
		 */
		
		/**
		 * 绘制主导航
		 * @param m_loader 队列中下载Lib库的下载器对象
		 */
		private function BulidMainNav(m_loader:SWFLoader):void{
			var mainNav:INavTweenButtonBar = GetNavBarClassFromLibByClassName(m_loader);
			//加载导航事件
			mainNav.addEventListener(NavTweenButtonBarEvent.NavClick,NavClickHandler);
			this.MainNavShow(mainNav as NavTweenButtonBarBase);
		}
		/**
		 * 主导航的表现形式 实际使用中覆盖
		 * @param iNavBar 主导航对象接口
		 */
		protected function MainNavShow(iNavBar:INavTweenButtonBar):void{
			var tmp:DisplayObject = iNavBar as DisplayObject;
			tmp.x=0;
			tmp.y=0;
			//p.PreSelectedNavTagName="home";
		}
		
		/**
		 * 通过类名在类库中返回符合接口的导航实例
		 * 可扩展替换
		 * @param m_loader Lib库的下载器
		 * @return NavTweenButtonBarBase 导航基类
		 */
		protected function GetNavBarClassFromLibByClassName(m_loader:SWFLoader):INavTweenButtonBar{
			var tmp:INavTweenButtonBar = this.addUi(m_loader.GetClass(Libaray.NavTweenButtonBar_NAME),"data/nav.xml") as INavTweenButtonBar;
			return tmp;
		}
		
		/**
		 * 导航点击处理函数
		 * @param e NavTweenButtonBarEvent
		 */
		private function NavClickHandler(e:NavTweenButtonBarEvent):void{
			if(moduleShowContent!=null){
					HideModuleCss(moduleShowContent);	
					moduleShowContent.dispose();	
			}
			ShowLoadingUI();
			NavDo(e.navDataXML);
		}
		/**
		 * 执行导航
		 * @param xml 点击导航后返回的导航XML数据 可通过GetNavItemByXML转换为NavItem
 		*/
		private function NavDo(xml:XML):void{
			selectedNavItem = GetNavItemByXML(xml);
			if(selectedNavItem.Swf!=null){
				var tmpUrl:URLRequest = selectedNavItem.Swf;
				this.moduleList.push(tmpUrl.url);
				trace("导航加载！");
				this.loadFile(tmpUrl);
			}
		}
		
		/**
		 * XML转换成NavItem
		 *@param xml
		 *@return NavItem实例
		 */
		protected function GetNavItemByXML(xml:XML):NavItem{
			var tmpNavItem:NavItem = new NavItem(xml);  
			return tmpNavItem;
		} 
		
		/**
		 * 加载事件完成 库文件和模块文件加载都在这里进行响应
		 * @param p_e LoadLineEvent加载队列事件
		 */
		protected override function CompleteSuccessHandler(p_e:LoadLineEvent):void {
			if(libList.length>0){
				trace("下载类库下载完成");
				libList.splice(libList.indexOf(p_e.currentTragetURL),1);
				//如果库加载完成 则生成导航栏
				if(libList.length==0){
					BulidMainNav(p_e.content as SWFLoader);
				}
			}else{
				//下载指定模块
				if(this.moduleList!=null){
					var tmpInt:int = this.moduleList.indexOf(p_e.currentTragetURL.url);
					if( tmpInt>= 0){
						trace("下载指定模块完成 模块地址是" + p_e.currentTragetURL.url);
						moduleList.splice(tmpInt,1);
						var tmpLoaderSwf:SWFLoader = p_e.content as SWFLoader;
						HideLoadingUI();
						this.ShowModule(tmpLoaderSwf.content  as  IModule);
					}
				}
			}
		}
		/**
		 * 显示已经加载的模块
		 * @param p_module 加载的模块对象
		 */
		private function ShowModule(p_module:IModule):void {
			if(p_module!=null){
				moduleShowContent = p_module;
				p_module.MyNavItem = selectedNavItem;
				ShowModuleCss(p_module);
			}
		}
			
		/**
		 * 模块对象的具体显示方式
		 * @param p_module 加载的模块对象
		 */
		protected function ShowModuleCss(p_module:IModule):void
		{
		}
		/**
		 * 模块对象的具体推出显示方式
		 * @param p_module 加载的模块对象
		 */
		protected function HideModuleCss(p_module:IModule):void
		{
		}
		
		/**
		 * 处理加载过程 c
		 */
		protected override function ProgressHandler(p_e:LoadLineProgressEvent):void {
			this.setChildIndex((loading as DisplayObject),this.numChildren-1);
			(loading as DisplayObject).visible = true;
			this.loading.setTarget(p_e.currentTragetURL.url);
			this.loading.update(p_e.bytesLoaded,p_e.bytesTotal);
		}
		/**
		 * 隐藏下载进度条
		 */
		protected function HideLoadingUI() : void {
			if(loading!=null){
				(loading as DisplayObject).visible = false;
			}
		}

		/**
		 * 显示下载进度条
		 */
		protected function ShowLoadingUI() : void {
			if(loading!=null){
				(loading as DisplayObject).visible = true;
			}
		}
	}
}