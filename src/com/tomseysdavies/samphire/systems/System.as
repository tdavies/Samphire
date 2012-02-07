package com.tomseysdavies.samphire.systems
{

	
	import com.tomseysdavies.ember.entitySystem.api.ISystem;
	
	import flash.utils.Dictionary;
	
	import org.osflash.signals.ISignal;
	
	public class System implements ISystem
	{
		
		private var _signalMap:Dictionary = new Dictionary();
		
		public function System()
		{
			
		}

		public function initialize():void
		{
			
		}
		
		protected function remove():void
		{
			
		}

		public function destroy():void{
			for (var signal:Object in _signalMap){
				var handlers:Vector.<Function> = _signalMap[signal] as Vector.<Function>;
				for each(var handler:Function in handlers){
					removeListener(signal as ISignal,handler);
				}
			}
			_signalMap = new Dictionary();
		}
		
		protected function addListener(signal:ISignal,callback:Function):void{
			handlerMap(signal).push(callback);
			signal.add(callback);
		}
		
		protected function removeListener(signal:ISignal,callback:Function):void{
			signal.remove(callback);
			var handlers:Vector.<Function> = handlerMap(signal);
			var index:int = handlers.indexOf(callback);
			if(index > -1){
				handlers.splice(index,1);
				if(handlers.length == 0){
					delete _signalMap[signal];
				}
			}
		}
		
		private function handlerMap(signal:ISignal):Vector.<Function>{
			return _signalMap[signal] ||= new Vector.<Function>();
		}

	}
}

internal class CacheSignal{
	
	import org.osflash.signals.ISignal;
	
	public var signal:ISignal;
	public var callback:Function;
	
	public function CacheSignal(signal:ISignal,callback:Function):void{
		this.signal = signal;
		this.callback = callback;
	}
}