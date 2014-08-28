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
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.Quad;

	public class CCLayerColor extends CCLayer
	{
		protected var mQuad:Quad;
		
		public function CCLayerColor()
		{
		}
		
		public static function create():CCLayerColor
		{
			var pobLayer:CCLayerColor = new CCLayerColor();
			if (pobLayer.init())
				return pobLayer;
			return null;
		}
		
		public static function createWithSize(w:Number, h:Number):CCLayerColor
		{
			var pobLayer:CCLayerColor = new CCLayerColor();
			if (pobLayer.initWithSize(w, h))
				return pobLayer;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCLayerColor
		{
			var pobLayer:CCLayerColor = new CCLayerColor();
			if (pobLayer.initWithNodeProperty(nodeInfo))
				return pobLayer;
			return null;
		}
		
		public override function init():Boolean
		{
			return initWithSize(CCDialogManager.ResourceWidth, CCDialogManager.ResourceHeight);
		}
		
		public override function initWithSize(w:Number, h:Number):Boolean
		{
			mQuad = new Quad(w, h);
			this.contentSizeX = w;
			this.contentSizeY = h;
			return true;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var absoluteContentSize:Point = nodeInfo.getAbsoluteContentSize(null, null);
			initWithSize(absoluteContentSize.x, absoluteContentSize.y);
			
			this.color = nodeInfo.getColor();
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			this.anchorPoint = nodeInfo.getAnchorPoint();
			return true;
		}
		
		public override function get color():uint { return mQuad.color; }
		public override function set color(value:uint):void { mQuad.color = value; }
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			CCNode.renderObject(support, parentAlpha, mQuad);
			
			super.render(support, parentAlpha);
		}
	}
}
