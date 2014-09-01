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
	import starling.display.Button;
	import starling.events.Event;

	public class PbMain extends CCDialog
	{
		public function PbMain()
		{
			addEventListener(Event.TRIGGERED, onButtonTriggered);
		}
		
		private function onButtonTriggered(event:Event):void
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
			} else if (buttonName == "Back") {
				{
					var btn:Button = this.parent.getChildByName("backButton") as Button;
					btn.touchable = true;
					btn.dispatchEventWith(Event.TRIGGERED, true);
				}
				CCDialogManager.destroyDialog(this);
			}
		}
	}
}
