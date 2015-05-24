/*** MKtl  tests for refactoring ***/

MKtl.all
MKtl.globalSpecs
MKtl.addSpec(\test, [1, 10, -4, 3]);
MKtl.getSpec(\test);
// default takes first few consonants and all numbers
MKtl.makeLookupNameFunc.value("asd234");
MKtl.makeLookupName("asdft12whfbeir");

MKtl.find;
MKtl.find(\hid);
MKtl.find(\midi);
MKtl.find(\osc);

MKtlDevice.allAvailable;

MKtl.globalSpecs[\hidBut];

MKtl
MKtl('rnnd0').elementsDict

MKtl('rnnd0', 'RunNDrive');
MKtl('rnnd0').mktlDevice.dump;

MKtl('rnnd0').trace(true); // WORKS!
MKtl('rnnd0').trace(false); // WORKS!

MKtl('rnnd0').rebuild; // with current desc
MKtl('rnnd0').rebuild(~desc) // with new ~esc here>);

MKtl('rnnd0').trace(true);
MKtl('rnnd0').elementsDict[\bt_2];
// good that it is visible in Modality, not in HIDFunc etc.
MKtl('rnnd0').traceRunning;

MKtl('rnnd0').desc.openFile;
MKtl('rnnd0').desc.elementsDesc.keys;
MKtl('rnnd0').mktlDevice;

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