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
	import starling.display.Quad;

	public class CCLayer extends CCNode
	{		
		protected var mQuad:Quad;
		
		public function CCLayer()
		{
		}
		
		public static function create():CCLayer
		{
			var pobLayer:CCLayer = new CCLayer();
			if (pobLayer.init())
				return pobLayer;
			return null;
		}
		
		public static function createWithSize(w:Number, h:Number):CCLayer
		{
			var pobLayer:CCLayer = new CCLayer();
			if (pobLayer.initWithSize(w, h))
				return pobLayer;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCLayer
		{
			var pobLayer:CCLayer = new CCLayer();
			if (pobLayer.initWithNodeProperty(nodeInfo))
				return pobLayer;
			return null;
		}
		
		public function init():Boolean
		{
			return initWithSize(CCDialogManager.ResourceWidth, CCDialogManager.ResourceHeight);
		}
		
		public function initWithSize(w:Number, h:Number):Boolean
		{
			var _w:Number = w == 0.0 ? 0.001 : w;
			var _h:Number = h == 0.0 ? 0.001 : h;
			mQuad = new Quad(_w, _h);
			this.contentSizeX = w;
			this.contentSizeY = h;
			return true;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			initWithSize(this.contentSizeX, this.contentSizeY);
			
			this.color = nodeInfo.getColor();
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			return true;
		}
				
		public function get color():uint { return mQuad.color; }
		public function set color(value:uint):void { mQuad.color = value; }
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			//CCNode.renderObject(support, parentAlpha, mQuad);
			
			super.render(support, parentAlpha);
		}
	}
}
