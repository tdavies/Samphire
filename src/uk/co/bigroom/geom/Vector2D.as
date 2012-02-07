/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007-2008
 * Version: 1.0.1
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package uk.co.bigroom.geom 
{
	import flash.geom.Point;
	
	/**
	 * Vector2D represents a 2-dimensional vector in cartesian coordinate space.
	 * It has all features of flash.geom.Point but adds further
	 * functionality not found in that class. While this class represents a
	 * vector, it can also be used to represent a point, in which case
	 * the class actually represents the vector from the origin to the point.
	 * 
	 * <p>To convert between flash.geom.Point and this class, use the methods
	 * toPoint and fromPoint.</p>
	 * 
	 * <p>Aall the methods return a reference to the result, even when the result
	 * is the original vector. So you can chain methods together.
	 * e.g. <code>v.add( u ).multiply( 7 )</code></p>
	 */
	public class Vector2D
	{
		/**
		 * Creates a Vector2 object from polar coordinates.
		 * 
		 * @param len length coordinate.
		 * @param angle angle coordinate.
		 *
		 * @return true if the key is down, false otherwise.
		 */
		public static function polar( len:Number, angle:Number ):Vector2D
		{
			return new Vector2D( len * Math.cos( angle ), len * Math.sin( angle ) );
		}
		
		/**
		 * Creates a Vector2 object between the two input vectors.
		 * 
		 * @param v1 first input vector.
		 * @param v2 second input vector.
		 * @param f a value between 1 and 0 indicating how far between the two vectors
		 * to interpolate. A value of 1 returns v1 and a value of 0 returns v2.
		 *
		 * @return the vector created by interpolating between the inputs.
		 */
		public static function interpolate( v1:Vector2D, v2:Vector2D, f:Number ):Vector2D
		{
			return v2.add( v1.subtract( v2 ).multiply( f ) );
		}
		
		/**
		 * Calculates the distance between the points represented by the input vectors
		 * as vectors from the origin to the points.
		 * 
		 * @param v1 first input vector.
		 * @param v2 second input vector.
		 *
		 * @return the distance between the points.
		 */
		public static function distance( v1:Vector2D, v2:Vector2D ):Number
		{
			return Math.sqrt( Vector2D.distanceSquared( v1, v2 ) );
		}
		
		
		/**
		 * create a vector between the points represented by the input vectors
		 * as vectors from the origin to the points.
		 * 
		 * @param v1 first input vector.
		 * @param v2 second input vector.
		 *
		 * @return the diffence between the points as vector
		 */
		public static function diffenceVector( v1:Vector2D, v2:Vector2D ):Vector2D
		{
			return new Vector2D(v1.x - v2.x,v1.y - v2.y);
		}
		
	
		
		/**
		 * Calculates the square of the distance between the points represented by the
		 * input vectors as vectors from the origin to the points. This is faster than
		 * calculating the actual distance.
		 * 
		 * @param v1 first input vector.
		 * @param v2 second input vector.
		 *
		 * @return the square of the distance between the points.
		 */
		public static function distanceSquared( u:Vector2D, v:Vector2D ):Number
		{
			var dx:Number = u.x - v.x;
			var dy:Number = u.y - v.y;
			return ( dx * dx + dy * dy );
		}
		
	

		/**
		 * Returns a Vector2D object from the origin to the input point. Used to convert
		 * between flash.geom.Point objects and Vector2D objects.
		 * 
		 * @param pt the Point to convert to a Vector2D.
		 *
		 * @return a Vector2D object.
		 */
		public static function fromPoint( pt:Point ):Vector2D
		{
			return new Vector2D( pt.x, pt.y );
		}
		
		/**
		 * A zero vector.
		 */
		public static var ZERO:Vector2D = new Vector2D( 0, 0 );
		
		/**
		 * The x coordinate of the vector.
		 */
		public var x:Number;
		
		/**
		 * The y coordinate of the vector.
		 */
		public var y:Number;
		
		/**
		 * Constructor
		 *
		 * @param a the x coordinate of the vector
		 * @param b the y coordinate of the vector
		 */
		public function Vector2D( a:Number = 0, b:Number = 0 )
		{
			x = a;
			y = b;
		}
		
		/**
		 * Returns the Point that the vector would point to if placed at the origin.
		 * Used to convert from a Vector2 to a flash.geom.Point.
		 *
		 * @return a flash.geom.Point object
		 */
		public function toPoint():Point
		{
			return new Point( x, y );
		}
		
		/**
		 * Assign new coordinates to this vector
		 * 
		 * @param a The new x coordinate
		 * @param b The new y coordinate
		 * 
		 * @return a reference to this Vector2 object
		 */
		public function reset( a:Number = 0, b:Number = 0 ):Vector2D
		{
			x = a;
			y = b;
			return this;
		}
		
		/**
		 * Copy another vector into this one.
		 * 
		 * @param v The vector to copy
		 * 
		 * @return a reference to this Vector2 object
		 */
		public function assign( v:Vector2D ):Vector2D
		{
			x = v.x;
			y = v.y;
			return this;
		}
		
		/**
		 * Make a copy of this Vector2.
		 * 
		 * @return a copy of this Vector2
		 */
		public function clone():Vector2D
		{
			return new Vector2D( x, y );
		}
		
		/**
		 * Add another vector to this one, returning a new vector.
		 * 
		 * @param v the vector to add
		 * 
		 * @return the result of the addition
		 */
		public function add( v:Vector2D ):Vector2D
		{
			return new Vector2D( x + v.x, y + v.y );
		}
		
		/**
		 * Subtract another vector from this one, returning a new vector.
		 * 
		 * @param v the vector to subtract
		 * 
		 * @return the result of the subtraction
		 */		
		public function subtract( v:Vector2D ):Vector2D
		{
			return new Vector2D( x - v.x, y - v.y );
		}

		/**
		 * Multiply this vector by a number, returning a new vector.
		 * 
		 * @param s the number to multiply by
		 * 
		 * @return the result of the multiplication
		 */
		public function multiply( s:Number ):Vector2D
		{
			return new Vector2D( x * s, y * s );
		}
		
		/**
		 * Divide this vector by a number, returning a new vector.
		 * 
		 * @param s the number to divide by
		 * 
		 * @return the result of the division
		 */
		public function divide( s:Number ):Vector2D
		{
			return multiply( 1 / s );
		}

		/**
		 * Add another vector to this one.
		 * 
		 * @param v the vector to add
		 * 
		 * @return a reference to this vector
		 */
		public function incrementBy( v:Vector2D ):Vector2D
		{
			x += v.x;
			y += v.y;
			return this;
		}

		/**
		 * Subtract another vector from this one.
		 * 
		 * @param v the vector to subtract
		 * 
		 * @return a reference to this vector
		 */
		public function decrementBy( v:Vector2D ):Vector2D
		{
			x -= v.x;
			y -= v.y;
			return this;
		}

		/**
		 * Multiply this vector by a number.
		 * 
		 * @param s the number to multiply by
		 * 
		 * @return a reference to this vector
		 */
		public function scaleBy( s:Number ):Vector2D
		{
			x *= s;
			y *= s;
			return this;
		}
		
		/**
		 * Divide this vector by a number.
		 * 
		 * @param s the number to divide by
		 * 
		 * @return a reference to this vector
		 */
		public function divideBy( s:Number ):Vector2D
		{
			x /= s;
			y /= s;
			return this;
		}
		
		/**
		 * Rotate this vector, returning a new vector.
		 * @param angle The angle to rotate by, in radians.
		 * @return the new vector
		 */
		public function rotate( angle:Number ):Vector2D
		{
			var newAngle:Number = Math.atan2( y, x ) + angle;
			return Vector2D.polar( length, newAngle );
		}
		
		/**
		 * Rotate this vector.
		 * @param angle The angle to rotate by, in radians.
		 * @return the new vector
		 */
		public function rotateBy( angle:Number ):Vector2D
		{
			var newAngle:Number = Math.atan2( y, x ) + angle;
			var len:Number = length;
			x = len * Math.cos( newAngle );
			y = len * Math.sin( newAngle );
			return this;
		}

		/**
		 * Compare this vector to another
		 * 
		 * @param v the vector to compare with
		 * 
		 * @return true if the vectors have the same coordinates, false otherwise
		 */
		public function equals( v:Vector2D ):Boolean
		{
			return x == v.x && y == v.y;
		}

		/**
		 * Compare this vector to another
		 * 
		 * @param v the vector to compare with
		 * @param e the distance allowed between the points represented by the
		 * two vectors
		 * 
		 * @return true if the points represented by the vectors are within 
		 * distance e of each other, false otherwise
		 */
		public function nearEquals( v:Vector2D, e:Number ):Boolean
		{
			return subtract( v ).lengthSquared <= e * e;
		}
		
		/**
		 * Calculate the dot product of this vector with another
		 * 
		 * @param v the vector to calculate the dot product with
		 * 
		 * @return the dot product of the two vectors
		 */
		public function dotProduct( v:Vector2D ):Number
		{
			return ( x * v.x + y * v.y );
		}
		
		/**
		 * The length of this vector
		 */
		public function get length():Number
		{
			return Math.sqrt( lengthSquared );
		}
		
		/**
		 * The square of the length of this vector
		 */
		public function get lengthSquared():Number
		{
			return ( x * x + y * y );
		}
		
		/**
		 * Get the negative of this vector - a vector the same length but in the 
		 * opposite direction.
		 * 
		 * @return the negative of this vector
		 */
		public function negative():Vector2D
		{
			return new Vector2D( -x, -y );
		}
		
		/**
		 * A vector of the same length but perpendicular to this one.
		 * 
		 * @return the perpendicular vector
		 */
		public function perpendicular():Vector2D
		{
			return new Vector2D( -y, x );
		}
		
		/**
		 * Convert this vector to have length 1
		 * 
		 * @return a reference to this vector
		 */
		public function normalize():Vector2D
		{
			var s:Number = this.length;
			if ( s != 0 )
			{
				s = 1 / s;
				x *= s;
				y *= s;
			}
			else
			{
				x = undefined;
				y = undefined;
			}
			return this;
		}
		
		
		/**
		 * get the altha angle of this vector
		 * 
		 * @return altha angle
		 */
		public function angle():Number
		{
			return Math.atan2(y,x);
		}
		
		/**
		 * Create a unit vector in the same direction as this one
		 * 
		 * @return a unit vector in the same direction as this one
		 */
		public function unit():Vector2D
		{
			return clone().normalize();
		}
		
		/**
		 * Get a string representation of this vector
		 * 
		 * @return a string representation of this vector
		 */
		public function toString():String
		{
			return "(x=" + x + ", y=" + y + ")";
		}
	}
}
