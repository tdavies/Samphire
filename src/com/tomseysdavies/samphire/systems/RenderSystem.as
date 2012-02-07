package com.tomseysdavies.samphire.systems
{

	
	import com.tomseysdavies.ember.entitySystem.api.IEntityManager;
	import com.tomseysdavies.ember.entitySystem.api.IFamily;
	import com.tomseysdavies.samphire.assets.IAssetFactory;
import com.tomseysdavies.samphire.components.GraphicComponent;
import com.tomseysdavies.samphire.events.EngineEvents;
	import com.tomseysdavies.samphire.nodes.RenderabelNode;
	import com.tomseysdavies.samphire.systems.System;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import uk.co.bigroom.utils.ObjectPool;
	
	public class RenderSystem extends System
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


        private static const ASSET:String = "asset";
		private const _canvas:Sprite = new Sprite();			
		private var _family:IFamily;
		
		
		override public function initialize():void{	
			_family = entityManager.requestFamily(RenderabelNode);	
			contextView.addChild(_canvas);
			addListener(_family.entityAddedSignal,onEntityAdded);
			addListener(_family.entityRemovedSignal,onEntityRemoved);
			addListener(engineEvents.render,onRender);
		}

        private function onEntityAdded(node:RenderabelNode):void{
            var asset:MovieClip =  assetFactory.createAsset(node.graphic.asset);
            asset.name = ASSET;
			node.graphic.clip.addChild(asset);
            node.graphic.clip.x = node.spatial.x;
            node.graphic.clip.y = node.spatial.y;
			_canvas.addChild(node.graphic.clip);
		}

        private function onEntityRemoved(node:RenderabelNode):void{
			_canvas.removeChild(node.graphic.clip);
			node.graphic.clip  = null;
		}

        private function onRender():void{
			for each(var node:RenderabelNode in renderableNodes){
				node.graphic.clip.x = node.spatial.x;
				node.graphic.clip.y = node.spatial.y;
                if(node.graphic.assetInvalidated){
                    changeAsset(node.graphic);
                }
			}
          
		}

        private function changeAsset(graphic:GraphicComponent):void{
            graphic.clip.removeChild(graphic.clip.getChildByName(ASSET));
            var asset:MovieClip =  assetFactory.createAsset(graphic.asset);
            asset.name = ASSET;
            graphic.clip.addChildAt(asset,0);
            graphic.assetInvalidated = false;
        }



		override public function destroy():void{
			contextView.removeChild(_canvas);
		}

	}
}