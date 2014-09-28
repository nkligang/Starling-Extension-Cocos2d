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
	import flash.utils.getDefinitionByName;
	
	public class CCBFile
	{
		public var mJSControlled:Boolean = false;
		public var mAutoPlaySequenceId:int = -1;
		public var mSequences:Vector.<CCBSequence>;
		public var mRootNode:CCNodeProperty;
		
		public static const CCBNodeClassName_CCLayer:String              = "CCLayer";
		public static const CCBNodeClassName_CCLayerColor:String         = "CCLayerColor";
		public static const CCBNodeClassName_CCLayerGradient:String      = "CCLayerGradient";
		public static const CCBNodeClassName_CCScrollView:String         = "CCScrollView";
		public static const CCBNodeClassName_CCNode:String               = "CCNode";
		public static const CCBNodeClassName_CCSprite:String             = "CCSprite";
		public static const CCBNodeClassName_CCLabelTTF:String           = "CCLabelTTF";
		public static const CCBNodeClassName_CCLabelBMFont:String        = "CCLabelBMFont";
		public static const CCBNodeClassName_CCScale9Sprite:String       = "CCScale9Sprite";
		public static const CCBNodeClassName_CCControlButton:String      = "CCControlButton";
		public static const CCBNodeClassName_CCParticleSystemQuad:String = "CCParticleSystemQuad";
		public static const CCBNodeClassName_CCBFile:String              = "CCBFile";
		public static const CCBNodeClassName_CCMenu:String               = "CCMenu";
		public static const CCBNodeClassName_CCMenuItem:String           = "CCMenuItem";
		public static const CCBNodeClassName_CCMenuItemImage:String      = "CCMenuItemImage";
		public static const CCBNodeClassName_CCEditBox:String            = "CCEditBox";

		public static var sCustomClassPrefix:String;

		/** helper objects */
		
		public function CCBFile()
		{
		}
		
		private function createDisplayNodeGraph(parentObject:CCNode, nodeInfo:CCNodeProperty, defaultRootClass:String = CCBNodeClassName_CCLayer):CCNode
		{
			var nodeObject:CCNode = null;
			if (nodeInfo.className == CCBNodeClassName_CCBFile)
			{
				var ccb:CCBFileRef = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyCCBFile) as CCBFileRef;
				if (ccb != null)
				{
					var ccbFile:CCBFile = ccb.getCCB();
					if (ccbFile != null)
					{
						nodeObject = ccbFile.createNodeGraph();
					}
					else
					{
						throw new Error("createDisplayNodeGraph: ccb file is not prepared.");
					}
				}
				else
				{
					throw new Error("createDisplayNodeGraph: ccb node without ccb file referenced.");
				}					
			}
			else if (nodeInfo.className == CCBNodeClassName_CCSprite)
			{
				nodeObject = new CCSprite();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCScale9Sprite)
			{
				nodeObject = new CCScale9Sprite();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCLabelTTF)
			{
				nodeObject = new CCLabelTTF();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCLabelBMFont)
			{
				nodeObject = new CCLabelBMFont();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCNode)
			{
				nodeObject = new CCNode();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCLayer)
			{
				nodeObject = new CCLayer();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCLayerColor)
			{
				nodeObject = new CCLayerColor();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCLayerGradient)
			{
				nodeObject = new CCLayerGradient();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCScrollView)
			{
				nodeObject = new CCScrollView();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCControlButton)
			{
				nodeObject = new CCControlButton();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCParticleSystemQuad)
			{
				nodeObject = new CCParticleSystemQuad();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCMenu)
			{
				nodeObject = new CCMenu();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCMenuItem)
			{
				nodeObject = new CCMenuItem();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCMenuItemImage)
			{
				nodeObject = new CCMenuItemImage();
			}
			else if (nodeInfo.className == CCBNodeClassName_CCEditBox)
			{
				nodeObject = new CCEditBox();
			}
			else
			{
				try
				{
					var customClassRef:Class = getDefinitionByName(sCustomClassPrefix + nodeInfo.className) as Class;
					nodeObject = new customClassRef() as CCNode;
				}
				catch(error:ReferenceError)
				{
					trace("[CCBFile] createDisplayNodeGraph: not implement class: '" + sCustomClassPrefix + nodeInfo.className + "'");
					if (parentObject == null) {
						try {
							var defaultClassRef:Class = getDefinitionByName(defaultRootClass) as Class;
							nodeObject = new defaultClassRef() as CCNode;
						} catch(error:ReferenceError) {
							trace("[CCBFile] createDisplayNodeGraph: not implement class: '" + defaultRootClass + "'");
							nodeObject = new CCLayer();
						}
					} else {
						nodeObject = new CCLayer();
					}
				}
			}
			// set target
			nodeObject.nodeProperty = nodeInfo;
				
			var memberVarAssignmentName:String = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyMemberVarAssignmentName) as String;
			if (memberVarAssignmentName != null)
				nodeObject.name = memberVarAssignmentName;

			// calculate local position
			var localPosition:Point = nodeInfo.getPosition(parentObject, nodeObject);
			nodeObject.x =  localPosition.x;
			nodeObject.y =  localPosition.y;

			// calculate local content size
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyContentSize)) {
				var localContentSize:Point = new Point;
				var contentSizeObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyContentSize);
				var contentSize:CCTypeSize = contentSizeObj as CCTypeSize;
				CCNodeProperty.getContentSize(contentSize, parentObject, nodeObject, localContentSize);
				nodeObject.contentSizeX = localContentSize.x;
				nodeObject.contentSizeY = localContentSize.y;
			}
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyPreferedSize))
			{
				var preferedSizeObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyPreferedSize);
				if (preferedSizeObj is CCTypeSize) {
					var preferedSize:CCTypeSize = preferedSizeObj as CCTypeSize;
					var preferedAbsoluteSize:Point = CCNodeProperty.getContentSize(preferedSize, parentObject, nodeObject, localContentSize);
					nodeInfo.setProperty(CCNodeProperty.CCBNodePropertyPreferedSize, preferedAbsoluteSize);
				}
			}

			// calculate local scale
			var localScale:Point = nodeInfo.getScale(parentObject, nodeObject);
			nodeObject.scaleX = localScale.x;
			nodeObject.scaleY = localScale.y;

			// anchor point
			// bug fixed: CCSale9Sprite with AchorPoint(0,0) is not exported!
			if (nodeInfo.className == CCBNodeClassName_CCScale9Sprite) {
				if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyAnchorPoint))
					nodeObject.anchorPoint = nodeInfo.getAnchorPoint();
			} else if (nodeInfo.className != CCBNodeClassName_CCBFile) {
				nodeObject.anchorPoint = nodeInfo.getAnchorPoint();
			}
			
			// rotation
			nodeObject.rotation = nodeInfo.getRotation();
			
			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertySkew))
			{
				var skew:Point = nodeInfo.getSkew();
				nodeObject.skewX = skew.x;
				nodeObject.skewY = skew.y;
			}

			if (nodeInfo.hasProperty(CCNodeProperty.CCBNodePropertyTag))
			{
				nodeObject.tag = nodeInfo.getTag();
			}
			
			// visiblity
			nodeObject.visible = nodeInfo.isVisible();
			
			// create display object
			nodeObject.initWithNodeProperty(nodeInfo);

			// ignore anchor point
			if (nodeInfo.className != CCBNodeClassName_CCBFile) {
				nodeObject.ignoreAnchorPointForPosition = nodeInfo.isIgnoreAnchorPointForPosition();
			}
			
			var mChildren:Vector.<CCNodeProperty> = nodeInfo.getChildren();
			var numChildren:int = mChildren.length;
			for (var i:int=0; i<numChildren; ++i)
			{
				var childNodeInfo:CCNodeProperty = mChildren[i];
				var childNodeObject:CCNode = createDisplayNodeGraph(nodeObject, childNodeInfo, defaultRootClass);
				nodeObject.addChild(childNodeObject);
			}

			return nodeObject;
		}
				
		public function createNodeGraph(defaultRootClass:String = "starling.cocosbuilder.CCLayer"):CCNode
		{
			var node:CCNode = createDisplayNodeGraph(null, mRootNode, defaultRootClass);
			var actionManager:CCBAnimationManager = new CCBAnimationManager(this, node);
			node.animationManager = actionManager;
			
			if (mAutoPlaySequenceId >= 0)
				actionManager.startAnimationBySequenceID(mAutoPlaySequenceId, true);
			return node;
		}
		
		public function getSequenceIndexByName(seqName:String):int
		{
			var numSequence:int = mSequences.length;
			for (var i:int = 0; i < numSequence; ++i) {
				var sequence:CCBSequence = mSequences[i];
				if (sequence.name == seqName)
					return i;
			}
			return -1;
		}
		
		public function getSequenceByName(seqName:String):CCBSequence
		{
			var numSequence:int = mSequences.length;
			for (var i:int = 0; i < numSequence; ++i) {
				var sequence:CCBSequence = mSequences[i];
				if (sequence.name == seqName)
					return sequence;
			}
			return null;
		}
		
		public function getSequenceBySequenceID(id:uint):CCBSequence
		{
			var numSequence:int = mSequences.length;
			for (var i:int = 0; i < numSequence; ++i) {
				var sequence:CCBSequence = mSequences[i];
				if (sequence.sequenceId == id)
					return sequence;
			}
			return null;
		}
		
		public function getSequenceByIndex(idx:uint):CCBSequence
		{
			var numSequence:int = mSequences.length;
			if (idx < 0 || idx >= numSequence)
				throw new Error("Out of index");
			return mSequences[idx];
		}
		
		public function getSequenceCount():int { return mSequences.length; }
		
		public static function get CustomClassPrefix():String { return sCustomClassPrefix; }
		public static function set CustomClassPrefix(value:String):void { sCustomClassPrefix = value; }
	}
}
