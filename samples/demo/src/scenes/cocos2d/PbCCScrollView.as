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
	import flash.geom.Point;
	
	import starling.cocosbuilder.CCBFile;
	import starling.cocosbuilder.CCBReader;
	import starling.cocosbuilder.CCDialog;
	import starling.cocosbuilder.CCDialogManager;
	import starling.cocosbuilder.CCLayerColor;
	import starling.cocosbuilder.CCNode;
	import starling.cocosbuilder.CCScrollView;
	import starling.events.Event;
	import starling.utils.Color;

	public class PbCCScrollView extends CCDialog
	{
		public function PbCCScrollView()
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
			var list:CCScrollView = this.getChildByNameRecursive("list") as CCScrollView;
			var ccbFile:CCBFile = CCBReader.assets.getCCB("ccb/CCScrollViewItem.ccbi");
			if (ccbFile != null) {
				for (var i:int = 0; i < 5; i++)
				{
					for (var j:int = 0; j < 1; j++)
					{
						var ccbAction:CCNode = ccbFile.createNodeGraph();
						var bg:CCLayerColor = ccbAction.getChildByNameRecursive("bg") as CCLayerColor;
						bg.color = Color.argb(255, Math.random() * 255, Math.random() * 255, Math.random() * 255);
						ccbAction.x = ccbAction.contentSizeX * j;
						ccbAction.y = ccbAction.contentSizeY * i;
						ccbAction.anchorPoint = new Point(0, 0);
						list.addViewItem(ccbAction);
					}
				}
			}
			list.setVerticalMoveEnabled(true);
			list.setHorizontalMoveEnabled(false);
			list.setClipEnabled(true);
		}
	}
}
