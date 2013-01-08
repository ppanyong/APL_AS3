package com.FSC.UI.InterActiveObject.NavTweenButtonClass
{
	import com.FSC.UI.InterActiveObject.TweenButtonClass.ITweenButton;

	public interface INavTweenButton extends ITweenButton
	{
		function set NavTreeXML(v:XML):void;
		function get NavTreeXML():XML;
	}
}