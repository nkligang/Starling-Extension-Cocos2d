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
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class CCLabelTTF extends CCNode
	{
		protected var mTextField:TextField;
		
		public function CCLabelTTF()
		{
		}
				
		public static function create(w:int, h:int, text:String, fontName:String="Verdana",
									  fontSize:Number=12, color:uint=0x0, bold:Boolean=false):CCLabelTTF
		{
			var pobSprite:CCLabelTTF = new CCLabelTTF();
			if (pobSprite.init(w, h, text, fontName, fontSize, color, bold))
				return pobSprite;
			return null;
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCLabelTTF
		{
			var pobSprite:CCLabelTTF = new CCLabelTTF();
			if (pobSprite.initWithNodeProperty(nodeInfo))
				return pobSprite;
			return null;
		}
		
		public function init(w:int, h:int, text:String, fontName:String,
							 fontSize:Number, color:uint, bold:Boolean):Boolean
		{
			mTextField = new TextField(w, h, text, fontName, fontSize, color, bold);
			this.contentSizeX = w;
			this.contentSizeY = h;
			return true;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var string:String = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyString) as String;
			var dimensionsObj:Object = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyDimensions);
			var dimensions:CCTypeSize = dimensionsObj != null ? dimensionsObj as CCTypeSize : new CCTypeSize;
			var labelWidth:int = dimensions.x == 0 ? 50 : dimensions.x;
			var labelHeight:int = dimensions.y == 0 ? 50 : dimensions.y;
			
			var fontName:String = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyFontName) as String;
			var fontSize:CCTypeFloatScale = nodeInfo.getProperty(CCNodeProperty.CCBNodePropertyFontSize) as CCTypeFloatScale;
			
			init(labelWidth, labelHeight, string, fontName, fontSize.scale, 0x0, false);
			
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
		
		public function get color():uint { return mTextField.color; }
		public function set color(value:uint):void { mTextField.color = value; }

		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			CCNode.renderObject(support, parentAlpha, mTextField);
			super.render(support, parentAlpha);
		}
		
		/** The displayed text. */
		public function get text():String { return mTextField.text; }
		public function set text(value:String):void { mTextField.text = value; }
		
		/** The horizontal alignment of the text. @default center @see starling.utils.HAlign */
		public function get hAlign():String { return mTextField.hAlign; }
		public function set hAlign(value:String):void { mTextField.hAlign = value; }
		
		/** The vertical alignment of the text. @default center @see starling.utils.VAlign */
		public function get vAlign():String { return mTextField.vAlign; }
		public function set vAlign(value:String):void { mTextField.vAlign = value; }
		
		public function get autoSize():String { return mTextField.autoSize; }
		public function set autoSize(value:String):void { mTextField.autoSize = value; }
	}
}
