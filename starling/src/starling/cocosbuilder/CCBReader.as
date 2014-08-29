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
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.animation.Transitions;
	import starling.display.BlendMode;
	import starling.utils.AssetManager;
	import starling.utils.Color;
	
    /**
     *  The CocosBuilder class parses ccbi files
     */
	public class CCBReader
	{
		private static var sAssets:AssetManager = null;
		public static function get assets():AssetManager { return sAssets; }
		public static function set assets(value:AssetManager):void { sAssets = value; }
		
		private var mJSControlled:Boolean = false;
		private var mAssertManager:AssetManager;
		private var mFileVersion:int;
		
		public function CCBReader(assertManager:AssetManager)
		{
			mAssertManager = assertManager;
		}
		
		public function read(data:ByteArray):CCBFile
		{
			if (!isCCBData(data)) throw new ArgumentError("Invalid ccbi data");
			
			var dataCCB:CCBByteArray = new CCBByteArray(data);
			
			// read magic string
			var magicString:ByteArray = new ByteArray;
			dataCCB.readBytes(magicString, 4, 1);
			//trace(magicString.toString());
			
			// only support version 5
			mFileVersion = dataCCB.readIntWithSign(false);
			if (mFileVersion != 5 && mFileVersion != 3)
			{
				throw new Error("not supported file version " + mFileVersion);
			}
			
			var ccbFile:CCBFile = new CCBFile();
			
			if (mFileVersion == 5)
			  	mJSControlled = dataCCB.readBool();
			else
				mJSControlled = false;
			
			// read all cache strings
			dataCCB.readStringCache();
			
			var mSequences:Vector.<CCBSequence> = null;
			var iSequenceInfosCount:int = dataCCB.readIntWithSign(false);
			for (var i:int = 0; i < iSequenceInfosCount; i++)
			{
				var length:Number = dataCCB.readFloat();
				var name:String = dataCCB.readCachedString();
				var sequenceId:int = dataCCB.readIntWithSign(false);
				var chainedSequenceId:int = dataCCB.readIntWithSign(true);
				var sequence:CCBSequence = new CCBSequence(length, name, sequenceId, chainedSequenceId);
				
				if (mFileVersion == 5)
				{
					var numCallbackKeyframes:int = dataCCB.readIntWithSign(false);
					if (numCallbackKeyframes > 0)
						throw new Error("no callback key frames permit");
					
					var numSoundKeyframes:int = dataCCB.readIntWithSign(false);
					if (numSoundKeyframes > 0) {
						sequence.soundChannel = new CCBSequenceProperty();
					}
					for (var j:int = 0; j < numSoundKeyframes; j++)
					{
						var keyfame:CCBKeyframe = new CCBKeyframe();
						keyfame.time = dataCCB.readFloat();
						var soundProperty:CCSoundChannelProperty = new CCSoundChannelProperty();
						soundProperty.file = new CCSoundRef(mAssertManager, dataCCB.readCachedString());
						soundProperty.pitch = dataCCB.readFloat();
						soundProperty.pan = dataCCB.readFloat();
						soundProperty.gain = dataCCB.readFloat();
						keyfame.value = soundProperty;
						sequence.soundChannel.addKeyframe(keyfame);
					}
				}
				
				if (mSequences == null) mSequences = new <CCBSequence>[];
				mSequences[i] = sequence;
			}
			
			ccbFile.mAutoPlaySequenceId = dataCCB.readIntWithSign(true);
			ccbFile.mSequences = mSequences;
			ccbFile.mRootNode = readNodeGraphParent(dataCCB, null);
			
			return ccbFile;
		}
		
		public static const kCCBKeyframeEasingInstant:int      = 0;
		public static const kCCBKeyframeEasingLinear:int       = 1;
		public static const kCCBKeyframeEasingCubicIn:int      = 2;
		public static const kCCBKeyframeEasingCubicOut:int     = 3;
		public static const kCCBKeyframeEasingCubicInOut:int   = 4;
		public static const kCCBKeyframeEasingElasticIn:int    = 5;
		public static const kCCBKeyframeEasingElasticOut:int   = 6;
		public static const kCCBKeyframeEasingElasticInOut:int = 7;
		public static const kCCBKeyframeEasingBounceIn:int     = 8;
		public static const kCCBKeyframeEasingBounceOut:int    = 9;
		public static const kCCBKeyframeEasingBounceInOut:int  = 10;
		public static const kCCBKeyframeEasingBackIn:int       = 11;
		public static const kCCBKeyframeEasingBackOut:int      = 12;
		public static const kCCBKeyframeEasingBackInOut:int    = 13;
		private function readKeyframeOfType(dataCCB:CCBByteArray, type:int):CCBKeyframe
		{
			var keyframe:CCBKeyframe = new CCBKeyframe;
			
			keyframe.time = dataCCB.readFloat();
			var easingType:int = dataCCB.readIntWithSign(false);
			if (easingType == kCCBKeyframeEasingCubicIn || 
				easingType == kCCBKeyframeEasingCubicOut || 
				easingType == kCCBKeyframeEasingCubicInOut || 
				easingType == kCCBKeyframeEasingElasticIn || 
				easingType == kCCBKeyframeEasingElasticOut || 
				easingType == kCCBKeyframeEasingElasticInOut)
			{
				keyframe.easingOpt = dataCCB.readFloat();
			}
			switch (easingType)
			{
			case kCCBKeyframeEasingInstant:
				keyframe.easingFunc = Transitions.getTransition(Transitions.LINEAR);
				break;
			case kCCBKeyframeEasingLinear:
				keyframe.easingFunc = Transitions.getTransition(Transitions.LINEAR);
				break;
			case kCCBKeyframeEasingCubicIn:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN);
				break;
			case kCCBKeyframeEasingCubicOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_OUT);
				break;
			case kCCBKeyframeEasingCubicInOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_OUT);
				break;
			case kCCBKeyframeEasingElasticIn:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_ELASTIC);
				break;
			case kCCBKeyframeEasingElasticOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_OUT_ELASTIC);
				break;
			case kCCBKeyframeEasingElasticInOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_OUT_ELASTIC);
				break;
			case kCCBKeyframeEasingBounceIn:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_BOUNCE);
				break;
			case kCCBKeyframeEasingBounceOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_OUT_BOUNCE);
				break;
			case kCCBKeyframeEasingBounceInOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_OUT_BOUNCE);
				break;
			case kCCBKeyframeEasingBackIn:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_BACK);
				break;
			case kCCBKeyframeEasingBackOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_OUT_BACK);
				break;
			case kCCBKeyframeEasingBackInOut:
				keyframe.easingFunc = Transitions.getTransition(Transitions.EASE_IN_OUT_BACK);
				break;
			}
			
			if (type == kCCBPropTypeCheck)
			{
				keyframe.value = dataCCB.readBool();
			}
			else if (type == kCCBPropTypeByte)
			{
				keyframe.value = dataCCB.readByte();
			}
			else if (type == kCCBPropTypeColor3)
			{
				var r:int = dataCCB.readByte();
				var g:int = dataCCB.readByte();
				var b:int = dataCCB.readByte();
				keyframe.value = Color.rgb(r, g, b);
			}
			else if (type == kCCBPropTypeDegrees)
			{
				keyframe.value = dataCCB.readFloat();
			}
			else if (type == kCCBPropTypeScaleLock || 
				     type == kCCBPropTypePosition || 
					 type == kCCBPropTypeFloatXY)
			{
				var _a:Number = dataCCB.readFloat();
				var _b:Number = dataCCB.readFloat();
				keyframe.value = new Point(_a, _b);
			}
			else if (type == kCCBPropTypeSpriteFrame)
			{
				var spriteSheet:String = dataCCB.readCachedString();
				var spriteFile:String = dataCCB.readCachedString();	
				keyframe.value = new CCSpriteFrame(mAssertManager, spriteSheet, spriteFile);
			}
			else
			{
				throw new Error("not implement 'readKeyframeOfType' of type " + type);
			}
			
			return keyframe;
		}
		
		private function readNodeGraphParent(dataCCB:CCBByteArray, parent:CCNodeProperty):CCNodeProperty
		{
			var className:String = dataCCB.readCachedString();
			
			// read javascript controller name
			var jsControllerName:String = null;
			if (mJSControlled)
			{
				jsControllerName = dataCCB.readCachedString();
			}
			
			// Read assignment type and name
			var memberVarAssignmentType:int = dataCCB.readIntWithSign(false);
			var memberVarAssignmentName:String = null;
			if (memberVarAssignmentType)
			{
				memberVarAssignmentName = dataCCB.readCachedString();
			}
			
			var node:CCNodeProperty = new CCNodeProperty(className, parent);
			if (memberVarAssignmentType)
			  node.setProperty(CCNodeProperty.CCBNodePropertyMemberVarAssignmentName, memberVarAssignmentName);
			
			var seqs:Dictionary = new Dictionary();
			var numAnimatedProperties:int = dataCCB.readIntWithSign(false);
			for (var iAP:int = 0; iAP < numAnimatedProperties; iAP++)
			{
				var seqId:int = dataCCB.readIntWithSign(false);
				var seqNodeProps:Dictionary = new Dictionary();
				var numAnimatedProperty:int = dataCCB.readIntWithSign(false);
				for (var j:int = 0; j < numAnimatedProperty; j++)
				{
					var seqProp:CCBSequenceProperty = new CCBSequenceProperty;
					var seqPropName:String = dataCCB.readCachedString();
					seqProp.name = seqPropName;
					seqProp.type = dataCCB.readIntWithSign(false);
					
					var numKeyframes:int = dataCCB.readIntWithSign(false);
					for (var k:int = 0; k < numKeyframes; k++)
					{
						var keyframe:CCBKeyframe = readKeyframeOfType(dataCCB, seqProp.type);
						
						seqProp.addKeyframe(keyframe);
					}
					seqNodeProps[seqProp.nameType] = seqProp;
				}
				seqs[seqId] = seqNodeProps;
			}
			if (numAnimatedProperties > 0)
			{
				node.setSequences(seqs);
			}

			// Read properties
			var numRegularProps:int = dataCCB.readIntWithSign(false);
			var numExtraProps:int = dataCCB.readIntWithSign(false);
			var numProps:int = numRegularProps + numExtraProps;
			for (var i:int = 0; i < numProps; i++)
			{
				var isExtraProp:Boolean = (i >= numRegularProps);
				
				readPropertyForNode(dataCCB, node, parent, isExtraProp);
			}
			
			// Handle sub ccb files (remove middle node)
			if (node is CCBFile)
			{
			}
			
			// Read and add children
			var numChildren:int = dataCCB.readIntWithSign(false);
			for (var iChild:int = 0; iChild < numChildren; iChild++)
			{
				var child:CCNodeProperty = readNodeGraphParent(dataCCB, node);
				node.addChild(child);
			}
			
			return node;
		}
		
		private static const kCCBPropTypePosition:int       = 0;
		private static const kCCBPropTypeSize:int           = 1;
		private static const kCCBPropTypePoint:int          = 2;
		private static const kCCBPropTypePointLock:int      = 3;
		private static const kCCBPropTypeScaleLock:int      = 4;
		private static const kCCBPropTypeDegrees:int        = 5;
		private static const kCCBPropTypeInteger:int        = 6;
		private static const kCCBPropTypeFloat:int          = 7;
		private static const kCCBPropTypeFloatVar:int       = 8;
		private static const kCCBPropTypeCheck:int          = 9;
		private static const kCCBPropTypeSpriteFrame:int    = 10;
		private static const kCCBPropTypeTexture:int        = 11;
		private static const kCCBPropTypeByte:int           = 12;
		private static const kCCBPropTypeColor3:int         = 13;
		private static const kCCBPropTypeColor4FVar:int     = 14;
		private static const kCCBPropTypeFlip:int           = 15;
		private static const kCCBPropTypeBlendmode:int      = 16;
		private static const kCCBPropTypeFntFile:int        = 17;
		private static const kCCBPropTypeText:int           = 18;
		private static const kCCBPropTypeFontTTF:int        = 19;
		private static const kCCBPropTypeIntegerLabeled:int = 20;
		private static const kCCBPropTypeBlock:int          = 21;
		private static const kCCBPropTypeAnimation:int      = 22;
		private static const kCCBPropTypeCCBFile:int        = 23;
		private static const kCCBPropTypeString:int         = 24;
		private static const kCCBPropTypeBlockCCControl:int = 25;
		private static const kCCBPropTypeFloatScale:int     = 26;
		private static const kCCBPropTypeFloatXY:int        = 27;
		
		private function readPropertyForNode(dataCCB:CCBByteArray, node:CCNodeProperty, parent:CCNodeProperty, isExtraProp:Boolean):void
		{
			// Read type and property name
			var type:int = dataCCB.readIntWithSign(false);
			var name:String = dataCCB.readCachedString();
			
			// Check if the property can be set for this platform
			var setProp:Boolean = true;
			var platform:int = dataCCB.readByte();
			
			// Forward properties for sub ccb files
			if (node is CCBFile)
			{
			}
			else if (isExtraProp)
			{
			}
			
			if (type == kCCBPropTypePosition)
			{
				var pos:CCTypeSize = new CCTypeSize;
				pos.x = dataCCB.readFloat();
				pos.y = dataCCB.readFloat();
				pos.type = dataCCB.readIntWithSign(false);
				
				node.setProperty(name, pos);
			}
			else if (type == kCCBPropTypeSize)
			{
				var size:CCTypeSize = new CCTypeSize;
				size.x = dataCCB.readFloat();
				size.y = dataCCB.readFloat();
				size.type = dataCCB.readIntWithSign(false);
				
				node.setProperty(name, size);
			}
			else if (type == kCCBPropTypePoint || 
				     type == kCCBPropTypePointLock)
			{
				var xPoint:Number = dataCCB.readFloat();
				var yPoint:Number = dataCCB.readFloat();
				
				node.setProperty(name, new Point(xPoint, yPoint));
			}
			else if (type == kCCBPropTypeScaleLock)
			{
				var scaleLock:CCTypeSize = new CCTypeSize;
				scaleLock.x = dataCCB.readFloat();
				scaleLock.y = dataCCB.readFloat();
				scaleLock.type = dataCCB.readIntWithSign(false);
				
				node.setProperty(name, scaleLock);
			}
			else if (type == kCCBPropTypeFloatXY)
			{
				var xFloat:Number = dataCCB.readFloat();
				var yFloat:Number = dataCCB.readFloat();
				
				node.setProperty(name, new Point(xFloat, yFloat));
			}
			else if (type == kCCBPropTypeDegrees || 
				     type == kCCBPropTypeFloat)
			{
				var degree:Number = dataCCB.readFloat();
				
				node.setProperty(name, degree);
			}
			else if (type == kCCBPropTypeFloatScale)
			{
				var fs:CCTypeFloatScale = new CCTypeFloatScale;
				fs.scale = dataCCB.readFloat();
				fs.type = dataCCB.readIntWithSign(false);
				
				node.setProperty(name, fs);
			}
			else if (type == kCCBPropTypeInteger || 
				     type == kCCBPropTypeIntegerLabeled)
			{
				var d:int = dataCCB.readIntWithSign(true);
				
				node.setProperty(name, d);
			}
			else if (type == kCCBPropTypeFloatVar)
			{
				var f:Number = dataCCB.readFloat();
				var fVar:Number = dataCCB.readFloat();
				
				node.setProperty(name, new Point(f, fVar));
			}
			else if (type == kCCBPropTypeCheck)
			{
				var bChecked:Boolean = dataCCB.readBool();
				
				node.setProperty(name, bChecked);
			}
			else if (type == kCCBPropTypeSpriteFrame)
			{
				var spriteSheet:String = dataCCB.readCachedString();
				var spriteFile:String = dataCCB.readCachedString();
				
				var spriteFrame:CCSpriteFrame = new CCSpriteFrame(mAssertManager, spriteSheet, spriteFile);
				node.setProperty(name, spriteFrame);
			}
			else if(type == kCCBPropTypeAnimation)
			{
				var animationFile:String = dataCCB.readCachedString();
				var animation:String = dataCCB.readCachedString();
				
				trace("readPropertyForNode: kCCBPropTypeAnimation " + " to be finished");
			}
			else if (type == kCCBPropTypeTexture)
			{
				var _spriteFile:String = dataCCB.readCachedString();
				
				var textureFile:CCSpriteFrame = new CCSpriteFrame(mAssertManager, "", _spriteFile);
				node.setProperty(name, textureFile);
			}
			else if (type == kCCBPropTypeByte)
			{
				var byte:int = dataCCB.readByte();
				
				node.setProperty(name, byte);
			}
			else if (type == kCCBPropTypeColor3)
			{
				var r:int = dataCCB.readByte();
				var g:int = dataCCB.readByte();
				var b:int = dataCCB.readByte();
				
				node.setProperty(name, Color.rgb(r, g, b));
			}
			else if (type == kCCBPropTypeColor4FVar)
			{
				var color4FVar:CCTypeColor4FVar = new CCTypeColor4FVar;
				color4FVar.r = dataCCB.readFloat();
				color4FVar.g = dataCCB.readFloat();
				color4FVar.b = dataCCB.readFloat();
				color4FVar.a = dataCCB.readFloat();
				color4FVar.rVar = dataCCB.readFloat();
				color4FVar.gVar = dataCCB.readFloat();
				color4FVar.bVar = dataCCB.readFloat();
				color4FVar.aVar = dataCCB.readFloat();
				
				node.setProperty(name, color4FVar);
			}
			else if (type == kCCBPropTypeFlip)
			{
				var xFlip:Boolean = dataCCB.readBool();
				var yFlip:Boolean = dataCCB.readBool();
				
				node.setProperty(name, CCNodeProperty.MakeFlipValue(xFlip, yFlip));
			}
			else if (type == kCCBPropTypeBlendmode)
			{
				var src:int = dataCCB.readIntWithSign(false);
				var dst:int = dataCCB.readIntWithSign(false);
				
				var blendArray:Array = [ src, dst ];
				node.setProperty(name, blendArray);
			}
			else if (type == kCCBPropTypeFntFile)
			{
				var fntFile:String = dataCCB.readCachedString();
				
				var bmFont:CCBMFont = new CCBMFont(mAssertManager, fntFile);
				node.setProperty(name, bmFont);
			}
			else if (type == kCCBPropTypeText || 
				     type == kCCBPropTypeString)
			{
				var txt:String = dataCCB.readCachedString();
				
				node.setProperty(name, txt);
			}
			else if (type == kCCBPropTypeFontTTF)
			{
				var ttf:String = dataCCB.readCachedString();
				
				node.setProperty(name, ttf);
			}
			else if (type == kCCBPropTypeCCBFile)
			{
				var ccb:String = dataCCB.readCachedString();

				if (ccb.length > 0)
				{
					var ccbFileRef:CCBFileRef = new CCBFileRef(mAssertManager, ccb);
					node.setProperty(name, ccbFileRef);
				}
			}
			else if (type == kCCBPropTypeBlockCCControl)
			{
				var selectorName:String = dataCCB.readCachedString();
				var selectorTarget:int = dataCCB.readIntWithSign(false);
				var controlEvents:int = dataCCB.readIntWithSign(false);
				
				node.setProperty(name, selectorName);
				trace("readPropertyForNode: kCCBPropTypeBlockCCControl to be finished");
			}
			else if (type == kCCBPropTypeBlock)
			{
				var selectorNameBlock:String = dataCCB.readCachedString();
				var selectorTargetBlock:int = dataCCB.readIntWithSign(false);
				
				node.setProperty(name, selectorNameBlock);
				trace("readPropertyForNode: kCCBPropTypeBlock to be finished");
			}
			else
			{
				throw new Error("not implement '" + name + "' of type " + type);
			}
		}
		
		public static function isCCBData(data:ByteArray):Boolean
		{
			if (data.length < 4) return false;
			else
			{
				var signature:String = String.fromCharCode(data[0], data[1], data[2], data[3]);
				return signature == "ibcc";
			}
		}		
	}
}