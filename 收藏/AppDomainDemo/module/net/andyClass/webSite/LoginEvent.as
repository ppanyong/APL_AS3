package net.andyClass.webSite
{
	import flash.events.Event;
	/**
	 * 模型事件
	 * 
	 */	
	public class LoginEvent extends Event
	{
		public var userName : String;
		
		/**
		 * 构造函数
		 * 
		 * @param p_type	事件类型
		 * @param p_name	用户名
		 */	
		public function LoginEvent(p_type : String, p_name : String)
		{
			super(p_type);
			this.userName = p_name;
		}
	}
}