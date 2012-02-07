package com.tomseysdavies.samphire.nodes
{

import com.tomseysdavies.ember.entitySystem.impl.Node;
import com.tomseysdavies.samphire.components.CollisionComponent;
import com.tomseysdavies.samphire.components.SpacialComponent;

public class CollisionNode extends Node
	{
		public var spatial:SpacialComponent;
        public var collision:CollisionComponent;
	}
}