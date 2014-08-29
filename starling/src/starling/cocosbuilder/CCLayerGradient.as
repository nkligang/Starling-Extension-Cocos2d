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
	
	import starling.utils.Color;

	public class CCLayerGradient extends CCLayerColor
	{				
		public function CCLayerGradient()
		{
		}
		
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
