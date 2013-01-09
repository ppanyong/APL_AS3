package com.apl.components.map.model {
	import flash.display.MovieClip;	
	import flash.display.DisplayObject;	
	
	/**
	 * @author andypan
	 */
	public interface IMapItem {
		function get title() : String ;
		
		function set title(title : String) : void ;
		
		function get value() : String ;
		
		function set value(value : String) : void ;
		
		function get id():String ;
		function set id(n:String):void ;

		//function getChildAt(i:Number):DisplayObject;
		function prase(xml:XML):void;
		
		 function get itemmc() : MovieClip 
		
		function set itemmc(itemmc : MovieClip) : void
	}
}
