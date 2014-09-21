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

	public class CCMenu extends CCLayer
	{		
		public function CCMenu()
		{
		}
		
		public static function create():CCMenu
		{
			var pobMenu:CCMenu = new CCMenu();
			if (pobMenu.init())
				return pobMenu;
			return null;
		}
				
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCLayer
		{
			var pobLayer:CCLayer = new CCLayer();
			if (pobLayer.initWithNodeProperty(nodeInfo))
				return pobLayer;
			return null;
		}
				
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			initWithSize(this.contentSizeX, this.contentSizeY);
			
			this.color = nodeInfo.getColor();
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			return true;
		}
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			//CCNode.renderObject(support, parentAlpha, mQuad);
			
			super.render(support, parentAlpha);
		}
	}
}
