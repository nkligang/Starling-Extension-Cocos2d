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
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.filters.FragmentFilter;

	/**
	 *  CCNode is the main element. Anything that gets drawn or contains things that get drawn is a CCNode.
	 */
	public class CCNode extends Sprite
	{
		private var mAnimationManager:CCBAnimationManager;
		private var mNodeProperty:CCNodeProperty;
		private var mTag:int = -1;
		
		private var mX:Number;
		private var mY:Number;
		private var mAnchorPoint:Point = new Point;
		private var mIgnoreAnchorPointForPosition:Boolean;
		private var mContentSizeX:Number;
		private var mContentSizeY:Number;
		private var mOffsetX:Number;
		private var mOffsetY:Number;
		private var mTransformationMatrixChanged:Boolean;
		
		public function CCNode()
		{
			mX = mY = mContentSizeX = mContentSizeY = mOffsetX = mOffsetY = 0.0;
			mAnchorPoint.x = mAnchorPoint.y = 0.0;
			mIgnoreAnchorPointForPosition = false;
			mTransformationMatrixChanged = true;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCNode
		{
			var pobNode:CCNode = new CCNode();
			if (pobNode.initWithNodeProperty(nodeInfo))
				return pobNode;
			return null;
		}
		
		public function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{			
			this.alpha = 1.0;
			this.anchorPoint = nodeInfo.getAnchorPoint();
			return true;
		}
		
		public function get animationManager():CCBAnimationManager { return mAnimationManager; }
		public function set animationManager(value:CCBAnimationManager):void { mAnimationManager = value; }
		
		public function get nodeProperty():CCNodeProperty { return this.mNodeProperty; }
		public function set nodeProperty(value:CCNodeProperty):void { this.mNodeProperty = value; }
		
		public function get tag():int { return mTag; }
		public function set tag(value:int):void { mTag = value; }
		
		public function getChildByTag(tag:int):CCNode {
			var childCount:int = this.numChildren;
			var child:DisplayObject = null;
			for (var i:int = 0; i < childCount; i++)
			{
				child = this.getChildAt(i);
				if (child is CCNode) {
					var childNode:CCNode = child as CCNode;
					if (childNode.tag == tag)
						return childNode;
				}
			}
			return null;
		}
		
		public function getChildByTagRecursive(tag:int):CCNode
		{
			return CCNode.getChildByTagRecursive(tag, this);
		}
		
		public static function getChildByTagRecursive(tag:int, parent:CCNode):CCNode
		{
			var result:CCNode = null;
			var numChildren:int = parent.numChildren;
			for (var i:int=0; i<numChildren; ++i)
			{
				var child:DisplayObject = parent.getChildAt(i);
				if (child is CCNode) {
					var childNode:CCNode = child as CCNode;
					if (childNode.tag == tag) {
						return childNode;
					}
					result = getChildByTagRecursive(tag, childNode);
					if (result != null) return result;
				}
			}
			
			return null;
		}
		
		public static function renderObject(support:RenderSupport, parentAlpha:Number, obj:DisplayObject):void
		{
			var alpha:Number = parentAlpha;
			var blendMode:String = support.blendMode;
			
			if (obj != null)
			{
				var child:DisplayObject = obj;
				
				if (child.hasVisibleArea)
				{
					var filter:FragmentFilter = child.filter;
					
					support.pushMatrix();
					support.transformMatrix(child);
					support.blendMode = child.blendMode;
					
					if (filter) filter.render(child, support, alpha);
					else        child.render(support, alpha);
					
					support.blendMode = blendMode;
					support.popMatrix();
				}
			}			
		}
				
		public override function get x():Number { return mX; }
		public override function set x(value:Number):void {
			mX = value;
			if (this.parent == null) {
				mTransformationMatrixChanged = true;
			} else {
				updatePosition(true, false);
			}
		}

		public override function get y():Number { return mY; }
		public override function set y(value:Number):void {
			mY = value;
			if (this.parent == null) {
				mTransformationMatrixChanged = true;
			} else {
				updatePosition(false, true);
			}
		}
		
		public function get anchorPoint():Point { return mAnchorPoint; }
		public function set anchorPoint(value:Point):void {
			anchorPointX = value.x;
			anchorPointY = value.y;
		}
		
		public function get anchorPointX():Number { return mAnchorPoint.x; }
		public function set anchorPointX(value:Number):void{
			mAnchorPoint.x = value;
			pivotX = mContentSizeX * mAnchorPoint.x;	
			mTransformationMatrixChanged = true;
		}
		
		public function get anchorPointY():Number { return mAnchorPoint.y; }
		public function set anchorPointY(value:Number):void{
			mAnchorPoint.y = value;
			super.pivotY = mContentSizeY * (1.0 - mAnchorPoint.y);	
			mTransformationMatrixChanged = true;
		}
		
		public function get ignoreAnchorPointForPosition():Boolean { return mIgnoreAnchorPointForPosition; }
		public function set ignoreAnchorPointForPosition(value:Boolean):void{
			if(mIgnoreAnchorPointForPosition != value) {
				mIgnoreAnchorPointForPosition = value;
				mTransformationMatrixChanged = true;
			}
			super.pivotX = mContentSizeX * mAnchorPoint.x;
			super.pivotY = mContentSizeY * (1.0 - mAnchorPoint.y);
		}
		
		public function get contentSizeX():Number { return mContentSizeX; }
		public function set contentSizeX(value:Number):void {
			mContentSizeX = value;
			super.pivotX = mContentSizeX * mAnchorPoint.x;
			mTransformationMatrixChanged = true;
		}
		
		public function get contentSizeY():Number { return mContentSizeY; }
		public function set contentSizeY(value:Number):void{
			mContentSizeY = value;
			super.pivotY = mContentSizeY * (1.0 - mAnchorPoint.y);
			mTransformationMatrixChanged = true;
		}
				
		private function updatePosition(bX:Boolean = true, bY:Boolean = true):void
		{
			var p:DisplayObjectContainer = this.parent;
			if (p != null)
			{
				if(mIgnoreAnchorPointForPosition) {
					if (bX) mOffsetX = super.pivotX;
					if (bY) mOffsetY = super.pivotY + (mAnchorPoint.y - 0.5) * mContentSizeY * 2;
				} else {
					if (bX) mOffsetX = 0;
					if (bY) mOffsetY = 0;
				}
				
				if (p is CCNode) {
					var parentNode:CCNode = p as CCNode;
					if (bX) super.x = mX + mOffsetX;
					if (bY) super.y = parentNode.contentSizeY - mY - mOffsetY;
				} else {
					if (bX) super.x = mX + mOffsetX;
					if (bY) super.y = Starling.current.stage.stageHeight - mY - mOffsetY;
				}
			}
		}
				
		public override function get transformationMatrix():Matrix
		{
			if (mTransformationMatrixChanged) {
				updatePosition();
				mTransformationMatrixChanged = false;
			}
			return super.transformationMatrix;
		}
		
		public function getChildByNameRecursive(name:String):DisplayObject
		{
			return getDisplayObjectByName(name, this);
		}
		
		/** Returns a display object with a certain name (recursively). */
		public static function getDisplayObjectByName(name:String, parent:DisplayObjectContainer):DisplayObject
		{
			var result:DisplayObject = null;
			var numChildren:int = parent.numChildren;
			for (var i:int=0; i<numChildren; ++i)
			{
				var child:DisplayObject = parent.getChildAt(i);
				if (child.name == name) {
					return child;
				} else if (child is DisplayObjectContainer)	{
					result = getDisplayObjectByName(name, child as DisplayObjectContainer);
					if (result != null) return result;
				}
			}
			
			return null;
		}
	}
}
