/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 03/02/12
 * Time: 10:23
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.samphire.systems {
import com.tomseysdavies.samphire.events.EngineEvents;
import com.tomseysdavies.samphire.nodes.PhysicsNode;

public class PhysicsSystem extends System{

    [Inject]
    public var physicsNodes:Vector.<PhysicsNode>;

    [Inject]
    public var engineEvents:EngineEvents;

    override public function initialize():void {
         addListener(engineEvents.tick,tickHandler)
    }

    private function tickHandler(t:Number):void {
        for each(var node:PhysicsNode in physicsNodes){
            if(node.physics.gravity){
                node.physics.velY += 0.9;
            }
            node.spatial.position.incrementBy(node.physics.velocity);
        }
    }

}
}
