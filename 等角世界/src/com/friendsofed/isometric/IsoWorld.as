package com.friendsofed.isometric
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class IsoWorld extends Sprite
	{
		private var _floor:Sprite;
		private var _objects:Array;
		private var _floorobjects:Array;
		private var _world:Sprite;
		
		public function IsoWorld()
		{
			_floor = new Sprite();
			addChild(_floor);
			
			_world = new Sprite();
			addChild(_world);
			
			_objects = new Array();
			_floorobjects = new Array();
		}
		/**
		 * 将对象添加到世界列表中，sort时检测景深。
		 */
		public function addChildToWorld(child:IsoObject):void
		{
			_world.addChild(child);
			_objects.push(child);
			sort();
		}
		/**
		 * 将对象增加到地板列表中，sort时不检测景深，始终显示在最底层。
		 */
		public function addChildToFloor(child:IsoObject):void
		{
			_floor.addChild(child);
			_floorobjects.push(child)
		}
		/**
		 * 对景深进行排序，调整显示。
		 */
		public function sort():void
		{
			_objects.sortOn("depth", Array.NUMERIC);
			for(var i:int = 0; i < _objects.length; i++)
			{
				_world.setChildIndex(_objects[i], i);
			}
		}
		/**
		 * 检测是否可行走
		 * @deprecated 同时检测世界列表和地板列表 (andy增加了对地板列表的检测)
		 */
		public function canMove(obj:IsoObject):Boolean
		{
			var rect:Rectangle = obj.rect;
			rect.offset(obj.vx, obj.vz);
			for(var i:int = 0; i < _objects.length; i++)
			{
				var objB:IsoObject = _objects[i] as IsoObject;
				if(obj != objB && !objB.walkable && rect.intersects(objB.rect))
				{
					return false;
				}
			}
			for(var j:int = 0; j < _floorobjects.length; j++)
			{
				var objF:IsoObject = _floorobjects[j] as IsoObject;
				if(obj != objF && !objF.walkable && rect.intersects(objF.rect))
				{
					return false;
				}
			}
			return true;
		}
	}
}