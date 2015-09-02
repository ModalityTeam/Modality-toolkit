HIDMKtlDevice : MKtlDevice {

	classvar <initialized = false;
	classvar <>showAllDevices = false, <deviceProductNamesToHide;
	classvar <protocol = \hid;

	var <srcID, <source;

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
		var postHidden = showAllDevices.not and: { HID.available.size != postables.size };
		var hiddenStr = "// Some HIDs not shown that can crash the OS. See: HID.available;";
		if (postables.size == 0) {
			"No HID devices available.".postln;
			if (postHidden) { hiddenStr.postln; };
			^this
		};

		if (postHidden) { hiddenStr.postln; };
		"\n// Available HIDMKtlDevices:".postln;
		"// MKtl(name, filename);  // [ product, vendor, (serial#) ]".postln;
		postables.sortedKeysValuesDo { |key, infodict|
			var info = infodict.deviceInfo;
			var product = info.productName;
			var vendor = info.vendorName;
			var serial = info.serialNumber;
			var postList = [product, vendor];
			var filename = MKtlDesc.filenameForIDInfo(infodict.idInfo);

			if (serial.notEmpty) {
				postList = postList.add(serial);
			};
			// filename = if (filename.isNil) { "" } { "," + quote(filename) };
			"MKtl('renameMe', %);		// %\n".postf(key.cs, postList.cs);
		};
	}

	*getIDInfoFrom { |hidInfo|
		^if (hidInfo.notNil) {
			[hidInfo.productName, hidInfo.vendorName].join($_);
		}
	}

    // create with a uid, or access by name
	*new { |name, path, parentMKtl|
		var foundSource;

		if (path.isNil) {
			foundSource = MKtlLookup.all.at(name);
			if (foundSource.notNil) {
				foundSource = foundSource.deviceInfo;
			}
		} {
			// // FIXME: is this a usb path?
			// // and what about multiple matches (e.g. Apple Keyboard)?
			// foundSource = HID.findBy( path: path ).asArray.first;
		};

		// make a new one
		if (foundSource.isNil) {
			warn("HIDMKtl:"
			"	No HID source with USB port ID % exists! please check again.".format(path));
			// ^MKtl.prMakeVirtual(name);
			^nil;
		};

		^super.basicNew( name,
			this.makeDeviceName( foundSource ),
			parentMKtl )
		.initHIDMKtl( foundSource );
	}

	initHIDMKtl { |argSource, argUid|
		// HID is only ever one source, hopefully
        source = argSource.open;
		srcID = source.id;

		this.initElements;
		this.initCollectives;

		// only do this explicitly
		// this.sendInitialisationMessages;
	}

	closeDevice {
		this.cleanupElementsAndCollectives;
		srcID = nil;
		if (source.isOpen) { source.close };
	}

    *makeDeviceName { |hidinfo|
		^(hidinfo.productName.asString ++ "_" ++ hidinfo.vendorName);
    }

	// postRawSpecs { this.class.postRawSpecsOf(source) }

	exploring {
		^(HIDExplorer.observedSrcDev == this.source);
	}

	explore { |mode=true|
		if ( mode ){
			"Using HIDExplorer. (see its Helpfile for Details)\n\n".post;
			"HIDExplorer started. Wiggle all elements of your controller,"
			" then do:".postln;
			"\tMKtl(%).explore(false);\n".postf( name );
			"\tMKtl(%).createDescriptionFile;\n".postf( name );
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
			Error("MKtl#createDescriptionFile - source is nil.\n"
				"HID probably could not open device").throw
		}
	}

	cleanupElementsAndCollectives {
		mktl.elementsDict.do{ |el|
			var theseElements;
            var elid = el.elemDesc[\hidElementID];
            var page = el.elemDesc[\hidUsagePage];
            var usage = el.elemDesc[\hidUsage];

			if ( elid.notNil ) { // filter by element id
				source.elements.at( elid ).action = nil;
			} {
				theseElements = source.findElementWithUsage( usage, page );
				theseElements.do { |it|
					it.action = nil;
				}
			}
		};
	}

	// nothing here yet, to be ported
	initCollectives {

	}

	initElements {

		mktl.elementsDict.do { |el|
            var theseElements;

            var elid = el.elemDesc[\hidElementID];
            var page = el.elemDesc[\hidUsagePage];
            var usage = el.elemDesc[\hidUsage];

            // device specs should primarily use usage and usagePage,
            // only in specific instances - where the device has bad firmware
			// use elementIDs which will possibly be operating system dependent

            if ( elid.notNil ){ // filter by element id
                // HIDFunc.element( { |v| el.deviceValueAction_( v ) }, elid, \devid, devid );
				// could get raw value hidele.deviceValue
                source.elements.at( elid ).action = { |v, hidele|
					el.deviceValueAction_( v );
					if(traceRunning) {
						"% - % > % | type: %, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3),
							el.type, el.source).postln
					}
				};
            }{  // filter by usage and usagePage
                // HIDFunc.usage( { |v| el.deviceValueAction_( v ) },
				// usage, page, \devid, devid );
                theseElements = source.findElementWithUsage( usage, page );
                theseElements.do { |it|
                    it.action = { |v, hidele| // could get raw value hidele.deviceValue
						el.deviceValueAction_( v );
						if(traceRunning) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln
						}
					};
                };
            };
    	};
	}

	send { |key,val|
		var thisMktlElement, thisHIDElement;
		thisMktlElement = mktl.elementsDict[ key ].elemDesc;
		if ( thisMktlElement.notNil ){
			thisHIDElement = source.findElementWithUsage( thisMktlElement.at( 'hidUsage' ), thisMktlElement.at( 'hidUsagePage' ) ).first;
			if ( thisHIDElement.notNil ){
				thisHIDElement.value = val;
			};
		};
	}

	// still to be ported
	sendInitialisationMessages {

	}
}
