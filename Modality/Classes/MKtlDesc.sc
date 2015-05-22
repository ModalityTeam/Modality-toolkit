/*
PLANS:
* only load on demand
* make a directory cache of filenames -> devicenames as reported
* update only when files newer than cache were added
*/

MKtlDesc {
	classvar <defaultFolder, <folderName = "MKtlDescriptions";
	classvar fileExt = ".desc.scd";
	classvar <descFolders;
	classvar <allDescs;

	classvar <>isElementTestFunc;

	var <descDict, <path, <>shortName, <elementsKeyValueArray;

	*initClass {
		defaultFolder = this.filenameSymbol.asString.dirname.dirname
			+/+ folderName;
		descFolders = List[defaultFolder];
		allDescs =();
		isElementTestFunc = { |el| el.isKindOf(Dictionary) and: { el[\spec].notNil } };
	}

	*addFolder { |path, name = (folderName)|
		var folderPath = path +/+ name;
		var foundFolder = pathMatch(folderPath);

		if (descFolders.includesEqual(folderPath)) { ^this };
		descFolders.add(folderPath);
		if (foundFolder.notEmpty) {
			"MKtlDesc found and added folder: %\n".postf(foundFolder);
		} {
			"// MKtlDesc added a nonexistent folder: %\n".postf(name);
			"// create it with:"
			"\n unixCmd(\"mkdir\" + quote(\"%\".standardizePath))\n"
				.postf(folderPath);

		}
	}

	*openFolder { |index = 0|
		unixCmd("open" + quote(descFolders[index]));
	}

	*findFile { |filename|
		var found = descFolders.collect { |dir|
			(dir +/+ filename ++ fileExt).pathMatch
		}.flatten(1);
		if (found.isEmpty) {
			warn("MKtlDesc - no file found for '%'.".format(filename));
			^nil
		};
		if (found.size > 1) {
			"\nMKtlDesc.loadDesc - multiple files for'%':\n".postf(filename);
			found.printcsAll;
			"*** please be more specific. ***\n".postln;
			^nil
		};
		^found.first;
	}

	*fromFile { |filename|
		var dict, path = this.findFile(filename);
		if (path.notNil) {
			dict = path.load;
			if (this.isValidDescDict(dict)) {
				^this.new(dict, path);
			};
		}
	}

	*fromDict { |dict|
		^super.new.descDict_(dict);
	}

	// do more tests here
	*isValidDescDict { |dict|
		^dict.isKindOf(Dictionary)
	}

	*makeShortName { |deviceKey|
		var str = deviceKey.asString;
		^(str.toLower.select{|c| c.isAlpha && { c.isVowel.not }}.keep(4)
		++ str.select({|c| c.isDecDigit}))
	}

	// convenience only
	*loadDescs { |filenameToMatch = "*", folderIndex|
		var count = 0, foldersToLoadFrom;
		filenameToMatch = filenameToMatch ++ fileExt;

		folderIndex = folderIndex ?? { (0 .. descFolders.size-1) };
		foldersToLoadFrom = descFolders[folderIndex.asArray].select(_.notNil);

		foldersToLoadFrom.do {|folder|
			(folder +/+ filenameToMatch).pathMatch.do {|descPath|
				count = count + 1;
				this.fromFile(descPath.basename.drop(fileExt.size.neg));
			}
		};
		"\n// MKtlDesc loaded % description files - see "
		"\nMKtlDesc.allDescs;\n".postf(count);
	}

	*at { |descName|
		^allDescs[descName]
	}

	*makeDescFrom { |symbolStringOrDict|
		var dict = this.findDict(symbolStringOrDict);
		var newDesc = super.new(dict);
		^newDesc;
	}

	*findDict { |descOrPathOrSymbol|
		var dict = descOrPathOrSymbol.class.switch(
			Symbol, { this.at(descOrPathOrSymbol).descDict },
			String, {
				var str = this.findFile(descOrPathOrSymbol);
				var newdict;
				if (str.notNil) {
					newdict = str.load;
					if (newdict.isKindOf(Dictionary)) {
						newdict[\path] = str;
					};
				};
				newdict;
			},
			Event, { descOrPathOrSymbol }
		);
		if (dict.isNil) { "warnNoDescFound".warn; };
		^dict
	}

	*new { |descOrPathOrSymbol|
		var dict = this.findDict(descOrPathOrSymbol);

		if (this.isValidDescDict(dict).not) {
			inform("MKtlDesc: dict is not a valid desc.");
			^nil
		};
		^super.newCopyArgs(dict).init;
	}

	init {
		shortName = MKtlDesc.makeShortName(descDict[\device]).asSymbol;
		"shortName: %\n".postf(shortName);
		allDescs.put (shortName, this);
		path = path ?? { descDict[\path] };
		this.makeElementsArray;
		this.resolveDescEntriesForPlatform;
	}

	openFile { unixCmd("open" + quote(path)) }

	descDict_ { |dict|
		if (MKtl.isValidDescDict(dict)) {
			descDict = dict;
			this.init;
		};
	}


	// keep all data in descDict only if possible
	protocol { ^descDict[\protocol] }
	protocol_ { |type| ^descDict[\protocol] = type }

	// adc proposal - seem clearest
	// idInfoAsReportedBySystem,
	// aslo put it in descDict[\idInfo]
	idInfo { ^descDict[\device] }
	idInfo_ { |type| ^descDict[\device] = type }

	elementsDesc { ^descDict[\description] }
	elementsDesc_ { |type| ^descDict[\description] = type }

	deviceFilename {
		^path !? { path.basename.drop(fileExt.size.neg) }
	}

	postInfo { |elements = false|
		("---\n//" + this + $:) .postln;
		"deviceFilename: %\n".postf(this.deviceFilename);
		"protocol: %\n".postf(this.protocol);
		"deviceIDString: %\n".postf(this.deviceIDString);
		"desc keys: %\n".postf(this.elementsDesc.keys);


		if (elements) { this.postElements }
	}

	writeFile { |path|
		"! more than nice to have ! - not done yet.".postln;
	}

	storeArgs { ^[shortName] }
	printOn { |stream|
		stream << this.class.name << ".at(%)".format(shortName.cs);
	}

	*resolveForPlatform { |dict|
		var platForms = [\osx, \linux, \win];
		var myPlatform = thisProcess.platform.name;

		dict.keysValuesDo { |dictkey, entry|
			var foundPlatformDep = false, foundval;
			if (entry.isKindOf(Dictionary)) {
				foundPlatformDep = entry.keys.sect(platForms).notEmpty;
			};
			if (foundPlatformDep) {
				foundval = entry[myPlatform];
				"MKtlDesc replacing: ".post;
				dict.put(*[dictkey, foundval].postln);
			};
		}
		^dict
	}

	// (-: just in case programming ;-)
	resolveDescEntriesForPlatform {
		this.class.resolveForPlatform(descDict);
		elementsKeyValueArray.pairsDo { |key, elemDesc|
			MKtlDesc.resolveForPlatform(elemDesc);
		};
		this.class.resolveForPlatform(elementsKeyValueArray);
	}

	postElements {
		this.elementsDesc.traverseDo({ |el, deepKeys|
			deepKeys.size.do { $\t.post };
			deepKeys.postcs;
		}, (_.isKindOf(Dictionary)));
	}

	makeElementsArray { |devDesc|
		var arr = [];
		this.elementsDesc.traverseDo({ |el, deepKeys|
			var elKey = deepKeys.join($_).asSymbol;
			arr = arr.add(elKey).add(el);
		}, isElementTestFunc);
		elementsKeyValueArray = arr;
	}

		//traversal function for combinations of dictionaries and arrays
	*prTraverse {
		var isLeaf = { |dict|
			dict.keys.includes( \type ) or:
			dict.values.any({|x| (x.size > 1) }).not;
		};

		var f = { |x, state, stateFuncOnNodes, leafFunc|

			if(x.isKindOf(Dictionary) ){
				if( isLeaf.(x) ) {
					leafFunc.( state , x )
				}{
					x.sortedKeysValuesCollect{ |val, key|
						f.(val, stateFuncOnNodes.(state, key), stateFuncOnNodes, leafFunc )
					}
				}
			} {
				if(x.isKindOf(Array) ) {
					if( x.first.isKindOf( Association ) ) {
						f.(IdentityDictionary.with( *x ), state, stateFuncOnNodes, leafFunc );
					} {
						x.collect{ |val, i|
							f.(val, stateFuncOnNodes.(state, i),  stateFuncOnNodes, leafFunc )
						}
					}
				} {
					Error("MKtl:prTraverse Illegal data structure in device description.\nGot object % of type %. Only allowed objects are Arrays and Dictionaries".format(x,x.class)).throw
				}
			}

		};
		^f
	}
}
