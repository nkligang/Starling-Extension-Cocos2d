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
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	public class CCSprite extends CCNode
	{
		private var mImage:Image = null;
		
		public function CCSprite()
		{
			this.anchorPointX = 0.5;
			this.anchorPointY = 0.5;
		}
		
		public static function create(pszFileName:String):CCSprite
		{
			var pobSprite:CCSprite = new CCSprite();
			if (pobSprite.initWithFile(pszFileName))
				return pobSprite;
			return null;
		}
		
		public static function createWithTexture(pTexture:Texture):CCSprite
		{
			var pobSprite:CCSprite = new CCSprite();
			if (pobSprite.initWithTexture(pTexture))
				return pobSprite;
			return null;
		}
		
		public static function createWithSpriteFrame(pSpriteFrame:CCSpriteFrame):CCSprite
		{
			var pobSprite:CCSprite = new CCSprite();
			if (pobSprite.initWithSpriteFrame(pSpriteFrame))
				return pobSprite;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCSprite
		{
			var pobSprite:CCSprite = new CCSprite();
			if (pobSprite.initWithNodeProperty(nodeInfo))
				return pobSprite;
			return null;
		}
		
		public function initWithFile(pszFileName:String):Boolean
		{
			var pTexture:Texture = CCBReader.assets.getTexture(pszFileName);
			if (pTexture == null) return false;
			return initWithTexture(pTexture);
		}
		
		public function initWithTexture(pTexture:Texture):Boolean
		{
			mImage = new Image(pTexture);
			if (pTexture is SubTexture) {
				var pSubTexture:SubTexture = pTexture as SubTexture;
				var frame:Rectangle = pSubTexture.frame;
				this.contentSizeX = frame ? frame.width  : pSubTexture.width;
				this.contentSizeY = frame ? frame.height : pSubTexture.height;
			} else {
				this.contentSizeX = pTexture.width;
				this.contentSizeY = pTexture.height;
			}
			return true;
		}
		
		public function initWithSpriteFrame(pSpriteFrame:CCSpriteFrame):Boolean
		{
			return initWithTexture(pSpriteFrame.getTexture());
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var spriteFrame:CCSpriteFrame = nodeInfo.getProperty(CCBSequenceProperty.CCBKeyframeTypeDisplayFrame) as CCSpriteFrame;
			if (spriteFrame != null)
			{
				initWithSpriteFrame(spriteFrame);
								
				this.blendMode = nodeInfo.getBlendFunc();
				var flip:int = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyFlip) as int;
				if (flip > 0)
				{
					if (CCNodeProperty.IsFlipX(flip)) {
						mImage.scaleX = -mImage.scaleX;
						mImage.x = this.contentSizeX;
					}
					if (CCNodeProperty.IsFlipY(flip)) {
						mImage.scaleY = -mImage.scaleY;
						mImage.y = this.contentSizeY;
					}
				}
				
				this.color = nodeInfo.getColor();
				this.rotation = nodeInfo.getRotation();
				this.touchable = nodeInfo.isTouchable();
				this.alpha = nodeInfo.getOpacity();
				return true;
			}
			else
			{
				throw new Error("CCSprite: no sprite frame has been set.");
			}
			return false;
		}
				
		public function get color():uint { return mImage.color; }
		public function set color(value:uint):void { mImage.color = value; }
		
		public function get texture():Texture { return mImage.texture; }
		public function set texture(value:Texture):void {
			mImage.texture = value;
			mImage.readjustSize();
			if (value is SubTexture) {
				var pSubTexture:SubTexture = value as SubTexture;
				var frame:Rectangle = pSubTexture.frame;
				this.contentSizeX = frame ? frame.width  : pSubTexture.width;
				this.contentSizeY = frame ? frame.height : pSubTexture.height;
			} else {
				this.contentSizeX = value.width;
				this.contentSizeY = value.height;
			}
		}
		
		public override function get alpha():Number { return mImage.alpha; }
		public override function set alpha(value:Number):void 
		{ 
			mImage.alpha = value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value); 
		}
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			CCNode.renderObject(support, parentAlpha, mImage);
			super.render(support, parentAlpha);
		}
	}
}
