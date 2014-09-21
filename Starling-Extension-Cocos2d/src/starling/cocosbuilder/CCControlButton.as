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
	import starling.display.Button;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class CCControlButton extends CCNode
	{
		private var mButton:Button;
		
		public function CCControlButton()
		{
		}
		
		public static function create(upState:Texture, text:String="", downState:Texture=null):CCControlButton
		{
			var pobButton:CCControlButton = new CCControlButton();
			if (pobButton.init(upState, text, downState))
				return pobButton;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCControlButton
		{
			var pobButton:CCControlButton = new CCControlButton();
			if (pobButton.initWithNodeProperty(nodeInfo))
				return pobButton;
			return null;
		}
		
		public function init(upState:Texture, text:String, downState:Texture):Boolean
		{
			mButton = new Button(upState, text, downState);
			return true;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var backgroundSpriteFrame1:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyBackgroundSpriteFrame1) as CCSpriteFrame;
			var backgroundSpriteFrame2:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyBackgroundSpriteFrame2) as CCSpriteFrame;
			var backgroundSpriteFrame3:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyBackgroundSpriteFrame3) as CCSpriteFrame;
			var title1:String = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyTitle1) as String;
			var titleTTF1:String = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyTitleTTF1) as String;
			var titleTTFSize1:CCTypeFloatScale = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyTitleTTFSize1) as CCTypeFloatScale;
			var titleColor1Obj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyTitleColor1);
			var titleColor1:uint = titleColor1Obj != null ? titleColor1Obj as uint : Color.WHITE;
			var titleColor2Obj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyTitleColor2);
			var titleColor2:uint = titleColor2Obj != null ? titleColor2Obj as uint : Color.WHITE;
			var titleColor3Obj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyTitleColor3);
			var titleColor3:uint = titleColor3Obj != null ? titleColor3Obj as uint : Color.WHITE;
			var preferedSizeObj2:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyPreferedSize);
			var preferedSize2:CCTypeSize = preferedSizeObj2 != null ? preferedSizeObj2 as CCTypeSize : new CCTypeSize;
			var labelAnchorPointObj:Point = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyLabelAnchorPoint) as Point;
			var labelAnchorPoint:Point = labelAnchorPointObj != null ? labelAnchorPointObj : new Point(0.5, 0.5);
			
			init(backgroundSpriteFrame1.getTexture(), titleTTF1, backgroundSpriteFrame2.getTexture());
			//this.fontSize = titleTTFSize1.scale;
			//this.fontColor = titleColor1;
			
			this.anchorPoint = nodeInfo.getAnchorPoint();
			
			this.alpha = 0.0;
			this.anchorPoint = nodeInfo.getAnchorPoint();
			return true;
		}
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			CCNode.renderObject(support, parentAlpha, mButton);
			super.render(support, parentAlpha);
		}
	}
}
