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
	
	import starling.animation.IAnimatable;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;

	public class CCScrollView extends CCNode implements IAnimatable
	{
		private var mContainer:CCLayer = null;
		
		private var mHorizontalMoveEnabled:Boolean = false;
		private var mVerticalMoveEnabled:Boolean = false;
		private var mBounceable:Boolean = true;
		private var mViewOffsetPosition:Point = new Point();
		private var mViewSize:Point = new Point();

		private var mTouchs:Vector.<Touch> = new <Touch>[];
		
		private static const MOVE_STATE_NONE:int          = 0;
		private static const MOVE_STATE_RETURN_TOP:int    = 1;
		private static const MOVE_STATE_RETURN_BOTTOM:int = 2;
		private static const MOVE_STATE_FAST_MOVING:int   = 3;
		private var mCurMoveStateX:int = MOVE_STATE_NONE;
		private var mCurMoveStateY:int = MOVE_STATE_NONE;
		private var mDragEnabled:Boolean = false;
		private var mCurItemPositionX:Number = 0;
		private var mCurItemSpeedX:Number = 0;
		private var mCurItemAccelerateX:Number = 0;
		private var mCurItemPositionY:Number = 0;
		private var mCurItemSpeedY:Number = 0;
		private var mCurItemAccelerateY:Number = 0;
		
		private static var sHelperRect:Rectangle = new Rectangle();
		private static var sMin:Point = new Point;
		private static var sMax:Point = new Point;
		private static var sMinGlobal:Point = new Point;
		private static var sMaxGlobal:Point = new Point;
		private static var sDebugIntersection:Boolean = true;
		
		private var mIntersected:Boolean = false;
		private var mShowBorder:Boolean = false;
		private var mShowCenter:Boolean = false;
		
		private static const MAX_DRAG_DIST:Number = 50;
		private var mEnabled:Boolean = true;
		private var mIsDown:Boolean;
		private var mUseHandCursor:Boolean = false;
		
		private static var kCCScrollViewDirectionNone:int = -1;
		private static var kCCScrollViewDirectionHorizontal:int = 0;
		private static var kCCScrollViewDirectionVertical:int = 1;
		private static var kCCScrollViewDirectionBoth:int = 2;
		
		public function CCScrollView()
		{
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCScrollView
		{
			var pobView:CCScrollView = new CCScrollView();
			if (pobView.initWithNodeProperty(nodeInfo))
				return pobView;
			return null;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			mContainer = CCLayer.createWithSize(this.contentSizeX, this.contentSizeY);
			this.addChild(mContainer);
			
			this.touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyContainer))
			{
				var container:CCBFileRef = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyContainer) as CCBFileRef;
				var ccb:CCBFile = container.getCCB();
				var node:CCNode = ccb.createNodeGraph();
				setViewSize(node.contentSizeX, node.contentSizeY);
				mContainer.addChild(node);
			}
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyDirection))
			{
				var direction:int = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyDirection) as int;
				if (direction == kCCScrollViewDirectionNone) {
					mHorizontalMoveEnabled = false;
					mVerticalMoveEnabled = false;
				} else if (direction == kCCScrollViewDirectionHorizontal) {
					mHorizontalMoveEnabled = true;
					mVerticalMoveEnabled = false;
				} else if (direction == kCCScrollViewDirectionVertical) {
					mHorizontalMoveEnabled = false;
					mVerticalMoveEnabled = true;
				} else if (direction == kCCScrollViewDirectionBoth) {
					mHorizontalMoveEnabled = true;
					mVerticalMoveEnabled = true;
				}
			}
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyBounces))
			{
				mBounceable = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyBounces) as Boolean;
			}
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyClipsToBounds))
			{
				setClipEnabled(nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyClipsToBounds) as Boolean);
			}
			
			Starling.juggler.add(this);
			return true;
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// on a touch test, invisible or untouchable objects cause the test to fail
			if (forTouch && (!visible || !touchable)) return null;
			
			if (localPoint.x < 0 || localPoint.y < 0) return null;
			if (localPoint.x > this.contentSizeX || localPoint.y > this.contentSizeY) return null;
			var subObj:DisplayObject = super.hitTest(localPoint, forTouch);
			if (subObj != null) return subObj;
			return this;
		}
				
		private function resetContents():void
		{
			mIsDown = false;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			//trace("onTouch " + event);			
			var touch:Touch = event.getTouch(this);
			if (!mEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				mTouchs.push(touch.clone());
				
				mIsDown = true;
				mUseHandCursor = true;
				mDragEnabled = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				if (mTouchs.length > 30) mTouchs.length = 0;
				mTouchs.push(touch.clone());
				
				if (mHorizontalMoveEnabled) {
					var offsetX:Number = touch.globalX - touch.previousGlobalX;
					var viewX:Number = mViewSize.x - mContainer.contentSizeX;
					var moveStepX:Number = viewX == 0 ? 0 : offsetX / viewX;
					mCurItemPositionX -= moveStepX;
				}
				if (mVerticalMoveEnabled) {
					var offsetY:Number = touch.globalY - touch.previousGlobalY;
					var viewY:Number = mViewSize.y - mContainer.contentSizeY;
					var moveStepY:Number = viewY == 0 ? 0 : offsetY / viewY;
					mCurItemPositionY -= moveStepY;
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				mTouchs.push(touch.clone());
				
				mUseHandCursor = false;
				resetContents();
				if (mCurItemPositionX < 0) {
					mCurMoveStateX = MOVE_STATE_RETURN_TOP;
				} else if (mCurItemPositionX > 1) {
					mCurMoveStateX = MOVE_STATE_RETURN_BOTTOM;
				} else {
					mCurItemSpeedX = getInitialSpeed(false);
					mCurMoveStateX = MOVE_STATE_FAST_MOVING;
				}
				if (mCurItemPositionY < 0) {
					mCurMoveStateY = MOVE_STATE_RETURN_TOP;
				} else if (mCurItemPositionY > 1) {
					mCurMoveStateY = MOVE_STATE_RETURN_BOTTOM;
				} else {
					mCurItemSpeedY = getInitialSpeed(true);
					mCurMoveStateY = MOVE_STATE_FAST_MOVING;
				}
				
				mDragEnabled = false;
				mTouchs.length = 0;
			}
			
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
				MouseCursor.BUTTON : MouseCursor.AUTO;
		}
		
		private function getInitialSpeed(vertical:Boolean):Number {
			var speed:Number = 0.0;
			if (mTouchs.length < 1) return speed;
			var lastTouch:Touch = mTouchs[mTouchs.length - 1];
			for (var i:int = mTouchs.length - 1; i > 0; i--)
			{
				var touchThis:Touch = mTouchs[i+0];
				if ((lastTouch.timestamp - touchThis.timestamp) > 0.1) break;
				var touchNext:Touch = mTouchs[i-1];
				if ((touchNext.timestamp - touchThis.timestamp) == 0.0) continue;
				if (vertical)
					speed += -0.00001 * (touchNext.globalY - touchThis.globalY)/(touchNext.timestamp - touchThis.timestamp);
				else
					speed += -0.00001 * (touchNext.globalX - touchThis.globalX)/(touchNext.timestamp - touchThis.timestamp);
			}
			return speed;
		}
		
		private function slideX(fTimeDelta:Number):void
		{
			if (mCurMoveStateX == MOVE_STATE_RETURN_TOP)
			{
				// 上拉时速度的大小与位置成反比
				mCurItemSpeedX = (0.0 - mCurItemPositionX) * fTimeDelta * 4;
				// 当速度非常小的时候关闭移动
				if (mCurItemSpeedX < 0.00001)
				{
					mCurMoveStateX = MOVE_STATE_NONE;
					mCurItemSpeedX = 0.0;
				}
			}
			else if (mCurMoveStateX == MOVE_STATE_RETURN_BOTTOM)
			{
				// 下拉时速度的大小也与位置成反比
				mCurItemSpeedX = (1.0 - mCurItemPositionX) * fTimeDelta * 4;
				// 当速度非常小的时候关闭移动
				if (mCurItemSpeedX > 0.00001)
				{
					mCurMoveStateX = MOVE_STATE_NONE;
					mCurItemSpeedX = 0.0;
				}
			}
			else if (mCurMoveStateX == MOVE_STATE_FAST_MOVING)
			{
				if (mCurItemPositionX >= 0 && mCurItemPositionX <= 1) {
					// 受摩擦力作用，速度慢慢减少
					mCurItemSpeedX *= 0.95;
					if (IsNearEnough(mCurItemSpeedX, 0, 0.00001))
					{
						mCurMoveStateX = MOVE_STATE_NONE;
						mCurItemSpeedX = 0.0;
					}
				} else if (mCurItemPositionX < 0) {
					// 受顶部拉力的作用，速度慢慢减少
					mCurItemAccelerateX = -(mCurItemPositionX) * fTimeDelta * 1.0;
					// 速度计算
					mCurItemSpeedX += mCurItemAccelerateX;
					// 当速度为零时切换上拉动作(这里可能会导致不平滑)
					if (mCurItemSpeedX > 0) {
						mCurMoveStateX = MOVE_STATE_RETURN_TOP;
					}
				} else if (mCurItemPositionX > 1) {
					// 受底部拉力的作用，速度慢慢减少
					mCurItemAccelerateX = (1.0 - mCurItemPositionX) * fTimeDelta * 1.0;
					// 速度计算
					mCurItemSpeedX += mCurItemAccelerateX;
					// 当速度为零时切换下拉动作(这里可能会导致不平滑)
					if (mCurItemSpeedX < 0) {
						mCurMoveStateX = MOVE_STATE_RETURN_BOTTOM;
					}
				}
			}
			mCurItemPositionX += mCurItemSpeedX;
		}
		
		private function slideY(fTimeDelta:Number):void
		{
			if (mCurMoveStateY == MOVE_STATE_RETURN_TOP)
			{
				// 上拉时速度的大小与位置成反比
				mCurItemSpeedY = (0.0 - mCurItemPositionY) * fTimeDelta * 4;
				// 当速度非常小的时候关闭移动
				if (mCurItemSpeedY < 0.00001)
				{
					mCurMoveStateY = MOVE_STATE_NONE;
					mCurItemSpeedY = 0.0;
				}
			}
			else if (mCurMoveStateY == MOVE_STATE_RETURN_BOTTOM)
			{
				// 下拉时速度的大小也与位置成反比
				mCurItemSpeedY = (1.0 - mCurItemPositionY) * fTimeDelta * 4;
				// 当速度非常小的时候关闭移动
				if (mCurItemSpeedY > 0.00001)
				{
					mCurMoveStateY = MOVE_STATE_NONE;
					mCurItemSpeedY = 0.0;
				}
			}
			else if (mCurMoveStateY == MOVE_STATE_FAST_MOVING)
			{
				if (mCurItemPositionY >= 0 && mCurItemPositionY <= 1) {
					// 受摩擦力作用，速度慢慢减少
					mCurItemSpeedY *= 0.95;
					if (IsNearEnough(mCurItemSpeedY, 0, 0.00001))
					{
						mCurMoveStateY = MOVE_STATE_NONE;
						mCurItemSpeedY = 0.0;
					}
				} else if (mCurItemPositionY < 0) {
					// 受顶部拉力的作用，速度慢慢减少
					mCurItemAccelerateY = -(mCurItemPositionY) * fTimeDelta * 1.0;
					// 速度计算
					mCurItemSpeedY += mCurItemAccelerateY;
					// 当速度为零时切换上拉动作(这里可能会导致不平滑)
					if (mCurItemSpeedY > 0) {
						mCurMoveStateY = MOVE_STATE_RETURN_TOP;
					}
				} else if (mCurItemPositionY > 1) {
					// 受底部拉力的作用，速度慢慢减少
					mCurItemAccelerateY = (1.0 - mCurItemPositionY) * fTimeDelta * 1.0;
					// 速度计算
					mCurItemSpeedY += mCurItemAccelerateY;
					// 当速度为零时切换下拉动作(这里可能会导致不平滑)
					if (mCurItemSpeedY < 0) {
						mCurMoveStateY = MOVE_STATE_RETURN_BOTTOM;
					}
				}
			}
			mCurItemPositionY += mCurItemSpeedY;
		}
		
		private function IsNearEnough(p1:Number, p2:Number, epson:Number):Boolean {
			return p1 > p2 ? p1 - p2 < epson : p2 - p1 < epson;
		}
		
		public function advanceTime(time:Number):void
		{
			if (!mDragEnabled) {
				slideX(time);
				slideY(time);
			}
			var curPosX:Number = mContainer.x;
			var curPosY:Number = mContainer.y;
			if (mBounceable) {
				if (mCurItemPositionX < 0.0) mCurItemPositionX = 0.0;
				if (mCurItemPositionX > 1.0) mCurItemPositionX = 1.0;
				if (mCurItemPositionY < 0.0) mCurItemPositionY = 0.0;
				if (mCurItemPositionY > 1.0) mCurItemPositionY = 1.0;
			}
			var newPosX:Number = mViewOffsetPosition.x - (mViewSize.x - mContainer.contentSizeX) * mCurItemPositionX;
			var newPosY:Number = mViewOffsetPosition.y + (mViewSize.y - mContainer.contentSizeY) * mCurItemPositionY;
			if (mVerticalMoveEnabled) {
				if (!IsNearEnough(curPosY, newPosY, 0.1)) {
					mContainer.y = newPosY;
				}
			}
			if (mHorizontalMoveEnabled) {
				if (!IsNearEnough(curPosX, newPosX, 0.1)) {
					mContainer.x = newPosX;
				}
			}
		}
		
		public function addViewItem(item:DisplayObject):void {
			mContainer.addChild(item);
		}
		
		public function removeAllViewItem():void {
			mContainer.removeChildren(0);
		}
		
		private function setViewOffsetPosition(_x:Number, _y:Number):void {
			mViewOffsetPosition.setTo(_x, _y);
		}
		
		public function setViewSize(_x:Number, _y:Number):void {
			mViewSize.x = _x;
			mViewSize.y = _y;
			if (mViewSize.x == mContainer.contentSizeX)
				mViewSize.x = mContainer.contentSizeX + 1;
			if (mViewSize.y == mContainer.contentSizeY)
				mViewSize.y = mContainer.contentSizeY + 1;
			mViewOffsetPosition.setTo(0, mContainer.contentSizeY - _y);
		}

		public function setClipEnabled(clip:Boolean):void {
			if (clip) {
				this.clipRect = new Rectangle(0, 0, mContainer.contentSizeX, mContainer.contentSizeY);
			} else {
				this.clipRect = null;
			}
		}
		
		public function setVerticalMoveEnabled(enabled:Boolean):void {
			this.mVerticalMoveEnabled = enabled;
		}
		
		public function setHorizontalMoveEnabled(enabled:Boolean):void {
			this.mHorizontalMoveEnabled = enabled;
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
				///starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMinGlobal.y, sMaxGlobal.x, sMinGlobal.y, showBorderColor);
				///starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMaxGlobal.y, sMaxGlobal.x, sMaxGlobal.y, showBorderColor);
				///starling.core.Starling.current.drawSingleLine2D(sMinGlobal.x, sMinGlobal.y, sMinGlobal.x, sMaxGlobal.y, showBorderColor);
				///starling.core.Starling.current.drawSingleLine2D(sMaxGlobal.x, sMinGlobal.y, sMaxGlobal.x, sMaxGlobal.y, showBorderColor);
			}
			
			super.render(support, parentAlpha);
		}
		
		/** Indicates if the mouse cursor should transform into a hand while it's over the button. 
		 *  @default true */
		public override function get useHandCursor():Boolean { return mUseHandCursor; }
		public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
	}
}
