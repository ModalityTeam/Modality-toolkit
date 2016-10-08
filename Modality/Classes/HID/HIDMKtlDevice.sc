HIDMKtlDevice : MKtlDevice {

	classvar <initialized = false;
	classvar <>showAllDevices = false, <deviceProductNamesToHide;
	classvar <protocol = \hid;

	var <srcID, <source;
	var <enabled = true;
	var <hidElemDict, <hidElemFuncDict;

	*initClass {
		Platform.case(\osx, {
			showAllDevices = false;
			deviceProductNamesToHide = List[
				"Apple Internal Keyboard / Trackpad",
				"Apple Mikey HID Driver",
				"Apple IR"
			];
		}, { deviceProductNamesToHide = List[]; } );
	}

	*initDevices { |force=false|

		if ( initialized && { force.not } ){ ^this; };

		if ( Main.versionAtLeast( 3, 7 ).not ){
			"Sorry, no HID before 3.7.".postln;
			^this;
		};

		HID.findAvailable;
		// if (HID.running.not) { HID.initializeHID }; // happens in HID.findAvailable
		MKtlLookup.addAllHID;

		initialized = true;
	}

	*devicesToShow {
		^HID.available.select { |dev, id|
			//	(dev.productName + ": ").post;
			showAllDevices or: {
				deviceProductNamesToHide.every({ |prodname|
					[dev.productName, prodname];
					(dev.productName != prodname);
				});
			}
		};
	}

	// open all ports and display them in readable fashion,
	// copy/paste-able directly
	*find { |post = true|
		this.initDevices ( true );
		if ( post ) { this.postPossible; };
	}

	*postPossible {
		var postables = MKtlLookup.allFor(\hid);
		var foundHidden = showAllDevices.not and: { HID.available.size != postables.size };
		var hiddenStr = "// HID: Some HIDs not shown that can crash the OS. See: HID.available;";
		var genericHint;

		if (foundHidden) { hiddenStr.postln; };
		if (postables.size == 0) {
			"// No HID devices available.".postln;
			^this
		};

		"\n/*** Possible MKtls for HID devices: ***/".postln;
		"\t// [ product, vendor, (serial#) ]\n".postln;
		postables.sortedKeysValuesDo { |lookupKey, infodict|
			var info = infodict.deviceInfo;
			var product = info.productName;
			var vendor = info.vendorName;
			var serial = info.serialNumber;
			var postList = [product, vendor];
			var filenames = MKtlDesc.filenamesForIDInfo(infodict.idInfo);
			var nameKey = lookupKey.asString.keep(12).asSymbol;

			if (serial.notEmpty) {
				postList = postList.add(serial);
			};
			postList.cs.postcln;

			if (filenames.size == 0) {
				genericHint = "\n\t// (or match with a generic desc)";
			};
			this.descFileStrFor(nameKey, lookupKey, filenames,
				infodict.multiIndex, genericHint).post;
		};
	}

	*getIDInfoFrom { |hidInfo|
		^if (hidInfo.notNil) {
			[hidInfo.productName, hidInfo.vendorName].join($_);
		}
	}

	// create with a uid, or access by name
	*new { |name, path, parentMKtl, multiIndex|
		var foundSourceInfo, foundInfo;

		if (path.isNil) {
			foundInfo = MKtlLookup.all.at(name);
			if (foundInfo.notNil) {
				foundSourceInfo = foundInfo.deviceInfo;
			}
		} {
			// // FIXME: is this a USB path?
			// // and what about multiple matches (e.g. Apple Keyboard)?
			// foundSourceInfo = HID.findBy( path: path ).asArray.first;
		};

		// make a new one
		if (foundSourceInfo.isNil) {
			warn("HIDMKtl:"
				"	No HID source with USB port ID % exists! please check again.".format(path));
			// ^MKtl.prMakeVirtual(name);
			^nil;
		};

		^super.basicNew( name,
			this.makeDeviceName( foundSourceInfo ),
			parentMKtl )
		.initHIDMKtl( foundSourceInfo );
	}


	initHIDMKtl { |sourceInfo|
		// HID is only ever one source, hopefully
		var foundOpenHID;
		// To make HID polyphonic:
		// find out if HID is already open first;
		// be polite and only add hidele.actions with
		// hidele.action = hidele.action.addFunc(newaction);
		// and keep the as they are actions somewhere for removeFunc

		foundOpenHID = HID.openDevices.detect { |hid|
			hid.info.path == sourceInfo.path };
		// maybe still listed as open, but already closed
		if (foundOpenHID.notNil and: { foundOpenHID.isOpen }) {

			("%: HID already open for: \n%. "
				"\n - reusing this open HID for polyphony."
				.format(thisMethod, sourceInfo));
			source = foundOpenHID;
		} {
			source = sourceInfo.open;
		};
		srcID = source.id;

		hidElemDict = ();
		hidElemFuncDict = ();

		if (mktl.desc.notNil) {
			this.initElements;
			this.initCollectives;
		};
	}

	closeDevice {
		if (this.mktlsSharingDeviceSource.isEmpty) {
			this.cleanupElementsAndCollectives;
			srcID = nil;
			if (source.notNil and: { source.isOpen }) {
				source.close;
			};
		} {
			// other mktls use this HID,
			// so just remove my actions
			this.disable;
			srcID = nil;
		};
	}

	mktlsSharingDeviceSource {
		var found = MKtl.all.select { |mk|
			mk.device.notNil and: { mk.device.source == source }
		};
		found.removeAt(mktl.name);
		^found
	}

	*makeDeviceName { |hidinfo|
		^(hidinfo.productName.asString ++ "_" ++ hidinfo.vendorName);
	}

	// postRawSpecs { this.class.postRawSpecsOf(source) }

	exploring {
		^(HIDExplorer.observedSrcDev == this.source);
	}

	explore { |bool = true|
		if ( bool ){
			"Using HIDExplorer. (see its Helpfile for Details)\n\n".post;
			"HIDExplorer started. Wiggle all elements of your controller,"
			" then do:".postln;
			"%.explore(false);\n".postf( mktl );
			"%.createDescriptionFile;\n".postf( mktl );
			HIDExplorer.start( this.source );
		}{
			HIDExplorer.stop;
			"HIDExplorer stopped.".postln;
		}
	}

	createDescriptionFile {
		if(source.notNil) {
			HIDExplorer.openDocFromDevice(source)
		} {
			"%.createDescriptionFile - source is nil.\n"
			"HID probably could not open device.\n".postf(mktl);
		}
	}

	cleanupElementsAndCollectives {
		// only remove my actions, hid may be shared by others
		this.disable;
	}

	// nothing here yet, to be ported
	initCollectives {

	}

	initElements {
		var traceFunc = { |el|
			"%: hid, % > % type: %".format(
				mktl, el.name.cs, el.value.asStringPrec(3), el.type).postln
		};

		mktl.elementsDict.keysValuesDo { |elemKey, elem|
			var theseElements;

			var elid = elem.elemDesc[\hidElementID];
			var page = elem.elemDesc[\hidUsagePage];
			var usage = elem.elemDesc[\hidUsage];

			var hidElemFunc = { |val, hidElem|
				if (enabled) { elem.deviceValueAction_( val ); };
				if(traceRunning) { traceFunc.value(elem) }
			};

			var hidElem, hidElems;

			// device specs should primarily use usage and usagePage,
			// only in specific instances - where the device has bad firmware
			// use elementIDs which will possibly be operating system dependent

			if ( elid.notNil ) { // filter by element id
				hidElem = source.elements.at( elid );
			} {  // filter by usage and usagePage
				// HIDFunc.usage( { |v| el.deviceValueAction_( v ) },
				// usage, page, \devid, devid );
				hidElems = source.findElementWithUsage( usage, page );
				if (hidElems.size > 1) {
					"%: hidElems.size is % - should not be > 1!\n"
					.postf(mktl, hidElems.size);
					"taking first of :".postln(hidElems);
					hidElems.printAll;
				};
				hidElem = hidElems.first;
			};
			if (hidElem.isNil) {
				"%: in % no hidElem was found for elemKey % !\n"
					.postf(mktl, thisMethod, elemKey.cs);
				^this
			};

			// we have a valid element, so use it
			hidElemDict.put(elemKey, hidElem);
			hidElemFuncDict.put(elemKey, hidElemFunc);
			hidElem.action = hidElem.action.addFunc(hidElemFunc);
		};
	}

	enableElement { |elemKey|
		var hidElem = hidElemDict[elemKey];
		var funcToAdd = hidElemFuncDict[elemKey];
		var hidElemAction = hidElem.action;

		// only add once, so remove first, then add
		hidElem.action = hidElemAction
		.removeFunc(funcToAdd)
		.addFunc(funcToAdd);
	}

	disableElement {|elemKey|
		var hidElem = hidElemDict[elemKey];
		var funcToRemove = hidElemFuncDict[elemKey];
		var hidElemAction = hidElem.action;
		hidElem.action = hidElemAction.removeFunc(funcToRemove);
	}

	// not elegant to write global enabling into each element.
	// there should be a simpler global way.
	enable { |elemKeys|
		(elemKeys ? hidElemDict.keys).do { |elem|
			this.enableElement(elem);
		}
	}

	disable { |elemKeys|
		(elemKeys ? hidElemDict.keys).do { |elem|
			this.disableElement(elem);
		}
	}

	send { |key, val|
		var mktlElem, elemDesc, hidElem;
		mktlElem = mktl.elementsDict[ key ];
		if (mktlElem.isNil) {
			^this
		};
		elemDesc = mktlElem.elemDesc;
		if ( elemDesc.isNil ){
			^this
		};

		hidElem = hidElemDict[key];
		if (hidElem.notNil) {
			hidElem.value = val;
		};
	}

	// no cases yet in MKtlDesc folder
	sendSpecialMessage { |msgs|
		"% not implemented yet, no cases yet in MKtl descs.\n"
		.postf(thisMethod);
	}
}
