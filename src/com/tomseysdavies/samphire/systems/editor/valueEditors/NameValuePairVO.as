package com.tomseysdavies.samphire.systems.editor.valueEditors
{
	public class NameValuePairVO
	{


		public var name:String;
		public var stringValue:String;	
		public var component:Object;
		public var type:String;
        public var data:Object;
		
		public function NameValuePairVO(name:String,value:String,component:Object,type:String,data:Object = null)
		{
			this.name = name;
			this.stringValue = value;
			this.component = component;
			this.type = type;
            this.data = data;
		}
		
		public function set value(valueData:*):void{
			component[name] = valueData;
		}
		
		public function get value():*{
			return component[name];
		}
		
		
	}
}