package scenes
{
	import flash.geom.Point;
	
	import scenes.cocos2d.PbButton;
	import scenes.cocos2d.PbMain;
	import scenes.cocos2d.PbCCLayer;
	import scenes.cocos2d.PbCCSprite;
	import scenes.cocos2d.PbCCLabelBMFont;
	import scenes.cocos2d.PbCCLabelTTF;
	import scenes.cocos2d.PbCCDialog;
	import scenes.cocos2d.PbCCScrollView;
	
	import starling.cocosbuilder.CCBFile;
	import starling.cocosbuilder.CCBReader;
	import starling.cocosbuilder.CCDialogManager;
	import starling.cocosbuilder.CCLayer;
	import starling.cocosbuilder.CCNode;
	import starling.cocosbuilder.CCSprite;
	import starling.events.Event;
	
    public class Cocos2dScene extends Scene
    {
        public function Cocos2dScene()
        {
			PbButton;
			PbMain;
			PbCCLayer;
			PbCCSprite;
			PbCCLabelBMFont;
			PbCCLabelTTF;
			PbCCDialog;
			PbCCScrollView;
			CCBFile.CustomClassPrefix = "scenes.cocos2d.";
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
        }
		
		private function addFlight():void
		{
			var ccbFile:CCBFile = CCBReader.assets.getCCB("ccb/Flight.ccbi");
			var node:CCNode = ccbFile.createNodeGraph();
			node.x = CCDialogManager.CenterX;
			node.y = CCDialogManager.CenterY;
			node.scaleX = 0.5;
			node.scaleY = 0.5;
			addChild(node);
		}
		
		private function onAddToStage(event:Event):void
		{
			var dialogManager:CCDialogManager = new CCDialogManager(this, stage.stageWidth, stage.stageHeight, 320, 480);
			dialogManager.makeCurrent();

			CCDialogManager.createDialogByURL("CCDialog:ccb/Main.ccbi");
			/*if (CCDialogManager.loadCCB("ccb/Flight.ccbi", null,  addFlight) != null) {
				addFlight();
			}*/
		}
    }
}
