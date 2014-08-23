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

	// example: CCDialog:PbHUD.ccbi?p1=1&p2=3&p3=2
	public class CCDialogURLParser
	{
		private var mURL:String;
		private var mParametersString:String;
		
		private var mType:String;
		private var mResource:String;
		private var mParameters:Dictionary = new Dictionary();

		public function CCDialogURLParser(url:String = null)
		{
			if (url != null)
				parseURL(url);
		}
				
		private function parseURL(url:String):void {
			if (url.length == 0) {
				new ArgumentError("url cannot be empty");
				return;
			}
			var results:Array = url.split("?");
			if (results.length == 1) {
				parametersString = "";
			} else if (results.length == 2) {
				parametersString = results[1];
			} else {
				new ArgumentError("multiple split char '?' exist");
				return;
			}
			var bases:Array = results[0].split(":");
			if (bases.length == 2) {
				mType = bases[0];
				mResource = bases[1];
			} else {
				new ArgumentError("invalid type and resource");
				return;				
			}
		}
		
		private function parseParameters(param:String):void {
			var groups:Array = param.split("&");
			var groupCount:int = groups.length;
			for (var i:int = 0; i< groupCount; i++)
			{
				var keyValue:Array = groups[0].split("=");
				if (keyValue.length != 2) continue;
				mParameters[keyValue[0]] = keyValue[1];
			}
		}
		private function generateParametersString(value:Dictionary):void {
			mParametersString = "";
			if (value == null) return;
			var i:int = 0;
			for (var key:String in value) {
				if (i != 0) mParametersString += "&";
				mParametersString += key + "=" + value[key];
			}
		}
		
		public function set parametersString(value:String):void {
			mParametersString = value;
			if (mParametersString != null && mParametersString.length > 0) {
				parseParameters(mParametersString);
			}
		}
		public function get parametersString():String { return mParametersString; }
		
		public function get parameters():Dictionary { return mParameters; }
		public function set parameters(value:Dictionary):void {
			mParameters = value;
			generateParametersString(mParameters);
		}
		
		public function get type():String { return mType; }
		public function set type(value:String):void {
			mType = value;
		}

		public function get resource():String { return mResource; }
		public function set resource(value:String):void {
			mResource = value;
		}
		
		public function getParameterInt(key:String):int {
			return mParameters[key] as int;
		}
		
		public function getParameterString(key:String):String {
			return mParameters[key];
		}
		
		public function getParameterStringArray(key:String, splitChar:String = ";"):Array {
			if (mParameters == null) return null;
			var v:String = mParameters[key];
			if (v == null || v.length == 0) return null;
			return v.split(splitChar);
		}
		
		public function equals(value:CCDialogURLParser):Boolean {
			return value.resource == mResource && value.type == mType;
		}
		
		public static function create(res:String, _type:String = "CCDialog", parameters:Dictionary = null):CCDialogURLParser {
			var urlParser:CCDialogURLParser = new CCDialogURLParser(null);
			urlParser.type = _type;
			urlParser.resource = res;
			urlParser.parameters = parameters;
			return urlParser;
		}
		public static function createWithURL(url:String):CCDialogURLParser {
			return new CCDialogURLParser(url);
		}
	}
}
