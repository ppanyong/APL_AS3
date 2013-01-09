package net.andyClass.net
{
	import flash.events.Event;
	import flash.display.LoaderInfo;
	
	/**
	 * 加载事件
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class LoadEvent extends Event
	{
		public static var COMPLETE : String = "complete";
		
		public var loaderInfo : LoaderInfo;
		
		/**
		 * 构造函数
		 * 
		 * @param p_type	事件类型
		 * @param p_info	加载对象的LoaderInfo
		 */		
		public function LoadEvent(p_type : String, p_info : LoaderInfo)
		{
			super(p_type);
			this.loaderInfo = p_info;
		}
	}
}