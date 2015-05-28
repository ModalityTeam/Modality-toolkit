// only useful with a device,
// so sort of abstract superclass.

MKtlDevice {

	// ( 'midi': List['name1',... ], 'hid': List['name1',... ], ... )

	classvar <allAvailable;
	classvar <allProtocols;

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
	}

	*find { |protocols|
		(protocols ? allProtocols).asCollection.do { |pcol|
			this.matchClass(pcol) !? _.find
		};
	}

	*matchClass { |symbol|
		^this.allSubclasses.detect({ |x| x.protocol == symbol })
	}

	*initHardwareDevices { |force = false, protocols|
		protocols = protocols ? allProtocols;

		this.allSubclasses.do { |it|
			if ( protocols.includes( it.protocol ) ){
				it.initDevices( force );
			};
		};
	}

	*findMatchingProtocols { |lookupName|
		^allAvailable.select(_.includes(lookupName)).keys.as(Array);
	}

	*getMatchingProtocol { |lookupName|
		var matchingProtocols = this.findMatchingProtocols( lookupName );
		if ( matchingProtocols.size == 0 ){
			// no dev with matching protocol found
			^nil;
		};
		if ( matchingProtocols.size > 1 ){ // more than one matching protocol:
			"% multiple protocol devices not implemented yet, found %, using %\n"
			.format(MKtlDevice, matchingProtocols, matchingProtocols.first ).warn;
		};
		matchingProtocols = matchingProtocols.first;
		^matchingProtocols;
	}

	*idInfoForLookupName { |lookupName|
		var allFound = MKtlDevice.allSubclasses.collect {|sub|
			var found = sub.sourceDeviceDict[lookupName];
			if (found.notNil) { sub.getIDInfoFrom(found) };
		}.reject(_.isNil);

		if (allFound.isEmpty) {
			inform("MKtlDevice: found no device"
				"at lookupName %.".format(lookupName));
			^nil
		};
		if (allFound.size > 1) {
		inform("MKtlDevice: found multiple devices"
			"at lookupName %.".format(lookupName));
			^allFound
		}
		// found exactly one:
		^allFound.unbubble;
	}


	*lookupNameForIDInfo { |idInfo|
		var devKey, newDevKey;
		if ( idInfo.isKindOf( String ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( idInfo );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
		if (idInfo.isKindOf( Array ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( *idInfo );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
		if (idInfo.isKindOf( Dictionary ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( idInfo );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
		^nil;
	}

	// collapse tryOpenDevice and tryOpenDeviceFromDesc
	// into one
	*open { |name, parentMKtl, protocol, desc|
		var subClass, newDevice, devLookupName;

		devLookupName = MKtlDevice.lookupNameForIDInfo(
			parentMKtl.desc.idInfo);

		protocol = protocol ?? {
			parentMKtl.desc.protocol ?? {
				this.getMatchingProtocol( name )
		} };
		if (protocol.isNil) {
			"MKtlDevice.open: no protocol found for %.\n".warn;
			^nil;
		};
		// "MKtlDevice.open: parentMKtl: %, prot: %,\n"
		// "desc keys: %".format(parentMKtl.cs, protocol.cs, desc.keys.cs).postln;

		subClass = MKtlDevice.matchClass(protocol);
		if( subClass.isNil ){
			"MKtlDevice.open: no device found for name % and protocol %.\n"
			.postf( name, protocol );
			^nil;
		};

		// try to find one:
		newDevice = subClass.new( devLookupName, parentMKtl: parentMKtl );
		if (newDevice.notNil) {
			// yes yes yes
			newDevice.initElements;
			^newDevice
		};

		"MKtlDevice.open: parentMKtl: %, prot: %,\n"
		"desc: %".format(parentMKtl.cs, protocol.cs, desc);

		"// MKtlDevice.open - if we ever get here,"
		"// implement lookup of name in desc..."
		"this.findNameFromDesc(desc);".postln;
		^nil
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