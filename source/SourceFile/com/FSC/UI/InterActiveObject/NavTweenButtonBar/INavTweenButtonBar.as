package com.FSC.UI.InterActiveObject.NavTweenButtonBar {
	import flash.display.DisplayObject;	
	
	import com.FSC.UI.InterActiveObject.NavTweenButton.*;
	public interface INavTweenButtonBar
	{
		function SetEveryNavButtonCSS(displayObject:DisplayObject):void;
		function GetInstance():INavTweenButton;
		function XMLtoNavTweenButton(xml:XML):INavTweenButton;
	}
}