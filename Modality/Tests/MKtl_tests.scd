/*** MKtl  tests for refactoring ***/

makeShortName

MKtl.all
MKtl.globalSpecs
MKtl.addSpec(\test, [1, 10, -4, 3]);
MKtl.getSpec(\test);
MKtlDevice.allAvailable

MKtl.find(\hid);
MKtl.find(\midi);

MKtl.find;

MKtl(\abc) === MKtl(\abc);
MKtl.all

MKtl('asdf').desc;

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