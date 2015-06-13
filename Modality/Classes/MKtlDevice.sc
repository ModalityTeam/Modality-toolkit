// only useful with a device,
// so sort of abstract superclass.

MKtlDevice {

	// ( 'midi': List['name1',... ], 'hid': List['name1',... ], ... )

	classvar <allAvailable;
	classvar <allProtocols;
	classvar <subClassDict;

	// lookup name, full device name, the mktl it was made for
	var <name, <deviceName, <>mktl;

	var <traceRunning = false;

	trace { |mode=true|
		traceRunning = mode;
	}

	*initClass {
		allAvailable = ();

		if ( Main.versionAtLeast( 3, 7 ) ) {
			allProtocols = [\midi,\hid,\osc];
		} {
			allProtocols = [\midi,\osc];
		};

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
		var infoCandidates;

		if (parentMKtl.isNil) {
			"MKtlDevice.open: parentMktl.isNil - should not happen!".postln;
			^nil
		};

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

		// no luck with lookup info, so try desc next

		desc = parentMKtl.desc;
		if (desc.isNil) {
			"MKtldevice.open: parentMktl.desc.isNil - should not happen!".postln;
			^nil
		};

		protocol = desc.protocol;
		idInfo = desc.idInfo;
		infoCandidates = MKtlLookup.findByIDInfo(idInfo).asArray;

		// "number of infoCandidates: %\n".postf(infoCandidates.size);
		if (infoCandidates.size == 0) {
			inform("%: could not open mktlDevice, no infoCandidates found."
				.format(this));
			^nil
		};

		// FIXME: how to get multiple merged devices distinguished properly?
		// currently two nanoKontrols would get merged.
		if (infoCandidates.size > 1) {
			inform("%: multiple infoCandidates found, please disambiguate by lookupName:"
				.format(this.name));
			infoCandidates.do { |cand|
				"\n MKtl(%, %)".format(this.name, cand.lookupName);
			};
			^nil
		};

		// exactly one candidate, so we take it:
		lookupInfo = infoCandidates[0];
		parentMKtl.updateLookupInfo(lookupInfo);

		subClass = MKtlDevice.subFor(desc.protocol);
		^subClass.new( lookupInfo.lookupName, parentMKtl: parentMKtl );

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

	sendInitialisationMessages {
		this.subclassResponsibility(thisMethod)
	}

}