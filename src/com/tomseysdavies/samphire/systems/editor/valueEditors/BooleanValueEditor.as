package com.tomseysdavies.samphire.systems.editor.valueEditors
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class BooleanValueEditor extends Editor
	{
		
		private var _checkBox:CheckBox;
		private var _valuePair:NameValuePairVO;
		
		public const edited:Signal = new Signal(String);
		
		public function BooleanValueEditor(valuePair:NameValuePairVO)
		{
			_valuePair = valuePair;
			var nameLabel:Label =  new Label();				
			nameLabel.text = valuePair.name + ":";
			_checkBox = new CheckBox();
			_checkBox.label = ""
			_checkBox.selected = (valuePair.stringValue == "true");
			_checkBox.addEventListener(MouseEvent.CLICK, onChange,false,0,true);

			_checkBox.x = 50;
			_checkBox.y = 4;
			addChild(nameLabel);
			addChild(_checkBox);
			height = 20;
		}
		
		public function onChange(e:Event):void{
			_valuePair.value = _checkBox.selected;
		}
	}
}