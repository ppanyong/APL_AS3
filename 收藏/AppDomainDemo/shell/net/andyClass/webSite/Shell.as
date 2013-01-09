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
	 * 主程序
	 * 
	 * @authorpan
	 * @date080428
	 * @version1.0.080428
	 */
	public class Shell extends ShellBase {
		//****************
		//业务变量 可作为程序全局变量
		//****************
		private var m_userName:String;
		/**
		 * 构造函数
		 */
		public function Shell() {
			super();
		}
		
		override protected  function showModule(p_module:IModule):void {
			//下面是网页内部业务逻辑
			/*if (this.m_moduleList[0] == "login.swf") {
				p_module.show(this);
				p_module.addEventListener("login",this.onLogin);
			} else {
				p_module.show(this,this.m_userName);
			}*/
		}
		
		private function onLogin(p_e:Object):void {
			this.m_userName=p_e.userName;
			var login:IModule=p_e.currentTarget;
			login.removeEventListener("login",this.onLogin);
			login.dispose();
			this.loadSwf();
		}
	}
}