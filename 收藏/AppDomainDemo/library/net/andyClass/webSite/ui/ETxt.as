package net.andyClass.webSite.ui
{
	import fl.controls.TextInput;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 输入文本
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.0.070601
	 */	
	public class ETxt extends TextInput
	{
		/**
		 * 构造函数
		 * 
		 * @param p_txt	默认文本
		 */		
		public function ETxt(p_txt : String = "")
		{
			super();
			this.text = p_txt;
			this.addEventListener(MouseEvent.CLICK, this.onClick);
			this.x = 35;
			this.y = 50;
		}
		/**
		 * @private
		 * 选中所有文字
		 */		
		private function onClick(p_e : Event) : void
		{
			this.setSelection(0, this.length);
		}
	}
}