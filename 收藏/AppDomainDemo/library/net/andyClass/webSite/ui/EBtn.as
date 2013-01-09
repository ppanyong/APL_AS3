package net.andyClass.webSite.ui
{
	import fl.controls.Button;
	
	/**
	 * 按钮
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class EBtn extends Button
	{
		/**
		 * 构造函数
		 * 
		 * @param p_label	按钮文字
		 */		
		public function EBtn(p_label : String = "label")
		{
			super();
			this.label = p_label;
			this.x = 35;
			this.y = 80
		}
	}
}