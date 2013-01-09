package net.andyClass.webSite
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 登录模型
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class LoginModule extends ModuleBase implements IModule
	{
		private var m_nameTxt : Object;
		private var m_loginBtn : Object;
		/**
		 * 构造函数
		 */		
		public function LoginModule()
		{
			super();
		}
		/**
		 * 初始化用户界面
		 * 
		 * @param p_libClass	库类
		 * @param p_rest		其它参数
		 */		
		override protected function initUi(p_libClass : Class, p_rest : Array = null) : void
		{
			this.addUi(this.getClass(p_libClass.BG_NAME), "登录");
			this.m_nameTxt = this.addUi(this.getClass(p_libClass.TXT_NAME), "guest");
			this.m_loginBtn = this.addUi(this.getClass(p_libClass.BTN_NAME), "login");
			this.m_loginBtn.addEventListener(MouseEvent.CLICK, this.onLogin);
		}
		
		private function onLogin(p_e : MouseEvent) : void
		{
			this.m_loginBtn.removeEventListener(MouseEvent.CLICK, this.onLogin);
			this.dispatchEvent(new LoginEvent("login", this.m_nameTxt.text));
		}
	}
}