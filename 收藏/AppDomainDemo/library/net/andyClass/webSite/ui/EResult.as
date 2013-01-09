package net.andyClass.webSite.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 测试结果
	 * 
	 * @author	eidiot (http://eidiot.net)
	 * @date	070601
	 * @version	1.1.070602
	 */
	public class EResult extends Sprite
	{
		public var resultTxt : TextField;
		
		/**
		 * 构造函数
		 * 
		 * @param p_name	用户名
		 */		
		public function EResult(p_name : String)
		{
			super();
			this.y = 40;
			this.resultTxt.htmlText = "Thx, " + p_name + "\n\n";
			this.resultTxt.htmlText += "From\n";
			this.resultTxt.htmlText += "<a href='http://eidiot.net'>http://eidiot.net</a>";
		}
	}
}