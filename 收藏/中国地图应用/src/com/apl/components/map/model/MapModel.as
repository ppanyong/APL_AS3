package com.apl.components.map.model {
	import flash.net.URLRequest;	
	import flash.events.Event;	
	import flash.net.URLLoader;	
	
	import com.apl.util.Collection;
	
	/**
	 * @author andypan
	 * 地图数据
	 */
	public class MapModel extends Collection {
		private  var _dataURL:String ="data/d.xml";
		private var _modelClass:Class = MapItemBase;
		
		private var xmldata:XML;
		public function MapModel(_data : Object = null) {
			super(_data);
			//init();
		}
		public function loadData():void{
			init();
		}
		private function init():void{
			var ldr:URLLoader = new URLLoader()
			ldr.addEventListener(Event.COMPLETE, ondataoverhandler);
			ldr.load(new URLRequest(dataURL));
		}
		
		private function ondataoverhandler(e:Event) : void {
			xmldata = new XML(e.target.data);
			prasedata(xmldata)
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function prasedata(xmldata : XML) : void {
			for each(var node:XML in xmldata.area){
				var tmp_area:IMapItem = praseDataEach(node);
				this.addItem(tmp_area);
			}
		}
		/**
		 * 填充单个对象
		 */
		private function praseDataEach(node : XML) : IMapItem {
			//<area id="beijing" title="北京" value="" url="test.html" target="_blank"></area>
			var d:IMapItem = new _modelClass();
			d.prase(node);
			return d;
		}
		
		
		public function getAreaDataById(name:String):IMapItem{
			for(var i:Number=0,l:Number=this.getLength();i<l;i++){
				var tmp:IMapItem = this.getItemAt(i) as IMapItem;
				if(tmp.id == name){
					return tmp
					break
				}
			}
			return null;
		}
		
		public function get dataURL() : String {
			return _dataURL;
		}
		
		public function set dataURL(dataURL : String) : void {
			_dataURL = dataURL;
		}
		
		public function get modelClass() : Class {
			return _modelClass;
		}
		
		public function set modelClass(modelClass : Class) : void {
			_modelClass = modelClass;
		}
	}
}
