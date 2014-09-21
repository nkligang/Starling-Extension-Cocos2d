package starling.cocosbuilder.utils
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.FileReference;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ImageDecodingPolicy;
    import flash.system.LoaderContext;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.clearTimeout;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    import flash.utils.setTimeout;
    
    import starling.cocosbuilder.CCBFile;
    import starling.cocosbuilder.CCBReader;
	import starling.cocosbuilder.CCBMFont;
    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.EventDispatcher;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.AtfData;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    
    /** Dispatched when all textures have been restored after a context loss. */
    [Event(name="texturesRestored", type="starling.events.Event")]
    
    /** The AssetManager handles loading and accessing a variety of asset types. You can 
     *  add assets directly (via the 'add...' methods) or asynchronously via a queue. This allows
     *  you to deal with assets in a unified way, no matter if they are loaded from a file, 
     *  directory, URL, or from an embedded object.
     *  
     *  <p>The class can deal with the following media types:
     *  <ul>
     *    <li>Textures, either from Bitmaps or ATF data</li>
     *    <li>Texture atlases</li>
     *    <li>Bitmap Fonts</li>
     *    <li>Sounds</li>
     *    <li>XML data</li>
     *    <li>JSON data</li>
     *    <li>ByteArrays</li>
     *  </ul>
     *  </p>
     *  
     *  <p>For more information on how to add assets from different sources, read the documentation
     *  of the "enqueue()" method.</p>
     * 
     *  <strong>Context Loss</strong>
     *  
     *  <p>When the stage3D context is lost (and you have enabled 'Starling.handleLostContext'),
     *  the AssetManager will automatically restore all loaded textures. To save memory, it will
     *  get them from their original sources. Since this is done asynchronously, your images might
     *  not reappear all at once, but during a timeframe of several seconds. If you want, you can
     *  pause your game during that time; the AssetManager dispatches an "Event.TEXTURES_RESTORED"
     *  event when all textures have been restored.</p>
     */
    public class AssetManager extends EventDispatcher
    {
        private var mScaleFactor:Number;
        private var mUseMipMaps:Boolean;
        private var mCheckPolicyFile:Boolean;
        private var mVerbose:Boolean;
        private var mNumLostTextures:int;
        private var mNumRestoredTextures:int;
        
        private var mQueue:Array;
        private var mIsLoading:Boolean;
        private var mTimeoutID:uint;
        
        private var mTextures:Dictionary;
        private var mAtlases:Dictionary;
        private var mSounds:Dictionary;
        private var mXmls:Dictionary;
        private var mObjects:Dictionary;
        private var mByteArrays:Dictionary;
		private var mCCBs:Dictionary;
        
        /** helper objects */
        private static var sNames:Vector.<String> = new <String>[];
		private static var sCCBReader:CCBReader;
        
        /** Create a new AssetManager. The 'scaleFactor' and 'useMipmaps' parameters define
         *  how enqueued bitmaps will be converted to textures. */
        public function AssetManager(scaleFactor:Number=1, useMipmaps:Boolean=false)
        {
            mVerbose = mCheckPolicyFile = mIsLoading = false;
            mScaleFactor = scaleFactor > 0 ? scaleFactor : Starling.contentScaleFactor;
            mUseMipMaps = useMipmaps;
            mQueue = [];
            mTextures = new Dictionary();
            mAtlases = new Dictionary();
            mSounds = new Dictionary();
            mXmls = new Dictionary();
            mObjects = new Dictionary();
            mByteArrays = new Dictionary();
			mCCBs = new Dictionary();
			
			sCCBReader = new CCBReader(this);
        }
        
        /** Disposes all contained textures. */
        public function dispose():void
        {
            for each (var texture:Texture in mTextures)
                texture.dispose();
            
            for each (var atlas:TextureAtlas in mAtlases)
                atlas.dispose();
        }
        
        // retrieving
        
        /** Returns a texture with a certain name. The method first looks through the directly
         *  added textures; if no texture with that name is found, it scans through all 
         *  texture atlases. */
        public function getTexture(name:String):Texture
        {
            if (name in mTextures) return mTextures[name];
            else
            {
                for each (var atlas:TextureAtlas in mAtlases)
                {
                    var texture:Texture = atlas.getTexture(name);
                    if (texture) return texture;
                }
                return null;
            }
        }
        
        /** Returns all textures that start with a certain string, sorted alphabetically
         *  (especially useful for "MovieClip"). */
        public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture>
        {
            if (result == null) result = new <Texture>[];
            
            for each (var name:String in getTextureNames(prefix, sNames))
                result.push(getTexture(name));
            
            sNames.length = 0;
            return result;
        }
        
        /** Returns all texture names that start with a certain string, sorted alphabetically. */
        public function getTextureNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            result = getDictionaryKeys(mTextures, prefix, result);
            
            for each (var atlas:TextureAtlas in mAtlases)
                atlas.getNames(prefix, result);
            
            result.sort(Array.CASEINSENSITIVE);
            return result;
        }
        
        /** Returns a texture atlas with a certain name, or null if it's not found. */
        public function getTextureAtlas(name:String):TextureAtlas
        {
            return mAtlases[name] as TextureAtlas;
        }
        
        /** Returns a sound with a certain name, or null if it's not found. */
        public function getSound(name:String):Sound
        {
            return mSounds[name];
        }
        
        /** Returns all sound names that start with a certain string, sorted alphabetically.
         *  If you pass a result vector, the names will be added to that vector. */
        public function getSoundNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            return getDictionaryKeys(mSounds, prefix, result);
        }
        
        /** Generates a new SoundChannel object to play back the sound. This method returns a 
         *  SoundChannel object, which you can access to stop the sound and to control volume. */ 
        public function playSound(name:String, startTime:Number=0, loops:int=0, 
                                  transform:SoundTransform=null):SoundChannel
        {
            if (name in mSounds)
                return getSound(name).play(startTime, loops, transform);
            else 
                return null;
        }
        
        /** Returns an XML with a certain name, or null if it's not found. */
        public function getXml(name:String):XML
        {
            return mXmls[name];
        }
        
        /** Returns all XML names that start with a certain string, sorted alphabetically. 
         *  If you pass a result vector, the names will be added to that vector. */
        public function getXmlNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            return getDictionaryKeys(mXmls, prefix, result);
        }

        /** Returns an object with a certain name, or null if it's not found. Enqueued JSON
         *  data is parsed and can be accessed with this method. */
        public function getObject(name:String):Object
        {
            return mObjects[name];
        }
        
        /** Returns all object names that start with a certain string, sorted alphabetically. 
         *  If you pass a result vector, the names will be added to that vector. */
        public function getObjectNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            return getDictionaryKeys(mObjects, prefix, result);
        }
        
        /** Returns a byte array with a certain name, or null if it's not found. */
        public function getByteArray(name:String):ByteArray
        {
            return mByteArrays[name];
        }
        
        /** Returns all byte array names that start with a certain string, sorted alphabetically. 
         *  If you pass a result vector, the names will be added to that vector. */
        public function getByteArrayNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            return getDictionaryKeys(mByteArrays, prefix, result);
        }
		
		public function getCCB(name:String):CCBFile
		{
			if (name in mCCBs) return mCCBs[name];
			else return null;
		}
        
        // direct adding
        
        /** Register a texture under a certain name. It will be available right away. */
        public function addTexture(name:String, texture:Texture):void
        {
            log("Adding texture '" + name + "' with " + texture.width + "x" + texture.height + " pixels");
            
            if (name in mTextures)
                log("Warning: name was already in use; the previous texture will be replaced.");
            
            mTextures[name] = texture;
        }
        
        /** Register a texture atlas under a certain name. It will be available right away. */
        public function addTextureAtlas(name:String, atlas:TextureAtlas):void
        {
            log("Adding texture atlas '" + name + "' with " + atlas.getNames().length + " atlas");
            
            if (name in mAtlases)
                log("Warning: name was already in use; the previous atlas will be replaced.");
            
            mAtlases[name] = atlas;
        }
        
        /** Register a sound under a certain name. It will be available right away. */
        public function addSound(name:String, sound:Sound):void
        {
            log("Adding sound '" + name + "'");
            
            if (name in mSounds)
                log("Warning: name was already in use; the previous sound will be replaced.");

            mSounds[name] = sound;
        }
        
        /** Register an XML object under a certain name. It will be available right away. */
        public function addXml(name:String, xml:XML):void
        {
            log("Adding XML '" + name + "'");
            
            if (name in mXmls)
                log("Warning: name was already in use; the previous XML will be replaced.");

            mXmls[name] = xml;
        }
        
        /** Register an arbitrary object under a certain name. It will be available right away. */
        public function addObject(name:String, object:Object):void
        {
            log("Adding object '" + name + "'");
            
            if (name in mObjects)
                log("Warning: name was already in use; the previous object will be replaced.");
            
            mObjects[name] = object;
        }
        
        /** Register a byte array under a certain name. It will be available right away. */
        public function addByteArray(name:String, byteArray:ByteArray):void
        {
            log("Adding byte array '" + name + "'");
            
            if (name in mObjects)
                log("Warning: name was already in use; the previous byte array will be replaced.");
            
            mByteArrays[name] = byteArray;
        }
		
		public function addCCB(name:String, ccb:CCBFile):void
		{
			log("Adding ccbi '" + name + "' with " + ccb.getSequenceCount() + " sequences");
			
			if (name in mCCBs)
				log("Warning: name was already in use; the previous ccb will be replaced.");
			
			mCCBs[name] = ccb;
		}
        
        // removing
        
        /** Removes a certain texture, optionally disposing it. */
        public function removeTexture(name:String, dispose:Boolean=true):void
        {
            log("Removing texture '" + name + "'");
            
            if (dispose && name in mTextures)
                mTextures[name].dispose();
            
            delete mTextures[name];
        }
        
        /** Removes a certain texture atlas, optionally disposing it. */
        public function removeTextureAtlas(name:String, dispose:Boolean=true):void
        {
            log("Removing texture atlas '" + name + "'");
            
            if (dispose && name in mAtlases)
                mAtlases[name].dispose();
            
            delete mAtlases[name];
        }
        
        /** Removes a certain sound. */
        public function removeSound(name:String):void
        {
            log("Removing sound '"+ name + "'");
            delete mSounds[name];
        }
        
        /** Removes a certain Xml object, optionally disposing it. */
        public function removeXml(name:String, dispose:Boolean=true):void
        {
            log("Removing xml '"+ name + "'");
            
            if (dispose && name in mXmls)
                System.disposeXML(mXmls[name]);
            
            delete mXmls[name];
        }
        
        /** Removes a certain object. */
        public function removeObject(name:String):void
        {
            log("Removing object '"+ name + "'");
            delete mObjects[name];
        }
        
        /** Removes a certain byte array, optionally disposing its memory right away. */
        public function removeByteArray(name:String, dispose:Boolean=true):void
        {
            log("Removing byte array '"+ name + "'");
            
            if (dispose && name in mByteArrays)
                mByteArrays[name].clear();
            
            delete mByteArrays[name];
        }
		
		public function removeCCB(name:String, dispose:Boolean=true):void
		{
			log("Removing ccb '" + name + "'");
			
			if (dispose && name in mCCBs)
				mCCBs[name].dispose();
			
			delete mCCBs[name];
		}
        
        /** Empties the queue and aborts any pending load operations. */
        public function purgeQueue():void
        {
            mIsLoading = false;
            mQueue.length = 0;
            clearTimeout(mTimeoutID);
        }
        
        /** Removes assets of all types, empties the queue and aborts any pending load operations.*/
        public function purge():void
        {
            log("Purging all assets, emptying queue");
            purgeQueue();
            
            for each (var texture:Texture in mTextures)
                texture.dispose();
            
            for each (var atlas:TextureAtlas in mAtlases)
                atlas.dispose();

            mTextures = new Dictionary();
            mAtlases = new Dictionary();
            mSounds = new Dictionary();
            mXmls = new Dictionary();
            mObjects = new Dictionary();
            mByteArrays = new Dictionary();
        }
        
        // queued adding
        
        /** Enqueues one or more raw assets; they will only be available after successfully 
         *  executing the "loadQueue" method. This method accepts a variety of different objects:
         *  
         *  <ul>
         *    <li>Strings containing an URL to a local or remote resource. Supported types:
         *        <code>png, jpg, gif, atf, mp3, xml, fnt, json, binary</code>.</li>
         *    <li>Instances of the File class (AIR only) pointing to a directory or a file.
         *        Directories will be scanned recursively for all supported types.</li>
         *    <li>Classes that contain <code>static</code> embedded assets.</li>
         *    <li>If the file extension is not recognized, the data is analyzed to see if
         *        contains XML or JSON data. If it's neither, it is stored as ByteArray.</li>
         *  </ul>
         *  
         *  <p>Suitable object names are extracted automatically: A file named "image.png" will be
         *  accessible under the name "image". When enqueuing embedded assets via a class, 
         *  the variable name of the embedded object will be used as its name. An exception
         *  are texture atlases: they will have the same name as the actual texture they are
         *  referencing.</p>
         *  
         *  <p>XMLs that contain texture atlases or bitmap fonts are processed directly: fonts are
         *  registered at the TextField class, atlas textures can be acquired with the
         *  "getTexture()" method. All other XMLs are available via "getXml()".</p>
         *  
         *  <p>If you pass in JSON data, it will be parsed into an object and will be available via
         *  "getObject()".</p>
         */
        public function enqueue(...rawAssets):void
        {
            for each (var rawAsset:Object in rawAssets)
            {
                if (rawAsset is Array)
                {
                    enqueue.apply(this, rawAsset);
                }
                else if (rawAsset is Class)
                {
                    var typeXml:XML = describeType(rawAsset);
                    var childNode:XML;
                    
                    if (mVerbose)
                        log("Looking for static embedded assets in '" + 
                            (typeXml.@name).split("::").pop() + "'"); 
                    
                    for each (childNode in typeXml.constant.(@type == "Class"))
                        enqueueWithName(rawAsset[childNode.@name], childNode.@name);
                    
                    for each (childNode in typeXml.variable.(@type == "Class"))
                        enqueueWithName(rawAsset[childNode.@name], childNode.@name);
                }
                else if (getQualifiedClassName(rawAsset) == "flash.filesystem::File")
                {
                    if (!rawAsset["exists"])
                    {
                        log("File or directory not found: '" + rawAsset["url"] + "'");
                    }
                    else if (!rawAsset["isHidden"])
                    {
                        if (rawAsset["isDirectory"])
                            enqueue.apply(this, rawAsset["getDirectoryListing"]());
                        else
                            enqueueWithName(rawAsset["url"]);
                    }
                }
                else if (rawAsset is String)
                {
                    enqueueWithName(rawAsset);
                }
                else
                {
                    log("Ignoring unsupported asset type: " + getQualifiedClassName(rawAsset));
                }
            }
        }
        
        /** Enqueues a single asset with a custom name that can be used to access it later. 
         *  If you don't pass a name, it's attempted to generate it automatically.
         *  @returns the name under which the asset was registered. */
        public function enqueueWithName(asset:Object, name:String=null):String
        {
            if (name == null) name = getName(asset);
            log("Enqueuing '" + name + "'");
            
            mQueue.push({
                name: name,
                asset: asset
            });
            
            return name;
        }
        
        /** Loads all enqueued assets asynchronously. The 'onProgress' function will be called
         *  with a 'ratio' between '0.0' and '1.0', with '1.0' meaning that it's complete.
         *
         *  @param onProgress: <code>function(ratio:Number):void;</code> 
         */
        public function loadQueue(onProgress:Function):void
        {
            if (Starling.context == null)
                throw new Error("The Starling instance needs to be ready before textures can be loaded.");
            
            if (mIsLoading)
                throw new Error("The queue is already being processed");
            
            var xmls:Dictionary = new Dictionary;
			var textFonts:Dictionary = new Dictionary;
            var numElements:int = mQueue.length;
            var currentRatio:Number = 0.0;
            
            mIsLoading = true;
            resume();
            
            function resume():void
            {
                if (!mIsLoading)
                    return;
                
                currentRatio = mQueue.length ? 1.0 - (mQueue.length / numElements) : 1.0;
                
                if (mQueue.length)
                    mTimeoutID = setTimeout(processNext, 1);
                else
                {
                    processXmls();
					processTextFonts();
                    mIsLoading = false;
                }
                
                if (onProgress != null)
                    onProgress(currentRatio);
            }
            
            function processNext():void
            {
                var assetInfo:Object = mQueue.pop();
                clearTimeout(mTimeoutID);
                processRawAsset(assetInfo.name, assetInfo.asset, xmls, textFonts, progress, resume);
            }
            
            function processXmls():void
            {
                // xmls are processed seperately at the end, because the textures they reference
                // have to be available for other XMLs. Texture atlases are processed first:
                // that way, their textures can be referenced, too.
                
                //xmls.sort(function(a:XML, b:XML):int { 
                //    return a.localName() == "TextureAtlas" ? -1 : 1; 
                //});
                
                for (var key:String in xmls)
                {
					var xml:XML = xmls[key];
                    var name:String;
                    var texture:Texture;
                    var rootNode:String = xml.localName();
                    
                    if (rootNode == "TextureAtlas")
                    {
                        name = getName(xml.@imagePath.toString());
                        texture = getTexture(name);
                        
                        if (texture)
                        {
                            addTextureAtlas(name, new TextureAtlas(texture, xml));
                            removeTexture(name, false);
                        }
                        else log("Cannot create atlas: texture '" + name + "' is missing.");
                    }
                    else if (rootNode == "font")
                    {
                        name = getName(xml.pages.page.@file.toString());
                        texture = getTexture(name);
						if (texture == null)
						{
							name = key;
							if (isFileName(name))
							{
								var texFileName:String = resolvePath(name, xml.pages.page.@file.toString());
								texture = getTexture(texFileName);
							}
						}
                        
                        if (texture)
                        {
                            log("Adding bitmap font '" + name + "'");
                            TextField.registerBitmapFont(new BitmapFont(texture, xml), name);
                        }
                        else log("Cannot create bitmap font: texture '" + name + "' is missing.");
                    }
					else if (rootNode == "plist")
					{
						var dictionary:Dictionary = LoadDictionaryFromXML(xml.dict[0]) as Dictionary;
						
						name = key;
						var metas:Dictionary = dictionary["metadata"];
						var realTextureFileName:String = metas["realTextureFileName"];
						var pos:int = name.lastIndexOf("/")+1;
						if (pos > 0)
						{
							var textureFileName:String = name.substr(0, pos) + realTextureFileName;
							texture = getTexture(textureFileName);
						}
						else
						{
							texture = getTexture(realTextureFileName);
							if (texture == null)
								texture = getTexture(getName(realTextureFileName));
						}
						
						if (texture)
						{
							var atlas:TextureAtlas = new TextureAtlas(texture, null);
							parseAtlasDictionary(atlas, dictionary);
							addTextureAtlas(name, atlas);
						}
						else log("Cannot create atlas: texture '" + name + "' is missing.");
					}
                    else
                        throw new Error("XML contents not recognized: " + rootNode);
                    
                    System.disposeXML(xml);
                }
            }
			
			function processTextFonts():void
			{
				for (var key:String in textFonts)
				{
					var dict:Dictionary = textFonts[key];
					
					var texture:Texture;
					var name:String = key;
					var pageArray:Array = dict["page"] as Array;
					for (var i:uint=0; i < pageArray.length; i++)
					{
						var page:Dictionary = pageArray[i] as Dictionary;
						var pageFile:String = page["file"];
						var pageTextureFileName:String = resolvePath(name, pageFile);
						texture = getTexture(pageTextureFileName);
					}
					if (texture)
					{
						log("Adding bitmap font '" + name + "'");
						TextField.registerBitmapFont(new CCBMFont(texture, null, dict), name);
					}
					else log("Cannot create bitmap font: texture '" + name + "' is missing.");					
				}
			}
			
            function progress(ratio:Number):void
            {
                onProgress(currentRatio + (1.0 / numElements) * Math.min(1.0, ratio) * 0.99);
            }
        }
        
        private function processRawAsset(name:String, rawAsset:Object, xmls:Dictionary, textFonts:Dictionary,
                                         onProgress:Function, onComplete:Function):void
        {
            loadRawAsset(name, rawAsset, onProgress, process); 
            
            function process(asset:Object):void
            {
                var texture:Texture;
                var bytes:ByteArray;
                
                if (!mIsLoading)
                {
                    onComplete();
                }
                else if (asset is Sound)
                {
                    addSound(name, asset as Sound);
                    onComplete();
                }
                else if (asset is Bitmap)
                {
                    texture = Texture.fromBitmap(asset as Bitmap, mUseMipMaps, false, mScaleFactor);
                    texture.root.onRestore = function():void
                    {
                        mNumLostTextures++;
                        loadRawAsset(name, rawAsset, null, function(asset:Object):void
                        {
                            try { texture.root.uploadBitmap(asset as Bitmap); }
                            catch (e:Error) { log("Texture restoration failed: " + e.message); }
                            
                            asset.bitmapData.dispose();
                            mNumRestoredTextures++;
                            
                            if (mNumLostTextures == mNumRestoredTextures)
                                dispatchEventWith(Event.TEXTURES_RESTORED);
                        });
                    };

                    asset.bitmapData.dispose();
                    addTexture(name, texture);
                    onComplete();
                }
                else if (asset is ByteArray)
                {
                    bytes = asset as ByteArray;
                    
                    if (AtfData.isAtfData(bytes))
                    {
                        texture = Texture.fromAtfData(bytes, mScaleFactor, mUseMipMaps, onComplete);
                        texture.root.onRestore = function():void
                        {
                            mNumLostTextures++;
                            loadRawAsset(name, rawAsset, null, function(asset:Object):void
                            {
                                try { texture.root.uploadAtfData(asset as ByteArray, 0, true); }
                                catch (e:Error) { log("Texture restoration failed: " + e.message); }
                                
                                asset.clear();
                                mNumRestoredTextures++;
                                
                                if (mNumLostTextures == mNumRestoredTextures)
                                    dispatchEventWith(Event.TEXTURES_RESTORED);
                            });
                        };
                        
                        bytes.clear();
                        addTexture(name, texture);
                    }
                    else if (byteArrayStartsWith(bytes, "{") || byteArrayStartsWith(bytes, "["))
                    {
                        addObject(name, JSON.parse(bytes.readUTFBytes(bytes.length)));
                        bytes.clear();
                        onComplete();
                    }
                    else if (byteArrayStartsWith(bytes, "<"))
                    {
                        process(new XML(bytes));
                        bytes.clear();
                    }
					else if (CCBReader.isCCBData(bytes))
					{
						addCCB(name, sCCBReader.read(bytes));
						bytes.clear();
						onComplete();
					}
					else if (byteArrayStartsWith(bytes, "info"))
					{
						var dict:Dictionary = LoadDictionaryFromText(bytes.toString()) as Dictionary;
						var pageArray:Array = dict["page"] as Array;
						for (var i:uint=0; i < pageArray.length; i++)
						{
							var page:Dictionary = pageArray[i] as Dictionary;
							var pageFile:String = page["file"];
							var pageTextureFileName:String = resolvePath(name, pageFile);
							enqueueWithName(pageTextureFileName, pageTextureFileName);
						}
						textFonts[name] = dict;
						onComplete();
					}
                    else
                    {
                        addByteArray(name, bytes);
                        onComplete();
                    }
                }
                else if (asset is XML)
                {
                    var xml:XML = asset as XML;
                    var rootNode:String = xml.localName();
                    
                    if (rootNode == "TextureAtlas" || rootNode == "font" || rootNode == "plist")
					{
						if (rootNode == "plist")
						{
							if (isFileName(name))
							{
								var dictionary:Dictionary = LoadDictionaryFromXML(xml.dict[0]) as Dictionary;
								var metas:Dictionary = dictionary["metadata"];
								var realTextureFileName:String = metas["realTextureFileName"];
								var textureFileName:String = resolvePath(name, realTextureFileName);
								enqueueWithName(textureFileName, textureFileName);
							}
						}
						else if (rootNode == "font")
						{
							if (isFileName(name))
							{
								var texFileName:String = resolvePath(name, xml.pages.page.@file.toString());
								enqueueWithName(texFileName, texFileName);
							}
						}
                        xmls[name] = xml;
					}
                    else
                        addXml(name, xml);
                    
                    onComplete();
                }
                else if (asset == null)
                {
                    onComplete();
                }
                else
                {
                    log("Ignoring unsupported asset type: " + getQualifiedClassName(asset));
                    onComplete();
                }
                
                // avoid that objects stay in memory (through 'onRestore' functions)
                asset = null;
                bytes = null;
            }
        }
        
        private function loadRawAsset(name:String, rawAsset:Object, 
                                      onProgress:Function, onComplete:Function):void
        {
            var extension:String = null;
            var urlLoader:URLLoader = null;
			var fileRef:FileReference = null;
            
            if (rawAsset is Class)
            {
                setTimeout(onComplete, 1, new rawAsset());
            }
            else if (rawAsset is String)
            {
                var url:String = rawAsset as String;
                extension = url.split(".").pop().toLowerCase().split("?")[0];
                
                urlLoader = new URLLoader();
                urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
                urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
                urlLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
                urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
                urlLoader.load(new URLRequest(url));
            }
			else if (rawAsset is FileReference)
			{
				fileRef = rawAsset as FileReference;
				var fileName:String = fileRef.name;
				extension = fileName.split(".").pop().toLowerCase().split("?")[0];
				
				fileRef.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				fileRef.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				fileRef.addEventListener(Event.COMPLETE, onFileLoaderComplete);
				fileRef.load();
			}
            
            function onIoError(event:IOErrorEvent):void
            {
                log("IO error: " + event.text);
                onComplete(null);
            }
            
            function onLoadProgress(event:ProgressEvent):void
            {
                if (onProgress != null)
                    onProgress(event.bytesLoaded / event.bytesTotal);
            }
            
            function onUrlLoaderComplete(event:Object):void
            {
                var bytes:ByteArray = urlLoader.data as ByteArray;
                var sound:Sound;
                
                urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
                urlLoader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
                urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderComplete);
                
                switch (extension)
                {
                    case "mp3":
                        sound = new Sound();
                        sound.loadCompressedDataFromByteArray(bytes, bytes.length);
                        bytes.clear();
                        onComplete(sound);
                        break;
                    case "jpg":
                    case "jpeg":
                    case "png":
                    case "gif":
                        var loaderContext:LoaderContext = new LoaderContext(mCheckPolicyFile);
                        var loader:Loader = new Loader();
                        loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
                        loader.loadBytes(bytes, loaderContext);
                        break;
                    default: // any XML / JSON / binary data 
                        onComplete(bytes);
                        break;
                }
            }
			
			function onFileLoaderComplete(event:Object):void
			{
				var bytes:ByteArray = event.target.data as ByteArray;
				var sound:Sound;
				
				fileRef.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				fileRef.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				fileRef.removeEventListener(Event.COMPLETE, onFileLoaderComplete);
				
				switch (extension)
				{
					case "mp3":
						sound = new Sound();
						sound.loadCompressedDataFromByteArray(bytes, bytes.length);
						bytes.clear();
						onComplete(sound);
						break;
					case "jpg":
					case "jpeg":
					case "png":
					case "gif":
						var loaderContext:LoaderContext = new LoaderContext(mCheckPolicyFile);
						var loader:Loader = new Loader();
						loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
						loader.loadBytes(bytes, loaderContext);
						break;
					default: // any XML / JSON / binary data 
						onComplete(bytes);
						break;
				}
			}
            
            function onLoaderComplete(event:Object):void
            {
                urlLoader.data.clear();
                event.target.removeEventListener(Event.COMPLETE, onLoaderComplete);
                onComplete(event.target.content);
            }
        }
		
		private static function resolvePath(path:String, file:String):String
		{
			var lastSlashPos:int = path.lastIndexOf("/") + 1;
			if (lastSlashPos > 0)
				return path.substr(0, lastSlashPos) + file;
			return file;
		}
		
		private static function isFileName(file:String):Boolean { return file.lastIndexOf(".") != -1; }
        
        // helpers
        
        /** This method is called by 'enqueue' to determine the name under which an asset will be
         *  accessible; override it if you need a custom naming scheme. Typically, 'rawAsset' is 
         *  either a String or a FileReference. Note that this method won't be called for embedded
         *  assets. */
        protected function getName(rawAsset:Object):String
        {
            var matches:Array;
            var name:String;
            
            if (rawAsset is String || rawAsset is FileReference)
            {
                name = rawAsset is String ? rawAsset as String : (rawAsset as FileReference).name;
                name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
                matches = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(name);
                
                if (matches && matches.length == 4) return matches[2];
                else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
            }
            else
            {
                name = getQualifiedClassName(rawAsset);
                throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
            }
        }
        
        /** This method is called during loading of assets when 'verbose' is activated. Per
         *  default, it traces 'message' to the console. */
        protected function log(message:String):void
        {
            if (mVerbose) { 
				trace("[CocosAssetManager]", message);
				//if (Starling.current != null) Starling.current.addMessage(message);
			}
        }
        
        private function byteArrayStartsWith(bytes:ByteArray, char:String):Boolean
        {
            var start:int = 0;
            var length:int = bytes.length;
            var wanted:int = char.charCodeAt(0);
            
            // recognize BOMs
            
            if (length >= 4 &&
                (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0xfe && bytes[3] == 0xff) ||
                (bytes[0] == 0xff && bytes[1] == 0xfe && bytes[2] == 0x00 && bytes[3] == 0x00))
            {
                start = 4; // UTF-32
            }
            else if (length >= 3 && bytes[0] == 0xef && bytes[1] == 0xbb && bytes[2] == 0xbf)
            {
                start = 3; // UTF-8
            }
            else if (length >= 2 &&
                (bytes[0] == 0xfe && bytes[1] == 0xff) || (bytes[0] == 0xff && bytes[1] == 0xfe))
            {
                start = 2; // UTF-16
            }
            
            // find first meaningful letter
            
            for (var i:int=start; i<length; ++i)
            {
                var byte:int = bytes[i];
                if (byte == 0 || byte == 10 || byte == 13 || byte == 32) continue; // null, \n, \r, space
                else return byte == wanted;
            }
            
            return false;
        }
        
        private function getDictionaryKeys(dictionary:Dictionary, prefix:String="",
                                           result:Vector.<String>=null):Vector.<String>
        {
            if (result == null) result = new <String>[];
            
            for (var name:String in dictionary)
                if (name.indexOf(prefix) == 0)
                    result.push(name);
            
            result.sort(Array.CASEINSENSITIVE);
            return result;
        }
		
		private function LoadDictionaryFromXML(xml:XML):Object
		{
			var nodeName:String = xml.localName();
			if (nodeName == "dict")
			{
				var dictionary:Dictionary = new Dictionary;
				var children:XMLList = xml.children();
				var numChildren:int = children.length();
				for (var i:int = 0; i < numChildren; i++)
				{
					var child:XML = children[i];
					var childName:String = child.localName();
					if (childName == "key")
					{
						i++;
						var keyName:String = child.text();
						dictionary[keyName] = LoadDictionaryFromXML(children[i]);
					}
				}
				return dictionary;
			}
			else if (nodeName == "string")
			{
				var stringValue:String = xml.text();
				return stringValue;
			}
			else if (nodeName == "float")
			{
				var floatValue:String = xml.text();
				return parseFloat(floatValue);
			}
			else if (nodeName == "integer")
			{
				var integerValue:String = xml.text();
				return (int)(parseInt(integerValue));
			}
			else
			{
				if (nodeName == "true") return Boolean(true);
				else if (nodeName == "false") return Boolean(false);
			}
			return null;
		}
		
		private function LoadDictionaryFromKeyValues(text:String):Object
		{
			var dictionary:Dictionary = new Dictionary;
			var char:String;
			var quotationNum:int = 0;
			var pair:String = "";
			var pairDone:Boolean = false;
			for (var i:int = 0; i < text.length; i++)
			{
				char = text.charAt(i);
				if ((char == " " || char == "\t") && (quotationNum == 0))
				{
  					pairDone = true;
				}
				else 
				{
					if (char == "\"")
					{
						// TODO: cause bug(file="""hello""")
						if (quotationNum == 0) quotationNum = 1;
						else if (quotationNum == 1) quotationNum = 0;
					}
					else
					{
						pair += char;
					}
					if (i == text.length - 1) pairDone = true;
				}
				if (pairDone)
				{
					pairDone = false;
					if (pair.length > 0)
					{
						var keyValue:Array = pair.split("=");
						pair = "";
						if (keyValue.length != 2) continue;
						dictionary[keyValue[0]] = keyValue[1];
					}
				}
			}
			return dictionary;
		}
		
		private function LoadDictionaryFromText(text:String):Object
		{
			var dictionary:Dictionary = new Dictionary;
			var lines:Array = text.split("\r\n");
			for(var i:int = 0; i < lines.length; i++)
			{
				var line:String = lines[i];
				var keyIndex:int;
				keyIndex = line.indexOf(" ");
				if (keyIndex >= 0)
				{
					var key:String = line.substr(0, keyIndex);
					var array:Array = dictionary[key];
					if (array == null)
					{
						array = new Array;
						dictionary[key] = array;
					}
					array.push(LoadDictionaryFromKeyValues(line.substr(key.length)));
				}
			}
			return dictionary;
		}
		
		public function isInQueue(value:String):Boolean
		{
			var numElement:uint = mQueue.length;
			for (var i:uint=0; i < numElement; i++)
			{
				if (mQueue[i].name == value)
					return true;
			}
			return false;
		}
		
		public function isLoaded(value:String):Boolean
		{
			if (value in mTextures) return true;
			if (value in mAtlases) return true;
			if (value in mSounds) return true;
			if (value in mXmls) return true;
			if (value in mObjects) return true;
			if (value in mByteArrays) return true;
			if (value in mCCBs) return true;
			return false;
		}
		
		public function parseAtlasDictionary(atlas:TextureAtlas, dict:Dictionary):void
		{
			var frames:Dictionary = dict["frames"];
			for (var name:String in frames)
			{
				var frameDict:Dictionary = frames[name];
				var frame:Rectangle = extracRectangle(frameDict["frame"]);
				var offset:Point = extracPoint(frameDict["offset"]);
				var sourceColorRect:Rectangle = extracRectangle(frameDict["sourceColorRect"]);
				var sourceSize:Point = extracPoint(frameDict["sourceSize"]);
				var rotated:Boolean = frameDict["rotated"];
				
				var region:Rectangle = new Rectangle(frame.x, frame.y, rotated ? frame.height : frame.width, rotated ? frame.width : frame.height);
				var frameTarget:Rectangle  = new Rectangle(-sourceColorRect.x, -sourceColorRect.y, sourceSize.x, sourceSize.y);
				
				atlas.addRegion(name, region, frameTarget, rotated);
			}
		}
		
		private function extracRectangle(format:String):Rectangle
		{
			var numbers:Array = format.match(/\d+/g);
			if (4 != numbers.length) return null;
			var rect:Rectangle = new Rectangle;
			rect.left   = parseInt(numbers[0]);
			rect.top    = parseInt(numbers[1]);
			rect.width  = parseInt(numbers[2]);
			rect.height = parseInt(numbers[3]);
			return rect;
		}
		
		private function extracPoint(format:String):Point
		{
			var numbers:Array = format.match(/\d+/g);
			if (2 != numbers.length) return null;
			var point:Point = new Point;
			point.x = parseInt(numbers[0]);
			point.y = parseInt(numbers[1]);
			return point;
		}
        
        // properties
        
        /** The queue contains one 'Object' for each enqueued asset. Each object has 'asset'
         *  and 'name' properties, pointing to the raw asset and its name, respectively. */
        protected function get queue():Array { return mQueue; }
        
        /** Returns the number of raw assets that have been enqueued, but not yet loaded. */
        public function get numQueuedAssets():int { return mQueue.length; }
        
        /** When activated, the class will trace information about added/enqueued assets. */
        public function get verbose():Boolean { return mVerbose; }
        public function set verbose(value:Boolean):void { mVerbose = value; }
        
        /** For bitmap textures, this flag indicates if mip maps should be generated when they 
         *  are loaded; for ATF textures, it indicates if mip maps are valid and should be
         *  used. */
        public function get useMipMaps():Boolean { return mUseMipMaps; }
        public function set useMipMaps(value:Boolean):void { mUseMipMaps = value; }
        
        /** Textures that are created from Bitmaps or ATF files will have the scale factor 
         *  assigned here. */
        public function get scaleFactor():Number { return mScaleFactor; }
        public function set scaleFactor(value:Number):void { mScaleFactor = value; }
        
        /** Specifies whether a check should be made for the existence of a URL policy file before
         *  loading an object from a remote server. More information about this topic can be found 
         *  in the 'flash.system.LoaderContext' documentation. */
        public function get checkPolicyFile():Boolean { return mCheckPolicyFile; }
        public function set checkPolicyFile(value:Boolean):void { mCheckPolicyFile = value; }
    }
}
