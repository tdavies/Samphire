package com.tomseysdavies.samphire.systems.editor.valueEditors
{
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class StringValueEditor extends Editor
	{
		
		private var _text:InputText;
		private var _valuePair:NameValuePairVO;
		
		public const edited:Signal = new Signal(String);
		
		public function StringValueEditor(valuePair:NameValuePairVO)
		{
			_valuePair = valuePair;
			 new Label(this,0,0,valuePair.name + ":");				
			_text = new InputText(this,50,0,valuePair.stringValue);
			_text.addEventListener(Event.CHANGE, onChange,false,0,true);
			height = 20;
		}
		
		public function onChange(e:Event):void{
			_valuePair.value =_text.text;
		}
	}
}