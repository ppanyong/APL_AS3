package com.sun.utils{
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
    import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.display.InteractiveObject;
	
	import com.sun.events.FPContextMenuEvent;

    public class FPContextMenu extends EventDispatcher {
        private var myContextMenu:ContextMenu;
		private var menuItems:Array;

        public function FPContextMenu(addTarget:InteractiveObject) {
            menuItems = new Array();
			myContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			
			menuItems = fillItems();
            removeDefaultItems();
			menuItems.forEach(addCustomMenuItems);

            addTarget.contextMenu = myContextMenu;
			
			myContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
        }
		
		private function fillItems():Array
		{
			var a:Array = new Array();
			a.push({caption:"Version 2.0.0",separatorBefore:false,enabled:false});
			a.push({caption:"QQVideo",separatorBefore:false,enabled:true});
			a.push({caption:"播    放",separatorBefore:true,enabled:true});
			a.push({caption:"暂    停",separatorBefore:false,enabled:true});
			a.push({caption:"停    止",separatorBefore:false,enabled:true});
			a.push({caption:"全    屏",separatorBefore:true,enabled:true});
			a.push({caption:"退出全屏",lseparatorBefore:false,enabled:true});
			
			return a;
		}
        private function removeDefaultItems():void {
            myContextMenu.hideBuiltInItems();
        }
		
        private function addCustomMenuItems(element:*, index:int, arr:Array):void {
            var item:ContextMenuItem = new ContextMenuItem(element.caption,element.separatorBefore,element.enabled);
            myContextMenu.customItems.push(item);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
        }
		private function menuSelectHandler(event:ContextMenuEvent):void
		{
		}
        private function menuItemSelectHandler(event:ContextMenuEvent):void {
			dispatchEvent(new FPContextMenuEvent(FPContextMenuEvent.MENU_SELECTED,event.target.caption));
			setItemUnActive(event.target.caption);
        }
		private function setItemUnActive(selectedItem:String):void
		{
			switch(selectedItem){
				case myContextMenu.customItems[2].caption:
					 myContextMenu.customItems[2].enabled = false;
					 myContextMenu.customItems[3].enabled = true;
					 myContextMenu.customItems[4].enabled = true;
					break;
				case myContextMenu.customItems[3].caption:
					 myContextMenu.customItems[2].enabled = true;
					 myContextMenu.customItems[3].enabled = false;
					 myContextMenu.customItems[4].enabled = true;
					break;
				case myContextMenu.customItems[4].caption:
					 myContextMenu.customItems[2].enabled = true;
					 myContextMenu.customItems[3].enabled = true;
					 myContextMenu.customItems[4].enabled = false;
					break;
				case menuItems[5].caption:
					 myContextMenu.customItems[6].enabled = true;
					 myContextMenu.customItems[5].enabled = false;
					break;
				case menuItems[6].caption:
					 myContextMenu.customItems[5].enabled = true;
					 myContextMenu.customItems[6].enabled = false;
					break;
			}
		}
		public function set playUnActive(b:Boolean):void
		{
			myContextMenu.customItems[2].enabled = false;
			myContextMenu.customItems[3].enabled = false;
			myContextMenu.customItems[4].enabled = false;
		}
		public function set screenUnActive(b:Boolean):void
		{
			myContextMenu.customItems[5].enabled = false;
			myContextMenu.customItems[6].enabled = false;
		}
		public function set unActiveItem(str:String):void
		{
			var index:uint;
			for(var i:uint=2;i<menuItems.length;i++){
				if(str==menuItems[i].caption){
					index = i;
					break;
				}
			}
			if(index>1){
				setItemUnActive(str);
			}
		}
    }
}