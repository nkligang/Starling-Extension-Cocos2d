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
	
	import starling.core.Starling;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;

	public class CCParticleSystemQuad extends CCNode
	{
		private var mParticleSystem:PDParticleSystem;
		
		public function CCParticleSystemQuad()
		{
		}
		
		public static function createWithNodeProperty(nodeInfo:CCNodeProperty):CCParticleSystemQuad
		{
			var pobParticle:CCParticleSystemQuad = new CCParticleSystemQuad();
			if (pobParticle.initWithNodeProperty(nodeInfo))
				return pobParticle;
			return null;
		}
		
		public override function initWithNodeProperty(nodeInfo:CCNodeProperty):Boolean
		{
			var dict:Dictionary = new Dictionary;
			// emitter configuration
			dict["posVar"]       = nodeInfo.getProperty("posVar");
			dict["emitterMode"]  = nodeInfo.getProperty("emitterMode");
			dict["emissionRate"] = nodeInfo.getProperty("emissionRate");
			// Particle Configuration
			dict["totalParticles"] = nodeInfo.getProperty("totalParticles");
			dict["life"]           = nodeInfo.getProperty("life");
			dict["startSize"]      = nodeInfo.getProperty("startSize");
			dict["endSize"]        = nodeInfo.getProperty("endSize");
			dict["angle"]          = nodeInfo.getProperty("angle");
			dict["startSpin"]      = nodeInfo.getProperty("startSpin");
			dict["endSpin"]        = nodeInfo.getProperty("endSpin");
			var _emitterType:int   = nodeInfo.getProperty("emitterMode") as int;
			if (_emitterType == 0)
			{
				// gravity configuration
				dict["gravity"]         = nodeInfo.getProperty("gravity");
				dict["speed"]           = nodeInfo.getProperty("speed");
				dict["radialAccel"]     = nodeInfo.getProperty("radialAccel");
				dict["tangentialAccel"] = nodeInfo.getProperty("tangentialAccel");
			}
			else
			{
				// radial configuration 
				dict["startRadius"]     = nodeInfo.getProperty("startRadius");
				dict["endRadius"]       = nodeInfo.getProperty("endRadius");
				dict["rotatePerSecond"] = nodeInfo.getProperty("rotatePerSecond");
			}
			// color configuration
			var _startColor:CCTypeColor4FVar = nodeInfo.getProperty("startColor") as CCTypeColor4FVar;
			dict["startColor"]               = new ColorArgb(_startColor.r, _startColor.g, _startColor.b, _startColor.a);
 			dict["startColorVariance"]       = new ColorArgb(_startColor.rVar, _startColor.gVar, _startColor.bVar, _startColor.aVar);
			var _endColor:CCTypeColor4FVar   = nodeInfo.getProperty("endColor") as CCTypeColor4FVar;
			dict["endColor"]                 = new ColorArgb(_endColor.r, _endColor.g, _endColor.b, _endColor.a);
			dict["endColorVariance"]         = new ColorArgb(_endColor.rVar, _endColor.gVar, _endColor.bVar, _endColor.aVar);
			// Blend function
			dict["blendFunc"]                = nodeInfo.getProperty("blendFunc");
			
			var spriteFrame:CCSpriteFrame = nodeInfo.getProperty("texture") as CCSpriteFrame;
			mParticleSystem = new PDParticleSystem(null, spriteFrame.getTexture(), dict);
			
			Starling.juggler.add(mParticleSystem);
			mParticleSystem.start();
			return true;
		}
	}
}
