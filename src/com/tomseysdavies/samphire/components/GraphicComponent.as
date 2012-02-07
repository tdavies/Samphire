package com.tomseysdavies.samphire.components
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GraphicComponent
	{

		[Ember(skip = "true")]
		public var clip:Sprite = new Sprite();

        [Ember(skip = "true")]
        public var assetInvalidated:Boolean;

        private var _asset:String;
		
		
		public function GraphicComponent(asset:String = ""){
			_asset = asset;
		}

        [Edit(DropDown = "assets")]
		public function get asset():String
		{
			return _asset;
		}

		public function set asset(value:String):void
		{
			_asset = value;
            assetInvalidated = true;
		}
		
	}
}