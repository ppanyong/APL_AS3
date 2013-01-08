package com.FSC.UI.InterActiveObject.NavTweenButtonBar
{
	import com.FSC.UI.InterActiveObject.NavTweenButton.*;
	public interface INavTweenButtonBar
	{
		function bulidMenu();
		function getInstance();
		function XMLtoNavTweenButton(xml:XML):INavTweenButton;
	}
}