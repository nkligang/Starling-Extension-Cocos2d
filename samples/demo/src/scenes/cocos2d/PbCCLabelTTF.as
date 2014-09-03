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
	import starling.cocosbuilder.CCDialogManager;
	import starling.cocosbuilder.CCLabelTTF;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class PbCCLabelTTF extends CCDialog
	{
		public function PbCCLabelTTF()
		{
			addEventListener(Event.TRIGGERED, onButtonTriggered);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
				
		private function onButtonTriggered(event:Event):void
		{
			var button:PbButton = event.target as PbButton;
			if (button == null) return;
			
			var buttonName:String = button.name;
			if (buttonName == "Back") {
				CCDialogManager.destroyDialog(this);
			}
		}
		
		private function onAddToStage(event:Event):void
		{
			var text1:CCLabelTTF = this.getChildByNameRecursive("text1") as CCLabelTTF;
			text1.text = "Hello world";
			var text2:CCLabelTTF = this.getChildByNameRecursive("text2") as CCLabelTTF;
			text2.text = "Hello world";
			text2.hAlign = HAlign.RIGHT;
			text2.vAlign = VAlign.BOTTOM;
		}
	}
}
