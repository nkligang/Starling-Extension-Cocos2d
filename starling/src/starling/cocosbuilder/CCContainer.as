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
	import flash.ui.Keyboard;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.utils.Color;

	public class CCContainer extends Sprite
	{
		private var mContentSizeX:Number;
		private var mContentSizeY:Number;
		
		private var mCoreDisplayObject:DisplayObject;

		private static var sHelperRect:Rectangle = new Rectangle();
		private static var sMin:Point = new Point;
		private static var sMax:Point = new Point;
		private static var sMinGlobal:Point = new Point;
		private static var sMaxGlobal:Point = new Point;
		private static var sDebugIntersection:Boolean = true;
		
		private var mIntersected:Boolean = false;
		private var mShowBorder:Boolean = false;
		private var mShowCenter:Boolean = false;
	
		public function CCContainer()
		{
			mContentSizeX = 0;
			mContentSizeY = 0;
			
			if (sDebugIntersection) addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			mIntersected = event.interactsWith(this);
		}
		
		private function onKey(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.B)
				mShowBorder = !mShowBorder;
			else if (event.keyCode == Keyboard.C)
				mShowCenter = !mShowCenter;
		}

		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mShowBorder)
			{
				getBounds(this, sHelperRect);
				sMin.setTo(sHelperRect.left, sHelperRect.top);
				sMax.setTo(sHelperRect.right, sHelperRect.bottom);
				localToGlobal(sMin, sMinGlobal);
				localToGlobal(sMax, sMaxGlobal);
				var showBorderColor:uint = mIntersected ? Color.GREEN : Color.RED;
				starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMinGlobal.y, sMaxGlobal.x, sMinGlobal.y, showBorderColor);
				starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMaxGlobal.y, sMaxGlobal.x, sMaxGlobal.y, showBorderColor);
				starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMinGlobal.y, sMinGlobal.x, sMaxGlobal.y, showBorderColor);
				starling.core.Starling.current.drawSingleLine2D(sMaxGlobal.x, sMinGlobal.y, sMaxGlobal.x, sMaxGlobal.y, showBorderColor);
			}
			
			if (mShowCenter)
			{
				sMin.setTo(0, 0);
				localToGlobal(sMin, sMinGlobal);
				starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x-10, sMinGlobal.y, sMinGlobal.x+10, sMinGlobal.y, Color.RED);
				starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMinGlobal.y-10, sMinGlobal.x, sMinGlobal.y+10, Color.RED);
			}
			
			super.render(support, parentAlpha);
		}
		
		public function get coreObject():DisplayObject { return mCoreDisplayObject; }
		public function set coreObject(value:DisplayObject):void 
		{ 
			mCoreDisplayObject = value; 
			addChild(mCoreDisplayObject);
		}
		
		/*public override function localOffset(resultPoint:Point=null):Point
		{
			if (resultPoint == null) resultPoint = new Point(0, 0);
			if (mCoreDisplayObject != null) {
				mCoreDisplayObject.localOffset(resultPoint);
			}
			return resultPoint;
		}
		
		public function get contentSizeX():Number { return mContentSizeX; }
		public function set contentSizeX(value:Number):void { mContentSizeX = value; }
		
		public function get contentSizeY():Number { return mContentSizeY; }
		public function set contentSizeY(value:Number):void { mContentSizeY = value; }*/
	}
}
