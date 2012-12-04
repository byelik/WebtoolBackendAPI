package Manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EventManager extends EventDispatcher
	{
		private static var msSingleton:EventManager;
		
		public static var STOP_DRAG_BEAT:String = "StopDragBeat";
		public function EventManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function getSingleton():EventManager
		{
			if(!msSingleton)
			{
				msSingleton = new EventManager();
			}
			return msSingleton;
		}
		
		public function fireEvent():void
		{
			dispatchEvent(new Event(EventManager.STOP_DRAG_BEAT));
		}
	}
}