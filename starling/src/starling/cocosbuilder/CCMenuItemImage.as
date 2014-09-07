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

	public class CCMenuItemImage extends CCMenuItem
	{		
		public function CCMenuItemImage()
		{
		}
		
		public static function create():CCMenuItemImage
		{
			var pobMenuImage:CCMenuItemImage = new CCMenuItemImage();
			if (pobMenuImage.init())
				return pobMenuImage;
			return null;
		}
				
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCMenuItemImage
		{
			var pobMenuImage:CCMenuItemImage = new CCMenuItemImage();
			if (pobMenuImage.initWithNodeProperty(nodeInfo))
				return pobMenuImage;
			return null;
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
