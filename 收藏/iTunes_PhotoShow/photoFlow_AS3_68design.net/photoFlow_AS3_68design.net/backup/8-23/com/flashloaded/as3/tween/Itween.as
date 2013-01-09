
package com.flashloaded.as3.tween{
	import flash.events.IEventDispatcher;
	import com.flashloaded.as3.Points;
	
	public interface Itween extends IEventDispatcher{
		function getNextPoints(p1:Points,p2:Points):Points;
	}
}
		
		