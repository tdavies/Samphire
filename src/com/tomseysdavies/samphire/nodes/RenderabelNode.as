package com.tomseysdavies.samphire.nodes
{

	import com.tomseysdavies.ember.entitySystem.impl.Node;
	import com.tomseysdavies.samphire.components.GraphicComponent;
	import com.tomseysdavies.samphire.components.SpacialComponent;

	public class RenderabelNode extends Node
	{
		public var spatial:SpacialComponent;
		public var graphic:GraphicComponent;
	}
}