package com.tomseysdavies.samphire.systems.editor
{
	public class ComponentVO
	{
		
		public var label:String;
		public var clazz:Class
		
		public function ComponentVO(label:String,clazz:Class)
		{
			this.label = label;
			this.clazz = clazz;
		}
	}
}