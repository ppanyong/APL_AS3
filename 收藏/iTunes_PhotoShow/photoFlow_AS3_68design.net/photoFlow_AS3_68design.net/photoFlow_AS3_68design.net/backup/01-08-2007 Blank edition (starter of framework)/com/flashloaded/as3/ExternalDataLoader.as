/*
author:Ng Cheng How
description: load data from xml, inspector, frame, to prepare items data for selection system.

*/

package com.flashloaded.as3{
	
	import com.flashloaded.as3.Component;
	import com.flashloaded.as3.Collection;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	
	public class ExternalDataLoader extends Component{
		
		private var loader:URLLoader;
		
		protected var inspectorData:Collection; //coll from inspector
		protected var listItems:Collection;  //coll of all items data
		protected var items:Collection;  //coll of items
		
		protected var _xmlURL:String;		
		
		
		public function ExternalDataLoader(){
			
		}
		
		public function loadXML(url:String):void{
			if(url!="" && url!=null){
				
				loader=new URLLoader();
				loader.addEventListener(Event.COMPLETE,xmlLoaded);
				
				var request:URLRequest=new URLRequest(url);
				loader.load(request);
			}
								 
		}
		
		protected function loadFromInspector():void{
			if(inspectorData!=null){
				listItems.addItems(inspectorData.toArray());
			}
		}
		
		//event handler for xml loaded.
		protected function xmlLoaded(evt:Event):void{
			
			var xml:XML=new XML(loader.data);
			listItems.addItems(xml);
			
		}
		
		//params//
		
		[Inspectable(type=String,defaultValue="")]
		public function get xmlURL():String{
			return _xmlURL;
		}
		public function set xmlURL(url:String):void{
			_xmlURL=url;
		}
		
		
		
		//////
		
	}
}