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

	var <descDict, <path, <>shortName;

	*initClass {
		defaultFolder = this.filenameSymbol.asString.dirname.dirname
			+/+ folderName;
		descFolders = List[defaultFolder];
		allDescs =();
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

	*findDict { |symbolStringOrDict|
		var dict = symbolStringOrDict.class.switch(
			Symbol, { this.at(symbolStringOrDict).descDict },
			String, { this.findFile(symbolStringOrDict).load },
			Event, { symbolStringOrDict }
		);
		if (dict.isNil) {
		//	this.warnNoDescFound(symbolStringOrDict);
			"warnNoDescFound".warn;
		};
		^dict
	}

	*new { |desc, path|
		^super.newCopyArgs(desc, path).init;
	}

	init {
		shortName = MKtlDesc.makeShortName(descDict[\device]).asSymbol;
		allDescs.put (shortName, this);
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

	desc { ^descDict[\description] }
	desc_ { |type| ^descDict[\description] = type }

	deviceFilename {
		^path !? { path.basename.drop(fileExt.size.neg) }
	}

	postInfo { |elements = false|
		("---\n//" + this + $:) .postln;
		"deviceFilename: %\n".postf(this.deviceFilename);
		"protocol: %\n".postf(this.protocol);
		"deviceIDString: %\n".postf(this.deviceIDString);
		"desc keys: %\n".postf(this.desc.keys);


		if (elements) { this.postElements }
	}

	// prettyPost with indent, not working yet
	postElements {
		// var tabs = 0;
		// var postLine = { |elem, keyOrIndex, tabs = 0|
		// 	if (elem.isKindOf(Collection)) {
		// 		elem.do { |el, keyOrI| postLine.(el, keyOrI, tabs + 1) };
		// 	} {
		// 		String.fill(tabs, Char.tab)
		// 		++ "% - %\n".postf(keyOrIndex, elem);
		// 	};
		// };
		// "desc elements: ".postln;
		// this.desc.do { |el, keyOrI|
		// 	postLine.(el, keyOrI, 0)
		// };
	}

	writeFile { |path|
		"! more than nice to have ! - not done yet.".postln;
	}

	storeArgs { ^[shortName] }
	printOn { |stream|
		stream << this.class.name << ".at(%)".format(shortName.cs);
	}
}
