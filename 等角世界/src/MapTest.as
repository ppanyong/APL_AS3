package {
	import flash.ui.Keyboard;	
	import flash.events.KeyboardEvent;	
	
	import com.friendsofed.isometric.DrawnIsoBox;
	import com.friendsofed.isometric.GraphicTile;
	import com.friendsofed.isometric.IsoWorld;
	import com.friendsofed.isometric.MapLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(backgroundColor=0xffffff)]
	public class MapTest extends Sprite
	{
		private var _world:IsoWorld;
		private var mapLoader:MapLoader;
		private var speed:Number = 5;
		private var friction:Number = 0.95;
		private var bounce:Number = -0.9;
		
		private var box:DrawnIsoBox;//可以移动的方块
		
		public function MapTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			mapLoader = new MapLoader();
			mapLoader.addEventListener(Event.COMPLETE, onMapComplete);
			mapLoader.loadMap("map.txt");
		}
		
		private function onMapComplete(event:Event):void
		{
			_world = mapLoader.makeWorld(20);
			_world.x = stage.stageWidth / 2;
			_world.y = 100;
			addChild(_world);
			box = new DrawnIsoBox(20, 0xff0000, 20);
			box.x = 200;
			box.z = 200;
			_world.addChildToWorld(box);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP :
					box.vx = -speed;
				break;
				
				case Keyboard.DOWN :
					box.vx = speed;
				break;
				
				case Keyboard.LEFT :
					box.vz = speed;
				break;
				
				case Keyboard.RIGHT :
					box.vz = -speed;
				break;
				
				/*case Keyboard.SPACE :
					//box.vx = Math.random() * 20 - 10;
					box.vy = -Math.random() * 40;
					//box.vz = Math.random() * 20 - 10;
				break;*/
				
				default :
				break;
				
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			box.vx = 0;
			box.vz = 0;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(event:Event):void
		{
			if(_world.canMove(box)){
			//box.vy += 2;
			box.x += box.vx;
			box.y += box.vy;
			box.z += box.vz;
			//以下为跳跃代码
			/*if(box.x > 380)
			{
				box.x = 380;
				box.vx *= -.8;
			}
			else if(box.x < 0)
			{
				box.x = 0;
				box.vx *= bounce;
			}
			if(box.z > 380)
			{
				box.z = 380;
				box.vz *= bounce;
			}
			else if(box.z < 0)
			{
				box.z = 0;
				box.vz *= bounce;
			}
			if(box.y > 0)
			{
				box.y = 0;
				box.vy *= bounce;
			}
			box.vx *= friction;
			box.vy *= friction;
			box.vz *= friction;*/
			}
			_world.sort();
		}
	}
}