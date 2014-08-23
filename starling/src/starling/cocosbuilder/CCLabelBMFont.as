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
	import starling.text.TextFieldAutoSize;

	public class CCLabelBMFont extends CCLabelTTF
	{
		public function CCLabelBMFont()
		{
		}
		
		public static function create(width:int, height:int, text:String, fontName:String="Verdana",
									  fontSize:Number=12, color:uint=0x0, bold:Boolean=false):CCLabelBMFont
		{
			var pobSprite:CCLabelBMFont = new CCLabelBMFont();
			if (pobSprite.init(width, height, text, fontName, fontSize, color, bold))
				return pobSprite;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCLabelBMFont
		{
			var pobSprite:CCLabelBMFont = new CCLabelBMFont();
			if (pobSprite.initWithNodeProperty(nodeInfo))
				return pobSprite;
			return null;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var string:String = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyString) as String;
			var dimensionsObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyDimensions);
			var dimensions:CCTypeSize = dimensionsObj != null ? dimensionsObj as CCTypeSize : new CCTypeSize;
			var labelWidth:int = dimensions.x == 0 ? 50 : dimensions.x;
			var labelHeight:int = dimensions.y == 0 ? 50 : dimensions.y;
			
			var fntFile:CCBMFont = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyFntFile) as CCBMFont;
			init(labelWidth, labelHeight, string, fntFile.fontName, 25, 0x0, false);
			
			mTextField.hAlign = nodeInfo.getHorizontalAlignment();
			mTextField.vAlign = nodeInfo.getVerticalAlignment();
			if (dimensions.x == 0 && dimensions.y == 0)
				mTextField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			else if (dimensions.x == 0)
				mTextField.autoSize = TextFieldAutoSize.HORIZONTAL;
			else if (dimensions.y == 0)
				mTextField.autoSize = TextFieldAutoSize.VERTICAL;
			
			this.contentSizeX = mTextField.width;
			this.contentSizeY = mTextField.height;
			
			//this.border = true;
			this.color = nodeInfo.getColor();
			this.alpha = nodeInfo.getOpacity();
			this.rotation = nodeInfo.getRotation();
			this.anchorPoint = nodeInfo.getAnchorPoint();
			return true;
		}
	}
}
