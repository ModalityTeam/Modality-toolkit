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

	trace { |mode=true|
		traceRunning = mode;
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
			'faderbox', 'filterbank', 'gamepad', 'joystick', 'keyboard',
			'launchpad', 'manta', 'mixer', 'mouse', 'multiController',
			'phoneApp', 'push', 'ribbon' ];

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

	*initHardwareDevices { |force = false, protocols|
		this.subFor(protocols).do { |cl|
			cl.initDevices( force );
		};
	}

	*open { |name, parentMKtl|
		var lookupName, lookupInfo, protocol, idInfo;
		var desc, subClass, newDevice;
		var deviceCandidates;

		if (parentMKtl.isNil) {
			"MKtlDevice.open: parentMktl.isNil - should not happen!".postln;
			^nil
		};

		// try to find device by lokupName/info first:
		lookupName = parentMKtl.lookupName;
		lookupInfo = parentMKtl.lookupInfo ?? { MKtlLookup.all[lookupName] };
		lookupName = lookupName ?? { if (lookupInfo.notNil) { lookupInfo.lookupName } };

		// if we know the device lookupName already,
		// and it is a single name only, we can get it from here:
		if (lookupInfo.notNil) {
		//	[lookupName, lookupInfo].postln;
			subClass = MKtlDevice.subFor(lookupInfo.protocol);
			^subClass.new( lookupName, parentMKtl: parentMKtl );
		};

		// no luck with lookup info, so try with desc next

		desc = parentMKtl.desc;
		if (desc.isNil) {
			if (verbose) {
				"MKtldevice.open: parentMktl.desc.isNil"
				" - should not happen!".postln;
			};
			^nil
		};

		protocol = desc.protocol;
		idInfo = desc.idInfo;
		deviceCandidates = MKtlLookup.findByIDInfo(idInfo).asArray;


		// "number of device candidates: %\n".postf(deviceCandidates.size);
		if (deviceCandidates.size == 0) {
			if (protocol != \osc) {
				if (verbose) {
					inform("%: could not open mktlDevice,"
						" no device candidates found."
						.format(this));
				};
				^nil
			};
		};

		if (deviceCandidates.size > 1) {
			inform("%: multiple device candidates found, please disambiguate by lookupName:"
				.format(this.name));
			deviceCandidates.do { |cand|
				"\n MKtl(%, %)".format(this.name, cand.lookupName);
			};
			^nil
		};

		// we have exactly one candidate, so we take it:
		lookupInfo = deviceCandidates[0];

		if (lookupInfo.notNil) {
			lookupName = lookupInfo.lookupName;
			parentMKtl.updateLookupInfo(lookupInfo);
		} {
			lookupName = name;
		};


		subClass = MKtlDevice.subFor(desc.protocol);
		^subClass.new(lookupName,  parentMKtl: parentMKtl );

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

	explore { |mode=true|
		this.subclassResponsibility(thisMethod)
	}

	createDescriptionFile {
		this.subclassResponsibility(thisMethod)
	}

	// initialisation messages

	sendSpecialMessages {
		this.subclassResponsibility(thisMethod)
	}

}