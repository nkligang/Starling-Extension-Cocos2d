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
	import starling.core.RenderSupport;
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
		
		public function CCNode()
		{
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
	}
}
