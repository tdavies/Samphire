package com.tomseysdavies.samphire.systems.editor.valueEditors
{
	import com.bit101.components.Label;
	public class UnsuportedValueEditor extends Editor
	{

		private var _valuePair:NameValuePairVO;
		
		public function UnsuportedValueEditor(valuePair:NameValuePairVO)
		{
			_valuePair = valuePair;
			var nameLabel:Label =  new Label(this);				
			nameLabel.text = valuePair.name + ":";
			
			 new Label(this,50,0,"UNSUPORTED");				
			height = 20;
		}

	}
}