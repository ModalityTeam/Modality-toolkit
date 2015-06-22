MKtlDesc.openFolder;

// test that all descs make fully working MKtls:

// load
MKtlDevice.verbose = false; MKtlDesc.loadDescs; MKtlDesc.allDescs.size;

// make MKtls, keep fails if any
// Mon Jun 15 23:23:06 2015 - all 45 work!
(
~failed = List[];
MKtlDesc.allDescs.sortedKeysValuesDo { |key, desc|
	// desc.name.postln;
	try { MKtl(desc.name, desc.name.asString) } {
		~failed.add(desc);
		"% failed!\n".postf(desc.name);
	};
};"";
~failed;
)

MKtlDesc.loadDescs("*x-osc*");
MKtl('x-io-x-osc').specs.parent
// if any fail, remove them from MKtl.all to continue tests
~failed.do { |desc| MKtl.all.removeAt(desc.name); };

(
// test the working ones:

["OK, dict, elems, elemsOK, val, name:"].postln;
MKtl.all.sortedKeysValuesDo { |key, mktl|
	var numElemsInDict = mktl.elementsDict.size;
	var numTopElems = mktl.elements.size;
	var allEls = mktl.elementsDict.every(_.isKindOf(MKtlElement));
	var valOk = mktl.elementsDict.every {|el| el.name.postln; el.value.isNumber };
	var ok = allEls and: valOk and: (numElemsInDict > 0) and: (numTopElems > 0);
	if (ok.not) {
	[
		ok, numElemsInDict.asString.padLeft(3),
		numTopElems.asString.padLeft(3),
		allEls, valOk,
		mktl.name.cs].postln;
	};
};"";
)

MKtl('x-io-x-osc').desc.openFile

// xosc has no elementsDict? why is that?
[ false,   0,  16, true, true, x-io-x-osc ]

