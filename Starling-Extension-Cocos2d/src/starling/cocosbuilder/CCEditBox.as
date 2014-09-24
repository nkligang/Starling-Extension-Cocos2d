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
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CCEditBox extends CCLabelBMFont
	{
		private var mNativeTextField:flash.text.TextField;
		protected var mEditEnabled:Boolean = false;
		
		private static var sLocalPosition:Point = new Point();
		private static var sGlobalPosition:Point = new Point();
		
		public function CCEditBox()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		protected function addedToStageHandler(event:starling.events.Event):void
		{
			if(this.mNativeTextField && !this.mNativeTextField.parent)
			{
				Starling.current.nativeStage.addChild(this.mNativeTextField);
			}
			else if(!this.mNativeTextField)
			{
				this.mNativeTextField = new TextField();
				this.mNativeTextField.visible = false;
				//this.mNativeTextField.mouseEnabled = this.mNativeTextField.mouseWheelEnabled = false;
				this.mNativeTextField.autoSize = TextFieldAutoSize.NONE;
				this.mNativeTextField.multiline = false;
				this.mNativeTextField.wordWrap = false;
				this.mNativeTextField.embedFonts = false;
				this.mNativeTextField.defaultTextFormat = new TextFormat(null, 25, 0x000000, false, false, false);
				this.mNativeTextField.type = TextFieldType.INPUT;
				this.mNativeTextField.text = text;
				//this.mNativeTextField.background = true;
				this.mNativeTextField.addEventListener(flash.events.Event.CHANGE, onChange);
				this.mNativeTextField.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
				this.mNativeTextField.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
				//var textFormat:TextFormat = new TextFormat(fontName, 
				//	fontSize, color, bold, false, false, null, null, starling.utils.HAlign.CENTER);
				//this.mNativeTextField.defaultTextFormat = textFormat;
				this.mNativeTextField.width = this.contentSizeX;
				this.mNativeTextField.height = this.contentSizeY;
				
				Starling.current.nativeStage.addChild(this.mNativeTextField);
			}
		}
		private function onFocusIn(event:flash.events.FocusEvent):void  {
			trace(event);
		}
		private function onFocusOut(event:flash.events.FocusEvent):void  {
			this.mNativeTextField.visible = false;
			mTextField.visible = true;
			mEditEnabled = false;
		}
		
		protected function removedFromStageHandler(event:starling.events.Event):void
		{
			if(this.mNativeTextField)
			{
				Starling.current.nativeStage.removeChild(this.mNativeTextField);
				this.mNativeTextField = null;
			}
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// on a touch test, invisible or untouchable objects cause the test to fail
			if (forTouch && (!visible || !touchable)) return null;
			
			if (localPoint.x < 0 || localPoint.y < 0) return null;
			if (localPoint.x > this.contentSizeX || localPoint.y > this.contentSizeY) return null;
			return this;
		}

		private function onTouch(event:TouchEvent):void
		{	
			var touch:Touch = event.getTouch(this);
			if (touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !mEditEnabled)
			{
				this.mNativeTextField.visible = true;
				mTextField.visible = false;
				mEditEnabled = true;
			}
		}
		
		public static function create(width:int, height:int, text:String, fontName:String="Verdana",
									  fontSize:Number=12, color:uint=0x0, bold:Boolean=false):CCEditBox
		{
			var pobSprite:CCEditBox = new CCEditBox();
			if (pobSprite.init(width, height, text, fontName, fontSize, color, bold))
				return pobSprite;
			return null;
		}
		
		public override function init(w:int, h:int, text:String, fontName:String,
							 fontSize:Number, color:uint, bold:Boolean):Boolean
		{
			return super.init(w, h, text, fontName, fontSize, color, bold);
		}
		
		protected function onChange(event:flash.events.Event):void
		{
			this.text = this.mNativeTextField.text;
			event.stopImmediatePropagation();
		}
				
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			//CCNode.renderObject(support, parentAlpha, mQuad);
			var p:DisplayObjectContainer = this.parent;
			if (mEditEnabled && p != null)
			{
				sLocalPosition.setTo(0, 0);
				localToGlobal(sLocalPosition, sGlobalPosition);
				this.mNativeTextField.x = sGlobalPosition.x;
				this.mNativeTextField.y = sGlobalPosition.y;
			}
			
			super.render(support, parentAlpha);
		}
	}
}
