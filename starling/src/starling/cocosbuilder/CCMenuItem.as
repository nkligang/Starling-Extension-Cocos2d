// =================================================================================================
//
//	Starling Framework Extension
//	Copyright 2014 nkligang(nkligang@163.com). All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.cocosbuilder
{
	import starling.core.RenderSupport;

	public class CCMenuItem extends CCNode
	{		
		public function CCMenuItem()
		{
		}
		
		public static function create():CCMenuItem
		{
			var pobMenuItem:CCMenuItem = new CCMenuItem();
			if (pobMenuItem.init())
				return pobMenuItem;
			return null;
		}
				
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCMenuItem
		{
			var pobMenuItem:CCMenuItem = new CCMenuItem();
			if (pobMenuItem.initWithNodeProperty(nodeInfo))
				return pobMenuItem;
			return null;
		}
		
		public function init():Boolean
		{
			return false;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			init();
			
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			return true;
		}
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support, parentAlpha);
		}
	}
}
