package com.tomseysdavies.samphire.systems.editor
{
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class NamePanel extends Window
	{
		
		private var _nameBox:InputText;
		private var _okButton:PushButton;		
		public const ok:Signal = new Signal(String);
		
		public function NamePanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos, "Name:");
			
			_nameBox = new InputText(this.content,5,7);
			_okButton = new PushButton(this.content,110,5,"OK");
			_okButton.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
			_okButton.width = 38;
			width = 150;
			height = 50;
			
		}
		
		public function onClick(e:MouseEvent):void{
			parent.removeChild(this);
			ok.dispatch(_nameBox.text);			
		}
	}
}