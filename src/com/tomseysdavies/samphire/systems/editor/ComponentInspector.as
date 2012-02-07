package com.tomseysdavies.samphire.systems.editor
{
import com.bit101.components.PushButton;
import com.bit101.components.Window;
import com.tomseysdavies.samphire.components.GraphicComponent;
import com.tomseysdavies.samphire.components.SpacialComponent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import org.osflash.signals.Signal;

public class ComponentInspector extends Window
	{
		
		public const remove:Signal = new Signal(Class);	
		public const resize:Signal = new Signal();	
		private var _component:Object;
		private var _inspector:AttributeInspector;
        private var _arrays:Dictionary;
	

		public function ComponentInspector(component:Object, arrays:Dictionary)
		{
			super();
			_component = component;
            _arrays = arrays;
            width = 181;
			draggable = false;
			title = String(component);
				
			if(optionalComponent(component)){
				var remove:PushButton = new PushButton();
				remove.label = "-";
				remove.width = 16;
				remove.height = 16;
				remove.x = 152;
				remove.y = 2;
				remove.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
				addRawChild(remove);
			}
			
			createValueInspector(component)
		}		
		
		public function onClick(e:Event):void{
			remove.dispatch(_component.constructor);
		}		
		
		private function optionalComponent(component:Object):Boolean{
			return !((component is GraphicComponent) || (component is SpacialComponent))
		}
				
		private function createValueInspector( component:Object):void{
			_inspector  = new AttributeInspector(component,_arrays);
			_inspector.x = 5;
			_inspector.y = 5;
			adjustHeight();			
			_inspector.resize.add(onResize);
			addChild(_inspector);
		}
		
		private function adjustHeight():void{
			height = _inspector.height + 20;
		}
		
		private function onResize():void{
			adjustHeight();
			resize.dispatch();
		}
		
		public function dispose():void{
			_inspector.dispose();
			remove.removeAll();
			resize.removeAll();
		}

	}
}

