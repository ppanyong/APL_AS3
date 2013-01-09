package net.andyClass.webSite{
	import flash.display.MovieClip;
	import flash.events.*;
	import net.andyClass.webSite.ui.navItem;
	import net.andyClass.webSite.navEvent;
	/**
	 * 库
	 * 
	 * @date070601
	 * @version1.0.070601
	 */
	public class mainNav extends ModuleBase implements IModule {
		/**
		 * 构造函数
		 */
		public function mainNav() {
			super();
			//初始化各菜单按钮
			//采用直接在界面上进行修改的方式
			var nav1:navItem = new navItem(bg_mc,title_mc);
			nav1.Trigger =  true;
			nav1.OnClick = onNav1Click;
			var nav2:navItem = new navItem(bg2_mc,title2_mc);
			nav2.Trigger =  true;
			nav2.OnClick = function (e:MouseEvent){
			nav2.refresh();
			};
		}
		function onNav1Click(e:MouseEvent) {
			trace("dispatchEvent");
			trace(this);
			this.dispatchEvent(new navEvent(navEvent.ONNAVCLICK,"nav1"));
		}

	}
}