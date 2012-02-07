package com.tomseysdavies.samphire.assets
{
	import flash.display.MovieClip;

	public interface IAssetFactory
	{
		function get assets():Vector.<String>;
		function createAsset(name:String):MovieClip;
	}
}