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
	import flash.utils.Dictionary;
	
	import starling.display.BlendMode;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;

	public class CCNodeProperty
	{
		private var mClassName:String;

		private var mChildren:Vector.<CCNodeProperty>;
		private var mParent:CCNodeProperty;
		
		private var mSequences:Dictionary;
		private var mProperties:Dictionary;
		
		public static const CCBNodePropertyColor:String                        = "color";
		public static const CCBNodePropertyOpacity:String                      = "opacity";
		public static const CCBNodePropertyBlendFunc:String                    = "blendFunc";
		public static const CCBNodePropertyFlip:String                         = "flip";
		public static const CCBNodePropertyMemberVarAssignmentName:String      = "memberVarAssignmentName";
		public static const CCBNodePropertyFontName:String                     = "fontName";
		public static const CCBNodePropertyFontSize:String                     = "fontSize";
		public static const CCBNodePropertyDimensions:String                   = "dimensions";
		public static const CCBNodePropertyString:String                       = "string";
		public static const CCBNodePropertyHorizontalAlignment:String          = "horizontalAlignment";
		public static const CCBNodePropertyVerticalAlignment:String            = "verticalAlignment";
		public static const CCBNodePropertyRotation:String                     = "rotation";
		public static const CCBNodePropertyFntFile:String                      = "fntFile";
		public static const CCBNodePropertyContentSize:String                  = "contentSize";
		public static const CCBNodePropertyStartColor:String                   = "startColor";
		public static const CCBNodePropertyEndColor:String                     = "endColor";
		public static const CCBNodePropertyStartOpacity:String                 = "startOpacity";
		public static const CCBNodePropertyEndOpacity:String                   = "endOpacity";
		public static const CCBNodePropertyVector:String                       = "vector";
		public static const CCBNodePropertySpriteFrame:String                  = "spriteFrame";
		public static const CCBNodePropertyPreferedSize:String                 = "preferedSize";
		public static const CCBNodePropertyInsetLeft:String                    = "insetLeft";
		public static const CCBNodePropertyInsetTop:String                     = "insetTop";
		public static const CCBNodePropertyInsetRight:String                   = "insetRight";
		public static const CCBNodePropertyInsetBottom:String                  = "insetBottom";
		public static const CCBNodePropertyBackgroundSpriteFrame1:String       = "backgroundSpriteFrame|1";
		public static const CCBNodePropertyBackgroundSpriteFrame2:String       = "backgroundSpriteFrame|2";
		public static const CCBNodePropertyBackgroundSpriteFrame3:String       = "backgroundSpriteFrame|3";
		public static const CCBNodePropertyTitle1:String                       = "title|1";
		public static const CCBNodePropertyTitleTTF1:String                    = "titleTTF|1";
		public static const CCBNodePropertyTitleTTFSize1:String                = "titleTTFSize|1";
		public static const CCBNodePropertyTitleColor1:String                  = "titleColor|1";
		public static const CCBNodePropertyTitleColor2:String                  = "titleColor|2";
		public static const CCBNodePropertyTitleColor3:String                  = "titleColor|3";
		public static const CCBNodePropertyLabelAnchorPoint:String             = "labelAnchorPoint";
		public static const CCBNodePropertyPosition:String                     = "position";
		public static const CCBNodePropertyScale:String                        = "scale";
		public static const CCBNodePropertyVisible:String                      = "visible";
		public static const CCBNodePropertyAnchorPoint:String                  = "anchorPoint";
		public static const CCBNodePropertyIgnoreAnchorPointForPosition:String = "ignoreAnchorPointForPosition";
		public static const CCBNodePropertyCCBFile:String                      = "ccbFile";
		public static const CCBNodePropertyIsTouchEnabled:String               = "isTouchEnabled";
		public static const CCBNodePropertyIsAccelerometerEnabled:String       = "isAccelerometerEnabled";
		public static const CCBNodePropertyIsKeyboardEnabled:String            = "isKeyboardEnabled";
		public static const CCBNodePropertyMouseEnabled:String                 = "mouseEnabled";
				
		public function CCNodeProperty(className:String, parent:CCNodeProperty)
		{
			mClassName = className;
			mParent = parent;
			mChildren = new <CCNodeProperty>[];
			mProperties = new Dictionary();
		}
		
		public function addChild(child:CCNodeProperty):CCNodeProperty
		{
			mChildren.push(child);
			return child;
		}
		
		public function getChildren():Vector.<CCNodeProperty> { return mChildren; }
		
		public function setSequences(seqs:Dictionary):void
		{
			mSequences = seqs;
		}
		
		public function getSequence(seqId:int):Dictionary
		{
			if (mSequences == null) return null;
			return mSequences[seqId];
		}
		
		public function setProperty(name:String, value:Object):void
		{
			mProperties[name] = value;
		}
		
		public function getProperty(name:String):Object { return mProperties[name]; }
		
		public function get className():String { return mClassName; }
		
		public static const FLIP_BIT_X:int = 1;
		public static const FLIP_BIT_Y:int = 2;
		
		public static function MakeFlipValue(xFlip:Boolean, yFlip:Boolean):int {
			return (xFlip ? FLIP_BIT_X : 0) | (yFlip ? FLIP_BIT_Y : 0);
		}
		public static function IsFlipX(flip:int):Boolean { return (flip & FLIP_BIT_X) != 0; }
		public static function IsFlipY(flip:int):Boolean { return (flip & FLIP_BIT_Y) != 0; }
		
		public static function getOpacityFloat(v:int):Number { return v * 0.00392156862746; }
		
		public static function getPosition(position:CCTypeSize, parentObject:CCNode, nodeObject:CCNode, result:Point = null):Point
		{
			if (result == null) result = new Point(0, 0);
			var offset:Point = new Point(0, 0);
			if (parentObject != null)
			{
				//parentObject.localOffset(offset);
			}
			switch (position.type)
			{
				case CCTypeSize.CCTypePositionTypeAbsolute:
				{
					result.x = offset.x + position.x;
					result.y = offset.y + position.y;
					return result;
				}
				case CCTypeSize.CCTypePositionTypePercentageOfContainerSize:
				{
					if (parentObject != null)
					{
						result.x = offset.x + parentObject.contentSizeX * position.x / 100;
						result.y = offset.y + parentObject.contentSizeY * position.y / 100;
						return result;
					}
					else
					{
						result.x = CCDialogManager.ResourceWidth  * position.x / 100;
						result.y = CCDialogManager.ResourceHeight * position.y / 100;
						return result;
					}
				}
				default:
				{
					throw new Error("getPosition: not implement type: " + position.type);
					return result;
				}
			}
			return result;
		}
		
		public static function getContentSize(contentSize:CCTypeSize, parentObject:CCNode, nodeObject:CCNode, result:Point = null):Point
		{
			switch (contentSize.type)
			{
				case CCTypeSize.CCTypeSizeTypeAbsolute:
				{
					if (result == null) return new Point(contentSize.x, contentSize.y);
					result.x = contentSize.x;
					result.y = contentSize.y;
					return result;
				}
				case CCTypeSize.CCTypeSizeTypePercentageOfContainerSize:
				{
					if (parentObject != null)
					{
						if (result == null) return new Point(parentObject.contentSizeX * contentSize.x / 100, parentObject.contentSizeY * contentSize.y / 100);
						result.x = parentObject.contentSizeX * contentSize.x / 100;
						result.y = parentObject.contentSizeY * contentSize.y / 100;
						return result;
					}
					else
					{
						if (result == null) return new Point(CCDialogManager.ResourceWidth * contentSize.x / 100, CCDialogManager.ResourceHeight * contentSize.y / 100);
						result.x = CCDialogManager.ResourceWidth  * contentSize.x / 100;
						result.y = CCDialogManager.ResourceHeight * contentSize.y / 100;
						return result;
					}
				}
				default:
				{
					throw new Error("getContentSize: not implement type: " + contentSize.type);
					return result;
				}
			}
			return result;
		}
		
		public static function getScale(scale:CCTypeSize, parentObject:CCNode, nodeObject:CCNode, result:Point = null):Point
		{
			switch (scale.type)
			{
				case CCTypeSize.CCTypeScaleTypeAbsolute:
				{
					if (result == null) return new Point(scale.x, scale.y);
					result.x = scale.x;
					result.y = scale.y;
					return result;
				}
				case CCTypeSize.CCTypeScaleTypeMultiplyByResolutionScale:
				{
					if (result == null) return new Point(scale.x, scale.y);
					result.x = scale.x * CCDialogManager.GlobalScale;
					result.y = scale.y * CCDialogManager.GlobalScale;
					return result;
				}
				default:
				{
					throw new Error("getScale: not implement type: " + scale.type);
					return result;
				}
			}
			return result;
		}
		
		public static function getColorInterpolation(startColor:uint, endColor:uint, ratio:Number):uint
		{
			var rThis:int = Color.getRed(startColor);
			var gThis:int = Color.getGreen(startColor);
			var bThis:int = Color.getBlue(startColor);
			var rNext:int = Color.getRed(endColor);
			var gNext:int = Color.getGreen(endColor);
			var bNext:int = Color.getBlue(endColor);
			var r:int = (int)(rThis + (rNext - rThis) * ratio);
			var g:int = (int)(gThis + (gNext - gThis) * ratio);
			var b:int = (int)(bThis + (bNext - bThis) * ratio);
			return Color.argb(255, r, g, b);
		}
		
		private static function getHorizontalAlignment(v:int):String
		{
			switch (v) {
				case 0: return HAlign.LEFT;
				case 1: return HAlign.CENTER;
				case 2: return HAlign.RIGHT;
			}
			return HAlign.CENTER;
		}
		
		private static function getVerticalAlignment(v:int):String
		{
			switch (v) {
				case 0: return VAlign.TOP;
				case 1: return VAlign.CENTER;
				case 2: return VAlign.BOTTOM;
			}
			return VAlign.CENTER;
		}
		
		
		private static const GL_ZERO:int                         = 0;
		private static const GL_ONE:int                          = 1;
		private static const GL_SRC_COLOR:int                    = 0x0300;
		private static const GL_ONE_MINUS_SRC_COLOR:int          = 0x0301;
		private static const GL_SRC_ALPHA:int                    = 0x0302;
		private static const GL_ONE_MINUS_SRC_ALPHA:int          = 0x0303;
		private static const GL_DST_ALPHA:int                    = 0x0304;
		private static const GL_ONE_MINUS_DST_ALPHA:int          = 0x0305;
		private static const GL_DST_COLOR:int                    = 0x0306;
		private static const GL_ONE_MINUS_DST_COLOR:int          = 0x0307;
		private static const GL_SRC_ALPHA_SATURATE:int           = 0x0308;
		public function getBlendFunc():String {
			var blendFuncObj:Array = mProperties[CCBNodePropertyBlendFunc] as Array;
			if (blendFuncObj == null) return BlendMode.NORMAL;
			var src:int = blendFuncObj[0];
			var dst:int = blendFuncObj[1];
			var blendMode:String = BlendMode.NORMAL;
			if (src == GL_SRC_ALPHA && dst == GL_ONE)
				blendMode = BlendMode.SCREEN;
			else if (src == GL_ONE && dst == GL_ONE_MINUS_SRC_ALPHA)
				blendMode = BlendMode.NORMAL;
			else if (src == GL_ONE && dst == GL_ONE)
				blendMode = BlendMode.ADD;
			else if (src == GL_SRC_ALPHA && dst == GL_ONE_MINUS_SRC_ALPHA)
				blendMode = BlendMode.NORMAL;
			else if (src == GL_ONE_MINUS_DST_COLOR && dst == GL_DST_ALPHA)
				blendMode = BlendMode.MULTIPLY;
			else if (src == GL_DST_COLOR && dst == GL_ONE_MINUS_SRC_ALPHA)
				blendMode = BlendMode.NORMAL;
			else
				throw new Error("unknown blend mode");			
			return blendMode;
		}

		public function getAnchorPoint():Point {
			var anchorPointObj:Point = mProperties[CCBNodePropertyAnchorPoint] as Point;
			var anchorPoint:Point = anchorPointObj != null ? anchorPointObj : new Point(0.5, 0.5);
			return anchorPoint;
		}
		
		public function isIgnoreAnchorPointForPosition():Boolean {
			var ignoreAnchorPointForPositionObj:Object = mProperties[CCBNodePropertyIgnoreAnchorPointForPosition];
			return ignoreAnchorPointForPositionObj != null ? ignoreAnchorPointForPositionObj as Boolean : false;
		}
		
		public function getOpacity():Number {
			var opacityObj:Object = mProperties[CCBNodePropertyOpacity];
			var opacity:int = opacityObj != null ? opacityObj as int : 255;
			return opacity * 0.00392156862746;
		}
		
		public function getColor():uint {
			var colorObj:Object = mProperties[CCBNodePropertyColor];
			return colorObj != null ? colorObj as uint : Color.WHITE;
		}
		
		public function getAbsoluteContentSize(nodeObject:CCNode, parentObject:CCNode):Point {
			var contentSizeObj:Object = mProperties[CCBNodePropertyContentSize];
			var contentSize:CCTypeSize = contentSizeObj != null ? contentSizeObj as CCTypeSize : new CCTypeSize;
			return getContentSize(contentSize, parentObject, nodeObject);
		}
		
		public function isTouchable():Boolean {
			var isTouchEnabledObj:Object = mProperties[CCBNodePropertyIsTouchEnabled];
			return isTouchEnabledObj != null ? isTouchEnabledObj as Boolean : false;
		}
		
		public function getRotation():Number {
			var rotationObj:Object = mProperties[CCBNodePropertyRotation];
			return rotationObj != null ? deg2rad(rotationObj as Number) : 0;
		}
		
		public function isVisible():Boolean {
			var visibleObj:Object = mProperties[CCBNodePropertyVisible];
			return visibleObj != null ? visibleObj as Boolean : true;
		}
		
		public function getHorizontalAlignment():String
		{
			var hAlignObj:Object = mProperties[CCBNodePropertyHorizontalAlignment];
			var hAlign:int = hAlignObj != null ? hAlignObj as int : 1;
			return CCNodeProperty.getHorizontalAlignment(hAlign);
		}
		
		public function getVerticalAlignment():String
		{
			var vAlignObj:Object = mProperties[CCBNodePropertyVerticalAlignment];
			var vAlign:int = vAlignObj != null ? vAlignObj as int : 1;
			return CCNodeProperty.getVerticalAlignment(vAlign);
		}
		
		public function getPosition(parentObject:CCNode, nodeObject:CCNode, result:Point = null):Point
		{
			if (result == null) result = new Point;
			var positionObj:CCTypeSize = mProperties[CCBNodePropertyPosition] as CCTypeSize;
			var position:CCTypeSize = positionObj != null ? positionObj : new CCTypeSize;
			CCNodeProperty.getPosition(position, parentObject, nodeObject, result);
			return result;
		}
		
		public function getPositionEx():CCTypeSize
		{
			var positionObj:CCTypeSize = mProperties[CCBNodePropertyPosition] as CCTypeSize;
			var position:CCTypeSize = positionObj != null ? positionObj : new CCTypeSize;
			return position;
		}
		
		public function getScale(parentObject:CCNode, nodeObject:CCNode, result:Point = null):Point
		{
			if (result == null) result = new Point;
			var scaleObj:CCTypeSize = mProperties[CCBNodePropertyScale] as CCTypeSize;
			var scale:CCTypeSize = scaleObj != null ? scaleObj : new CCTypeSize(1,1,0);
			CCNodeProperty.getScale(scale, parentObject, nodeObject, result);
			return result;
		}
	}
}
