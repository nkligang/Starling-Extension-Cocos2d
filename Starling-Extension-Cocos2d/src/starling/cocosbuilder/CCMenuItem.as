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
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CCMenuItem extends CCNode
	{
		protected var mSelected:Boolean = false;
		protected var mEnabled:Boolean = true;
		protected var mBlock:CCTypeBlock;
		
		private static const MAX_DRAG_DIST:Number = 50;
		private var mUseHandCursor:Boolean;
		
		public function CCMenuItem()
		{
			mUseHandCursor = true;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public static function create():CCMenuItem
		{
			var pobMenuItem:CCMenuItem = new CCMenuItem();
			if (pobMenuItem.init())
				return pobMenuItem;
			return null;
		}
				
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCMenuItem
		{
			var pobMenuItem:CCMenuItem = new CCMenuItem();
			if (pobMenuItem.initWithNodeProperty(nodeInfo))
				return pobMenuItem;
			return null;
		}
		
		public function init():Boolean
		{
			return false;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			mEnabled = nodeInfo.isEnabled();
			mBlock = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyBlock) as CCTypeBlock;
			
			this.alpha = nodeInfo.getOpacity();
			this.blendMode = nodeInfo.getBlendFunc();
			return true;
		}
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support, parentAlpha);
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// on a touch test, invisible or untouchable objects cause the test to fail
			if (forTouch && (!visible || !touchable)) return null;
			
			if (localPoint.x < 0 || localPoint.y < 0) return null;
			if (localPoint.x > this.contentSizeX || localPoint.y > this.contentSizeY) return null;
			return this;
		}
		
		private function resetContents():void
		{
			mSelected = false;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
				MouseCursor.BUTTON : MouseCursor.AUTO;
			
			var touch:Touch = event.getTouch(this);
			if (!mEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !mSelected)
			{
				mSelected = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mSelected)
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
			else if (touch.phase == TouchPhase.ENDED && mSelected)
			{
				resetContents();
				dispatchEventWith(Event.TRIGGERED, true);
				trace("[CCMenuItem] '" + this.name + "' triggered");
				if (mBlock != null && mBlock.name.length > 0) {
					dispatchEventWith(mBlock.name, true, mBlock.target);
					trace("[CCMenuItem] Block'" + mBlock.name + "':" + mBlock.target + " triggered");
				}
			}
		}
		
		/** Indicates if the mouse cursor should transform into a hand while it's over the button. 
		 *  @default true */
		public override function get useHandCursor():Boolean { return mUseHandCursor; }
		public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
		
		public function get selected():Boolean { return mSelected; }
		public function set selected(value:Boolean):void { mSelected = value; }
		
		public function get enabled():Boolean { return mEnabled; }
		public function set enabled(value:Boolean):void { mEnabled = value; }
	}
}
