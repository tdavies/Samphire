package com.tomseysdavies.samphire.events
{
	import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
	
	public class EngineEvents
	{
        public const tick:ISignal = new Signal();
		public const render:ISignal = new Signal();
		public const pause:ISignal = new Signal(Boolean);
	}
}