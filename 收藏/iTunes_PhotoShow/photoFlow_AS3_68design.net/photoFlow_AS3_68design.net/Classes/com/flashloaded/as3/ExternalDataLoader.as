/*
author:Ng Cheng How
description: load data from xml, inspector, frame, to prepare items data for selection system.

*/

package com.flashloaded.as3{
	
	import com.flashloaded.as3.Component;
	import com.flashloaded.as3.Collection;
	import flash.system.LoaderContext;	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class ExternalDataLoader extends Component{
		
		private var loader:URLLoader;
		
		protected var inspectorData:Collection; //coll from inspector
		public var listItems:Collection;  //coll of all items data
		protected var items:Collection;  //coll of items
		
		protected var _xmlURL:String;		
		
		
		public function ExternalDataLoader(){
			
		}
		
		public function loadXML(url:String):void{
			if(url!="" && url!=null){
				
				loader=new URLLoader();
				loader.addEventListener(Event.COMPLETE,xmlLoaded);
				
				loader.addEventListener(IOErrorEvent.IO_ERROR,xmlError);
				var lc:LoaderContext = new LoaderContext(true);
				
				var request:URLRequest=new URLRequest(url);
				loader.load(request);
				trace("------")
			}
								 
		}
		
		protected function xmlError(e:IOErrorEvent):void{
			//override
		}
		
		protected function loadFromInspector():void{
			if(inspectorData!=null){
				listItems.addItems(inspectorData.toArray());
			}
		}
		
		//event handler for xml loaded.
		protected function xmlLoaded(evt:Event):void{
			trace("xmlLoaded")
			var xml:XML = new XML(loader.data);
			if(listItems==null) listItems = new Collection();
			//trace(xml)
			listItems.addItems(xml);
			
		}
		//event handler for xml loaded.
		public function xmlLoadedpublic(data:String=""):void{
			loader=new URLLoader();
			loader.data = data;
			_xmlURL = "";
			trace("insxmlLoadedpublicert")
			var xml:XML=new XML(data);
			if(listItems==null) listItems = new Collection();
			trace("listItems.addItems(xml);")
			listItems.addItems(xml);
			
		}
		
		//params//
		
		[Inspectable(category="a_comp",type=String,defaultValue="")]
		public function get xmlURL():String{
			return _xmlURL;
		}
		public function set xmlURL(url:String):void{
			_xmlURL=url;
		}
		
		
		
		//////
		
	}
}