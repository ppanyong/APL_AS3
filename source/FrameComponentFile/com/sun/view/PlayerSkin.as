package com.sun.view
{
	//播放器皮肤的超类,主要用于调整控制条的位置
	import flash.display.Sprite;
	public class PlayerSkin extends Sprite
	{
		private var _skin:String;
		public function PlayerSkin(skin:String = "QQ 视频播放器皮肤");
		{
			_skin = skin;
		}
		public function controlBarAdjust(w:Number,h:Number):void
		{
			//由子类覆盖重写
		}
	}
}