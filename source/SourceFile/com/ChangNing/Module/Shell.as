package com.ChangNing.Module {
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.INavTweenButtonBar;	
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.NavTweenButtonBarBase;	
	import com.FSC.UI.DateUI.Clock;	
	
	import flash.display.DisplayObject;	
	import flash.text.TextField;	
	import flash.display.MovieClip;	
	
	import com.FSF.Module.Shell.ShellBase;
	
	/**
	 * 长宁多媒体网站
	 * 主程序
	 * @author Andy
	 * @version 1.080515
	 */
	public class Shell extends ShellBase {
		public var main_frame_mc:MovieClip;
		public var data_text:TextField;
		private var tmpNavBar:DisplayObject;
		public var myClock:Clock;
		
		//要求增加效果动画
		public function Shell() {
			super();
		}
	
		protected override function MainNavShow(p:INavTweenButtonBar):void{			
			tmpNavBar =  p as DisplayObject;
			tmpNavBar.visible=false;
			tmpNavBar.x = 25.1;
			tmpNavBar.y = 81;
			p.PreSelectedNavTagName="home";
		}
		private function ShowNavBar():void{
			tmpNavBar.visible = true;
			this.setChildIndex(tmpNavBar, (this.numChildren-1));
			
		}
	}
}
