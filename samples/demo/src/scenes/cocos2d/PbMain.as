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
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import starling.cocosbuilder.CCBFile;
	import starling.cocosbuilder.CCBReader;
	import starling.cocosbuilder.CCDialog;
	import starling.cocosbuilder.CCDialogManager;
	import starling.cocosbuilder.CCNode;
	import starling.display.Button;
	import starling.events.Event;

	public class PbMain extends CCDialog
	{
		private var fileRef:FileReference;
		
		public function PbMain()
		{
			addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
		}
		
		private function onButtonTriggered(event:starling.events.Event):void
		{
			var button:PbButton = event.target as PbButton;
			if (button == null) return;
			
			var buttonName:String = button.name;
			if (buttonName == "CCLayer") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCLayer.ccbi");
			} else if (buttonName == "CCSprite") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCSprite.ccbi");
			} else if (buttonName == "CCLabelBMFont") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCLabelBMFont.ccbi");
			} else if (buttonName == "CCLabelTTF") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCLabelTTF.ccbi");
			} else if (buttonName == "CCParticleSystemQuad") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCParticleSystemQuad.ccbi");
			} else if (buttonName == "CCScrollView") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCScrollView.ccbi?__load=ccb/CCScrollViewItem.ccbi");
			} else if (buttonName == "CCBAnimationManager") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCBAnimationManager.ccbi");
			} else if (buttonName == "CCMenu") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/CCMenu.ccbi");
			} else if (buttonName == "BasicProperty") {
				CCDialogManager.createDialogByURL("CCDialog:ccb/BasicProperty.ccbi");
			} else if (buttonName == "Brower") {
				fileRef = new FileReference();
				var ccbiTypeFilter:FileFilter = new FileFilter("ccbi Files (*.ccbi)", "*.ccbi");
				fileRef.browse([ccbiTypeFilter]);
				fileRef.addEventListener(flash.events.Event.SELECT, onFileSelected);
			} else if (buttonName == "Back") {
				{
					var btn:Button = this.parent.getChildByName("backButton") as Button;
					btn.touchable = true;
					btn.dispatchEventWith(starling.events.Event.TRIGGERED, true);
				}
				CCDialogManager.destroyDialog(this);
			}
		}
		
		private function onFileSelected(e:flash.events.Event):void {
			if (CCBReader.assets.isLoaded(fileRef.name) == false) {
				CCBReader.assets.enqueueWithName(fileRef, fileRef.name);
				CCBReader.assets.loadQueue(function(ratio:Number):void {
					if (ratio == 1) {
						addCCB(fileRef.name);
					}
				});
			} else {
				addCCB(fileRef.name);
			}
		}
		
		private function addCCB(ccb:String):void
		{
			var ccbFile:CCBFile = CCBReader.assets.getCCB(ccb);
			var node:CCNode = ccbFile.createNodeGraph();
			node.x = CCDialogManager.CenterX;
			node.y = CCDialogManager.CenterY;
			addChild(node);
		}
	}
}
