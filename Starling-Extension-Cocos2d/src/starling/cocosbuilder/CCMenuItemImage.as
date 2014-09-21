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
	import starling.display.Image;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	public class CCMenuItemImage extends CCMenuItem
	{		
		private var mNormalImage:Image;
		private var mSelectedImage:Image;
		private var mDisabledImage:Image;

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
			var normalSpriteFrame:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyNormalSpriteFrame) as CCSpriteFrame;
			var value:Texture = normalSpriteFrame.getTexture();
			if (value is SubTexture) {
				var pSubTexture:SubTexture = value as SubTexture;
				this.contentSizeX = pSubTexture.frame.width;
				this.contentSizeY = pSubTexture.frame.height;
			} else {
				this.contentSizeX = value.width;
				this.contentSizeY = value.height;
			}
			super.initWithNodeProperty(nodeInfo);
			
			mNormalImage = new Image(value);

			var selectedSpriteFrame:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertySelectedSpriteFrame) as CCSpriteFrame;
			if (selectedSpriteFrame.getTexture() != null)
				mSelectedImage = new Image(selectedSpriteFrame.getTexture());
			
			var disabledSpriteFrame:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyDisabledSpriteFrame) as CCSpriteFrame;
			if (disabledSpriteFrame.getTexture() != null)
				mDisabledImage = new Image(disabledSpriteFrame.getTexture());
			
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			return true;
		}
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mEnabled) {
				if (mSelected) {
					if (mSelectedImage != null) {
						CCNode.renderObject(support, parentAlpha, mSelectedImage);
					}
				} else {
					if (mNormalImage != null) {
						CCNode.renderObject(support, parentAlpha, mNormalImage);
					}
				}
			} else {
				if (mDisabledImage != null) {
					CCNode.renderObject(support, parentAlpha, mDisabledImage);
				}
			}
			super.render(support, parentAlpha);
		}
	}
}
