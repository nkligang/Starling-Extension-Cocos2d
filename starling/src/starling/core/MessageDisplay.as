// =================================================================================================
//
//	Starling Framework
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.core
{
    import starling.display.BlendMode;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    /** A small, lightweight box that displays the current framerate, memory consumption and
     *  the number of draw calls per frame. The display is updated automatically once per frame. */
    internal class MessageDisplay extends Sprite
    {
        private var mLineHeight:Number = 0;
        
        private var mBackground:Quad = null;
		
        private var mTextFields:Array = new Array;
		private var mTextFieldNum:uint = 0;
        
		private var mDuration:Number = 20;
		private var mMaxNum:int = 30;
        
        /** Creates a new Statistics Box. */
        public function MessageDisplay()
        {
            //mBackground = new Quad(80, 25, 0x0);

            blendMode = BlendMode.NONE;
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        private function onAddedToStage():void
        {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            update();
        }
        
        private function onRemovedFromStage():void
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(event:EnterFrameEvent):void
        {
			update(event.passedTime, false, false);
        }
		
		public function add(str:String):void
		{
			if (mTextFieldNum == 0 && mBackground != null)
				addChild(mBackground);
			
			if (mTextFieldNum >= mMaxNum)
			{
				update(0, true, true, true);
			}
			var textField:TextField = new TextField(1024, 25, str, BitmapFont.MINI, BitmapFont.NATIVE_SIZE, 0xffffff);
			if (mLineHeight == 0) mLineHeight = TextField.getBitmapFont(BitmapFont.MINI).lineHeight;
			textField.x = 2;
			textField.y = mLineHeight * (mTextFieldNum);
			textField.hAlign = HAlign.LEFT;
			textField.vAlign = VAlign.TOP;
			textField.blendMode = BlendMode.ADD;
			textField.batchable = true;
			addChild(textField);
			mTextFields.push({
				"text": textField, 
				"time": mDuration
			});
			mTextFieldNum++;
			
			if (mBackground != null)
			 	mBackground.height = mLineHeight * (mTextFieldNum);
		}

		public function update(passedTime:Number = 0, _move:Boolean = false, _delete:Boolean = false, _moveUp:Boolean = true):void
		{
			if (mTextFieldNum == 0) return;
			var textField:TextField = null;
			for (var i:uint=0; i < mTextFieldNum; i++)
			{
				textField = mTextFields[i].text;
				var duration:Number = mTextFields[i].time;
				duration -= passedTime;
				if (i == 0 && duration < 0)
				{
					_move = true;
					_delete = true;
				}
				mTextFields[i].time = duration;
				if (_move)
				  textField.y += _moveUp ? -mLineHeight : mLineHeight;
			}
			if (_delete)
			{
				textField = mTextFields.shift().text;
				this.removeChild(textField);
				mTextFieldNum--;
				if (mBackground != null)
				{
					mBackground.height = mLineHeight * (mTextFieldNum);
					if (mTextFieldNum == 0) removeChild(mBackground);
				}
			}
		}
                
        public override function render(support:RenderSupport, parentAlpha:Number):void
        {
            // The display should always be rendered with two draw calls, so that we can
            // always reduce the draw count by that number to get the number produced by the 
            // actual content.
            
            support.finishQuadBatch();
            super.render(support, parentAlpha);
        }
        
        public function get maxNum():int { return mMaxNum; }
        public function set maxNum(value:int):void { mMaxNum = value; }
        
        public function get duration():Number { return mDuration; }
        public function set duration(value:Number):void { mDuration = value; }
    }
}