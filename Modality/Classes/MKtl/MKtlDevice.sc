// only useful with a device,
// so sort of abstract superclass.

MKtlDevice {

	// ( 'midi': List['name1',... ], 'hid': List['name1',... ], ... )

	classvar <>verbose = true;

	// classvar <allAvailable;
	classvar <allProtocols;
	classvar <subClassDict;

	classvar <deviceTypes;

	// lookup name, full device name, the mktl it was made for
	var <name, <deviceName, <>mktl;

	var <traceRunning = false;

	trace { |bool = true|
		traceRunning = bool;
	}

	*initClass {
		// allAvailable = ();

		if ( Main.versionAtLeast( 3, 7 ) ) {
			// this order seems to work better on osx
			// order \midi, \hid ... crashes interpreter when server is on
			// see https://github.com/supercollider/supercollider/issues/1640
			allProtocols = [\hid,\midi,\osc];
		} {
			allProtocols = [\midi,\osc];
		};
		deviceTypes = List[
			'controller', 'djController', 'drumPad', 'drumpad', 'fader',
			'faderbox', 'filterbank', 'gamepad', 'hidKeyboard','joystick',
			'launchpad', 'manta', 'midiKeyboard', 'mixer', 'mouse',
			'multiController', 'phoneApp', 'push', 'ribbon' ];

		subClassDict = ();
		this.allSubclasses.do { |cl| subClassDict.put(cl.protocol, cl) };
	}

	*subFor { |protocol|
		protocol = protocol ? allProtocols;
		^protocol.asArray.collect { |proto| subClassDict[proto] }.unbubble;
	}

	*find { |protocols, post = true|
		this.subFor(protocols).do (_.find(false));
		if (post) {
			this.subFor(protocols).do(_.postPossible);
		};
	}

	*descFileStrFor { |nameKey, lookupKey, filenames, multiIndex, generic = ""|
		var str, numDescs = filenames.size;
		var lookupStr = "MKtl('%', %);\n".format(nameKey, lookupKey.cs);

		numDescs.switch(
			0, 	{
				str = "\t// Unknown - Create from lookupName and explore %:\n".format(generic) ++ lookupStr;
			},
			1, 	{
				str = "\t// Supported. Create by lookupName only if necessary:\n// "
				++ lookupStr
				++ "\t// Best create MKtl from desc file:\n";

			},
			{ 	str = "\t// Supported by % desc files.\n".format(numDescs)
				++ "// Create MKtl from lookupName only if necessary:\n// "
				++ lookupStr
				++ "\t// Best create MKtl from one of the desc files:\n";

			}
		);

		filenames.do { |filename|
		str = str ++ "MKtl(%, %%);\n".format(
			nameKey.cs,
			filename.cs,
				if (multiIndex.notNil, ", multiIndex:" + multiIndex, "")
			);
		};
		^str ++ "\n";
	}


	*initHardwareDevices { |force = false, protocols|
		this.subFor(protocols).do { |cl|
			cl.initDevices( force );
		};
	}

	*open { |name, parentMKtl, multiIndex|
		var lookupName, lookupInfo, protocol, idInfo;
		var desc, subClass, newDevice;
		var deviceCandidates;

		if (parentMKtl.isNil) {
			"%: parentMktl.isNil - should not happen!\n".postf(thisMethod);
			^nil
		};

		// try to find device by lokupName/info first:
		lookupName = parentMKtl.lookupName;
		lookupInfo = parentMKtl.lookupInfo ?? { MKtlLookup.all[lookupName] };
		lookupName = lookupName ?? {
			if (lookupInfo.notNil) { lookupInfo.lookupName }
		};

		// if we know the device lookupName already,
		// and it is a single name only, we can get it from here:
		if (lookupInfo.notNil) {
		//	[lookupName, lookupInfo].postln;
			subClass = MKtlDevice.subFor(lookupInfo.protocol);
			^subClass.new( lookupName, parentMKtl: parentMKtl, multiIndex: multiIndex);
		};

		// no luck with lookup info, so try with desc next

		desc = parentMKtl.desc;
		if (desc.isNil) {
			if (verbose) {
				"MKtlDevice:open: cannot open - no matching device found and no desc given."
				.postln;
			};
			^nil
		};

		protocol = desc.protocol;
		idInfo = desc.idInfo;
		deviceCandidates = MKtlLookup.findByIDInfo(idInfo);

		// "number of device candidates: %\n".postf(deviceCandidates.size);
		if (deviceCandidates.size == 0) {
			if (protocol != \osc) {
				if (verbose) {
					inform("%: can not open - no device candidates found."
						.format(thisMethod)
					);
				};
				^nil
			};
		};

		if (deviceCandidates.size > 1) {
			if (multiIndex.notNil) {
				lookupInfo = deviceCandidates[multiIndex];
				if (lookupInfo.notNil) {
					lookupName = lookupInfo.lookupName;
				};
			} {
				inform("//---\n%: multiple device candidates found,"
					" please disambiguate by providing a multiIndex!"
					"\nThe candidates are:\n"
				.format(thisMethod));
				deviceCandidates.do { |info, i|
					"multiIndex %: %\n".format(i, info.cs).postln;
				};
				^nil
			};
		} {
			// we have exactly one candidate, so we take it:
			lookupInfo = deviceCandidates[0];
			if (lookupInfo.notNil) {
				lookupName = lookupInfo.lookupName;
			};
		};

		if (lookupName.notNil) {
			lookupInfo.lookupName = lookupName;
			parentMKtl.updateLookupInfo(lookupInfo);
		} {
			lookupName = name;
		};

		// "% gets to end. lookupName: %.\n\n\n".postf(thisMethod, lookupName);
		subClass = MKtlDevice.subFor(desc.protocol);
		^subClass.new(lookupName,
			parentMKtl: parentMKtl,
			multiIndex: multiIndex);

	}

	*basicNew { |name, deviceName, parentMKtl |
		^super.newCopyArgs(name, deviceName, parentMKtl ).init;
	}

	init { } // overwrite in subclasses

	*protocol {
		this.subclassResponsibility(thisMethod)
	}

	cleanupElementsAndCollectives {
		this.subclassResponsibility(thisMethod)
	}

	initElements {
		this.subclassResponsibility(thisMethod)
	}

	initCollectives {
		this.subclassResponsibility(thisMethod)
	}

	closeDevice {
		this.subclassResponsibility(thisMethod)
	}

	// exploration:

	exploring {
		this.subclassResponsibility(thisMethod)
	}

	explore { |bool = true|
		this.subclassResponsibility(thisMethod)
	}

	createDescriptionFile {
		this.subclassResponsibility(thisMethod)
	}

	// initialisation messages

	sendSpecialMessage {
		this.subclassResponsibility(thisMethod)
	}

}