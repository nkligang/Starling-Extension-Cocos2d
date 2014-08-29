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
	import flash.media.Sound;

	public class CCSoundRef
	{
		private var mAssertManager:AssetManager;
		
		private var mSoundFilePath:String;
		
		private var mSoundFile:Sound;
		
		public function CCSoundRef(assertManager:AssetManager, ccbFile:String)
		{
			mAssertManager = assertManager;
			mSoundFilePath = ccbFile;
			
			mSoundFile = mAssertManager.getSound(mSoundFilePath);
			if (mSoundFile == null) {
				if (mAssertManager.isInQueue(mSoundFilePath) == false)
					mAssertManager.enqueueWithName(mSoundFilePath, mSoundFilePath);
			}
		}
		
		public function getSound():Sound
		{
			if (mSoundFile != null) return mSoundFile;
			if (mSoundFile == null) {
				mSoundFile = mAssertManager.getSound(mSoundFilePath);
				return mSoundFile;
			}
			return mSoundFile;
		}
	}
}