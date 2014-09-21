// =================================================================================================
//
//	Starling Framework Extension
//	Copyright 2014 nkligang(nkligang@163.com). All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package scenes.cocos2d
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import starling.cocosbuilder.CCLayer;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.display.DisplayObject;

	public class PbButton extends CCLayer
	{
		private static const MAX_DRAG_DIST:Number = 50;
		private static var sHelperRect:Rectangle = new Rectangle();
		
		private var mOldScale:Point = new Point(1, 1);
		
		private var mScaleWhenDown:Number;
		private var mAlphaWhenDisabled:Number;
		private var mEnabled:Boolean;
		private var mIsDown:Boolean;
		private var mUseHandCursor:Boolean;
		
		public function PbButton()
		{
			mOldScale.x = 1.0;
			mOldScale.y = 1.0;
			mScaleWhenDown = 0.9;
			mAlphaWhenDisabled = 0.5;
			mEnabled = true;
			mIsDown = false;
			mUseHandCursor = true;

			this.touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			mOldScale.x = this.scaleX;
			mOldScale.y = this.scaleY;
		}
		
		private function resetContents():void
		{
			mIsDown = false;
			this.scaleX = mOldScale.x;
			this.scaleY = mOldScale.y;
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// on a touch test, invisible or untouchable objects cause the test to fail
			if (forTouch && (!visible || !touchable)) return null;
			
			if (localPoint.x < 0 || localPoint.y < 0) return null;
			if (localPoint.x > this.contentSizeX || localPoint.y > this.contentSizeY) return null;
			return this;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
				MouseCursor.BUTTON : MouseCursor.AUTO;
			
			var touch:Touch = event.getTouch(this);
			if (!mEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				this.scaleX = mOldScale.x * mScaleWhenDown;
				this.scaleY = mOldScale.y * mScaleWhenDown;
				mIsDown = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				// reset button when user dragged too far away after pushing
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					resetContents();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				resetContents();
				dispatchEventWith(Event.TRIGGERED, true);
				//Starling.current.addMessage(this.name);
			}
		}
		
		/** Indicates if the mouse cursor should transform into a hand while it's over the button. 
		 *  @default true */
		public override function get useHandCursor():Boolean { return mUseHandCursor; }
		public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
	}
}
