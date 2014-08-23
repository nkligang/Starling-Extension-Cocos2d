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
	public class CCBSequenceProperty
	{
		public static const kCCBKeyframeTypeOpacity:int      = 0;
		public static const kCCBKeyframeTypeVisible:int      = 1;
		public static const kCCBKeyframeTypeScale:int        = 2;
		public static const kCCBKeyframeTypePosition:int     = 3;
		public static const kCCBKeyframeTypeDisplayFrame:int = 4;
		public static const kCCBKeyframeTypeRotation:int     = 5;
		public static const kCCBKeyframeTypeColor:int        = 6;
		public static const kCCBKeyframeTypeSoundChannel:int = 7;
		
		public static const CCBKeyframeTypeOpacity:String      = "opacity";
		public static const CCBKeyframeTypeVisible:String      = "visible";
		public static const CCBKeyframeTypeScale:String        = "scale";
		public static const CCBKeyframeTypePosition:String     = "position";
		public static const CCBKeyframeTypeDisplayFrame:String = "displayFrame";
		public static const CCBKeyframeTypeRotation:String     = "rotation";
		public static const CCBKeyframeTypeColor:String        = "color";
		public static const CCBKeyframeTypeSoundChannel:String = "soundChannel";

		public var nameType:int;
		public var type:int;
		private var keyframes:Vector.<CCBKeyframe> = new <CCBKeyframe>[];
		
		public function CCBSequenceProperty()
		{
		}
		
		public function set name(value:String):void
		{ 
			switch (value)
			{
				case CCBKeyframeTypeOpacity:      nameType = kCCBKeyframeTypeOpacity;      break;
				case CCBKeyframeTypeVisible:      nameType = kCCBKeyframeTypeVisible;      break;
				case CCBKeyframeTypeScale:        nameType = kCCBKeyframeTypeScale;        break;
				case CCBKeyframeTypePosition:     nameType = kCCBKeyframeTypePosition;     break;
				case CCBKeyframeTypeDisplayFrame: nameType = kCCBKeyframeTypeDisplayFrame; break;
				case CCBKeyframeTypeRotation:     nameType = kCCBKeyframeTypeRotation;     break;
				case CCBKeyframeTypeColor:        nameType = kCCBKeyframeTypeColor;        break;
				case CCBKeyframeTypeSoundChannel: nameType = kCCBKeyframeTypeSoundChannel; break;
				default: throw new Error("not implement of type " + value);
			}
		}
		
		public function addKeyframe(keyframe:CCBKeyframe):void { keyframes.push(keyframe); }
		public function getKeyframes():Vector.<CCBKeyframe> { return keyframes; }
	}
}