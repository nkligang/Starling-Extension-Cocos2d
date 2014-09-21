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
	import starling.cocosbuilder.CCNode;
	import starling.events.Event;

	public class PbTag extends CCDialog
	{
		public function PbTag()
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
			var node0:CCNode = this.getChildByTag(0);
			if (node0 != null) {
				var labelTTF0:CCLabelTTF = node0 as CCLabelTTF;
				labelTTF0.text = "getChildByTag=0";
			}
			var node1:CCNode = this.getChildByTag(1);
			if (node1 != null) {
				var labelTTF1:CCLabelTTF = node1 as CCLabelTTF;
				labelTTF1.text = "getChildByTag=1";
			}
			var node2:CCNode = this.getChildByTag(2);
			if (node2 != null) {
				var labelTTF2:CCLabelTTF = node2 as CCLabelTTF;
				labelTTF2.text = "getChildByTag=2";
			}
			var node3:CCNode = this.getChildByTag(3);
			if (node3 != null) {
				var labelTTF4:CCLabelTTF = node3 as CCLabelTTF;
				labelTTF4.text = "getChildByTag=3";
			} else {
				node3 = this.getChildByTagRecursive(3);
				if (node3 != null) {
					var labelTTF3:CCLabelTTF = node3 as CCLabelTTF;
					labelTTF3.text = "getChildByTagRecursive=3";
				}
				
			}
		}
	}
}
