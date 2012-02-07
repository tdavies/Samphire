package com.tomseysdavies.samphire.systems.editor
{
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.tomseysdavies.ember.entitySystem.api.IEntity;
	import com.tomseysdavies.ember.entitySystem.api.IEntityManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
import flash.utils.Dictionary;

import org.osflash.signals.Signal;
	
	public class EditorPanel extends Sprite
	{
		
		private var _editor:Window
		public const newEntity:Signal = new Signal();
		public const save:Signal = new Signal();
		public const load:Signal = new Signal();
		public const removeEntity:Signal = new Signal(IEntity);
		private var _inspector:EntityInspector;
		private var _entityManager:IEntityManager;
		private var _componets:Array;
        private var _arrays:Dictionary;
		
		public function EditorPanel(entityManager:IEntityManager,componets:Array,arrays:Dictionary)
		{
			_entityManager = entityManager;
			_componets = componets;
            _arrays = arrays;
            _editor = new Window(this,0,0,"Editor");
			_editor.width = 180;
			_editor.height = 375;
			var newEntityButton:PushButton = new PushButton(_editor.content,2,0,"New ",onNew);
			newEntityButton.width = 50;			
			var saveButton:PushButton = new PushButton(_editor.content,128,0,"Save",onSave);
			saveButton.width = 50;
			
			var loadButton:PushButton = new PushButton(_editor.content,78,0,"Load",onLoad);
			loadButton.width = 50;
		}

		private function onNew(event:Event):void{
			newEntity.dispatch();
		}
		
		private function onSave(event:Event):void{
			save.dispatch();
		}
		
		private function onLoad(event:Event):void{
			load.dispatch();
		}

		public function showEntitiy(entity:IEntity):void{
			removeEntityInspector();
			if(entity != null){
				_inspector = new EntityInspector(entity,_componets,_arrays);
				_inspector.deleteEntity.add(onRemove);
				_inspector.y = 20;
				_editor.content.addChild(_inspector);
			}
		}
		
		public function deleteSelected():void{
			if(_inspector.entity != null){
				onRemove(_inspector.entity);
			}
		}

		private function onRemove(entity:IEntity):void{
			removeEntityInspector();
			removeEntity.dispatch(entity);	
		}
		

		private function removeEntityInspector():void{
			if(_inspector != null && _editor.content.contains(_inspector)){
				_editor.content.removeChild(_inspector);
				_inspector.deleteEntity.remove(onRemove);
				_inspector = null;
			}
		}
		
		public function dispose():void{

		}
		
		

	}
}