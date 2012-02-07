package com.tomseysdavies.samphire.systems.editor
{
	import com.tomseysdavies.ember.entitySystem.api.IEntity;
	import com.tomseysdavies.ember.entitySystem.api.IEntityManager;
	import com.tomseysdavies.ember.io.EntityEncoder;
import com.tomseysdavies.ember.io.serialise.ISerialiser;
import com.tomseysdavies.ember.io.serialise.json.JsonSerialiser;
	import com.tomseysdavies.samphire.assets.IAssetFactory;
	import com.tomseysdavies.samphire.components.ComponentFactory;
	import com.tomseysdavies.samphire.components.GraphicComponent;
	import com.tomseysdavies.samphire.components.SpacialComponent;
	import com.tomseysdavies.samphire.events.EngineEvents;
	import com.tomseysdavies.samphire.nodes.RenderabelNode;
	import com.tomseysdavies.samphire.systems.System;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class EditorSystem extends System
	{
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		[Inject]
		public var engineEvents:EngineEvents;
		
		[Inject]
		public var renderableNodes:Vector.<RenderabelNode>;
		
		[Inject]
		public var entityManager:IEntityManager;
		
		[Inject]
		public var assetFactory:IAssetFactory;
		
		[Inject]
		public var componentFactory:ComponentFactory;

        [Inject]
        public var serialiser:ISerialiser;

		private var _editing:Boolean;		
		private var _hud:EditorHUD;
		private var _panel:EditorPanel;

		private var _fr:FileReference;
        private var _arrays:Dictionary = new Dictionary();
		
		override public function initialize():void{	
			contextView.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
			_fr = new FileReference();
			_hud = new EditorHUD(renderableNodes,contextView);
			_hud.selectEntity.add(onEntitySelected);
			_hud.updateEntity.add(onEntityUpdate);
			
			createEditorPanel();
			serialiser = new JsonSerialiser()
		
		}
		
		private function onEntitySelected(entity:IEntity):void{
			_panel.showEntitiy(entity);
		}
		
		private function onEntityUpdate(entity:IEntity):void{
			var graphics:GraphicComponent = entity.get(GraphicComponent) as GraphicComponent;
			var spacial:SpacialComponent = entity.get(SpacialComponent) as SpacialComponent;
			spacial.x = graphics.clip.x;
			spacial.y = graphics.clip.y;
			_panel.showEntitiy(entity);
		}
		
		private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.E){
				if(!_editing){
					_editing = true;
					addHUD();
					addEditorPanel();
                    engineEvents.pause.dispatch(true);
				}else{					
					_editing = false;
					removeHUD();
					removeEditorPanel();
                    engineEvents.pause.dispatch(false);
				}
			}
		}

		private function createEditorPanel():void{
			_panel = new EditorPanel(entityManager,componentFactory.components,_arrays);
			_panel.save.add(saveHandler);
			_panel.load.add(loadHandler);
			_panel.removeEntity.add(deleteHandler);
			_panel.newEntity.add(newEntityHandler);
		}
		
		private function newEntityHandler():void{			
			var entity:IEntity = entityManager.create();
			entity.add(new SpacialComponent(240,160));
			entity.add(new GraphicComponent(assetFactory.assets[0]));
			_hud.redraw();
		}
		
		private function deleteHandler(entity:IEntity):void{			
			entityManager.remove(entity);
			_hud.clearSelection();
		}

		private function addEditorPanel():void{
			contextView.addChild(_panel);
		}
		
		private function removeEditorPanel():void{
			contextView.removeChild(_panel);
		}

		private function addHUD():void{
			_hud.redraw();
			addListener(engineEvents.render,renderHandler)
		}
		
		private function removeHUD():void{
			removeListener(engineEvents.render,renderHandler)
			_hud.disable();
			_hud.clearSelection();
		}
		
		private function renderHandler():void{
			_hud.update();
		}
		
		private function saveHandler():void{
			var levelData:String = serialiser.serialise(entityManager);
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(levelData);
			_fr.save(ba);
		}
		
		private function loadHandler():void{
			_hud.clearSelection();
			_fr.addEventListener(Event.SELECT, selectHandler);
			_fr.browse();
		}
		
		private function selectHandler(e:Event):void{
			_fr.removeEventListener(Event.SELECT, selectHandler);
			_fr.addEventListener(Event.COMPLETE,fileLoadCompleted);
			_fr.load();		
		}
		
		private function fileLoadCompleted(e:Event):void{
            _fr.removeEventListener(Event.COMPLETE,fileLoadCompleted);
			entityManager.removeAll();
			var data:ByteArray = _fr.data;
			var levelText:String = data.readUTFBytes(data.bytesAvailable);
			serialiser.deserialise(levelText,entityManager);
			_hud.redraw();
		}

        public function addDataArray(name:String,data:Vector.<String>):void{
            _arrays[name] =  data;
        }

	}
}