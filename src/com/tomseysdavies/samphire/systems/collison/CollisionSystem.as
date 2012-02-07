package com.tomseysdavies.samphire.systems.collison
{
import com.tomseysdavies.ember.entitySystem.api.IEntityManager;
import com.tomseysdavies.ember.entitySystem.api.IFamily;
import com.tomseysdavies.samphire.components.CollisionComponent;
import com.tomseysdavies.samphire.systems.*;
import com.tomseysdavies.samphire.events.EngineEvents;
import com.tomseysdavies.samphire.nodes.CollisionNode;

import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import org.swiftsuspenders.Injector;

import uk.co.bigroom.geom.Vector2D;

public class CollisionSystem extends System{



    [Inject]
    public var injector:Injector;

    [Inject]
    public var collisionNodes:Vector.<CollisionNode>;

    [Inject]
    public var engineEvents:EngineEvents;

    [Inject]
    public var entityManager:IEntityManager;



    private const _collisionGroups:Dictionary = new Dictionary();
    private var _collisionMap:Dictionary = new Dictionary();
    private var _triggers:Dictionary = new Dictionary();
    private var _family:IFamily;

    override public function initialize():void {
        addListener(engineEvents.tick,tickHandler);
        _family = entityManager.requestFamily(CollisionNode);
        addListener(_family.entityAddedSignal,onEntityAdded);
        addListener(_family.entityRemovedSignal,onEntityRemoved);
    }


    public function add(groupA:String,groupB:String,CollisionClass:Class,InverseCollisionClass:Class = null):void{
        var key:String = groupA+"-"+groupB;
        getTriggerGroup(groupA).push(groupB);
        var collisionClass:ICollision = new CollisionClass();
        injector.injectInto(collisionClass);
        _collisionMap[key] = collisionClass;
        if(InverseCollisionClass){
            var ikey:String = groupB+"-"+groupA;
            var inverseCollisionClass:ICollision = new InverseCollisionClass();
            injector.injectInto(inverseCollisionClass);
            _collisionMap[ikey] = inverseCollisionClass;
        }
    }

    public function getCollisionSignal(groupA:String,groupB:String):ICollision{
        var key:String = groupA+"-"+groupB
        return _collisionMap[key];
    }


    private function getTriggerGroup(group:String):Vector.<String>{
        return _triggers[group] ||= new Vector.<String>;
    }

    private function onEntityAdded(node:CollisionNode):void{
        getGroup(node.collision.groupID).push(node);
    }

    private function onEntityRemoved(node:CollisionNode):void{
        var group:Vector.<CollisionNode> = getGroup(node.collision.groupID);
        group.splice(group.indexOf(node),1);
    }

    private function checkIfGroupsChanged():void{
        for each(var node:CollisionNode in collisionNodes){
            if(node.collision.groupInvalidated){
                updateGroup(node);
            }
        }
    }

    private function updateGroup(node:CollisionNode):void{
        var oldGroup:Vector.<CollisionNode> = getGroup(node.collision.oldGroup);
        oldGroup.splice(oldGroup.indexOf(node),1);
        getGroup(node.collision.groupID).push(node);
        node.collision.groupInvalidated = false;
    }

    private function tickHandler(t:Number):void{
        checkIfGroupsChanged();
        for (var group:String in _triggers){
            var groupA:Vector.<CollisionNode> = getGroup(group);
            var triggers:Vector.<String> = _triggers[group];
            for each(var trigger:String in triggers){
                var groupB:Vector.<CollisionNode> = getGroup(trigger);
                var key:String = group+"-"+trigger;
                var ikey:String = trigger+"-"+group;
                checkGroups(groupA,groupB,key,ikey);
            }
        }
    }

    private function checkGroups(groupA:Vector.<CollisionNode>,groupB:Vector.<CollisionNode>,key:String,ikey:String):void{
        for each(var node:CollisionNode in groupA){
            var hits:Vector.<CollisionNode> = checkVsGroup(node,groupB);
            if(hits.length > 0){
                for each(var hit:CollisionNode in hits){
                    ICollision(_collisionMap[key]).collide(node,hit);
                    if( _collisionMap[ikey]){
                        ICollision(_collisionMap[ikey]).collide(hit,node);
                    }
                }
            }
        }
    }

    private function checkVsGroup(node:CollisionNode,group:Vector.<CollisionNode>):Vector.<CollisionNode>{
        const hits:Vector.<CollisionNode> = new Vector.<CollisionNode>();
        for each (var collidable:CollisionNode in group) {
            if(checkForCollision(node, collidable)){
                hits.push(collidable);
            }
        }
        return hits;
    }

    private function checkForCollision(nodeA:CollisionNode, nodeB:CollisionNode):Boolean {
        const boundsA:Rectangle  = nodeA.spatial.getBoundingBox();
        const boundsB:Rectangle  = nodeB.spatial.getBoundingBox();
        return (boundsA.intersects(boundsB));
    }

    private function getGroup(name:String):Vector.<CollisionNode>{
        return _collisionGroups[name] ||= new Vector.<CollisionNode>();
    }


    override public function destroy():void {
        _collisionMap = new Dictionary();
    }
		
	
	}
}


