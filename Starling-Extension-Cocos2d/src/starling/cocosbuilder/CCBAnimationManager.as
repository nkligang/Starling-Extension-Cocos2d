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
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	public class CCBAnimationManager extends EventDispatcher implements IAnimatable
	{		
		private var mCCBFile:CCBFile;
		
		private var mRootNode:CCNode;
		
		private var mOnStart:Function;
		private var mOnUpdate:Function;
		private var mOnRepeat:Function;
		private var mOnComplete:Function;  
		
		private var mOnStartArgs:Array;
		private var mOnUpdateArgs:Array;
		private var mOnRepeatArgs:Array;
		private var mOnCompleteArgs:Array;

		private var mTotalTime:Number;
		private var mCurrentTime:Number;
		private var mProgress:Number;
		private var mDelay:Number;
		private var mRoundToInt:Boolean;
		private var mRepeatCount:int;
		private var mRepeatDelay:Number;
		private var mReverse:Boolean;
		private var mCurrentCycle:int;

		private var mCurrentSequence:CCBSequence = null;
		
		/** helper objects */
		public var sLocalPosition:Point = new Point;
		
		public function CCBAnimationManager(ccbFile:CCBFile, root:CCNode)
		{
			mCCBFile = ccbFile;
			mRootNode = root;
			
			reset();
		}
		
		public function reset():CCBAnimationManager
		{
			mCurrentTime = 0.0;
			mTotalTime = 0.0;
			mProgress = 0.0;
			mDelay = mRepeatDelay = 0.0;
			mOnStart = mOnUpdate = mOnComplete = null;
			mOnStartArgs = mOnUpdateArgs = mOnCompleteArgs = null;
			mRoundToInt = mReverse = false;
			mRepeatCount = 1;
			mCurrentCycle = -1;
			
			return this;
		}
		
		public function getAnimationCount():int { return mCCBFile.getSequenceCount(); }
		public function getAnimationNameByIndex(index:uint):String { return mCCBFile.getSequenceByIndex(index).name; }
		
		public function startAnimationByName(seqName:String, loop:Boolean = false, delay:Number = 0):Boolean
		{
			return startAnimation(mCCBFile.getSequenceByName(seqName), loop, delay);
		}
		
		public function startAnimationByIndex(index:uint, loop:Boolean = false, delay:Number = 0):Boolean
		{
			return startAnimation(mCCBFile.getSequenceByIndex(index), loop, delay);
		}
		
		public function startAnimationBySequenceID(id:uint, loop:Boolean = false, delay:Number = 0):Boolean
		{
			return startAnimation(mCCBFile.getSequenceBySequenceID(id), loop, delay);
		}
		
		private function setSequence(sequence:CCBSequence, loop:Boolean, delay:Number):void
		{
			var reset:Boolean = mCurrentSequence != null && mCurrentSequence.sequenceId != sequence.sequenceId;
			mCurrentSequence = sequence;
			
			mCurrentTime = 0;
			mTotalTime = mCurrentSequence.duration;
			mRepeatCount = loop ? 0 : 1;
			mDelay = delay;
			advanceRecurse(mRootNode, null, reset);
			advanceSound(mRootNode, null, false);
		}
		
		private function startAnimation(sequence:CCBSequence, loop:Boolean, delay:Number):Boolean
		{
			if (sequence == null) return false;
			
			setSequence(sequence, loop, delay);
			
			Starling.juggler.add(this);
			return true;
		}
		
		public function stopAnimation():void
		{
			mCurrentSequence = null;
			dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
		}
		
		public function advanceTime(time:Number):void
		{
			// if the object is not connected to the stage, we should not advance 
			if (mRootNode.root == null) return;
			
			if (time == 0 || (mRepeatCount == 1 && mCurrentTime == mTotalTime)) return;
			
			if (mCurrentSequence == null) return;

			var i:int;
			var previousTime:Number = mCurrentTime;
			var restTime:Number = mTotalTime - mCurrentTime;
			var carryOverTime:Number = time > restTime ? time - restTime : 0.0;
			
			mCurrentTime += time;
			
			if (mCurrentTime <= 0) 
				return; // the delay is not over yet
			else if (mCurrentTime > mTotalTime) 
				mCurrentTime = mTotalTime;
			
			if (mCurrentCycle < 0 && previousTime <= 0 && mCurrentTime > 0)
			{
				mCurrentCycle++;
				if (mOnStart != null) mOnStart.apply(null, mOnStartArgs);
			}
			
			var ratio:Number = mCurrentTime / mTotalTime;
			var reversed:Boolean = mReverse && (mCurrentCycle % 2 == 1);
			mProgress = reversed ? (1.0 - ratio) : (ratio);

			advanceRecurse(mRootNode, null, false);
			
			if (mOnUpdate != null) 
				mOnUpdate.apply(null, mOnUpdateArgs);
			
			if (previousTime < mTotalTime && mCurrentTime >= mTotalTime)
			{
				if (mRepeatCount > 1)
				{
					mCurrentTime = -mRepeatDelay;
					mCurrentCycle++;
					if (mRepeatCount > 1) mRepeatCount--;
					if (mOnRepeat != null) mOnRepeat.apply(null, mOnRepeatArgs);
					
					advanceSound(mRootNode, null, false);
				}
				else
				{
					if (mCurrentSequence.chainedSequenceId < 0) {
						// save callback & args: they might be changed through an event listener
						var onComplete:Function = mOnComplete;
						var onCompleteArgs:Array = mOnCompleteArgs;
					
						// in the 'onComplete' callback, people might want to call "tween.reset" and
						// add it to another juggler; so this event has to be dispatched *before*
						// executing 'onComplete'.
						dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
						if (onComplete != null) onComplete.apply(null, onCompleteArgs);
					} else {
						setSequence(mCCBFile.getSequenceBySequenceID(mCurrentSequence.chainedSequenceId), false, 0);
					}
					return;
				}
			}
			
			//if (carryOverTime) 
			//	advanceTime(carryOverTime);			
		}
		
		public function advanceRecurse(nodeObject:CCNode, parentObject:CCNode, reset:Boolean):void
		{
			// animate core object
			var coreObject:CCNode = nodeObject;
			if (coreObject != null && mRootNode != nodeObject)
			{				
				var nodeInfo:CCNodeProperty = coreObject.nodeProperty;
				if (nodeInfo != null)
				{				
					var position:CCTypeSize = nodeInfo.getPositionEx();
					CCNodeProperty.getPosition(position, parentObject, nodeObject, sLocalPosition);
					var sprite:CCSprite = coreObject as CCSprite;
					if (reset)
					{
						// position
						nodeObject.x =  sLocalPosition.x;
					    nodeObject.y =  sLocalPosition.y;
						// rotation
						nodeObject.rotation = nodeInfo.getRotation();
						// scale
						var localScale:Point = nodeInfo.getScale(parentObject, nodeObject);
						nodeObject.scaleX = localScale.x;
						nodeObject.scaleY = localScale.y;
						// opacity
						var opacityObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyOpacity);
						if (opacityObj != null)
						{
							var opacity:int = opacityObj as int;
							coreObject.alpha = CCNodeProperty.getOpacityFloat(opacity);
						}
						// visible
						var visibleObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyVisible);
						if (visibleObj != null)
						{
							nodeObject.visible = visibleObj as Boolean;
						}
						// color
						if (sprite != null)
						{
							var colorObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyColor);
							if (colorObj)
							{
								var color:uint = colorObj as uint;
								sprite.color = color;
							}
						}
						// skew
						var skew:Point = nodeInfo.getSkew();
						nodeObject.skewX = skew.x;
						nodeObject.skewY = skew.y;
					}
					
					var seqNodeProps:Dictionary = nodeInfo.getSequence(mCurrentSequence.sequenceId);
					if (seqNodeProps != null)
					{
						for (var nameType:int in seqNodeProps)
						{
							var seqProp:CCBSequenceProperty = seqNodeProps[nameType] as CCBSequenceProperty;
							if (seqProp == null) continue;
							
							var ratio:Number = 0;
							var keyframes:Vector.<CCBKeyframe> = seqProp.getKeyframes();
							var numKeyframe:int = keyframes.length;
							var keyframeThis:CCBKeyframe = null;
							var keyframeNext:CCBKeyframe = null;
							for (var j:int = 0; j < numKeyframe; j++)
							{
								var frameThis:CCBKeyframe = keyframes[j];
								if (mCurrentTime >= frameThis.time)
								{
									if (j == numKeyframe - 1)
									{
										keyframeThis = frameThis;
										keyframeNext = frameThis;
										ratio = 1;
										break;
									}
									else
									{
										var frameNext:CCBKeyframe = keyframes[j+1];
										if (mCurrentTime < frameNext.time)
										{
											keyframeThis = frameThis;
											keyframeNext = frameNext;
											ratio = (mCurrentTime - keyframeThis.time)/(keyframeNext.time - keyframeThis.time);
											break;
										}
									}
								}
								else if (mCurrentTime < frameThis.time && j == 0)
								{
									keyframeThis = frameThis;
									keyframeNext = frameThis;
									ratio = 0;
									break;
								}
							}
							if (keyframeThis == null || keyframeNext == null)
							{
								continue;
							}
							
							var transition:Function = keyframeThis.easingFunc;
							var resultRatio:Number = transition(ratio);
							if (nameType == CCBSequenceProperty.kCCBKeyframeTypeOpacity)
							{
								var opacityThis:int = keyframeThis.value as int;
								var opacityNext:int = keyframeNext.value as int;
								coreObject.alpha = CCNodeProperty.getOpacityFloat(opacityThis + (opacityNext - opacityThis) * resultRatio);
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypeScale)
							{
								var scaleThis:Point = keyframeThis.value as Point;
								var scaleNext:Point = keyframeNext.value as Point;
								nodeObject.scaleX = (scaleThis.x + (scaleNext.x - scaleThis.x) * resultRatio);
								nodeObject.scaleY = (scaleThis.y + (scaleNext.y - scaleThis.y) * resultRatio);
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypeColor)
							{
								var colorThis:uint = keyframeThis.value as uint;
								var colorNext:uint = keyframeNext.value as uint;
								var rThis:int = Color.getRed(colorThis);
								var gThis:int = Color.getGreen(colorThis);
								var bThis:int = Color.getBlue(colorThis);
								var rNext:int = Color.getRed(colorNext);
								var gNext:int = Color.getGreen(colorNext);
								var bNext:int = Color.getBlue(colorNext);
								var r:int = (int)(rThis + (rNext - rThis) * resultRatio);
								var g:int = (int)(gThis + (gNext - gThis) * resultRatio);
								var b:int = (int)(bThis + (bNext - bThis) * resultRatio);
								if (sprite != null) sprite.color = Color.argb(255, r, g, b);
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypePosition)
							{
								var positionThis:Point = keyframeThis.value as Point;
								var positionNext:Point = keyframeNext.value as Point;
								var positionResult:CCTypeSize = new CCTypeSize;
								positionResult.x =  (positionThis.x + (positionNext.x - positionThis.x) * resultRatio);
								positionResult.y =  (positionThis.y + (positionNext.y - positionThis.y) * resultRatio);
								positionResult.type = position.type;
								CCNodeProperty.getPosition(positionResult, parentObject, nodeObject, sLocalPosition);
								nodeObject.x =  sLocalPosition.x;
								nodeObject.y =  sLocalPosition.y;
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypeVisible)
							{
								var visibleThis:Boolean = keyframeThis.value as Boolean;
								var visibleNext:Boolean = keyframeNext.value as Boolean;
								nodeObject.visible = visibleThis;
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypeRotation)
							{
								var rotationThis:Number = keyframeThis.value as Number;
								var rotationNext:Number = keyframeNext.value as Number;
								nodeObject.rotation = deg2rad(rotationThis + (rotationNext - rotationThis) * resultRatio);
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypeDisplayFrame)
							{
								var spriteFrameThis:CCSpriteFrame = keyframeThis.value as CCSpriteFrame;
								if (spriteFrameThis != null)
								{
									var spriteTexture:Texture = spriteFrameThis.getTexture();
									if (sprite != null && spriteTexture != null) sprite.texture = spriteTexture;
								}
							}
							else if (nameType == CCBSequenceProperty.kCCBKeyframeTypeSkew)
							{
								var skewThis:Point = keyframeThis.value as Point;
								var skewNext:Point = keyframeNext.value as Point;
								nodeObject.skewX =  deg2rad(skewThis.x + (skewNext.x - skewThis.x) * resultRatio);
								nodeObject.skewY = -deg2rad(skewThis.y + (skewNext.y - skewThis.y) * resultRatio);
							}
							else
							{
								throw new Error("not implement");
							}
						}
					}
				}
			}
			
			// avoid sub ccbi animation
			if (coreObject.animationManager != null && coreObject.animationManager != this)
				return;
			
			// recurse each children
			var numChildren:int = nodeObject.numChildren;
			for (var i:int=0; i<numChildren; ++i)
			{
				var child:DisplayObject = nodeObject.getChildAt(i);
				if (child is CCNode) {
					advanceRecurse(child as CCNode, nodeObject, reset);
				}
			}
		}
		
		public function advanceSound(nodeObject:CCNode, parentObject:CCNode, reset:Boolean):void
		{
			if (mCurrentSequence == null) return;
			var soundChanel:CCBSequenceProperty = mCurrentSequence.soundChannel;
			if (soundChanel == null) return;
			var keyframes:Vector.<CCBKeyframe> = soundChanel.getKeyframes();
			var numKeyframe:int = keyframes.length;
			for (var i:int = 0; i < numKeyframe; i++)
			{
				var frameThis:CCBKeyframe = keyframes[i];
				if (frameThis == null) continue;
				var soundProperty:CCSoundChannelProperty = frameThis.value as CCSoundChannelProperty;
				if (soundProperty == null) continue;
				if (soundProperty.file == null) continue;
				var sound:Sound = soundProperty.file.getSound();
				if (sound == null) continue;
				sound.play(-mCurrentTime * 1000);
			}
		}
		
		/** A function that will be called when the tween starts (after a possible delay). */
		public function get onStart():Function { return mOnStart; }
		public function set onStart(value:Function):void { mOnStart = value; }
		
		/** A function that will be called each time the tween is advanced. */
		public function get onUpdate():Function { return mOnUpdate; }
		public function set onUpdate(value:Function):void { mOnUpdate = value; }
		
		/** A function that will be called each time the tween finishes one repetition
		 *  (except the last, which will trigger 'onComplete'). */
		public function get onRepeat():Function { return mOnRepeat; }
		public function set onRepeat(value:Function):void { mOnRepeat = value; }
		
		/** A function that will be called when the tween is complete. */
		public function get onComplete():Function { return mOnComplete; }
		public function set onComplete(value:Function):void { mOnComplete = value; }
		
		/** The arguments that will be passed to the 'onStart' function. */
		public function get onStartArgs():Array { return mOnStartArgs; }
		public function set onStartArgs(value:Array):void { mOnStartArgs = value; }
		
		/** The arguments that will be passed to the 'onUpdate' function. */
		public function get onUpdateArgs():Array { return mOnUpdateArgs; }
		public function set onUpdateArgs(value:Array):void { mOnUpdateArgs = value; }
		
		/** The arguments that will be passed to the 'onRepeat' function. */
		public function get onRepeatArgs():Array { return mOnRepeatArgs; }
		public function set onRepeatArgs(value:Array):void { mOnRepeatArgs = value; }
		
		/** The arguments that will be passed to the 'onComplete' function. */
		public function get onCompleteArgs():Array { return mOnCompleteArgs; }
		public function set onCompleteArgs(value:Array):void { mOnCompleteArgs = value; }
	}
}