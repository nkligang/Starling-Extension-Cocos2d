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
	import starling.utils.AssetManager;
	import starling.text.TextField;
	import starling.text.BitmapFont;

	public class CCBMFont
	{
		private var mAssertManager:AssetManager;
		
		private var mFntFile:String;
		
		private var mBitmapFont:BitmapFont;
		
		public function CCBMFont(assertManager:AssetManager, fntFile:String)
		{
			mAssertManager = assertManager;
			mFntFile = fntFile;
			
			mBitmapFont = TextField.getBitmapFont(mFntFile);
			if (mBitmapFont == null) {
				if (mAssertManager.isInQueue(mFntFile) == false)
					mAssertManager.enqueueWithName(mFntFile, mFntFile);
			}	
		}
		
		public function getBitmapFont():BitmapFont
		{
			if (mBitmapFont != null) return mBitmapFont;
			mBitmapFont = TextField.getBitmapFont(mFntFile);
			return mBitmapFont;
		}
		
		public function get fontName():String { return mFntFile; }
	}
}