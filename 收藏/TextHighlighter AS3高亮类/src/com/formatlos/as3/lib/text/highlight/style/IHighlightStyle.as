package com.formatlos.as3.lib.text.highlight.style {	import flash.display.Sprite;	import flash.geom.Rectangle;			/**	 * @author Martin Raedlinger (mr@formatlos.de)	 */	public interface IHighlightStyle 	{		function create(target_:Sprite, rect_:Rectangle) : void;				function clear(target_:Sprite) : void;		}}