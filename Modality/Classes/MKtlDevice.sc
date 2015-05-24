MKtlDevice {

	// ( 'midi': List['name1',... ], 'hid': List['name1',... ], ... )
	classvar <allAvailable;
	classvar <allInitialized = false;
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
		allInitialized = true;
	}

	*matchClass { |symbol|
		^this.allSubclasses.detect({ |x| x.protocol == symbol })
	}

	*initHardwareDevices { |force = false, protocols|
		protocols = protocols ? allProtocols;

		if ( allInitialized.not or: force ){
			this.allSubclasses.do { |it|
				if ( protocols.includes( it.protocol ) ){
					it.initDevices( force );
				};
			};
		};
		allInitialized = true;
	}

	*findMatchingProtocols { |name|
		^allAvailable.select(_.includes(name)).keys.as(Array);
	}

	*getMatchingProtocol { |name|
		var matchingProtocols = this.findMatchingProtocols( name );
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

	*getDeviceNameFromShortName { |shortName|

		var subClass;
		var matchingProtocol = this.getMatchingProtocol( shortName );
		if ( matchingProtocol.isNil ){
			^nil;
		};
		subClass = MKtlDevice.matchClass(matchingProtocol);
		if( subClass.isNil ){
			^nil;
		} {
			^subClass.getSourceName( shortName );
		};
	}

		*findDeviceShortNameFromLongName{ |devLongName|
		var devKey, newDevKey;
		if ( devLongName.isKindOf( String ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( devLongName );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
		if (devLongName.isKindOf( Array ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( *devLongName );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
		if (devLongName.isKindOf( Dictionary ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( devLongName );
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
	*tryOpenDevice { |name, parentMKtl|
		var matchingProtocol, subClass;
		// then see if it is attached:

		matchingProtocol = this.getMatchingProtocol( name );

		if ( matchingProtocol.isNil ){
			^nil;
		};

		subClass = MKtlDevice.matchClass(matchingProtocol);
		if( subClass.isNil ){
			"WARNING: MKtl: device not found with name % and protocol %, and no matching device description found\n".postf( name, matchingProtocol );
			^nil;
		};
		if( subClass.notNil ) {
			^subClass.new( name, parentMKtl: parentMKtl );
		};
	}

	*tryOpenDeviceFromDesc { |name, protocol, desc, parentMKtl|
		var subClass;
		if ( protocol.isNil ){
			^nil;
		};
		subClass = MKtlDevice.matchClass(protocol);
		if( subClass.isNil ){
			"WARNING: MKtl: device not found with description % and protocol %\n".postf( desc, protocol );
			^nil;
		};
		if( subClass.notNil ) {
			^subClass.new( name, desc, parentMKtl: parentMKtl );
		};
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