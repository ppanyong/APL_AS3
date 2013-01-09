package com.flashloaded.as3{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.display.LoaderInfo;
	
	public interface IImager extends IEventDispatcher{
		function create():DisplayObject;
		function getContentLoaderInfo():LoaderInfo;
	}
	
}