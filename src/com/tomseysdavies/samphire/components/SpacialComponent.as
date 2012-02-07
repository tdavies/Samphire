package com.tomseysdavies.samphire.components
{

import flash.geom.Rectangle;

import spark.core.NavigationUnit;

import uk.co.bigroom.geom.Vector2D;
	
	public class SpacialComponent
	{
		[Ember(skip = "true")]
		public var position:Vector2D;

        private var boundingBox:Rectangle;
		
		public function SpacialComponent(x:Number = 0,y:Number=0,width:Number=37,height:Number=37){
			position = new Vector2D(x,y);
            boundingBox = new Rectangle(x, y,width,height);
		}
		
		public function get x():Number
		{
			return position.x;
		}

		public function set x(value:Number):void
		{
			position.x = value;

		}
		public function get y():Number
		{
			return position.y;
		}

		public function set y(value:Number):void
		{
			position.y = value;
		}

        public function get width():Number
        {
            return boundingBox.width;
        }

        public function set width(value:Number):void
        {
            boundingBox.width = value;
        }
        public function get height():Number
        {
            return boundingBox.height;
        }

        public function set height(value:Number):void
        {
            boundingBox.height = value;
        }
        
        public function getBoundingBox():Rectangle{
            boundingBox.x = position.x;
            boundingBox.y = position.y;
            return boundingBox;
        }

	}
}