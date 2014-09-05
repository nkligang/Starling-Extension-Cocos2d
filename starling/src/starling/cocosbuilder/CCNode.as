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
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.filters.FragmentFilter;

	/**
	 *  CCNode is the main element. Anything that gets drawn or contains things that get drawn is a CCNode.
	 */
	public class CCNode extends Sprite
	{
		private var mAnimationManager:CCBAnimationManager;
		private var mNodeProperty:CCNodeProperty;
		
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
