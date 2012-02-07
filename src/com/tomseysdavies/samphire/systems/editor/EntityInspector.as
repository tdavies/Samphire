package com.tomseysdavies.samphire.systems.editor
{
import com.bit101.components.ComboBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.ScrollPane;
import com.bit101.components.VBox;
import com.tomseysdavies.ember.entitySystem.api.IEntity;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import org.osflash.signals.Signal;

public class EntityInspector extends ScrollPane
	{

		private var _componentsPanelContainer:VBox;
		private var _componentDropDown:ComboBox;
		private var _deleteButton:PushButton;
		private var _entity:IEntity;
			
		private var _availableComponents:Array;
		private const _componentsPanels:Vector.<ComponentInspector> = new Vector.<ComponentInspector>();
		public const deleteEntity:Signal = new Signal(IEntity);
        private var _arrays:Dictionary;
		
		public function EntityInspector(entity:IEntity, availableComponents:Array, arrays:Dictionary)
		{
			_entity = entity;
			_availableComponents = availableComponents;
            _arrays = arrays;
            _hScrollbar.enabled = false;
            autoHideScrollBar = true;
			dragContent = false;

			width = 181;
			height = 345;
			
			var name:Label = new Label(null,5,2,"Entity: " +_entity.name)
			addChild(name);
			
			_deleteButton = new PushButton(this,152,3,"-");
			_deleteButton.width = 16;
			_deleteButton.height = 16;
			_deleteButton.addEventListener(MouseEvent.CLICK,onDelete,false,0,true);
			
			_componentDropDown = new ComboBox(this,5,20,"Component",_availableComponents);
			_componentDropDown.width = 80;
			_componentDropDown.addEventListener(Event.SELECT,onSelect,false,0,true);
			updateComponents();
		}
		
		private function onDelete( e:MouseEvent):void{			
			deleteEntity.dispatch(_entity);
		}
		
		private function onSelect(e:Event):void{			
			_componentDropDown.removeEventListener(Event.SELECT,onSelect);			
			var c:ComponentVO = ComponentVO(_componentDropDown.selectedItem);			
			_entity.add(new c.clazz());
			_componentDropDown.selectedIndex = -1;
			_componentDropDown.addEventListener(Event.SELECT,onSelect,false,0,true);
			updateComponents();
		}
		
		private function updateComponents():void{
			if(_componentsPanelContainer != null){
				removeComponentsPanels();
				content.removeChild(_componentsPanelContainer);
			}
			var components:Dictionary = _entity.getAll();			
			_componentsPanelContainer = createComponentsPanels(components);
			_componentsPanelContainer.y = 42;
			addChild(_componentsPanelContainer);
			update();
		}
		
		private function createComponentsPanels(components:Dictionary):VBox{
			_componentsPanels.length = 0;
			var componentsInspector:VBox = new VBox();
			componentsInspector.spacing = 0;
			for (var component:Object in components) {
				var componentPanel:ComponentInspector = new ComponentInspector(components[component],_arrays);
				componentPanel.remove.add(onRemove);
				componentPanel.resize.add(onResizeInspector);
				componentsInspector.addChild(componentPanel);
				_componentsPanels.push(componentPanel);
			}
			return componentsInspector;
		}

		private function removeComponentsPanels():void{
			for each(var componentInspector:ComponentInspector in _componentsPanels){
				componentInspector.dispose();
				_componentsPanelContainer.removeChild(componentInspector);
			}
		}
		
		private function onRemove(clazz:Class):void{
			_entity.remove(clazz);
			updateComponents();
		}
		
		private function onResizeInspector():void{
			update();
		}

		public function get entity():IEntity
		{
			return _entity;
		}
		
		
	}
	
}

