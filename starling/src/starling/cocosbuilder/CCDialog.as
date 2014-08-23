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
	public class CCDialog extends CCLayer
	{
		protected var mURLParser:CCDialogURLParser;
		
		public function CCDialog()
		{
		}
		
		public function get URLParser():CCDialogURLParser { return mURLParser; }
		public function set URLParser(value:CCDialogURLParser):void {
			mURLParser = value;
		}		
	}
}
