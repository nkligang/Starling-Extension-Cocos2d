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
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.cocosbuilder.utils.AssetManager;

	public class CCSpriteFrame
	{
		private var mAssertManager:AssetManager;
		
		private var mSpriteSheet:String;
		private var mSriteFile:String;
		
		private var mTexture:Texture;
		
		private static var sSpriteBatchEnabled:Boolean = true;
		
		public function CCSpriteFrame(assertManager:AssetManager, spriteSheet:String, spriteFile:String)
		{
			mAssertManager = assertManager;
			mSpriteSheet = spriteSheet;
			mSriteFile = spriteFile;
			
			mTexture = null;
			if (mSpriteSheet.length == 0) {
				if (sSpriteBatchEnabled) {
					var spriteFilename:String = mSriteFile;
					var pos:int = spriteFilename.lastIndexOf("/")+1;
					if (pos > 0) spriteFilename = spriteFilename.substring(pos);
					mTexture = mAssertManager.getTexture(spriteFilename);
					if (mTexture != null) return;
				}
				mTexture = mAssertManager.getTexture(mSriteFile);
				if (mTexture == null) {
					if (mAssertManager.isInQueue(mSriteFile) == false)
						mAssertManager.enqueueWithName(mSriteFile, mSriteFile);
				}
			} else {
				var spriteFrames:TextureAtlas = mAssertManager.getTextureAtlas(mSpriteSheet);
				if (spriteFrames == null) {
					if (mAssertManager.isInQueue(mSpriteSheet) == false)
						mAssertManager.enqueueWithName(mSpriteSheet, mSpriteSheet);
				}
			}
			
		}
		
		public function getTexture():Texture
		{
			if (mTexture != null) return mTexture;
			if (mSpriteSheet.length == 0) {
				if (mTexture == null) {
					mTexture = mAssertManager.getTexture(mSriteFile);
					return mTexture;
				}
				return mTexture;
			} else {
				var spriteFrames:TextureAtlas = mAssertManager.getTextureAtlas(mSpriteSheet);
				if (spriteFrames == null) {
					return null;
				} else {
					mTexture = spriteFrames.getTexture(mSriteFile);
					return mTexture;
				}
			}
			return null;
		}
	}
}