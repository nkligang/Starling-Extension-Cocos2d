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
	import flash.utils.ByteArray;
	import flash.utils.Endian;

    /**
     *  CocosBuilder ByteArray
     */
	public class CCBByteArray
	{
		private var mData:ByteArray;
		private var mByteSize:uint;

		private var mCurrentByte:uint;
		private var mCurrentBit:uint;
		
		private var mCachedStringArray:Vector.<String>;
		
		private static var mTempArray:ByteArray = new ByteArray;
		
		public function CCBByteArray(data:ByteArray)
		{
			mData = data;
			mByteSize = mData.length;
			mTempArray.endian = flash.utils.Endian.LITTLE_ENDIAN;
			
			mCachedStringArray = new <String>[];
		}
		
		private function getBit():Boolean
		{
			var bit:Boolean;
			var byte:uint = mData[mCurrentByte];
			if (byte & (1 << mCurrentBit)) bit = true;
			else bit = false;
			
			mCurrentBit++;
			if (mCurrentBit >= 8)
			{
				mCurrentBit = 0;
				mCurrentByte++;
			}
			return bit;
		}
		
		private function alignBits():void
		{
			if (mCurrentBit) {
				mCurrentBit = 0;
				mCurrentByte++;
			}
		}
		
		public function readIntWithSign(sign:Boolean):int
		{
			var numBits:int = 0;
			while (!getBit())
			{
				numBits++;
			}
			
			var current:uint = 0;
			for (var a:int=numBits-1; a >= 0; a--)
			{
				if (getBit())
				{
					current |= (1 << a);
				}
			}
			current |= (1 << numBits);
			
			var num:int;
			if (sign)
			{
				var s:int = (int)(current%2);
				if (s) num = (int)(current/2);
				else num = (int)(-current/2);
			}
			else
			{
				num = (int)(current-1);
			}
			
			alignBits();
			
			return num;
		}
		
		public function readBytes(_DstBuf:ByteArray, _ElementSize:uint, _Count:uint):uint
		{
			var _s:uint = _ElementSize * _Count;
			if (mCurrentByte + _s <= mByteSize)
			{
				_DstBuf.writeBytes(mData, mCurrentByte, _s); 
				mCurrentByte += _s;
				return _s;
			}
			else if (mCurrentByte < mByteSize)
			{
				_DstBuf.writeBytes(mData, mCurrentByte, mByteSize - mCurrentByte);
				mCurrentByte = mByteSize;
				return mByteSize - mCurrentByte;
			}
			else
			{
				return 0;
			}
			return 0;
		}
		
		public function readByte():int
		{
			var byte:int = mData[mCurrentByte];
			mCurrentByte++;
			return byte;
		}
		
		public function readBool():Boolean
		{
			return readByte();
		}
		
		public function readUTF8():String
		{
			var b0:int = readByte();
			var b1:int = readByte();
			var numBytes:int = b0 << 8 | b1;
			mTempArray.clear();
			mTempArray.writeShort(numBytes);
			mTempArray.writeBytes(mData, mCurrentByte, numBytes);
			mTempArray.position = 0;
			mCurrentByte += numBytes;
			return mTempArray.readUTF();
		}
		
		public function readStringCache():void
		{
			var mStringArraySize:int = readIntWithSign(false);
			for (var i:int = 0; i < mStringArraySize; i++)
			{
				mCachedStringArray[i] = readUTF8();
			}
		}
		
		public function readFloat():Number
		{
			var type:int = readByte();
			
			switch (type) {
				case 0: return 0;
				case 1:	return 1;
				case 2:	return -1;
				case 3:	return 0.5;
				case 4:	return readIntWithSign(true);
				default: {
					mTempArray.clear();
					mTempArray.writeBytes(mData, mCurrentByte, 4);
					mTempArray.position = 0;
					var ret:Number = mTempArray.readFloat();
					mCurrentByte += 4;
					return ret;
				}
			}
		}
		
		public function readCachedString():String
		{
			var n:int = readIntWithSign(false);
			return mCachedStringArray[n];
		}
	}
}