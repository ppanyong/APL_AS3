package com.ChangNing.Module {
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import com.FSF.Module.IModule;	
	import com.FSC.UI.InterActiveObject.NavTweenButtonBarClass.INavTweenButtonBar;	
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
	public class ChangNingShell extends ShellBase {
		public var main_frame_mc:MovieClip;//背景MC
		public var data_text:TextField;//显示日期
		private var tmpNavBar:DisplayObject;//主导航
		public var myClock:Clock;//显示时钟
		public var maskMc:MovieClip;//加载模块的过度效果
		
		public function ChangNingShell() {
			super();
		}
		/**
		 * 显示下载进度条
		 */
		protected override function ShowLoadingUI() : void {
			if(loading!=null){
				var tmp : DisplayObject =(loading as DisplayObject); 
				tmp.visible = true;
				tmp.x=405;
				tmp.y=223;
				this.maskMc.visible = false;
			}
		}
	
		/**
		 * 覆盖 主菜单显示
		 * @param p 主菜单
		 */
		protected override function MainNavShow(p:INavTweenButtonBar):void{			
			tmpNavBar =  p as DisplayObject;
			tmpNavBar.visible=false;
			tmpNavBar.x = 25.1;
			tmpNavBar.y = 81;
			this.setChildIndex(tmpNavBar, this.numChildren-1);
			p.PreSelectedNavTagName="home";
		}
		/**
		 * 显示导航 该方法是在时间轴上被调用的
		 */
		private function ShowNavBar():void{
			if(tmpNavBar!=null){
				tmpNavBar.visible = true;
				this.maskMc.gotoAndPlay(2);
				this.setChildIndex(tmpNavBar, (this.numChildren-1));
			}else{
				trace("mainNav未加载好 等待1秒后再尝试执行");
				var time : Timer = new Timer(1000,0);
				time.start();
				time.addEventListener(TimerEvent.TIMER, TimerEventHandler);
			}
		}
		/**
		 * 延迟出发函数
		 */
		private function TimerEventHandler(e:TimerEvent):void{
			var time:Timer = e.target as Timer;
			time.stop();
			ShowNavBar();
		}
		/**
		 * 显示模块样式 统一定义模块加载的效果
		 * @param p_module 模块
		 */
		protected override function ShowModuleCss(p_module:IModule):void
		{
			p_module.show(this);
			var tmpDisPlay:DisplayObject = (p_module as DisplayObject);
			tmpDisPlay.x=25.6;
			tmpDisPlay.y=112.4;
			tmpDisPlay.mask = this.maskMc;
			if(tmpNavBar!=null&& tmpNavBar.visible == true)
				this.maskMc.gotoAndPlay(2);
		}
	}
}
