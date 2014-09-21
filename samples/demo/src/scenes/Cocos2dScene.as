package scenes
{
	import flash.geom.Point;
	
	import scenes.cocos2d.PbBasicProperty;
	import scenes.cocos2d.PbButton;
	import scenes.cocos2d.PbCCBAnimationManager;
	import scenes.cocos2d.PbCCDialog;
	import scenes.cocos2d.PbCCLabelBMFont;
	import scenes.cocos2d.PbCCLabelTTF;
	import scenes.cocos2d.PbCCLayer;
	import scenes.cocos2d.PbCCScrollView;
	import scenes.cocos2d.PbCCSprite;
	import scenes.cocos2d.PbMain;
	import scenes.cocos2d.PbTag;
	
	import starling.cocosbuilder.CCBFile;
	import starling.cocosbuilder.CCBReader;
	import starling.cocosbuilder.CCDialogManager;
	import starling.cocosbuilder.CCLabelBMFont;
	import starling.cocosbuilder.CCLabelTTF;
	import starling.cocosbuilder.CCLayer;
	import starling.cocosbuilder.CCLayerColor;
	import starling.cocosbuilder.CCLayerGradient;
	import starling.cocosbuilder.CCNode;
	import starling.cocosbuilder.CCScale9Sprite;
	import starling.cocosbuilder.CCSprite;
	import starling.cocosbuilder.utils.AssetManager;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
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
			PbCCBAnimationManager;
			PbBasicProperty;
			PbTag;
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
		
		public function testCCSprite():void
		{
			var sprite:CCSprite = CCSprite.create("button_medium.png");
			sprite.x = CCDialogManager.CenterX;
			sprite.y = CCDialogManager.CenterY;
			sprite.anchorPointX = 0.5;
			sprite.anchorPointY = 0.5;
			//sprite.texture = CCBReader.assets.getTexture("window_default.png");
			//sprite.color = 0xFF0000;
			//sprite.rotation = 0.1;
			//sprite.texture = CCBReader.assets.getTexture("icon_trophy.png");
			//sprite.visible = false;
			//sprite.ignoreAnchorPointForPosition = true;
			addChild(sprite);
		}
		
		public function testCCScale9Sprite():void
		{
			var sprite:CCScale9Sprite = CCScale9Sprite.create("window_default.png");
			sprite.anchorPointX = 0;
			sprite.anchorPointY = 1;
			//sprite.preferredSize = new Point(512, 512);
			//sprite.color = 0xFF0000;
			addChild(sprite);
		}
		
		public function testCCLayer():void
		{
			var layer:CCLayer = CCLayer.createWithSize(128, 128);
			//layer.x = 512;
			//layer.y = 512;
			layer.anchorPointX = 0.5;
			layer.anchorPointY = 0.5;
			layer.scaleX = 1.0;
			layer.scaleY = 1.0;
			layer.x = CCDialogManager.CenterX;
			layer.y = CCDialogManager.CenterY;
			//layer.color = 0xFF00FF;
			//layer.ignoreAnchorPointForPosition = true;
			
			var sprite:CCSprite = CCSprite.create("button_square.png");
			//sprite.ignoreAnchorPointForPosition = true;
			layer.addChild(sprite);
			//sprite.offsetY = sprite.parent.contentSizeY;
			
			addChild(layer);
			//var mQuad:Quad = new Quad(512, 512);
			//addChild(mQuad);
		}
		
		public function testCCLayer2():void
		{
			var layer:CCLayerColor = CCLayerColor.createWithSize(339, 248);
			layer.x = -127;
			layer.y = 325;
			layer.anchorPointX = 0.5;
			layer.anchorPointY = 0.5;
			layer.scaleX = 0.25;
			layer.scaleY = 0.25;
			layer.color = 0x000000;
			layer.ignoreAnchorPointForPosition = true;
			
			var sprite:CCSprite = CCSprite.create("starling_front.png");
			sprite.x = 170;
			sprite.y = 124;
			sprite.anchorPointX = 0.5;
			sprite.anchorPointY = 0.5;
			sprite.rotation = starling.utils.deg2rad(90);
			layer.addChild(sprite);
			
			addChild(layer);
		}
		
		public function testCCLayer3():void
		{
			var layer:CCLayerColor = CCLayerColor.createWithSize(253, 75);
			layer.x = 78;
			layer.y = 448;
			layer.anchorPointX = 0.5;
			layer.anchorPointY = 0.5;
			layer.scaleX = 0.5;
			layer.scaleY = 0.5;
			layer.color = 0x000000;
			layer.ignoreAnchorPointForPosition = false;
			
			var sprite:CCSprite = CCSprite.create("button_medium.png");
			sprite.x = 0;
			sprite.y = 0;
			sprite.anchorPointX = 0.5;
			sprite.anchorPointY = 0.5;
			sprite.ignoreAnchorPointForPosition = true;
			layer.addChild(sprite);
			
			var labelTTF:CCLabelTTF = CCLabelTTF.create(253, 75, "CCLayer", "Verdana", 24);
			labelTTF.x = 120;
			labelTTF.y = 38;
			labelTTF.anchorPointX = 0.5;
			labelTTF.anchorPointY = 0.5;
			layer.addChild(labelTTF);
			
			addChild(layer);
		}
		
		public function testCCLayerColor():void
		{
			var layer:CCLayerColor = CCLayerColor.createWithSize(64, 64);
			//layer.x = 512;
			//layer.y = 512;
			layer.x = CCDialogManager.CenterX;
			layer.y = CCDialogManager.CenterY;
			layer.anchorPointX = 0;
			layer.anchorPointY = 1;
			layer.color = 0xFF00FF;
			addChild(layer);
			//var mQuad:Quad = new Quad(512, 512);
			//addChild(mQuad);
		}
		
		public function testCCLayerGradient():void
		{
			var layer:CCLayerGradient = CCLayerGradient.createWithSize(512, 512);
			//layer.x = 512;
			//layer.y = 512;
			layer.anchorPointX = 0;
			layer.anchorPointY = 1;
			layer.color = 0xFF00FF;
			layer.setColorPoint(0xFF0000FF, 0xFFFF0000, new Point(1, 1));
			addChild(layer);
			//var mQuad:Quad = new Quad(512, 512);
			//addChild(mQuad);
		}
		
		public function testCCLabelTTF():void
		{
			var labelTTF:CCLabelTTF = CCLabelTTF.create(100, 100, "Hello world");
			labelTTF.x = CCDialogManager.CenterX;
			labelTTF.y = CCDialogManager.CenterY;
			labelTTF.anchorPointX = 0.5;
			labelTTF.anchorPointY = 0.5;
			labelTTF.color = 0xFFFFFF;
			labelTTF.border = true;
			addChild(labelTTF);
		}
		
		public function testCCLabelBMFont():void
		{
			var labelTTF:CCLabelBMFont = CCLabelBMFont.create(200, 50, "Hello world", "fonts/2x/Monotype.fnt", 50);
			labelTTF.x = CCDialogManager.CenterX;
			labelTTF.y = CCDialogManager.CenterY;
			labelTTF.anchorPointX = 0.5;
			labelTTF.anchorPointY = 0.5;
			labelTTF.color = 0x000000;
			labelTTF.border = true;
			addChild(labelTTF);
		}
		
		public function testCharacter():void
		{
			var mMovieNames:Array = [
				"wr_01_move_0", "wr_01_move_1", "wr_01_move_2",
				"wr_01_attack_a_0", "wr_01_attack_a_1", "wr_01_attack_a_2",
				"wr_01_attack_b_0", "wr_01_attack_b_1", "wr_01_attack_b_2",
				"wr_01_emotion_a_0",
				"wr_01_idle_0",
			];
			
			var mActionIndex:int = 2;
			var mTextureAtlas2:TextureAtlas = CCBReader.assets.getTextureAtlas("scene/character/texturepack/wr_01.plist");
			var frames:Vector.<Texture> = mTextureAtlas2.getTextures(mMovieNames[mActionIndex]);
			var mMovie:MovieClip = new MovieClip(frames, frames.length);
			mMovie.alignPivot();
			mMovie.x = CCDialogManager.CenterX;
			mMovie.y = CCDialogManager.CenterY;
			addChild(mMovie);
			Starling.juggler.add(mMovie);
		}
		
		private function onAddToStage(event:Event):void
		{
			if (CCBReader.assets == null) {
				CCBReader.assets = new AssetManager;
				CCBReader.assets.verbose = true;
				var dialogManager:CCDialogManager = new CCDialogManager(this, stage.stageWidth, stage.stageHeight, 320, 480);
				dialogManager.makeCurrent();
			} else {
				CCDialogManager.current.root = this;
			}

			var test:Boolean = false;
			if (test) {
				CCBReader.assets.enqueueWithName("fonts/2x/Monotype.fnt", "fonts/2x/Monotype.fnt");
				CCBReader.assets.enqueueWithName("textures/2x/atlas2.plist", "textures/2x/atlas2.plist");
				CCBReader.assets.loadQueue(function(ratio:Number):void {
					if (ratio == 1) {
						//testCCLayerColor();
						//testCCLabelTTF();
						//testCCLabelBMFont();
						//testCCSprite();
						//testCCLayer();
						//testCCLayer2();
						testCCLayer3();
					}
				});
			} else {
				CCDialogManager.createDialogByURL("CCDialog:ccb/Main.ccbi");
			}
			/*if (CCDialogManager.loadCCB("ccb/Flight.ccbi", null,  addFlight) != null) {
				addFlight();
			}*/
		}
    }
}
