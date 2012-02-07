package com.tomseysdavies.samphire.systems.editor.valueEditors
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.Label;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class ComboBoxValueEditor extends Editor
	{
		
		private var _combo:ComboBox;
		private var _valuePair:NameValuePairVO;

		
		public const edited:Signal = new Signal(String);
		
		public function ComboBoxValueEditor(valuePair:NameValuePairVO)
		{
			_valuePair = valuePair;
			var nameLabel:Label =  new Label();				
			nameLabel.text = valuePair.name + ":";
			_combo = new ComboBox(this,50,0,"-",valuePair.data as Array);
			_combo.selectedItem = _valuePair.stringValue;
			_combo.addEventListener(Event.SELECT, onSelect,false,0,true);
			addChild(nameLabel);
			height = 23;
		}
		
		public function onSelect(e:Event):void{
			_valuePair.value =_combo.selectedItem;
		}
	}
}