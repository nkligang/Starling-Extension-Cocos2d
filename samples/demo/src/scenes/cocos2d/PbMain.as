// =================================================================================================
//
//	Starling Framework Extension
//	Copyright 2014 nkligang(nkligang@163.com). All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package scenes.cocos2d
{
	import starling.cocosbuilder.CCDialog;
	import starling.events.Event;

	public class PbMain extends CCDialog
	{
		public function PbMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			//this.x = 0;
			//this.y = 480;
			//this.scaleX = 0.5;
			//this.scaleY = 0.5;
			//this.ignoreAnchorPointForPosition = false;
		}
	}
}
