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
	public class CCBSequence
	{
		public var duration:Number;
		public var name:String;
		public var sequenceId:int;
		public var chainedSequenceId:int;
		
		public function CCBSequence(_duration:Number, _name:String, 
									_sequenceId:int, _chainedSequenceId:int)
		{
			duration = _duration;
			name = _name;
			sequenceId = _sequenceId;
			chainedSequenceId = _chainedSequenceId;
		}
	}
}