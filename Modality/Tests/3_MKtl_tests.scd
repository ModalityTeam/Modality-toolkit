/*** MKtl  tests while refactoring ***/


MKtl.all
MKtl.globalSpecs
MKtl.addSpec(\test, [1, 10, -4, 3]);
MKtl.getSpec(\test);

n = MKtlDesc.fileToIDDict.choose.postln;

// find - could add desc filename if there.
MKtl.find(\hid);
MKtl.find(\midi);
MKtl.find(\osc);

MKtl.find;			// posts all 3

MKtlLookup.all;

// code copied from post works as is:
MKtl('x', "thrustmaster-run-n-drive");
MKtl('x').trace(true);	// actions work!

// renaming works
MKtl('x').name_('my2ndFerrari');
// turn posting off
MKtl('my2ndFerrari').trace(false);

MKtl('my2ndFerrari').gui;

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
MKtl('nk', "korg-nanokontrol"); // works, but posts way too much
MKtl('nk');  // does not work yet

MKtl('nk').trace;
// elements and ElementGroups are working again:
MKtl('nk').device.send('bt_1_0', 1);
MKtl('nk').elementsDict['bt_1_0_1']
MKtl('nk').elements[\fwd].elementDescription;
MKtl('nk').elementsDict.size;
MKtl('nk').elementsArray.size;
MKtl('nk').specs
MKtl('nk').elements.action = { |...keys|
	("// top group action:"
		+ keys.collect(_.name).cs).postln;
};

MKtl('nk').elementAt(\bt).action = { |...keys|
	("// \bt group action:"
		+ keys.collect(_.name).cs).postln;
};

MKtl('nk').elementAt(\bt, 0).action = { |...keys|
	("// \bt_0 group action:"
		+ keys.collect(_.name).cs).postln;
};

MKtl('nk').elementsDict[\bt_1_1_1].doAction; // button and top
MKtl('nk').elementsDict[\bt_0_0_1].doAction; // button, row and top


MKtl('nk').device.dump;
MKtl('nk').device.midiKeyToElemDict;
MKtl('nk').device.responders;
MKtl('nk').device.global;
MKtl('nk').device.msgTypes;


// unfinished tests
	// rebuild not working yet
MKtl('nk').rebuild; // with current desc
MKtl('nk').rebuild(~desc) // with new ~desc here>);


// good that traceRunning is visible in Modality
MKtl('nk').traceRunning;

MKtl('nk').desc.openFile;
MKtl('nk').desc.elementsDesc.keys;
MKtl('nk').device;
MKtl('nk').desc.postInfo(true);

MKtl(\myOpi, "*op-1");
MKtl(\myOpi).postElements;
MKtl(\myOpi).desc.postElements;
MKtl(\myOpi).desc.openFile;
MKtlDesc.openFolder;

e = (a: 1, b: (osx: 2, linux: 3), c: (win: \no));
MKtlDesc.resolveForPlatform(e); e;

// dont create blanks:
MKtl('NSA1', "NoSuchAgency");
MKtl(desc: "Teenage_OP1");


