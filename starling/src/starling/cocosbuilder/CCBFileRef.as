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

	public class CCBFileRef
	{
		private var mAssertManager:AssetManager;
		
		private var mCCBFilePath:String;
		private var mSriteFile:String;
		
		private var mCCBFile:CCBFile;
		
		public function CCBFileRef(assertManager:AssetManager, ccbFile:String)
		{
			mAssertManager = assertManager;
			mCCBFilePath = ccbFile;
			if (mCCBFilePath.lastIndexOf(".ccb") == mCCBFilePath.length - 4)
				mCCBFilePath += "i";
			
			mCCBFile = mAssertManager.getCCB(mCCBFilePath);
			if (mCCBFile == null) {
				if (mAssertManager.isInQueue(mCCBFilePath) == false)
					mAssertManager.enqueueWithName(mCCBFilePath, mCCBFilePath);
			}
		}
		
		public function getCCB():CCBFile
		{
			if (mCCBFile != null) return mCCBFile;
			if (mCCBFile == null) {
				mCCBFile = mAssertManager.getCCB(mCCBFilePath);
				return mCCBFile;
			}
			return mCCBFile;
		}
	}
}