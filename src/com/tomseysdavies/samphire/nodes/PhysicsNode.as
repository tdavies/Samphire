package com.tomseysdavies.samphire.nodes
{

import com.tomseysdavies.ember.entitySystem.impl.Node;
import com.tomseysdavies.samphire.components.PhysicsComponent;
import com.tomseysdavies.samphire.components.SpacialComponent;

public class PhysicsNode extends Node
	{
		public var spatial:SpacialComponent;
        public var physics:PhysicsComponent;
	}
}