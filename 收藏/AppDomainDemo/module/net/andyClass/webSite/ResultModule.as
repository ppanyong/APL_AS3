package net.andyClass.webSite
{
	/**
	 * 测试模型
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class ResultModule extends ModuleBase implements IModule
	{
		/**
		 * 构造函数
		 */		
		public function ResultModule()
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
			this.addUi(this.getClass(p_libClass.BG_NAME), "结果");
			var resultFunc : Function = p_libClass.getResult;
			var userName : String = p_rest[0];
			this.addChild(resultFunc(userName));
		}
	}
}