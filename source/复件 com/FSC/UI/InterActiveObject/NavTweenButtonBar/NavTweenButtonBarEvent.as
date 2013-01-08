package com.FSC.UI.InterActiveObject.NavTweenButtonBar
{
	import flash.events.Event;

	public class NavTweenButtonBarEvent extends Event
	{
		public static var NavClick : String = "navClick";
		public var menuTreeXML:XML;
		
		public function NavTweenButtonBarEvent(p_type : String, menuTreeXML : XML)
		{
			super(p_type,true);
			this.menuTreeXML = menuTreeXML;
		}
		
	}
}