/*
PLANS:
* only load on demand
* make a directory of filenames -> devicenames as reported
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
			"MKtlDesc added folder: %\n".postf(foundFolder);
			"// create it with:"
			"\n unixCmd(\"mkdir\" + quote(\"%\"));\n".postf(foundFolder[0]);
		}
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

	descDict_ { |dict|
		if (MKtl.isValidDescDict(dict)) {
			descDict = dict;
			this.init;
		};
	}

	*writeFile { |path|
		"! more than nice to have ! - not done yet.".postln;
	}

	// do more tests
	*isValidDescDict { |dict|
		^dict.isKindOf(Dictionary)
	}

	*makeShortName { |deviceKey|
		var str = deviceKey.asString;
		^(str.toLower.select{|c| c.isAlpha && { c.isVowel.not }}.keep(4)
		++ str.select({|c| c.isDecDigit}))
	}

	*loadAllDescs { |folders|
		var count = 0;
		descFolders.do {|folder|
			(folder +/+ "*").pathMatch.do {|descPath|
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

	storeArgs { ^[shortName] }
	printOn { |stream| ^this.storeOn(stream) }

	init {
		shortName = MKtlDesc.makeShortName(descDict[\device]).asSymbol;
		allDescs.put (shortName, this);
	}
}
