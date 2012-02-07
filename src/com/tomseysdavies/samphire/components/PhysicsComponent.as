package com.tomseysdavies.samphire.components
{
import uk.co.bigroom.geom.Vector2D;

/**
	 * ...
	 * @author Tom Davies
	 */
	public class PhysicsComponent 
	{
		[Ember(skip = "true")]
		public var velocity:Vector2D = new Vector2D();		
		public var gravity:Boolean = true;
		
		public function PhysicsComponent(velX:Number =0,velY:Number=0,gravity=true){
            velocity.x = velX;
            velocity.y = velY;
            this.gravity = gravity;
		}
		public function set velX(value:Number):void {
			velocity.x = value;
		}
		
		public function get velX():Number {
			return velocity.x;
		}
		public function set velY(value:Number):void {
			velocity.y = value;
		}
		
		public function get velY():Number {
			return velocity.y;
		}

	}

}