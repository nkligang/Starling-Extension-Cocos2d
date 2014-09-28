// =================================================================================================
//
//	Starling Framework Extension
//	Copyright 2014 nkligang(nkligang@163.com). All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.cocosbuilder
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class CCDialogManager
	{
		public static const CREATE_DIALOG_FLAG_NONE:int = 0;
		public static const CREATE_DIALOG_FLAG_MODAL:int = 1;
		public static const CREATE_DIALOG_FLAG_ADD_TO_LIST:int = 2;
		public static const CREATE_DIALOG_FLAG_DEFAULT:int = CREATE_DIALOG_FLAG_MODAL|CREATE_DIALOG_FLAG_ADD_TO_LIST;
		
		public static const DESTROY_DIALOG_FLAG_NONE:int = 0;
		public static const DESTROY_DIALOG_FLAG_DEFAULT:int = DESTROY_DIALOG_FLAG_NONE;
		
		public static var sCurrent:CCDialogManager;
		
		public static var ResourceWidth:int  = 1280;
		public static var ResourceHeight:int = 800;
		public static var ScreenWidth:int  = ResourceWidth;
		public static var ScreenHeight:int = ResourceHeight;
		public static var CenterX:int = ScreenWidth  / 2;
		public static var CenterY:int = ScreenHeight / 2;
		public static var GlobalScale:Number = 1;
		public static var OffsetX:Number = 0;
		public static var OffsetY:Number = 0;

		private var mRootNode:DisplayObjectContainer;
		
		private var mModalDialogs:Vector.<CCDialog> = new <CCDialog>[];
		private var mModelessDialogs:Vector.<CCDialog> = new <CCDialog>[];

		private var mDestroyedDialogs:Vector.<CCDialog> = new <CCDialog>[];
		
		public function CCDialogManager(rootNode:DisplayObjectContainer, screenWidth:int, screenHeight:int, designWidth:int = 1280, designHeight:int = 800)
		{
			CCDialogManager.ResourceWidth  = designWidth;
			CCDialogManager.ResourceHeight = designHeight;
			CCDialogManager.ScreenWidth  = screenWidth;
			CCDialogManager.ScreenHeight = screenHeight;
			var scaleX:Number = (CCDialogManager.ScreenWidth )/CCDialogManager.ResourceWidth; 
			var scaleY:Number = (CCDialogManager.ScreenHeight)/CCDialogManager.ResourceHeight;
			CCDialogManager.GlobalScale = scaleX < scaleY ? scaleX : scaleY;
			CCDialogManager.CenterX = ScreenWidth  / 2;
			CCDialogManager.CenterY = ScreenHeight / 2;
			CCDialogManager.OffsetX = (CCDialogManager.ScreenWidth  - CCDialogManager.ResourceWidth  * CCDialogManager.GlobalScale) * 0.5 / CCDialogManager.GlobalScale;
			CCDialogManager.OffsetY = (CCDialogManager.ScreenHeight - CCDialogManager.ResourceHeight * CCDialogManager.GlobalScale) * 0.5 / CCDialogManager.GlobalScale;

			mRootNode = rootNode;
		}
		
		public function makeCurrent():void
		{
			sCurrent = this;
		}
		public function get current():CCDialogManager { return sCurrent; }
		
		public function get root():DisplayObjectContainer { return mRootNode; }
		public function set root(value:DisplayObjectContainer):void { mRootNode = value; }
		
		public static function get current():CCDialogManager { return sCurrent; }
		
		public static function getParentDialog(dialog:CCDialog):CCDialog
		{
			var parentNode:DisplayObjectContainer = dialog.parent;
			while (parentNode != null) {
				if (parentNode is CCDialog) {
					var parentDialog:CCDialog = parentNode as CCDialog;
					if (CCDialogManager.current.isInDialogList(parentDialog))
						return parentDialog;
				}
				parentNode = parentNode.parent;
			}
			return null;
		}
		
		public function isInDialogList(dialog:CCDialog):Boolean {
			return mModalDialogs.indexOf(dialog) >= 0 || mModelessDialogs.indexOf(dialog) >= 0;
		}
		
		public function loadCCB(res:String, resArray:Array, callback:Function):CCBFile
		{
			var ccbFile:CCBFile = CCBReader.assets.getCCB(res);
			if (ccbFile == null) {
				CCBReader.assets.enqueueWithName(res, res);
				if (resArray != null)
				{
					var count:int = resArray.length;
					for (var i:int = 0; i< count; i++) {
						CCBReader.assets.enqueueWithName(resArray[i], resArray[i]);
					}
				}
				
				CCBReader.assets.loadQueue(function(ratio:Number):void {
					if (ratio == 1) {
						Starling.juggler.delayCall(callback, 0.15);
					}
				});
				return null;
			}
			return ccbFile;
		}
		
		public function createDialog(res:String, type:String = "CCDialog", parameters:Dictionary = null, flags:int = CREATE_DIALOG_FLAG_DEFAULT, callback:Function = null):CCDialog
		{
			return createDialogByURLParser(CCDialogURLParser.create(res, type, parameters), flags, callback);
		}
		
		public function createDialogByURL(url:String, flags:int = CREATE_DIALOG_FLAG_DEFAULT, callback:Function = null):CCDialog
		{
			return createDialogByURLParser(CCDialogURLParser.createWithURL(url), flags, callback);
		}

		public function createDialogByURLParser(urlParser:CCDialogURLParser, flags:int = CREATE_DIALOG_FLAG_DEFAULT, callback:Function = null):CCDialog
		{
			if (mRootNode == null) { throw new ArgumentError("root node cannot be null"); return null; }
			
			var ccbFile:CCBFile = loadCCB(urlParser.resource, urlParser.getParameterStringArray("__load"), function():void {
				createDialogByURLParser(urlParser, flags, callback);
			});
			if (ccbFile == null) {
				return null;
			}
			
			if (flags & CREATE_DIALOG_FLAG_ADD_TO_LIST)
			{
				if (flags & CREATE_DIALOG_FLAG_MODAL)
				{
					var numChildren:int = mRootNode.numChildren;
					for (var k:int = 0; k < numChildren; k++) {
						var child:DisplayObject = mRootNode.getChildAt(k);
						child.touchable = false;
					}
				}
			}
			
			var dialog:CCDialog = null;
			var destroyDialogCount:int = mDestroyedDialogs.length;
			for (var j:int = 0; j < destroyDialogCount; j++)
			{
				var dialogDestroyed:CCDialog = mDestroyedDialogs[j];
				if (dialogDestroyed.URLParser.equals(urlParser)) {
					dialog = dialogDestroyed;
					mDestroyedDialogs.splice(j, 1);
					break;
				}
			}
			if (dialog == null) {
				var node:CCNode = ccbFile.createNodeGraph("starling.cocosbuilder.CCDialog");
				if (node is CCDialog) {
					dialog = node as CCDialog;
				} else {
					throw new ArgumentError(getQualifiedClassName(node) + " is not based on CCDialog");
					return null;
				}
			}
			dialog.URLParser = urlParser;
			if (flags & CREATE_DIALOG_FLAG_ADD_TO_LIST)
			{
				if (dialog.ignoreAnchorPointForPosition) {
					dialog.x = CCDialogManager.OffsetX;
					dialog.y = CCDialogManager.OffsetY;
				} else {
				 	dialog.x = CCDialogManager.CenterX;
					dialog.y = CCDialogManager.CenterY;
				}
				dialog.scaleX = CCDialogManager.GlobalScale;
				dialog.scaleY = CCDialogManager.GlobalScale;
				dialog.touchable = true;
				mRootNode.addChild(dialog);
				mModalDialogs.push(dialog);
			}
			else
			{
				dialog.x = 0;
				dialog.y = 0;
			}
			if (callback != null) callback();
			return dialog;
		}
		
		public function destroyDialog(dialog:CCDialog, flags:int = DESTROY_DIALOG_FLAG_DEFAULT):void
		{
			if (mRootNode == null) { throw new ArgumentError("root node cannot be null"); return; }
			if (dialog == null) { throw new ArgumentError("dialog cannot be null"); return; }
			
			var index:Number = mModalDialogs.indexOf(dialog);
			if (index >= 0) {
				mModalDialogs.splice(index, 1);
				if (mModalDialogs.length > 0) {
					var lastDialog:CCDialog = mModalDialogs[mModalDialogs.length - 1];
					lastDialog.touchable = true;
				}
				
				mRootNode.removeChild(dialog);
				mDestroyedDialogs.push(dialog);
			}
		}
		
		public static function loadCCB(res:String, resArray:Array, callback:Function):CCBFile {
			return sCurrent.loadCCB(res, resArray, callback);
		}
		
		public static function createDialog(res:String, type:String = "CCDialog", parameters:Dictionary = null, flags:int = CREATE_DIALOG_FLAG_DEFAULT, callback:Function = null):CCDialog {
			return sCurrent.createDialog(res, type, parameters, flags, callback);
		}
		public static function createDialogByURL(url:String, flags:int = CREATE_DIALOG_FLAG_DEFAULT, callback:Function = null):CCDialog {
			return sCurrent.createDialogByURL(url, flags, callback);
		}
		public static function createDialogByURLParser(urlParser:CCDialogURLParser, flags:int = CREATE_DIALOG_FLAG_DEFAULT, callback:Function = null):CCDialog {
			return sCurrent.createDialogByURLParser(urlParser, flags, callback);
		}
		public static function destroyDialog(dialog:CCDialog, flags:int = DESTROY_DIALOG_FLAG_DEFAULT):void {
			return sCurrent.destroyDialog(dialog, flags);
		}
	}
}
