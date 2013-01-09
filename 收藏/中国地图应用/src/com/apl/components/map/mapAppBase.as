package com.apl.components.map {
	import com.apl.components.map.model.MapItemBase;	
	import com.apl.components.map.model.IMapItem;	
	import com.apl.components.map.event.MapEvent;	
	
	import flash.events.Event;	
	
	import com.apl.components.map.model.MapModel;	
	import com.apl.components.map.view.ChinaMap;	
	
	import flash.display.MovieClip;
	
	/**
	 * @author andypan
	 * 合并调用逻辑
	 */
	public class mapAppBase extends MovieClip {
		public var mapview:ChinaMap = new ChinaMap();
		public var mapmodel:MapModel;
		public function mapAppBase() {
			this.mapmodel = new 	MapModel();
			this.mapmodel.dataURL = "data/d.xml";
			this.addEventListener(Event.ADDED_TO_STAGE, onaddstage)
		}
		
		private function onaddstage(e:Event) : void {
			
			this.mapmodel.modelClass= setModelClass();
			this.mapmodel.addEventListener(Event.COMPLETE, onDataLoadedHandler);
			this.mapmodel.loadData();
		}
		public function setModelClass():Class{
			return MapItemBase;
		}

		/**
		 * 
		 */
		private function onDataLoadedHandler(e:Event) : void {
			createMap()		
		}
		private function createMap(){
		
			this.addChild(this.mapview)
			initMapView()
		}
		
		public function initMapView() : void {
			this.mapview.addEventListener(MapEvent.ITEMCLICK, onMapAreaClick);
			this.mapview.addEventListener(MapEvent.ITEMOUT, onMapAreaOut);
			this.mapview.addEventListener(MapEvent.ITEMOVER, onMapAreaOver);
		}
		
		private function onMapAreaOver(e:MapEvent) : void {
			if(tmp!=null){
			var tmp:IMapItem = this.mapmodel.getAreaDataById(e.MC.name);
			onMapAreaOverHandler(tmp);
			}
		}
		
		private function onMapAreaOverHandler(tmp : IMapItem) : void {
		}

		private function onMapAreaOut(e:MapEvent) : void {
			if(tmp!=null){
			var tmp:IMapItem = this.mapmodel.getAreaDataById(e.MC.name);
			onMapAreaOutHandler(tmp);
			}
		}
		
		private function onMapAreaOutHandler(tmp : IMapItem) : void {
		}

		private function onMapAreaClick(e:MapEvent) : void {
			var tmp:IMapItem = this.mapmodel.getAreaDataById(e.MC.name);
			if(tmp!=null){
				tmp.itemmc = e.MC;
				onMapAreaClickHandler(tmp);
			}
		}
		
		public function onMapAreaClickHandler(tmp : IMapItem) : void {
			
		}
	}
}
