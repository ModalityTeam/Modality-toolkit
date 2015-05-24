MKtlDevice {

	// ( 'midi': List['name1',... ], 'hid': List['name1',... ], ... )

	classvar <allAvailable;
	classvar <allProtocols;

	var <name, <deviceName; // short name + full device name
	var <>mktl;

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

		var subClass;
		var matchingProtocol = this.getMatchingProtocol( lookupName );
		if ( matchingProtocol.isNil ){
			^nil;
		};
		subClass = MKtlDevice.matchClass(matchingProtocol);
		if( subClass.isNil ){
			^nil;
		} {
			^subClass.getSourceName( lookupName );
		};
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
	*open { |name, protocol, desc, parentMKtl|
		var subClass;

		protocol = protocol ?? { this.getMatchingProtocol( name ) };
		if (protocol.isNil) {
			"MKtlDevice.open: no protocol found for %.\n".warn;
			^nil;
		};

		subClass = MKtlDevice.matchClass(protocol);
		if( subClass.isNil ){
			"MKtlDevice.open: no device found for name % and protocol %.\n"
			.postf( name, protocol );
			^nil;
		};
		// found one
		^subClass.new( name, parentMKtl: parentMKtl );
	}

	*basicNew { |name, deviceName, parentMKtl |
		^super.new.init(name, deviceName, parentMKtl );
	}


	init { |initName, argDeviceName, parentMKtl|
		name = initName;
		deviceName = argDeviceName;
		mktl = parentMKtl;
	}


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

	sendInitialiationMessages {
		this.subclassResponsibility(thisMethod)
	}

}