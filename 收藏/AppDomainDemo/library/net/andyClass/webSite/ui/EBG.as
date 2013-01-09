package net.andyClass.webSite.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * 模型背景
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */
	public class EBG extends Sprite
	{
		public var titleTxt : TextField;
		
		/**
		 * 构造函数
		 * 
		 * @param p_title	标题
		 */		
		public function EBG(p_title : String = "模型")
		{
			super();
			this.titleTxt.text = p_title;
			this.x = this.y = 10;
		}
	}
}