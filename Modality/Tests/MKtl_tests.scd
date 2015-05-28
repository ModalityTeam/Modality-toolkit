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






MKtl.find(\midi);
MKtl('pmdd10', "Teenage_OP1"); // not tested again
MKtl('pmdd10').trace(true);

	// rebuild not working yet
MKtl('rnnd0').rebuild; // with current desc
MKtl('rnnd0').rebuild(~desc) // with new ~esc here>);


MKtl('rnnd0').trace(true);
MKtl('rnnd0').elementsDict
MKtl('rnnd0').elementsDict.size
MKtl('rnnd0').elementsDict[\bt_2];

// good that traceRunning is visible in Modality
MKtl('rnnd0').traceRunning;

MKtl('rnnd0').desc.openFile;
MKtl('rnnd0').desc.elementsDesc.keys;
MKtl('rnnd0').mktlDevice;
MKtl('rnnd0').desc.postInfo(true);

MKtlDesc.fromFileName("RunNDrive");
MKtlDesc.at('RunNDrive').openFile;

MKtl(\abc) === MKtl(\abc);


/////
a = MKtlDesc("Teenage*");

MKtl(\myOpi, "Teenage*");
MKtl(\myOpi).rebuildFrom;

MKtl(\myOpi).rebuildFrom("Teenage*");
MKtl(\myOpi).dump

MKtl(\myOpi).elementsDict[\btMix];

MKtl(\myOpi).desc.elementsDesc.keys;
MKtl(\myOpi).elementsDict.size;

MKtlDevice.initHardwareDevices;
MKtlDevice.allAvailable;

MKtl(\myOpi).desc.postElements;
MKtl(\myOpi).desc.openFile;
MKtlDesc.openFolder;

e = (a: 1, b: (osx: 2, linux: 3), c: (win: \no))
MKtlDesc.resolveForPlatform(e); e;

x = MKtl(desc: "Teenage_OP1");
x.dump;



MKtl('pmdd10').desc;
MKtl('pmdd10').desc.descDict.device;

MKtl('NSA1', "NoSuchAgency");

MKtl(desc: "Teenage_OP1");

MKtl('pmdd10').addSpec(\blonk, [123, 456]);
MKtl('pmdd10').name;

MKtl('pmdd10');
MKtlDevice.subclasses;

a = MKtl('pmdd10').desc.descDict.device.postcs;
MKtlDevice.findDeviceShortNameFromLongName( a );

MKtl('pmdd10', "Teenage_OP1");
MKtl('pmdd10').openDevice;

MKtlDesc.at('pmdd1').elementsDesc.keysValuesDo { |key, desc|
	[key, desc].postcs;
};