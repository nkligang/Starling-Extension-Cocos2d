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
	
	import starling.display.Quad;
	import starling.utils.Color;

	public class CCLayerGradient extends CCLayerColor
	{				
		public function CCLayerGradient()
		{
		}
		
		/*public function CCLayerGradient(nodeInfo:CCNodeProperty, nodeObject:CCContainer, parentObject:CCContainer)
		{
			var absoluteContentSize:Point = nodeInfo.getAbsoluteContentSize(nodeObject, parentObject);
			var startColorObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyStartColor);
			var startColor:uint = startColorObj != null ? startColorObj as uint : Color.WHITE;
			var endColorObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyEndColor);
			var endColor:uint = endColorObj != null ? endColorObj as uint : Color.WHITE;
			var midColor:uint = CCNodeProperty.getColorInterpolation(startColor, endColor, 0.5);
			var startOpacityObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyStartOpacity);
			var startAlpha:Number = CCNodeProperty.getOpacityFloat(startOpacityObj != null ? startOpacityObj as int : 255);
			var endOpacityObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyEndOpacity);
			var endAlpha:Number = CCNodeProperty.getOpacityFloat(endOpacityObj != null ? endOpacityObj as int : 255);
			var midAlpha:Number = startAlpha + (endAlpha - startAlpha) * 0.5;
			var vectorObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyVector);
			var vector:Point = vectorObj != null ? vectorObj as Point : new Point(0, 0);
			
			super(absoluteContentSize.x, absoluteContentSize.y, 0);
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			if (vector.x == 0 && vector.y == 0) {
				this.color = startColor;
				this.alpha = startAlpha;
			} else if (vector.x > 0 && vector.y < 0) {
				this.setVertexColor(0, midColor);
				this.setVertexColor(1, endColor);
				this.setVertexColor(2, startColor);
				this.setVertexColor(3, midColor);
				this.setVertexAlpha(0, midAlpha);
				this.setVertexAlpha(1, endAlpha);
				this.setVertexAlpha(2, startAlpha);
				this.setVertexAlpha(3, midAlpha);
			} else if (vector.x > 0 && vector.y > 0) {
				this.setVertexColor(0, startColor);
				this.setVertexColor(1, midColor);
				this.setVertexColor(2, midColor);
				this.setVertexColor(3, endColor);
				this.setVertexAlpha(0, startAlpha);
				this.setVertexAlpha(1, midAlpha);
				this.setVertexAlpha(2, midAlpha);
				this.setVertexAlpha(3, endAlpha);
			} else if (vector.x < 0 && vector.y < 0) {
				this.setVertexColor(0, endColor);
				this.setVertexColor(1, midColor);
				this.setVertexColor(2, midColor);
				this.setVertexColor(3, startColor);
				this.setVertexAlpha(0, endAlpha);
				this.setVertexAlpha(1, midAlpha);
				this.setVertexAlpha(2, midAlpha);
				this.setVertexAlpha(3, startAlpha);
			} else if (vector.x < 0 && vector.y > 0) {
				this.setVertexColor(0, midColor);
				this.setVertexColor(1, startColor);
				this.setVertexColor(2, endColor);
				this.setVertexColor(3, midColor);
				this.setVertexAlpha(0, midAlpha);
				this.setVertexAlpha(1, startAlpha);
				this.setVertexAlpha(2, endAlpha);
				this.setVertexAlpha(3, midAlpha);
			} else if (vector.x > 0 && vector.y == 0) {
				this.setVertexColor(0, startColor);
				this.setVertexColor(1, endColor);
				this.setVertexColor(2, startColor);
				this.setVertexColor(3, endColor);
				this.setVertexAlpha(0, startAlpha);
				this.setVertexAlpha(1, endAlpha);
				this.setVertexAlpha(2, startAlpha);
				this.setVertexAlpha(3, endAlpha);
			} else if (vector.x < 0 && vector.y == 0) {
				this.setVertexColor(0, endColor);
				this.setVertexColor(1, startColor);
				this.setVertexColor(2, endColor);
				this.setVertexColor(3, startColor);
				this.setVertexAlpha(0, endAlpha);
				this.setVertexAlpha(1, startAlpha);
				this.setVertexAlpha(2, endAlpha);
				this.setVertexAlpha(3, startAlpha);
			} else if (vector.x == 0 && vector.y > 0) {
				this.setVertexColor(0, startColor);
				this.setVertexColor(1, startColor);
				this.setVertexColor(2, endColor);
				this.setVertexColor(3, endColor);
				this.setVertexAlpha(0, startAlpha);
				this.setVertexAlpha(1, startAlpha);
				this.setVertexAlpha(2, endAlpha);
				this.setVertexAlpha(3, endAlpha);
			} else if (vector.x == 0 && vector.y < 0) {
				this.setVertexColor(0, endColor);
				this.setVertexColor(1, endColor);
				this.setVertexColor(2, startColor);
				this.setVertexColor(3, startColor);
				this.setVertexAlpha(0, endAlpha);
				this.setVertexAlpha(1, endAlpha);
				this.setVertexAlpha(2, startAlpha);
				this.setVertexAlpha(3, startAlpha);
			}
			
			this.anchorPoint = nodeInfo.getAnchorPoint();
		}*/
		
		public static function create():CCLayerGradient
		{
			var pobLayer:CCLayerGradient = new CCLayerGradient();
			if (pobLayer.init())
				return pobLayer;
			return null;
		}
		
		public static function createWithSize(w:Number, h:Number):CCLayerGradient
		{
			var pobLayer:CCLayerGradient = new CCLayerGradient();
			if (pobLayer.initWithSize(w, h))
				return pobLayer;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCLayerGradient
		{
			var pobLayer:CCLayerGradient = new CCLayerGradient();
			if (pobLayer.initWithNodeProperty(nodeInfo))
				return pobLayer;
			return null;
		}
		
		public function setColor(startColor:uint, endColor:uint):Boolean
		{
			return setColorPoint(startColor, endColor, new Point(0, -1));
		}
		
		public function setColorPoint(startColor:uint, endColor:uint, vector:Point):Boolean
		{
			var startAlpha:Number = Color.getAlphaFloat(startColor);
			var endAlpha:Number = Color.getAlphaFloat(endColor);
			var midAlpha:Number = startAlpha + (endAlpha - startAlpha) * 0.5;
			var midColor:uint = CCNodeProperty.getColorInterpolation(startColor, endColor, 0.5);
			if (vector.x == 0 && vector.y == 0) {
				this.color = startColor;
				this.alpha = startAlpha;
			} else if (vector.x > 0 && vector.y < 0) {
				mQuad.setVertexColor(0, midColor);
				mQuad.setVertexColor(1, endColor);
				mQuad.setVertexColor(2, startColor);
				mQuad.setVertexColor(3, midColor);
				mQuad.setVertexAlpha(0, midAlpha);
				mQuad.setVertexAlpha(1, endAlpha);
				mQuad.setVertexAlpha(2, startAlpha);
				mQuad.setVertexAlpha(3, midAlpha);
			} else if (vector.x > 0 && vector.y > 0) {
				mQuad.setVertexColor(0, startColor);
				mQuad.setVertexColor(1, midColor);
				mQuad.setVertexColor(2, midColor);
				mQuad.setVertexColor(3, endColor);
				mQuad.setVertexAlpha(0, startAlpha);
				mQuad.setVertexAlpha(1, midAlpha);
				mQuad.setVertexAlpha(2, midAlpha);
				mQuad.setVertexAlpha(3, endAlpha);
			} else if (vector.x < 0 && vector.y < 0) {
				mQuad.setVertexColor(0, endColor);
				mQuad.setVertexColor(1, midColor);
				mQuad.setVertexColor(2, midColor);
				mQuad.setVertexColor(3, startColor);
				mQuad.setVertexAlpha(0, endAlpha);
				mQuad.setVertexAlpha(1, midAlpha);
				mQuad.setVertexAlpha(2, midAlpha);
				mQuad.setVertexAlpha(3, startAlpha);
			} else if (vector.x < 0 && vector.y > 0) {
				mQuad.setVertexColor(0, midColor);
				mQuad.setVertexColor(1, startColor);
				mQuad.setVertexColor(2, endColor);
				mQuad.setVertexColor(3, midColor);
				mQuad.setVertexAlpha(0, midAlpha);
				mQuad.setVertexAlpha(1, startAlpha);
				mQuad.setVertexAlpha(2, endAlpha);
				mQuad.setVertexAlpha(3, midAlpha);
			} else if (vector.x > 0 && vector.y == 0) {
				mQuad.setVertexColor(0, startColor);
				mQuad.setVertexColor(1, endColor);
				mQuad.setVertexColor(2, startColor);
				mQuad.setVertexColor(3, endColor);
				mQuad.setVertexAlpha(0, startAlpha);
				mQuad.setVertexAlpha(1, endAlpha);
				mQuad.setVertexAlpha(2, startAlpha);
				mQuad.setVertexAlpha(3, endAlpha);
			} else if (vector.x < 0 && vector.y == 0) {
				mQuad.setVertexColor(0, endColor);
				mQuad.setVertexColor(1, startColor);
				mQuad.setVertexColor(2, endColor);
				mQuad.setVertexColor(3, startColor);
				mQuad.setVertexAlpha(0, endAlpha);
				mQuad.setVertexAlpha(1, startAlpha);
				mQuad.setVertexAlpha(2, endAlpha);
				mQuad.setVertexAlpha(3, startAlpha);
			} else if (vector.x == 0 && vector.y > 0) {
				mQuad.setVertexColor(0, startColor);
				mQuad.setVertexColor(1, startColor);
				mQuad.setVertexColor(2, endColor);
				mQuad.setVertexColor(3, endColor);
				mQuad.setVertexAlpha(0, startAlpha);
				mQuad.setVertexAlpha(1, startAlpha);
				mQuad.setVertexAlpha(2, endAlpha);
				mQuad.setVertexAlpha(3, endAlpha);
			} else if (vector.x == 0 && vector.y < 0) {
				mQuad.setVertexColor(0, endColor);
				mQuad.setVertexColor(1, endColor);
				mQuad.setVertexColor(2, startColor);
				mQuad.setVertexColor(3, startColor);
				mQuad.setVertexAlpha(0, endAlpha);
				mQuad.setVertexAlpha(1, endAlpha);
				mQuad.setVertexAlpha(2, startAlpha);
				mQuad.setVertexAlpha(3, startAlpha);
			}
			return true;
		}
	}
}
