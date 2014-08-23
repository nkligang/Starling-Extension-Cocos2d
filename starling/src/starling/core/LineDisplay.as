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
    import flash.display.Shape;
    
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.utils.Color;
   
    internal class LineDisplay extends Sprite
    {
		// members
		private var mShapes:Vector.<Shape> = new Vector.<Shape>;
		
        public function LineDisplay()
        {            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        private function onAddedToStage():void
        {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onRemovedFromStage():void
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(event:EnterFrameEvent):void
        {
			var shapeNum:uint = mShapes.length;
			for (var i:uint = 0; i < shapeNum; i++)
			{
				starling.core.Starling.current.nativeStage.removeChild(mShapes[i]);
			}
			mShapes.splice(0, mShapes.length);
        }

		public function drawSingleLine2D(startX:Number, startY:Number, endX:Number, endY:Number, color:uint = Color.WHITE, width:Number = 1):void
		{
			var myLine:Shape = new Shape();
			myLine.graphics.lineStyle(width, color);
			myLine.graphics.moveTo(startX, startY);
			myLine.graphics.lineTo(endX, endY);
			starling.core.Starling.current.nativeStage.addChild(myLine);
			mShapes.push(myLine);
		}		
    }
}