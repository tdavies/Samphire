package com.tomseysdavies.samphire.systems.editor
{

	import com.tomseysdavies.ember.entitySystem.api.IEntity;
	import com.tomseysdavies.samphire.components.GraphicComponent;
	import com.tomseysdavies.samphire.nodes.RenderabelNode;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	import uk.co.bigroom.geom.Vector2D;

	public class EditorHUD
	{
		
		private const SELECTABLE:int = 0x00FF00;
		private const SELECTED:int = 0xFF0000;
		private const SELECTION_CLIP:String = "selection";
        private const GRID_SIZE:int = 37;

		private var _renderabelNode:Vector.<RenderabelNode>;
		private var _assetMap:Dictionary; 
		private var _selectedItem:Sprite;
		private var _selectedNode:RenderabelNode;

		private var _dragMode:Boolean;	
		private var _contextView:DisplayObjectContainer;
		
		public const updateEntity:Signal = new Signal(IEntity);
		public const selectEntity:Signal = new Signal(IEntity);
		
		public function EditorHUD(renderabelNode:Vector.<RenderabelNode>,contextView:DisplayObjectContainer){
			_renderabelNode= renderabelNode;
			_contextView = contextView;
			_assetMap = new Dictionary();
		}
				
		public function clearSelection():void{
			_selectedItem = null;
		}
		
		public function redraw():void{
			for each(var node:RenderabelNode in _renderabelNode){
				_assetMap[node.graphic.clip] = node;
				applyEditMode(node.graphic);		
			}
		}
		
		public function disable():void{
			for each(var node:RenderabelNode in _renderabelNode){
				removeEditMode(node.graphic);		
			}
			_assetMap = new Dictionary();
		}
		
		public function onMouseUp(event:MouseEvent):void {
			_contextView.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_dragMode = false;
			updateEntity.dispatch(_selectedNode.entity);
		}
		
		private function applyEditMode(graphics:GraphicComponent):void {
			graphics.clip.mouseChildren = false;
			graphics.clip.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			renderSelectable(graphics.clip);
		}
		
		private function removeEditMode(graphics:GraphicComponent):void {
			graphics.clip.mouseChildren = false;
			graphics.clip.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			var selection:DisplayObject =  graphics.clip.getChildByName(SELECTION_CLIP);
			if(selection != null){
				graphics.clip.removeChild(selection);
			}
		}

		private function onMouseDown(event:MouseEvent):void {
			const target:Sprite  = Sprite(event.target);
			selectItem(target);
			//var selection:DisplayObjectContainer = target.selection;
			_dragMode = true;
			_contextView.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
		}

		private function selectItem(target:Sprite):void {
			if(_selectedItem != null){
				renderSelectable(_selectedItem);
			}
			_selectedItem = target;
			renderSelected(target);	
			var node:RenderabelNode = _assetMap[_selectedItem];
			_selectedNode =  node;
			selectEntity.dispatch(node.entity);
		}
		
		private function renderSelectable(asset:Sprite):void {
			var oldSelection:DisplayObject =  asset.getChildByName(SELECTION_CLIP);
			if(oldSelection != null){
				asset.removeChild(oldSelection);
			}
			var selection:MovieClip = createSelection(asset.width,asset.height,SELECTABLE);
			asset.addChild(selection);
		}
		
		private function renderSelected(asset:Sprite):void {
			var oldSelection:DisplayObject =  asset.getChildByName(SELECTION_CLIP);
			if(oldSelection != null){
				asset.removeChild(oldSelection);
			}
			var selection:MovieClip =  createSelection(asset.width,asset.height,SELECTED);
			asset.addChild(selection);
		}
		
		private function createSelection(width:Number,height:Number,colour:int):MovieClip{
			const selection:MovieClip = new MovieClip();
			selection.graphics.clear();
			while(selection.numChildren > 0){
				selection.removeChildAt(0);
			}	
			selection.name = "selection";		
			selection.graphics.lineStyle(1, colour,0.8);
			selection.graphics.beginFill(colour, 0.1);
			selection.graphics.drawRect(0, 0, width, height);			
			selection.graphics.endFill();
			return selection; 
		}
		
		
		public function update():void{
			if(!_selectedItem) return;
			if(_dragMode){		
				_selectedNode.spatial.x  = Math.floor(_contextView.stage.mouseX /GRID_SIZE)* GRID_SIZE;
				_selectedNode.spatial.y = Math.floor(_contextView.stage.mouseY /GRID_SIZE)* GRID_SIZE;
			}
			
		}

		public function get selectedItem():Sprite {
			return _selectedItem;
		}

		public function set selectedItem(value:Sprite):void {
			_selectedItem = value;
		}
		
		
		public function dispose():void {
			disable();
			_contextView.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

	}
}