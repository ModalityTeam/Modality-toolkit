/*
Questions:
* update cache only when files newer than cache were added
- it is really fast anyway, so just do on every startup? -
*/

MKtlDesc {

	classvar <defaultFolder, <folderName = "MKtlDescriptions";
	classvar <descExt = ".desc.scd", <compExt = ".comp.scd";
	classvar <parentExt = ".parentDesc.scd";
	classvar <descFolders;
	classvar <userFolder;

	classvar <allDescs;
	classvar <cacheName = "_allDescs.cache.scd";
	classvar <fileToIDDict;

	classvar <webview;
	classvar <docURI = "http://modalityteam.github.io/controllers/";

	classvar <>isElemFunc;
	classvar <>platformSpecific = true;

	classvar <groupFuncs;

	var <name, <fullDesc, <path;
	var <elementsDict;

	*initClass {
		defaultFolder = MKtlDesc.filenameSymbol.asString.dirname.dirname.dirname
		+/+ folderName;
		this.checkUserFolder;
		descFolders = List[defaultFolder, userFolder];
		allDescs =();
		isElemFunc = { |el|
			el.isKindOf(Dictionary) and: { el[\elements].isNil }
		};

		fileToIDDict = Dictionary.new;

		this.initGroupFuncs;

		this.loadCache;
	}

	*checkUserFolder {
		userFolder = Platform.userAppSupportDir +/+ folderName;
		if (userFolder.pathMatch.isEmpty) {
			File.mkdir(userFolder)
		};
	}

	*initGroupFuncs {
		groupFuncs = (
			// // remain single elements, should not be needed at all
			// // - maybe use only to switch MPadView to its proper mode.
			noteOnTrig: { |dict|
				dict.putAll((\midiMsgType: \noteOn, \spec: \midiBut));
			},
			noteOnVel: { |dict|
				dict.putAll((\midiMsgType: \noteOn, \spec: \midiVel));
			},
			// default
			noteOnOff: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiVel),
					(key: \off, midiMsgType: \noteOff, spec: \midiBut, elementType: \padUp)
				]).put(\useSingleGui, true);
			},
			// others
			noteOnOffBut: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiBut),
					(key: \off, midiMsgType: \noteOff, spec: \midiBut, elementType: \padUp)
				]).put(\useSingleGui, true);
			},
			noteOnOffVel: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiVel),
					(key: \off, midiMsgType: \noteOff, spec: \midiVel, elementType: \padUp)
				]).put(\useSingleGui, true);
			},
			noteOnOffTouch: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiVel),
					(key: \off, midiMsgType: \noteOff, spec: \midiBut, elementType: \padUp),
					(key: \touch, midiMsgType: \polytouch, spec: \midiVel, elementType: \padMove)
				]).put(\useSingleGui, true);
			},
			noteOnOffVelTouch: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiVel),
					(key: \off, midiMsgType: \noteOff, spec: \midiVel, elementType: \padUp),
					(key: \touch, midiMsgType: \polytouch, spec: \midiVel, elementType: \padMove)
				]).put(\useSingleGui, true);
			},
			// fader touch on/off + control
			noteOnOffButCtl: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiBut),
					(key: \off, midiMsgType: \noteOff, spec: \midiBut, elementType: \padUp),
					(key: \ctl, midiMsgType: \control, spec: \midiVel, elementType: \padMove)
				]).put(\useSingleGui, true);
			},
			// velocity on, but off, pressure -> control
			noteOnOffCtl: { |dict|
				dict.put(\elements, [
					(key: \on,  midiMsgType: \noteOn,  spec: \midiVel),
					(key: \off, midiMsgType: \noteOff, spec: \midiBut, elementType: \padUp),
					(key: \ctl, midiMsgType: \control, spec: \midiVel, elementType: \padMove)
				]).put(\useSingleGui, true);
			},
		);
	}

	*deepExpand { |groupDict, groupType|
		^if (isElemFunc.value(groupDict)) {
			this.expandElemToGroup(groupDict, groupType);
		} {
			groupDict.elements.collect { |elemDict|
				this.deepExpand(elemDict, groupType)
			}
		}
	}

	*expandElemToGroup { |dict, groupType|
		var groupFunc, groupDict;
		groupType = groupType ? dict[\groupType];
		if (groupType.isNil) { ^dict };

		groupFunc = groupFuncs[groupType];
		if (groupFunc.isNil) {
			"%: no groupFunc found at %\n".postf(thisMethod, groupType.cs);
			^dict
		};
		groupDict = groupFunc.value(dict) ? dict;
		^groupDict.put(\groupType, groupType);
	}

	// access to all
	*at { |descName|
		^allDescs[descName]
	}

	// WEB interface
	*web { |ctlname = ""|
		webview = webview ?? { WebView() };
		webview.front.url_((docURI +/+ ctlname).postcs);
		webview.onClose_({ webview = nil });
	}

	docURI {|relative = false|
		if (relative) {
			^(name.asString ++ ".html");
		} {
			^(this.class.docURI +/+ name.asString ++ ".html");
		}
	}
	web {
		this.class.web(this.docURI(relative: true));
	}

	//----------- File admin methods:

	*addFolder { |path, name = (folderName)|
		var folderPath = path.standardizePath +/+ name;
		var foundFolder = pathMatch(folderPath);

		if (descFolders.includesEqual(folderPath)) { ^this };
		descFolders.add(folderPath);
		if (foundFolder.notEmpty) {
			"MKtlDesc found and added folder: %\n".postf(foundFolder.cs);
		} {
			"// MKtlDesc added a nonexistent folder: %\n.".postf(name.cs);
			"// you can create it with:"
			"\n File.mkdir(\"%\");\n".postf(folderPath);
		}
	}

	*openFolder { |index = 0|
		descFolders[index].openOS;
	}

	*findFile { |filename = "*", folderIndex, postFound = false, fileExt|
		var foundPaths, foldersToLoad, plural = 0;
		folderIndex = folderIndex ?? { (0 .. descFolders.size-1) };
		foldersToLoad = descFolders[folderIndex.asArray].select(_.notNil);

		fileExt = fileExt ? descExt;

		foundPaths = foldersToLoad.collect { |dir|
			(dir +/+ filename ++ fileExt).pathMatch
			// add depth of one folders
			// worked like this for osx and linux:
			// ++ (dir +/+ "*" +/+ filename ++ fileExt).pathMatch
			// quick fix for windows, where pathMatch does not allow
			// wildcards for dirs, like "path/*/*.desc.scd"
			++ (dir +/+ "*").pathMatch.collect { |folder|
				(folder +/+ filename ++ fileExt).pathMatch
			}.flatten(1)
		}.flatten(1);

		if (postFound) {
			plural = if (foundPaths.size == 1, "s", "");
			"\n*** MKtlDesc found % file% for'%': ***\n"
			.postf(foundPaths.size, plural, filename);
			foundPaths.printcsAll; "".postln;
		}

		^foundPaths
	}

	*postLoadable {|folderIndex|
		folderIndex = folderIndex ?? { (0..descFolders.lastIndex) };
		descFolders[folderIndex.asArray].do { |folder, i|
			var found = this.findFile(folderIndex: i);
			"*** % descs in folder % - % : ***\n".postf(found.size, i, folder);
			found.do { |path|
				var loadStr = path.basename.drop(this.descExt.size.neg);
				("(" ++ loadStr.cs ++ ")").postln;
			};
			"****\n".postln;
		};
	}

	*loadDescs { |filename = "*", folderIndex, post = false|
		var paths = this.findFile(filename, folderIndex);
		var descs = paths.collect {|path|
			try { this.fromPath(path); };
		}.select(_.notNil);

		if (post) {
			"\n// MKtlDesc loaded % valid description files - see:"
			"\nMKtlDesc.allDescs;\n".postf(paths.size);
		};
		^descs
	}

	*postLoaded {
		"\n*** MKtlDesc - loaded descs: ***".postln;
		allDescs.keys(SortedList).do { |key|
			"% // %\n".postf(allDescs[key], allDescs[key].idInfo);
		};
		"******\n".postln;
	}

	// info
	*postStatus { |showWorking = false|
		var maxNameLen = 0, numOK = 0;
		var descs = MKtlDesc.loadDescs;
		var test = { |desc| desc.fullDesc.status.beginsWith("tested and working") };
		descs.do { |desc|
			maxNameLen = max(maxNameLen, desc.name.cs.size);
			if (test.value(desc)) {
				numOK = numOK + 1
			};
		};

		"\n% - descs: % tested and working : %.\n\n"
		.postf(thisMethod, descs.size, numOK);

		if (showWorking) { "All descs:\n" } { "Not fully working yet:\n" }.postln;

		descs.sort { |a, b| a.fullDesc.status < b.fullDesc.status; };
		descs.do { |desc|
			if (showWorking or: { test.value(desc).not })  {
				(desc.name.cs.padRight(maxNameLen) + desc.fullDesc.status).postln
			};
		};
	}


	// create lookup dicts for filename -> idInfo and back
	// this will allow loading just the file needed, not all files.

	*idInfoForFilename { |filename| ^fileToIDDict.at(filename) }

	*filenamesForIDInfo { |idInfoFromDev|
		^fileToIDDict.select { |idInfoInFile, filename|
			// "matchInfo: %, %\n".postf(idInfoFromDev, idInfoInFile);
			this.matchInfo(idInfoFromDev, idInfoInFile)
		}.keys(Array).sort;
	}

	*matchInfo { |infoFromDev, infoInFile|
		if (infoFromDev == infoInFile) { ^true };

		if (infoFromDev.isKindOf(Dictionary).not) { infoFromDev = (deviceName: infoFromDev) };
		if (infoInFile.isKindOf(Dictionary).not) { infoInFile = (deviceName: infoInFile) };

		^(infoFromDev.deviceName == infoInFile.deviceName)
		and: { infoFromDev.srcPortIndex == infoInFile.srcPortIndex }
		// destPortIndex matches if srcPortIndex does
	}

	// compare a generic desc with a HID as found,
	// and return non-matching elements for each side:
	matchWithHID { |hid|
		var hidElems = hid.elements;
		var onlyInDesc = elementsDict.copy;
		var onlyInHid = hidElems.copy;
		elementsDict.keysValuesDo { |desckey, descelem|
			onlyInHid.keysValuesDo { |hidkey, hidelem|
				if ((descelem.hidUsage == hidelem.usage)
					and: (descelem.hidUsagePage == hidelem.usagePage)) {
					onlyInDesc.removeAt(desckey);
					onlyInHid.removeAt(hidkey);
				}
			}
		};
		^(onlyInDesc: onlyInDesc, onlyInHid: onlyInHid);
	}

	*findGenericForHID { |hid, rateForMatch = 0.5|
		var numHidElems = hid.elements.size;
		var candList = [], candidate;
		MKtlDesc.loadDescs("*generic*").do { |desc|
			var onlyDict = desc.matchWithHID(hid);
			var hidOnlySize = onlyDict[\onlyInHid].size;
			var descOnlySize = onlyDict[\onlyInDesc].size;

			// jump out if perfect match
			if (hidOnlySize + descOnlySize == 0) {
				"MKtlDesc: found exact generic desc matching %.\n"
				.postf(hid.info);
				^desc
			};

			// some degree of mismatch
			if ( hidOnlySize < (numHidElems * rateForMatch)) {
				onlyDict.put(\desc, desc);
				candList.add(onlyDict);
			}
		};

		candList;

		if (candList.isEmpty) { ^nil };

		if (candList.size > 1) {
			// more than one - sort candidates by fullest match of onlyInHid
			candList.sort { |a, b| a.onlyInHid.size < b.onlyInHid.size };
			"%: found multiple candidate descs: \n".postf(hid.info);
			candList.do (_.postcs);
			"-> taking best matching first desc.".postln;
		};

		candidate = candList[0];

		"\nMKtlDesc: found partially matching desc: %.\n".postf(hid.info);
		if (candidate.onlyInHid.size > 0) {
			"Some HID elements are not in the desc and cannot be used:".postln;
			candidate[\onlyInHid].sortedKeysValuesDo { |key, val|
				(key -> val).postln;
			};
			"Please adapt % as new desc file and add entries for these.\n"
			.postf(candidate.desc)
		};

		if ( candidate.onlyInDesc.size > 0) {
			"Some desc elements are not in the HID and cannot be used:".postln;
			candidate[\onlyInDesc].sortedKeysValuesDo { |key, val|
				(key -> val).postln;
			};
			"Please adapt % as new desc file and remove the entries for these.\n"
			.postf(candidate.desc)
		};
		"".postln;

		^candidate.desc
	}

	*writeCache {
		var dictForFolder = Dictionary.new, file;

		descFolders.do { |folder, i|
			var descs = MKtlDesc.loadDescs(folderIndex: i);
			var path = folder +/+ cacheName;

			descs.collect { |desc|
				var filename = desc.fullDesc.filename;
				var idInfo = desc.fullDesc.idInfo;
				dictForFolder.put(filename, idInfo);
			};
			file = File.open(path, "w");
			if (file.isOpen) {
				file.write("Dictionary[\n");
				dictForFolder.sortedKeysValuesDo { |key, val|
					file.write("\t" ++ (key -> val).cs ++ ",\n");
				};
				file.write("]\n");
				file.close;
				"MKtlDesc cache written with % entries at %.\n".postf(dictForFolder.size, path);
			} {
				warn("MKtlDesc: could not write cache at %.\n".format(path));
			}
		};
	}

	*loadCache {
		// clear first? maybe better not
		descFolders.do { |folder|
			var loadedList = (folder +/+ cacheName).load;
			//	("// loadedList: \n" + loadedList.cs).postln;
			if (loadedList.isNil) {
				"% : no cache file found.\n".postf(thisMethod);
				^this
			};
			loadedList.keysValuesDo { |filename, idInfo|
				fileToIDDict.put(filename, idInfo);
			};
		};
	}

	*updateCache {
		// check if any files have changed,
		// and if so, make a new cache file.
	}

	*defaultTestCode { |descfilename = "descNameHere"|
		var file = File(defaultFolder +/+ "_descFile_testCode.scd", "r");
		var testCode = file.readAllString;
		testCode = testCode.replace("descNameHere", descfilename);
		file.close;
		^testCode
	}

	testCode {|includeDefault = true|
		var descfilename = fullDesc.filename;
		var testCode = fullDesc[\testCode];
		var globalTestCode;


		if (testCode.notNil) {
			testCode = testCode.cs.drop(1).drop(-1);
		} {
			testCode = "// no specific testcode for %.".format(descfilename);
		};

		if (includeDefault) {
			testCode = this.class.defaultTestCode(descfilename)
			++ "\n"
			++ "/*********** %: specific tests ***************/".format(descfilename)
			++ testCode;
		};



		^testCode;
	}

	openTestCode {|includeDefault = true|
		var descfilename = fullDesc.filename;

		^Document("testCode_" ++ descfilename, this.testCode(includeDefault));
	}



	// ANALYSIS of loaded descs:
	*descKeysUsed {
		// all keys used in fullDescs
		var allKeys = MKtlDesc.allDescs.collectAs(_.fullDesc, Array)
		.collect(_.keys(Array));
		var keySet = allKeys.flat.asSet.collectAs({ |key|
			[key, allKeys.count(_.includes(key)) ];

		}, Array).sort { |a, b| a[1] > b[1] };
		"\n\n/*** All keys used in MKtlDesc.allDescs: ***/\n".postln;
		keySet.do { |list, i|
			[i, list].postcs;
		};
		"\n/*** end MKtlDesc.allDescs - keys. ***/\n".postln;
		^keySet
	}

	*deviceTypesUsed {
		var types = Set.new;
		MKtlDesc.allDescs.do {|d|
			var devtype = d.fullDesc.deviceType;
			if (devtype.notNil) { types = types.add(devtype) };
		};
		^types.asArray.sort;
	}

	*elementTypesUsed {
		var allUsed = Set[];
		MKtlDesc.allDescs.do { |desc|
			allUsed = allUsed.union(desc.elementTypesUsed)
		};
		^allUsed.asArray.sort
	}

	elementTypesUsed {
		var used = Set[];
		var getFunc = { |elem|
			if (elem.isKindOf(Dictionary)) {
				if(elem[\elementType].notNil) {
					used = used.add(elem[\elementType]); };
				elem.do (getFunc);
			};
			if (elem.isKindOf(Array)) {
				elem.do (getFunc);
			};
		};
		this.elementsDesc.do { |elDesc|
			getFunc.(elDesc);
		};
		^used.asArray.sort
	}


	// integrity checks for dicts at all levels:

	// according to current definition,
	// \idInfo, \protocol, \elementsDesc are required;

	*isValidDescDict { |dict|
		var ok = dict.isKindOf(Dictionary)
		and:  ({ dict[\parentDesc].notNil
			or: { dict[\idInfo].notNil
				and: { dict[\protocol].notNil
					and: { dict[\elementsDesc].notNil
						//	and: { this.checkElementsDesc(dict) }
					}
				}
		}});
		if (ok) { ^true };
		// todo: more detailed info here
		//	"% - dict not valid: %\n\n".postf(thisMethod, dict.deviceName);
		^false
	}

	*isValidElemDesc { |dict, protocol|
		var ok = dict.isKindOf(Dictionary)
		and: { dict[\elementType].notNil
			and: { dict[\ioType].notNil
				and: { dict[\spec].notNil }
			}
		};
		if (ok) { ^true };
		//	"% - elemDesc not valid: %\n\n".postf(thisMethod, dict);
	}

	// to be defined and tested
	*isValidMIDIDesc { |dict|
		^dict[\midiMsgType].notNil
	}
	*isValidHIDDesc { |dict|
		^(dict[\usage].notNil
			and: { dict[\usagePage].notNil })
		or: { dict[\hidElementID].notNil }
	}

	*isValidOSCDesc { |dict|
		true
	}

	// plug shared properties in as parents
	*sharePropsToElements { |dict, toShare|
		var shared, elements, subProps;
		if (dict.isKindOf(Dictionary).not) {
			//	"cant share in %\n".postf(dict);
			^this
		};

		shared = dict[\shared] ? ();
		elements = dict[\elements];
		if (toShare.notNil) {
			//	"shared: % parent: %\n\n".postf(shared, toShare);
			shared.parent = toShare;
		};
		elements.do { |elemDict|
			if (elemDict[\elements].notNil) {
				this.sharePropsToElements(elemDict, shared);
			} {
				//	"elem: % shared: %\n\n".postf(elemDict, shared);
				elemDict.parent = shared
			};
		};
	}


	// creation methods

	*fromFileName { |filename, folderIndex, multi = false|
		var paths = this.findFile(filename, folderIndex, false);
		if (paths.isEmpty) {
			warn("MktlDesc: could not find desc with filename %.\n"
				.format(filename));
			^nil;
		};
		if (multi.not) {
			if (paths.size > 1) {
				warn("MktlDesc: found multiple matching files!");
					paths.do { |path|
						"\t".post; path.basename.postcs;
					};
					warn("loading first of %\n:\t%.\n".format(paths.size, paths[0].basename.cs));
				^this.fromPath(paths[0]);
			};
		};

		^paths.collect(this.fromPath(_)).unbubble;
	}

	*fromPath { |path|
		var desc = path.load;
		if (desc.isNil) {
			warn("MktlDesc: could not load desc from path %.\n"
				.format(path));
			^nil;
		};

		if (this.isValidDescDict(desc).not) {
			warn("desc not valid - %"
				.format(path.basename.splitext[0]));
			^nil
		};
		// got here, should work now
		desc.path = path;
		desc.filename = path.basename.drop(descExt.size.neg);
		^this.fromDict(desc);
	}

	*fromDict { |dict|
		^super.new.fullDesc_(dict);
	}

	*new { |name|
		var foundObj = this.at(name.asSymbol);
		if (foundObj.notNil) {
			^foundObj;
		};

		if (name.notNil) {
			^this.fromFileName(name);
		};
		// for making it from dict
		// post a warning here?
		^super.new;
	}

	// initialisation/preparation

	fullDesc_ { |inDesc|
		var missing;
		if (this.class.isValidDescDict(inDesc).not) {
			warn("MKtlDesc: dict is not a valid desc,"
				" so cannot make elements.");
			^this
		};
		// "fullDesc: inDesc is ok, filename: %\npath: %\n"
		// .postf(inDesc.filename, inDesc.path);

		fullDesc = inDesc;
		path = path ?? { fullDesc[\path]; };

		this.findParent;

		this.inferName;
		// prepare elements, share and expand first
		MKtlDesc.sharePropsToElements(this.elementsDesc);
		MKtlDesc.deepExpand(this.elementsDesc);
		// do it again, in case there were elems to expand
		MKtlDesc.sharePropsToElements(this.elementsDesc);

		// now make elements in both dict and array form
		elementsDict = ();
		this.makeElemKeys(this.elementsDesc, []);

		if (this.protocol == \midi) {
			this.getMidiMsgTypes;
			missing = fullDesc[\elementsWithMissingType];
			if (missing.size > 0) {
				("" + this + "is missing 'midiMsgType' entry for %.")
				.format(missing).warn;
			};
		};

		if (this.class.platformSpecific){
			this.resolveDescEntriesForPlatform;
		}
	}

	dictAt { |key| ^elementsDict[key] }

	// not expanding yet - not sure if needed
	elAt { |... args|
		var res = this.elementsDesc;
		args.do { |key|
			case { key.isNumber } {
				res = res[\elements][key]
			} {
				res = res.elements.detect { |el| el[\key] == key }
			};
			if (res.isNil) {
				^res
			};
		};
		^res
	}

	findParent {
		var parentName = fullDesc[\parentDesc];
		var parentPath, parentDesc;

		if (parentName.isNil) { ^this };

		// "parent: % \n".postf(parentName);
		parentPath = MKtlDesc.findFile(parentName, fileExt: parentExt);

		switch(parentPath.size,
			0, { "no parent found.".postln; },
			1, {
				// "parent found ... ".postln;
				parentDesc = parentPath[0].loadPaths[0];
				// "loaded ...".postln;
				if (parentDesc.isKindOf(Dictionary)) {
					this.fullDesc.parent_(parentDesc);
					// "and adopted.".postln;
				};

			},
			{ "multiple parents found ???".postln; }
		);
	}

	makeElemKeys { |dict, deepKeys|
		var key = dict[\key];
		var elemKey;
		deepKeys = (deepKeys.copy ?? {[]}).add(key);
		if (dict.elements.isNil) {
			elemKey = deepKeys.reject(_.isNil).join($_).asSymbol;
			dict.put(\elemKey, elemKey);
			elementsDict.put(elemKey, dict);
		} {
			dict.elements.do { |elem, i|
				elem[\key] ?? { elem[\key] = (i+1).asSymbol };
				this.makeElemKeys(elem, deepKeys);
			};
		}
	}

	inferName { |inname, force = false|

		if (name.notNil and: force.not) {
			^this
		};

		name = inname ?? {
			fullDesc[\descName] ?
			fullDesc[\name] ?
			fullDesc[\filename];
		};
		if (name.isNil and: { path.notNil }) {
			name = path.basename.drop(descExt.size.neg);
		};

		if (name.isNil) {
			warn("MKtlDesc: could not create valid name, so desc remains\n"
				"unnamed, and will not show up in MKtlDesc.allDescs.");
		} {
			name = name.asSymbol;
			allDescs.put(name, this);
		};
	}

	openFile {
		if (path.notNil) {
			path.asString.openDocument
		} {
			inform("" ++ this + ".openFile: path was nil.");
		};
	}

	// access - keep all data in fullDesc only
	protocol { ^fullDesc[\protocol] }
	protocol_ { |type| ^fullDesc[\protocol] = type }

	idInfo { ^fullDesc[\idInfo] }
	idInfo_ { |type| ^fullDesc[\idInfo] = type }

	elementsDesc { ^fullDesc[\elementsDesc] }
	elementsDesc_ { |type| ^fullDesc[\elementsDesc] = type }

	specialMessage {|name|
		if ( fullDesc[\specialMessages].notNil) {
			^fullDesc[\specialMessages][name]
		}
	}
	specialMessageNames {
		if ( fullDesc[\specialMessages].notNil) {
			^fullDesc[\specialMessages].keys
		}
	}

	deviceFilename {
		^path !? { path.basename.drop(descExt.size.neg) }
	}

	postInfo { |postElements = false|
		var elements = this.elementsDesc.elements;
		("---\n//" + this + $:) .postln;
		"deviceFilename: %\n".postf(this.deviceFilename);
		"protocol: %\n".postf(this.protocol);
		"idInfo: %\n".postf(this.idInfo);
		"desc keys: %\n".postf(this.elementsDesc.keys);
		"elements keys: %\n".postf(elements !? { elements.collect(_.key) });

		if (postElements) { this.postElements };
	}

	postElements {
		var postOne = { |elemOrGroup, index, depth = 0|
			depth.do { $\t.post; };
			index.post; $\t.post;
			if (elemOrGroup[\elements].notNil) {
				"Group: ".post; elemOrGroup.key.postcs;
				elemOrGroup[\elements].do({ |item, i|
					postOne.value(item, i, depth + 1)
				});
			} {
				elemOrGroup.key.postcs;
			};
		};
		postOne.value(this.elementsDesc, "-");
	}

	writeFile { |path|
		"! more than nice to have ! - not done yet.".postln;
	}

	storeArgs { ^[name] }
	printOn { |stream|
		stream << this.class.name << ".at(%)".format(name.cs);
	}

	*notePairs { |pairs|
		^pairs.collect  (this.notePair(*_))
	}

	*notePair { |key, midiNum, shared|

		// make the notePair first:
		var style, notePair;
		var halfHeight;

		shared = shared ?? {()};
		shared.put(\midiNum, midiNum);
		style = shared[\style] ?? {()};
		shared.put(\style, style);

		// notePair be returned, no gui info
		notePair = (
			key: key,
			shared: shared,
			elements: [
				( key: \on, midiMsgType: \noteOn ),
				( key: \off, midiMsgType: \noteOff )
			]
		);

		// GUI creation:
		// the future solution is that style.guiType == \notePair
		// tells .gui when to create a single gui for an onOff pair;
		// shape of the gui will be determined by elementType.
		// style info on row, column etc is passed thru here to shared.
		style.put(\guiType, \notePair);


		// quick hack for now:
		// assume an elementType \pad,
		// and split pad area of 1x1 into
		// an upper half for noteOn,
		// and a lower half pad for noteOff.

		halfHeight = style.height ? 1 * 0.6;

		// upper half for noteOn:
		notePair.elements[0].put(
			\style, style.copy.put(\height, halfHeight)
		);

		// lower half pad for noteOff:
		notePair.elements[1].put(
			\style, style.copy.put(\height, halfHeight)
				// push down only if row is given,
				// else leave row nil for crude auto-positioning
			.put(\row, style.row !? { style.row + 0.45 })
		);

		^notePair
	}

	getMidiMsgTypes {
		var msgTypesUsed = Set.new;
		var type, missing = List[];

		this.elementsDesc.traverseDo ({ |elem, deepKeys|
			var msgType;
			if (deepKeys.last != \shared) {
				MKtlDesc.fillMidiDefaults(elem);
				msgType = elem[\midiMsgType];

				if (msgType.notNil) {
					msgTypesUsed.add(msgType.unbubble);
				} {
					//	"missing: ".post;
					missing.add(elem.elemKey);
				};
				// [elemKey, elem].postln;
			};
		}, MKtlDesc.isElemFunc);


		// treat noteOnOff as noteOn / noteOff
		if (msgTypesUsed.includes(\noteOnOff)) {
			msgTypesUsed.add(\noteOn);
			msgTypesUsed.add(\noteOff);
			msgTypesUsed.remove(\noteOnOff);
		};

		fullDesc.put(\msgTypesUsed, msgTypesUsed.asArray.sort);

		if (missing.notEmpty) {
			fullDesc.put(\elementsWithMissingType, missing);
		};
	}

	*fillMidiDefaults { |elemDict|
		// if type = button and no spec, and midiBut.asSpec;
		// if slider and no spec, assume cc message and midiCC.asSpec;
	}


	// some keys may be platform-dependent, e.g.
	// (meaning: (osx: 23, linux: 42, win: 4711));
	// these are resolved for the platform used,
	// e.g. for linux: (meaning: 42)
	*resolveForPlatform { |dict, recursive=false|
		var platForms = [\osx, \linux, \win];
		var myPlatform = thisProcess.platform.name;

		var entry, key, foundval;

		if (dict.isKindOf(Association)) {
			entry = dict.value; key = dict.key;
			if (entry.isKindOf(Dictionary) and:
				{ entry.keys.sect(platForms).notEmpty }) {
				foundval = entry[myPlatform];
				if (recursive) { this.resolveForPlatform(entry, recursive); };
				// "MKtlDesc:resolveForPlatform - replacing: ".post;
				^key -> foundval;
		} };

		if (dict.isKindOf(Dictionary)) {
			dict.keysValuesDo { |dictkey, entry|
				var foundPlatformDep = false, foundval;
				if (entry.isKindOf(Dictionary)) {
					foundPlatformDep = entry.keys.sect(platForms).notEmpty;
				};
				if (foundPlatformDep) {
					foundval = entry[myPlatform];
					if (recursive) { this.resolveForPlatform(entry, recursive); };
					// "MKtlDesc:resolveForPlatform - replacing: ".post;
					dict.put(dictkey, foundval);
				};
			}
			^dict
		}
		// cant change it
		^dict
	}

	resolveDescEntriesForPlatform {
		if (fullDesc.isNil) { ^this };
		if (fullDesc[\parentDesc].notNil) {
			MKtlDesc.resolveForPlatform(fullDesc[\parentDesc], true);
		};
		MKtlDesc.resolveForPlatform(fullDesc, true);
		// MKtlDesc.resolveForPlatform(this.elementsDesc);
		// this.elementsDesc.keysValuesDo { |key, elemDesc|
		// 	MKtlDesc.resolveForPlatform(elemDesc, true);
		// };
	}
}
