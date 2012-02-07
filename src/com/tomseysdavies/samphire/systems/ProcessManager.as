package com.tomseysdavies.samphire.systems
{


	import com.tomseysdavies.ember.entitySystem.api.ISystem;
	import com.tomseysdavies.samphire.events.EngineEvents;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getTimer;


	/**
	 * handles the ai and render loop
	 * @author Tom Davies
	 */
	public class ProcessManager extends System
	{
		private const TO_SECONDS:Number = 1 / 1000;

		private var _startTime:uint;

		[Inject]
		public var viewContext:DisplayObjectContainer;

		[Inject]
		public var engineEvents:EngineEvents;

		private var _paused:Boolean;

		override public function initialize():void
		{
			_startTime = getTimer();
			addListener(engineEvents.pause,onPause);
			viewContext.addEventListener(Event.ENTER_FRAME, frameHandler);
		}

		private function onPause(paused:Boolean):void
		{
			_paused = paused;
		}

		private function frameHandler(e:Event):void
		{
			var time:uint = getTimer();
			var t:Number = (time - _startTime) * TO_SECONDS;
			_startTime = time;
			
			if (!_paused)
				engineEvents.tick.dispatch(t);
				
			engineEvents.render.dispatch();
		}

		
		

	}

}