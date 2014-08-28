package scenes
{
	import flash.geom.Point;
	
	import scenes.cocos2d.PbButton;
	import scenes.cocos2d.PbMain;
	
	import starling.cocosbuilder.CCBFile;
	import starling.cocosbuilder.CCDialogManager;
	import starling.cocosbuilder.CCLayer;
	import starling.cocosbuilder.CCSprite;
	import starling.events.Event;
	
    public class Cocos2dScene extends Scene
    {
        public function Cocos2dScene()
        {
			PbButton;
			PbMain;
			CCBFile.CustomClassPrefix = "scenes.cocos2d.";
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
        }
		
		private function onAddToStage(event:Event):void
		{
			var dialogManager:CCDialogManager = new CCDialogManager(this, stage.stageWidth, stage.stageHeight, 320, 480);
			dialogManager.makeCurrent();

			CCDialogManager.createDialogByURL("CCDialog:ccb/Main.ccbi");
			/*var layer:CCLayer = CCLayer.createWithSize(320, 480);
			layer.x = CCDialogManager.CenterX;
			layer.y = CCDialogManager.CenterY;
			layer.anchorPoint = new Point(0.5, 0.5);
			this.addChild(layer);
			var layer2:CCLayer = CCLayer.createWithSize(253, 75);
			layer2.x = 127;
			layer2.y = 442;
			layer2.anchorPoint = new Point(0.5, 0.5);
			layer.addChild(layer2);
			layer2.offsetY += layer.contentSizeY;
			var sprite:CCSprite = CCSprite.create("button_medium");
			layer2.addChild(sprite);
			sprite.offsetY += layer2.contentSizeY;*/
		}
    }
}
