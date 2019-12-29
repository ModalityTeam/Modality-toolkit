/*
TestMKtlDesc.findTestMethods.do { |meth| TestMKtlDesc.new.runTestMethod(meth) };

TestMKtlDesc.runTest("TestMKtlDesc:test_makeParents");
TestMKtlDesc.runTest("TestMKtlDesc:test_makeParents2");
TestMKtlDesc.runTest("TestMKtlDesc:test_expandNoteOnOffCtl");

// only in latest
TestMKtlDesc.prRunAllTestMethods;
*/

// test well-formedness of MKtls
TestMKtlDesc : UnitTest {

	test_makeParents {
		var elemDesc = (
			key: \top,
			extra: \info,
			shared: (ding: \dong),
			elements: { () }.dup(8)
		);

		// MKtlDesc.setParentAndShared(elemDesc);
		MKtlDesc.makeParents(elemDesc);

		this.assertEquals(elemDesc.elements[0].parent, (extra: \info, ding: \dong),
			"element parent should contain merged enclosing dict and its 'shared' dict.", false);

		// this.assert(elemDesc.elements[0].proto === elemDesc.shared,
		// "element proto should be its containing elementDesc's shared dict.");

		// this.assert(false, "false alarm, haha...");
	}

	test_makeParents2 {
		var testElement;
		var elemDesc = (
			key: \top,
			extra: \info,
			shared: (ding: \dong),
			elements: [
				(key: \clink, a: \a, shared: (dinky: \kinky), elements: { () }.dup(8)),
				(key: \clonk, b: \b, shared: (donky: \konky), elements: { () }.dup(8)),
			]
		);

		MKtlDesc.makeParents(elemDesc);

		testElement = elemDesc.elements[1].elements[4];
		this.assertEquals(testElement.parent.parent, ( ding: \dong, extra: \info ),
			"deeper element's parent's parent should contain merged top dict and and its 'shared' dict.",
			false
		);

		// clear top parent so == works
		testElement.parent.parent = nil;

		this.assertEquals(elemDesc.elements[1].elements[4].parent, (b: \b, donky: \konky),
			"deeper element's parent should contain merged enclosing dict and its 'shared' dict.",
			false
		);
	}

	// does not work:
	test_testDesc {
		var d = (
			descName: 'testDesc',
			deviceName: "testDesc",
			protocol: 'midi',
			idInfo: "testDesc",
			elementsDesc: (
				// not shared: (), but direct
				elementType: \pad,
				midiChan: 0,
				midiMsgType: \noteOn,

				elements: (48..55).collect { |midiNum, i|
					( midiNum: midiNum )
				}
			)
		);

		MKtlDesc.fromDict(d);

		this.assertEquals(d.elementsDesc.elements.size, 8,
			"basic desc should have 8 elements.", false);

		this.assertEquals(d.elementsDesc.elements[4].midiMsgType, \noteOn,
			"basic desc should know midiMsgType from parent.", false);
		// check parenthood
		this.assertEquals(
			d.elementsDesc.elements[0].parent,
			(elementType: \pad, midiChan: 0, midiMsgType: \noteOn),
			"parent of basic desc element should be desc-dict.", false);

		// cleanup
		MKtlDesc.allDescs.removeAt('testDesc');
	}

	//// works, but should complain
	test_testDescShared {
		var d = (
			descName: 'testDesc',
			deviceName: "testDesc",
			protocol: 'midi',
			idInfo: "testDesc",
			elementsDesc: (
				shared: (
					elementType: \pad,
					midiChan: 0,
					midiMsgType: \noteOn
				),
				elements: (48..55).collect { |midiNum, i|
					( midiNum: midiNum )
				}
			)
		);

		MKtlDesc.fromDict(d);

		this.assertEquals(d.elementsDesc.elements[4].midiMsgType, \noteOn,
			"basic desc should know midiMsgType from parent's shared dict.", false);
		// check parenthood
		this.assertEquals(
			d.elementsDesc.elements[0].parent,
			(elementType: \pad, midiChan: 0, midiMsgType: \noteOn),
			"parent of basic desc element should be desc-dict.", false);

		// cleanup
		MKtlDesc.allDescs.removeAt('testDesc');
	}

	test_expand_noteOnOff {
		var dict = (
			descName: 'testDesc',
			deviceName: "testDesc",
			protocol: 'midi',
			idInfo: "testDesc",
			elementsDesc: (
				elementType: \pad,
				midiChan: 0,
				style: (thisIS: \style),
				groupType: \noteOnOff,
				elements: (48..55).collect { |midiNum, i|
					( midiNum: midiNum )
				}
			)
		);

		var desc = MKtlDesc.fromDict(dict);

		this.assertEquals(
			desc.elementsDesc.elements[0].elements.collect(_.midiMsgType),
			[\noteOn, \noteOff],
			"expanded noteOnOff desc elements should have proper midiMsgTypes.", false);

		// cleanup
		MKtlDesc.allDescs.removeAt('testDesc');
	}

	test_expand_noteOnOffBut {
		var dict = (
			descName: 'testDesc',
			deviceName: "testDesc",
			protocol: 'midi',
			idInfo: "testDesc",
			elementsDesc: (
				elementType: \pad,
				midiChan: 0,
				style: (thisIS: \style),
				groupType: \noteOnOffBut,
				elements: (48..55).collect { |midiNum, i|
					( midiNum: midiNum )
				}
			)
		);

		var desc = MKtlDesc.fromDict(dict);

		this.assertEquals(
			desc.elementsDesc.elements[0].elements.collect(_.midiMsgType),
			[\noteOn, \noteOff],
			"expanded noteOnOff desc elements should have proper midiMsgTypes.", false);

		// cleanup
		MKtlDesc.allDescs.removeAt('testDesc');
	}


	test_expand_noteOnOffCtl {
		var dict = (
			descName: 'testDesc',
			deviceName: "testDesc",
			protocol: 'midi',
			idInfo: "testDesc",
			elementsDesc: (
				elementType: \pad,
				midiChan: 0,
				style: (thisIS: \style),
				groupType: \noteOnOffCtl,
				elements: (48..55).collect { |midiNum, i|
					( midiNum: midiNum )
				}
			)
		);

		var desc = MKtlDesc.fromDict(dict);

		this.assertEquals(
			desc.elementsDesc.elements[0].elements.collect(_.midiMsgType).postcs,
			[\noteOn, \noteOff, \control],
			"expanded noteOnOff desc elements should have proper midiMsgTypes.", false);

		// cleanup
		MKtlDesc.allDescs.removeAt('testDesc');
	}

	test_expand_noteOnOffTouch {
		var dict = (
			descName: 'testDesc',
			deviceName: "testDesc",
			protocol: 'midi',
			idInfo: "testDesc",
			elementsDesc: (
				elementType: \pad,
				midiChan: 0,
				style: (thisIS: \style),
				groupType: \noteOnOffTouch,
				elements: (48..55).collect { |midiNum, i|
					( midiNum: midiNum )
				}
			)
		);

		var desc = MKtlDesc.fromDict(dict);

		this.assertEquals(
			desc.elementsDesc.elements[0].elements.collect(_.midiMsgType).postcs,
			[\noteOn, \noteOff, \polytouch],
			"expanded noteOnOff desc elements should have proper midiMsgTypes.", false);

		// cleanup
		MKtlDesc.allDescs.removeAt('testDesc');
	}

	//////// not really a UnitTest, more a big load test:
	//////// All desc files should load without failures or complaints
	test_loadDescs {
		// only test default folder
		var paths, pathNames, loadedNames, nonLoaded, numPaths;
		paths = MKtlDesc.findFile("*", 0);
		pathNames = paths.collect { |path| path.basename.split($.)[0].asSymbol };
		MKtlDesc.loadDescs("*", 0);
		loadedNames = MKtlDesc.allDescs.keys(Array).sort;
		// empty if every desc file was loaded as a desk
		nonLoaded = pathNames.difference(loadedNames);

		this.assert(nonLoaded.isEmpty,
			"all % desc.scd files should become a loaded desc object.".format(paths.size)
		);
		// cleanup
		MKtlDesc.allDescs.clear;
	}
}