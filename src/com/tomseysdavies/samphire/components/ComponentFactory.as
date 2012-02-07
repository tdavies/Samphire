package com.tomseysdavies.samphire.components
{
	import com.tomseysdavies.samphire.systems.editor.ComponentVO;

	public class ComponentFactory
	{
		private const _compomentsList:Array = [];
		
		public function ComponentFactory()
		{
		}
		
		public function get components():Array{
			return _compomentsList;
		}
		
		public function addComponent(name:String,ComponentClass:Class):void{
			_compomentsList.push(new ComponentVO(name,ComponentClass));
		}
			
	}
}