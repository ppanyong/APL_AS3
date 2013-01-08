package com.ChangNing.UI.InterActiveObject {
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.INavTweenButtonBar;	
	
	import flash.display.DisplayObject;	
	
	import com.FSC.UI.InterActiveObject.NavTweenButtonClass.INavTweenButton;	
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.NavTweenButtonBarBase;
	
	/**
	 * @author Andy
	 */
	public class ChangNingNavTweenButtonBar extends NavTweenButtonBarBase implements INavTweenButtonBar {
		public function ChangNingNavTweenButtonBar(dataXml : String) {
			super(dataXml);
		}
		override public function GetInstance():INavTweenButton{
			return new ChangNingNavTweenButton();
		}
		 /**
		 * 绘制菜单 定义了菜单的排列形式
		 */
		override public function  SetEveryNavButtonCSS(displayObject:DisplayObject):void{
			if(displayObject.x>0){
				displayObject.x =displayObject.x-5;
			}
		}
	}
}
