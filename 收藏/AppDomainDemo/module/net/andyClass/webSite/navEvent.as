package net.andyClass.webSite
{
	import flash.events.Event;
	
	/**
	 * 加载事件
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class navEvent extends Event
	{
		public static var ONNAVCLICK : String = "onNavClick";
		public var navInfo:String="";
		
		/**
		 * 构造函数
		 * 
		 * @param p_type	事件类型
		 * @param p_info	加载对象的LoaderInfo
		 */		
		public function navEvent(p_type : String, nav_info:String)
		{
			super(p_type,true);
			this.navInfo = nav_info;
		}
	}
}