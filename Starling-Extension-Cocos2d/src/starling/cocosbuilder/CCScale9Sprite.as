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
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.filters.FragmentFilter;
	import starling.textures.Texture;

	public class CCScale9Sprite extends CCNode
	{		
		private var mTexture:Texture;
		
		private var mPreferredSize:Point = new Point();
		
		private var mColor:uint;
		
		private var mInsets:Rectangle = new Rectangle();

		private var mInvalid:Boolean;
		
		// Top
		private var mImageLT:Image; // Left
		private var mImageMT:Image; // Middle
		private var mImageRT:Image; // Right

		// Middle
		private var mImageLM:Image; // Left
		private var mImageMM:Image; // Middle
		private var mImageRM:Image; // Right
		
		// Bottom
		private var mImageLB:Image; // Left
		private var mImageMB:Image; // Middle
		private var mImageRB:Image; // Right
		
		public function CCScale9Sprite()
		{
		}
		
		public static function create(pszFileName:String):CCScale9Sprite
		{
			var pobSprite:CCScale9Sprite = new CCScale9Sprite();
			if (pobSprite.initWithFile(pszFileName))
				return pobSprite;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCScale9Sprite
		{
			var pobSprite:CCScale9Sprite = new CCScale9Sprite();
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
			var frame:Rectangle = pTexture.frame;
			var w:Number = frame ? frame.width  : pTexture.width;
			var h:Number = frame ? frame.height : pTexture.height;
			
			mInsets.left   = 0;
			mInsets.top    = 0;
			mInsets.right  = 0;
			mInsets.bottom = 0;
			mPreferredSize.x = w;
			mPreferredSize.y = h;
			
			this.texture = pTexture;
			this.preferredSize = new Point(w, h);
			return true;
		}
				
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var spriteFrame:CCSpriteFrame = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertySpriteFrame) as CCSpriteFrame;
			if (spriteFrame != null)
			{
				var preferedSizeObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyPreferedSize);
				var preferedSize:CCTypeSize = preferedSizeObj != null ? preferedSizeObj as CCTypeSize : new CCTypeSize;
				var preferedAbsoluteSize:Point = CCNodeProperty.getContentSize(preferedSize, null, null);
				var insetLeftObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyInsetLeft);
				mInsets.left = insetLeftObj != null ? insetLeftObj as Number : 0;
				var insetRightObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyInsetRight);
				mInsets.right = insetRightObj != null ? insetRightObj as Number : 0;
				var insetTopObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyInsetTop);
				mInsets.top = insetTopObj != null ? insetTopObj as Number : 0;
				var insetBottomObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyInsetBottom);
				mInsets.bottom = insetBottomObj != null ? insetBottomObj as Number : 0;
				//var pma:Boolean = mTexture.premultipliedAlpha;
				
				mColor = 0xFFFFFF;
				mInvalid = false;
				
				this.texture = spriteFrame.getTexture();
				this.preferredSize = preferedAbsoluteSize;
				
				this.color = color;
				this.alpha = nodeInfo.getOpacity();
				
				this.touchable = nodeInfo.isTouchable();
			}
			else
			{
				throw new ArgumentError("CCScale9Sprite: no sprite frame has been set.");
			}
			return true;
		}
		
		public function get texture():Texture { return mTexture; }
		public function set texture(value:Texture):void 
		{ 
			if (value == null)
			{
				throw new ArgumentError("Texture cannot be null");
			}
			else if (value != mTexture)
			{
				mTexture = value;
				
				var frame:Rectangle = mTexture.frame;
				var w:Number = frame ? frame.width  : mTexture.width;
				var h:Number = frame ? frame.height : mTexture.height;
				
				var insetLeft:Number   = mInsets.left;
				var insetRight:Number  = mInsets.right;
				var insetTop:Number    = mInsets.top;
				var insetBottom:Number = mInsets.bottom;
				// all inset is zero, default set to equal divide
				if (insetLeft == 0 && insetTop == 0 && insetRight == 0 && insetBottom == 0) {
					insetLeft = insetRight = w/3;
					insetTop = insetBottom = h/3;
				}
				
				// top
				var textureLT:Texture = Texture.fromTexture(mTexture, new Rectangle(0, 0, insetLeft, insetTop));
				if (mImageLT == null)
					mImageLT = new Image(textureLT);
				else
					mImageLT.texture = textureLT;
				
				var textureT:Texture = Texture.fromTexture(mTexture, new Rectangle(insetLeft, 0, w - insetLeft - insetRight, insetTop));
				if (mImageMT == null)
					mImageMT = new Image(textureT);
				else
					mImageMT.texture = textureT;
				
				var textureRT:Texture = Texture.fromTexture(mTexture, new Rectangle(w - insetRight, 0, insetRight, insetTop));
				if (mImageRT == null)
					mImageRT = new Image(textureRT);
				else
					mImageRT.texture = textureRT;
				
				// middle
				var textureLM:Texture = Texture.fromTexture(mTexture, new Rectangle(0, insetTop, insetLeft, h - insetTop - insetBottom));
				if (mImageLM == null)
					mImageLM = new Image(textureLM);
				else
					mImageLM.texture = textureLM;
				
				var textureMM:Texture = Texture.fromTexture(mTexture, new Rectangle(insetLeft, insetTop, w - insetLeft - insetRight, h - insetTop - insetBottom));
				if (mImageMM == null)
					mImageMM = new Image(textureMM);
				else
					mImageMM.texture = textureMM;
				
				var textureRM:Texture = Texture.fromTexture(mTexture, new Rectangle(w - insetRight, insetTop, insetRight, h - insetTop - insetBottom));
				if (mImageRM == null)
					mImageRM = new Image(textureRM);
				else
					mImageRM.texture = textureRM;
				
				// bottom
				var textureLB:Texture = Texture.fromTexture(mTexture, new Rectangle(0, h - insetBottom, insetLeft, insetBottom));
				if (mImageLB == null)
					mImageLB = new Image(textureLB);
				else
					mImageLB.texture = textureLB;
				
				var textureMB:Texture = Texture.fromTexture(mTexture, new Rectangle(insetLeft, h - insetBottom, w - insetLeft - insetRight, insetBottom));
				if (mImageMB == null)
					mImageMB = new Image(textureMB);
				else
					mImageMB.texture = textureMB;
				
				var textureRB:Texture = Texture.fromTexture(mTexture, new Rectangle(w - insetRight, h - insetBottom, insetRight, insetBottom));
				if (mImageRB == null)
					mImageRB = new Image(textureRB);
				else
					mImageRB.texture = textureRB;
			}
		}
		
		/** Returns the color of the quad, or of vertex 0 if vertices have different colors. */
		public function get color():uint 
		{ 
			return mColor; 
		}
		
		/** Sets the colors of all vertices to a certain value. */
		public function set color(value:uint):void 
		{
			if (mColor == value) return;
			mColor = value;
			mImageLT.color = mColor;
			mImageMT.color = mColor;
			mImageRT.color = mColor;
			mImageLM.color = mColor;
			mImageMM.color = mColor;
			mImageRM.color = mColor;
			mImageLB.color = mColor;
			mImageMB.color = mColor;
			mImageRB.color = mColor;
		}
		
		public function get preferredSize():Point { return mPreferredSize; }
		public function set preferredSize(value:Point):void
		{
			mPreferredSize.x = value.x;
			mPreferredSize.y = value.y;
			
			var frame:Rectangle = mTexture.frame;
			var w:Number = frame ? frame.width  : mTexture.width;
			var h:Number = frame ? frame.height : mTexture.height;
			
			var insetLeft:Number   = mInsets.left;
			var insetRight:Number  = mInsets.right;
			var insetTop:Number    = mInsets.top;
			var insetBottom:Number = mInsets.bottom;
			// all inset is zero, default set to equal divide
			if (insetLeft == 0 && insetTop == 0 && insetRight == 0 && insetBottom == 0) {
				insetLeft = insetRight = w/3;
				insetTop = insetBottom = h/3;
			}
			
			mImageLT.x = 0;
			mImageLT.y = 0;
			mImageMT.x = mImageLT.x + mImageLT.width;
			mImageMT.y = mImageLT.y;
			mImageMT.width = value.x - insetLeft - insetRight;
			mImageRT.x = mImageLT.x + mImageLT.width + mImageMT.width;
			mImageRT.y = mImageLT.y;
			mImageLM.x = mImageLT.x;
			mImageLM.y = mImageLT.y + mImageLT.height;
			mImageLM.height = value.y - insetTop - insetBottom;
			mImageMM.x = mImageLT.x + mImageLM.width;
			mImageMM.y = mImageLT.y + mImageLT.height;
			mImageMM.width = value.x - insetLeft - insetRight;
			mImageMM.height = value.y - insetTop - insetBottom;
			mImageRM.x = mImageLT.x + mImageLM.width + mImageMM.width;
			mImageRM.y = mImageLT.y + mImageLT.height;
			mImageRM.height = value.y - insetTop - insetBottom;
			mImageLB.x = mImageLT.x;
			mImageLB.y = mImageLT.y + mImageLT.height + mImageLM.height;
			mImageMB.x = mImageLT.x + mImageLB.width;
			mImageMB.y = mImageLT.y + mImageLT.height + mImageLM.height;
			mImageMB.width = value.x - insetLeft - insetRight;
			mImageRB.x = mImageLT.x + mImageLB.width + mImageMB.width;
			mImageRB.y = mImageLT.y + mImageLT.height + mImageLM.height;
			
			this.contentSizeX = value.x;
			this.contentSizeY = value.y;
		}
		
		public function renderImage(image:Image, support:RenderSupport, parentAlpha:Number):void
		{
			var alpha:Number = parentAlpha * this.alpha;
			var blendMode:String = support.blendMode;
			
			{
				var child:DisplayObject = image;
				
				if (child.hasVisibleArea)
				{
					var filter:FragmentFilter = child.filter;
					
					support.pushMatrix();
					support.transformMatrix(child);
					support.blendMode = child.blendMode;
					
					if (filter) filter.render(child, support, alpha);
					else        child.render(support, alpha);
					
					support.blendMode = blendMode;
					support.popMatrix();
				}
			}
		}
				
		/** @inheritDoc */
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			CCNode.renderObject(support, parentAlpha, mImageLT);
			CCNode.renderObject(support, parentAlpha, mImageMT);
			CCNode.renderObject(support, parentAlpha, mImageRT);
			CCNode.renderObject(support, parentAlpha, mImageLM);
			CCNode.renderObject(support, parentAlpha, mImageMM);
			CCNode.renderObject(support, parentAlpha, mImageRM);
			CCNode.renderObject(support, parentAlpha, mImageLB);
			CCNode.renderObject(support, parentAlpha, mImageMB);
			CCNode.renderObject(support, parentAlpha, mImageRB);
			
			super.render(support, parentAlpha);
		}
	}
}