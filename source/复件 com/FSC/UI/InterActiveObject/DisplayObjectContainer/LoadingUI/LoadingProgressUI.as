package com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadingUI
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class LoadingProgressUI extends LoadingUI
	{
		public var bar:MovieClip;
		
		public function LoadingProgressUI(p_parent:DisplayObjectContainer)
		{
			super(p_parent);
		}
		
		override public function update(p_loaded : Number, p_total : Number) : void{
			bar.scaleX = (p_loaded/p_total);
		}
		
	}
}