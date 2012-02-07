package com.tomseysdavies.samphire.systems.collison
{
import com.tomseysdavies.samphire.nodes.CollisionNode;

public interface ICollision
	{
		function collide(entity:CollisionNode, hit:CollisionNode):void
	}
}