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
	import starling.events.Event;

	public class PbBasicProperty extends CCDialog
	{
		public function PbBasicProperty()
		{
			addEventListener(Event.TRIGGERED, onButtonTriggered);
		}
		
		private function onButtonTriggered(event:Event):void
		{
			var button:PbButton = event.target as PbButton;
			if (button == null) return;
			
			var buttonName:String = button.name;
			if (buttonName == "PositionAndSize") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/PositionAndSize.ccbi");
			} else if (buttonName == "AnchorPoint") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/AnchorPoint.ccbi");
			} else if (buttonName == "Skew") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/Skew.ccbi");
			} else if (buttonName == "Tag") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/Tag.ccbi");
			} else if (buttonName == "Back") {
				CCDialogManager.destroyDialog(this);
			}
		}
	}
}
