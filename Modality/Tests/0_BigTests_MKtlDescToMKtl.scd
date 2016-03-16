MKtlDesc.openFolder;

// test that all descs create working MKtls:

// load
MKtlDevice.verbose = false; MKtlDesc.loadDescs; MKtlDesc.allDescs.size;

// make MKtls, keep fails if any
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

// remove broken ones
~failed.do { |desc| MKtl.all.removeAt(desc.name); };

(
// test the working ones:

["OK, dict, elems, elemsOK, val, name:"].postln;
MKtl.all.sortedKeysValuesDo { |key, mktl|
	var postme = mktl.postln;
	var numElemsInDict = mktl.elementsDict.size;
	var numTopElems = mktl.elementGroup.size;
	var allEls = mktl.elementsDict.every(_.isKindOf(MKtlElement));
	var valOk = mktl.elementsDict.every {|el| el.name; el.value.isNumber };
	var ok = allEls and: valOk and: (numElemsInDict > 0) and: (numTopElems > 0);
	if (ok.not) {
		[
			"BROKEN:", mktl, numElemsInDict.asString.padLeft(3),
			numTopElems.asString.padLeft(3),
			allEls, valOk].postln;
	};
};"";
)

