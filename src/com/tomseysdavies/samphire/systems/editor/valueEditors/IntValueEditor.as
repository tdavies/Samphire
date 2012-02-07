package com.tomseysdavies.samphire.systems.editor.valueEditors
{
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;

	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class IntValueEditor extends Editor
	{
		
		private var _text:NumericStepper;
		private var _valuePair:NameValuePairVO;
		
		public const edited:Signal = new Signal(String);
		
		public function IntValueEditor(valuePair:NameValuePairVO)
		{
			_valuePair = valuePair;
			var nameLabel:Label =  new Label(this);				
			nameLabel.text = valuePair.name + ":";
			_text = new NumericStepper(this,50,0)
			_text.addEventListener(Event.CHANGE, onChange,false,0,true);
			_text.value = Number(valuePair.stringValue);
			_text.x = 50;
			height = 20;
		}
		
		public function onChange(e:Event):void{
			_valuePair.value = Number(_text.value);
		}
	}
}