package com.ChangNing.UI.InterActiveObject {
	import com.FSC.UI.InterActiveObject.NavTweenButtonClass.NavTweenButton;
	import flash.display.DisplayObject;
	import com.FSC.UI.InterActiveObject.NavTweenButtonClass.INavTweenButton;	

	/**
	 * 未长宁多媒体扩展的导航按钮
	 * @author Andy
	 */
	public class ChangNingNavTweenButton extends NavTweenButton implements INavTweenButton {
		public function ChangNingNavTweenButton() {
			super();
			
		}
		override public function SetWidth():void{
			//默认状态
			if(this.Title!=null){
				title_txt.width = title_txt.textWidth*1.1;
			}
		}
		
		
	}
}
