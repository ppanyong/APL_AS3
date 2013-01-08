package com.FSC.UI.InterActiveObject.NavTweenButtonBar
{
	import flash.events.Event;

	public class NavTweenButtonBarEvent extends Event
	{
		public static var NavClick : String = "navClick";
		public var navDataXML:XML;
		
		public function NavTweenButtonBarEvent(p_type : String, navDataXML : XML)
		{
			super(p_type,true);
			this.navDataXML = navDataXML;
		}
		
	}
}