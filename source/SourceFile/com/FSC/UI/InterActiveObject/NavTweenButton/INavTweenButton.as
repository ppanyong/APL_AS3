package com.FSC.UI.InterActiveObject.NavTweenButton
{
	import com.FSC.UI.InterActiveObject.TweenButton.ITweenButton;

	public interface INavTweenButton extends ITweenButton
	{
		function set NavTreeXML(v:XML):void;
		function get NavTreeXML():XML;
	}
}