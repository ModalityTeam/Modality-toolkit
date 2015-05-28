/*** MKtl  tests while refactoring ***/

MKtl.all
MKtl.globalSpecs
MKtl.addSpec(\test, [1, 10, -4, 3]);
MKtl.getSpec(\test);
// default takes first few consonants and all numbers
MKtl.makeLookupNameFunc.value("asd234");



// a custom lookupname func:

MKtl.makeLookupNameFunc = { |str|
	var numLetters = 7;
	var parts, start, mid, end;
	str = str.toLower;
	if (str.size < numLetters) {
		str;
	} {
		parts = str.split($ );
		start = parts[0].select(_.isAlphaNum).keep(3);
		mid = if (parts.size > 1) {
			parts[1].select(_.isAlphaNum).keep(2);
		} {
			parts[0].select(_.isAlphaNum).drop(2).keep(2);
		};
		end = str.select(_.isAlphaNum).keep(-2);
		[start, mid, end].join("").asSymbol;
	}
};

n = MKtlDesc.fileToIDDict.choose.postln;
MKtl.makeLookupName(n);
MKtl.makeLookupName("LPD8");

a = MKtlDesc.fileToIDDict.collect { |idInfo|
	var str = idInfo.asString;
	var shrt = MKtl.makeLookupName(str);
	[str, shrt].postcs;
	shrt.asSymbol;
};
// creates unique enough names? not quite yet. hm.
a.size.postln == a.values.asSet.size.postln;
a.asArray.sort;


// find - could add desc filename if there.
MKtl.find(\hid);
MKtl.find(\midi);
MKtl.find(\osc);

MKtl.find;			// posts all 3

MKtlDevice.allAvailable;

// code copied from post works as is:
MKtl('rnnd0', "thrustmaster-run-n-drive");
MKtl('rnnd0').trace(true);	// actions work!

// renaming works
MKtl('rnnd0').name_('my2ndFerrari');
// turn posting off
MKtl('my2ndFerrari').trace(false);

// from shortname as posted works!
MKtl('rnnd0');



// test group actions:
MKtl('my2ndFerrari').elementAt(\bt).action = { |bt, grp|
	"group action:".postln;
	 [bt.name, grp.name].postln;
};
MKtl('my2ndFerrari').elementAt(\joy, \r).action = { |el, grp|
	"group action joy, r:".postln;
	 [el.name, grp.name].postln;
};

MKtl('my2ndFerrari').elementAt(\joy).action = { |el, grp|
	"group action joy:".postln;
	 [el.name, grp.name].postln;
};

MKtl('my2ndFerrari').elements.action = { |...args|
	"group action to top:".postln;
	args.collect(_.name).postln;
};




//*********** MIDI MIDI MIDI ***********\\

MKtl.find(\midi);
MKtl('nnkn0', "korg-nanokontrol"); // works, but posts way too much
MKtl('nnkn0');  // does not work yet

// elements and ElementGroups are working again:
MKtl('nnkn0').dump;
MKtl('nnkn0').elements;
MKtl('nnkn0').elementsDict.size;
MKtl('nnkn0').elementsArray.size;
MKtl('nnkn0').specs
MKtl('nnkn0').elements.action = { |...keys|
	("// top group action:"
		+ keys.collect(_.name).cs).postln;
};

MKtl('nnkn0').elementAt(\bt).action = { |...keys|
	("// \bt group action:"
		+ keys.collect(_.name).cs).postln;
};

MKtl('nnkn0').elementAt(\bt, 0).action = { |...keys|
	("// \bt_0 group action:"
		+ keys.collect(_.name).cs).postln;
};

MKtl('nnkn0').elementsDict[\bt_1_1_1].doAction; // button and top
MKtl('nnkn0').elementsDict[\bt_0_0_1].doAction; // button, row and top


MKtl('nnkn0').mktlDevice.dump;
MKtl('nnkn0').mktlDevice.midiKeyToElemDict;
MKtl('nnkn0').mktlDevice.responders;
MKtl('nnkn0').mktlDevice.global;
MKtl('nnkn0').mktlDevice.msgTypes;


// unfinished tests
	// rebuild not working yet
MKtl('nnkn0').rebuild; // with current desc
MKtl('nnkn0').rebuild(~desc) // with new ~desc here>);


// good that traceRunning is visible in Modality
MKtl('nnkn0').traceRunning;

MKtl('nnkn0').desc.openFile;
MKtl('nnkn0').desc.elementsDesc.keys;
MKtl('nnkn0').mktlDevice;
MKtl('nnkn0').desc.postInfo(true);

MKtl(\myOpi).desc.postElements;
MKtl(\myOpi).desc.openFile;
MKtlDesc.openFolder;

e = (a: 1, b: (osx: 2, linux: 3), c: (win: \no))
MKtlDesc.resolveForPlatform(e); e;


MKtl('pmdd10').desc;
MKtl('pmdd10').desc.descDict.device;

MKtl('NSA1', "NoSuchAgency");

MKtl(desc: "Teenage_OP1");

MKtl('nnkn0').addSpec(\blonk, [123, 456]);
MKtl('nnkn0').name;

