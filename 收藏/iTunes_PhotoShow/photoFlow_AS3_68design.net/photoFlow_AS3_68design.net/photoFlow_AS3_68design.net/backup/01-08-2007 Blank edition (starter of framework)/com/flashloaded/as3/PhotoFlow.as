
package com.flashloaded.as3{

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.text.Font;
	
	import com.flashloaded.as3.SelectionSystem;
	import com.flashloaded.as3.PhotoCollection;
	import com.flashloaded.as3.PhotoItem;


	public class PhotoFlow extends SelectionSystem {

		public static  var SELECT_PHOTO="onSelectPhoto";
		public static  var LOAD_PHOTO_COMPLETE="onLoadPhotosComplete";
		public static  var AUTO_FLIP="onAutoFlip";
		public static  var END_AUTO_CLIP="onAutoFlip";
		public static  var ADD_PHOTO="onAddPhoto";
		public static  var REMOVE_PHOTO="onRemovePhoto";
		public static  var DOUBLE_CLICK="onDoubleClick";
		public static  var SINGLE_CLICK="onSingleClick";
		public static  var LOAD_PHOTO="onLoadPhoto";
		public static  var START_LOAD_PHOTO="onStartLoadPhoto";
		public static  var LOAD_PROGRESS="onLoadProgress";
		public static  var LOAD_SET="onLoadSet";
		public static  var MOUSE_OVER="onMouseOver";
		public static  var MOUSE_OUT="onMouseOut";

		private var photoColl:PhotoCollection;

		private var _defaultId:int;
		private var _urlArr:Array=[];
		private var _className:Array=[];
		private var _nameArr:Array=[];
		private var _descArr:Array=[];

		private var _autoFlip:Number=0;
		private var _interId:int;

		private var _currPhoto:Object;
		private var _folder:String="images/";

		private var _scaleMode:String="showAll";
		private var _flipSound:String="";
		private var sound:Sound;
		private var _flipSpeed:Number=10;

		private var _preloadSet:int=0;
		private var _showName:Boolean;
		private var name_txt:TextField;
		private var name_txtf:TextFormat;

		private var _f:Font;
		private var _c:Number=0x000000;
		private var _s:Number=20;
		private var _np:String;
		private var _b:Boolean=false;

		private var _nd:Number=0;
		private var _ef:Boolean=false;
		private var flipStep:int=1;
		private var _autoFlipLock:Boolean;

		/**
		* @exclude
		*/
		static var symbolName:String = "photoFlow";
		/**
		* @exclude
		*/
		static var symbolOwner:Object = Object(PhotoFlow);
		/**
		* @exclude
		*/
		var className:String = "PhotoFlow";

		public function PhotoFlow() {
			
		}
		
		override protected function prepareItemsData():void{
			listItems=new PhotoCollection();
			items=new PhotoCollection();
			
			super.prepareItemsData();
		}
		
		override protected function createItem(data:Object,index:int):Object{
			//override
			var p=new Photo(data,index);
			return p;
		}
		
		[Collection(name="photos",collectionClass="com.flashloaded.as3.Collection",collectionItem="com.flashloaded.as3.PhotoItem",identifier="name")]
		public function get itemData():Collection{
			return inspectorData;
		}
		public function set itemData(coll:Collection):void{
			inspectorData=coll;
		}
		
	}
}