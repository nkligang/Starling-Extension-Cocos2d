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
	public class CCTypeSize
	{
		public var x:Number;
		public var y:Number;
		public var type:int;
		
		// position type
		public static const CCTypePositionTypeAbsolute:int                  = 0;  // 绝对位置
		public static const CCTypePositionTypeRelativeTopLeft:int           = 1;  // 相对于左上角
		public static const CCTypePositionTypeRelativeTopRight:int          = 2;  // 相对于右上角
		public static const CCTypePositionTypeRelativeBottomRight:int       = 3;  // 相对于右下角
		public static const CCTypePositionTypePercentageOfContainerSize:int = 4;  // 容器的百分比
		public static const CCTypePositionTypeMultiplyByResolutionScale:int = 5;  // 乘以分辨率的缩放系数

		// size type
		public static const CCTypeSizeTypeAbsolute:int                      = 0;  // 绝对大小
		public static const CCTypeSizeTypePercentageOfContainerSize:int     = 1;  // 容器的百分比
		public static const CCTypeSizeTypeRelativeContainerSize:int         = 2;  // 相对于容器的大小
		public static const CCTypeSizeTypePercentageWidthFixHeight:int      = 3;  // 宽度为容器百分比、高度为实际大小
		public static const CCTypeSizeTypePercentageHeightFixWidth:int      = 4;  // 高度为容器百分比。宽度为实际大小
		public static const CCTypeSizeTypeMultiplyByResolutionScale:int     = 5;  // 乘以分辨率的缩放系数
		
		// scale type
		public static const CCTypeScaleTypeAbsolute:int                     = 0;  // 绝对缩放比例
		public static const CCTypeScaleTypeMultiplyByResolutionScale:int    = 1;  // 乘以分辨率的缩放系数
		
		public function CCTypeSize(_x:Number = 0, _y:Number = 0, _t:int = 0)
		{
			x = _x;
			y = _y;
			type = _t;
		}
	}
}