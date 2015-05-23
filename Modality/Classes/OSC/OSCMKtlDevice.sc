// TODO:
// * short names
// * exploring
// * send

/// and testing;
/*

(
MKtl.addSpec(\minibeeData, [0, 1]);


~minibeeDesc = (
device: "minibee",
protocol: \osc,
// port: 57600, // if messages are sent from a specific port
description: (
	'acc': (
			x: (
				oscPath: '/minibee/data',
				//filterAt: [ 0 ], match: [ 1 ],
                argTemplate: [ 1 ],
                valueAt: 2,
			'type': 'accelerationAxis', spec: \minibeeData
		),
		y: (
			oscPath: '/minibee/data',
			// filterAt: [ 0 ], match: [ 1 ],
            argTemplate: [ 1 ],
            valueAt: 3,
			'type': 'accelerationAxis', spec: \minibeeData
		),
		z: (
			oscPath: '/minibee/data',
			// filterAt: [ 0 ], match: [ 1 ],
            argTemplate: [ 1 ],
            valueAt: 4,
			'type': 'accelerationAxis', spec: \minibeeData
		)
	),
	'rssi': (
		oscPath: '/minibee/data',
		// filterAt: [ 0 ], match: [ 1 ],
        argTemplate: [ 1 ],
        valueAt: 5,
		'type': 'rssi', spec: \minibeeData
	)
)
)
);

(
MKtl( \testMinibee, ~minibeeDesc );
m = MKtl( \testMinibee );
);



*/

OSCMKtlDevice : MKtlDevice {
	classvar <protocol = \osc;
	classvar <sourceDeviceDict; // contains active sources ( recvPort: , srcPort: , ipAddress: , destPort:  )

	var <srcDevice;  // receiving OSC from this NetAddr
	var <destDevice; // sending OSC to this NetAddr
	var <recvPort; // port on which we need to listen

	var <oscFuncDictionary;
	// var <oscOutPathDictionary;

	classvar <initialized = false; // always true
	// classvar <>traceFind = false;

	*find { |post=true|
		this.initDevices( true );
		if ( post ){
			this.postPossible;
		}
		/*
		traceFind = post;
		this.initDevices( true );
		if ( post ){
			fork{
				1.0.wait;
				this.postPossible;
			};
		}
		*/
	}

	/*
	*initDevices { |force=false| // force has no real meaning here
		sourceDeviceDict = (); // this is tricky, we could have an OSCFunc running which checks from which NetAddresses we are receiving data.
		checkIncomingOSCFunction = {
			|msg,time,source|
			var sourcename = this.deviceNameFromAddr( source ).asSymbol;
			if ( sourceDeviceDict.at( sourcename ).isNil ){
				sourceDeviceDict.put( sourcename, source );
				// add to all available
				this.addFoundToAllAvailable( sourcename );
				if ( this.traceFind ){
					"OSCMKtlDevice found a new osc source: % \n".postf( source );
				};
			};
		};
		this.addToAllAvailable;
		thisProcess.addOSCRecvFunc( checkIncomingOSCFunction );
		initialized = true;
	}

	*addFoundToAllAvailable{ |key|
		allAvailable.at( \osc ).add( key );
	}

	*addToAllAvailable{
		// put the available osc devices in MKtlDevice's available devices
		allAvailable.put( \osc, List.new );
		sourceDeviceDict.keysDo({ |key|
			allAvailable[\osc].add( key );
		});
	}

	*deinitDevices {
		thisProcess.removeOSCRecvFunc( checkIncomingOSCFunction );
	}
	*/

	*initDevices { |force=false| // force has no real meaning here
		sourceDeviceDict = sourceDeviceDict ?? ();
		initialized = true;
	}
	*deinitDevices {} // doesn't do anything, but needs to be there

	*postPossible{
		"To find what OSC is coming in, please use the osc monitor:".postln;
		"o = OSCMon.new; o.enable; o.show".postln;
		if ( initialized ){
			"\n// Available OSCMKtlDevices:".postln;
			"// MKtl(autoName);  // [ host, port ]".postln;
			sourceDeviceDict.keysValuesDo{ |key,addr|
				"    MKtl('%');  // [ %, % ]\n"
				.postf(key, addr.hostname.asCompileString, addr.port.asCompileString )
			};
			"\n-----------------------------------------------------".postln;
		};
	}

	*findSource{ |name,host,port| // only reports interfaces that are already opened
		var devKey;
		if ( initialized ){
			this.sourceDeviceDict.keysValuesDo{ |key,addr|
				if ( host.notNil ){
					if ( port.notNil ){
						if ( addr.port == port and: (addr.hostname == host ) ){
							devKey = key;
						}
					}{ // just match host
						if ( addr.hostname == host ){
							devKey = key;
						}
					}
				}{ // just match port
					if ( addr.port == port ){
						devKey = key;
					}
				}
			};
		}
		^devKey;
	}

	*addToSourceDeviceDict{ |name, devInfo|
		sourceDeviceDict.put( name, devInfo );
		if ( allAvailable.at( \osc ).isNil ){
			allAvailable.put( \osc, List.new );
		};
		allAvailable.at( \osc ).add( name );
	}

	*new { |name, devInfo, parentMKtl|
		// srcDesc will be a ( destPort: , recvPort: , srcPort: ..., ipAddress: ..., listenPort: ... )
		if ( devInfo.isNil ){
			devInfo = sourceDeviceDict.at( name );
		}{
			if ( name.notNil ){
				this.addToSourceDeviceDict( name, devInfo );
			};
		};
		// ^super.basicNew( name, this.deviceNameFromAddr( addr ), parentMKtl ).initOSCMKtl( addr );
		^super.basicNew( name, name, parentMKtl ).initOSCMKtl( devInfo );
	}

	initOSCMKtl{ |desc| // this will not be addr but a ( destPort: , recvPort: , srcPort: ..., ipAddress: ..., listenPort: ... )

		srcDevice = NetAddr.new( desc.at( \ipAddress ), desc.at( \srcPort ) );
		if ( desc.at( \desPort ).notNil ){
			destDevice = NetAddr.new( desc.at( \ipAddress ), desc.at( \destPort ) );
		}{ // assume destination port is same as srcPort
			destDevice = NetAddr.new( desc.at( \ipAddress ), desc.at( \srcPort ) );
		};
		recvPort = desc.at( \recvPort );

		this.initElements;
	}


	closeDevice{
		this.cleanupElementsAndCollectives;
		srcDevice = nil;
		destDevice = nil;
		recvPort = nil;
	}

	initElements{
		if ( oscFuncDictionary.notNil ){
			oscFuncDictionary = IdentityDictionary.new;
		};
		mktl.elementsDict.do{ |el|
			var oscPath = el.elementDescription[ \oscPath ];
			var ioType = el.elementDescription[ \ioType ];
			var argTemplate = el.elementDescription[ \argTemplate ];
			var valueIndex = el.elementDescription[ \valueAt ];
			if ( [\in,\inout].includes( ioType ) or: ioType.isNil ){
				oscFuncDictionary.put( el.key,
					OSCFunc.new( { |msg|
						el.rawValueAction_( msg.at( valueIndex ) );
						if(traceRunning) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln;
						}
					}, oscPath, srcDevice, recvPort, argTemplate: argTemplate );
				);
			};
		};
	}

	initCollectives{
		if ( oscFuncDictionary.notNil ){
			oscFuncDictionary = IdentityDictionary.new;
		};
		mktl.collectivesDict.do{ |el|
			var oscPath = el.elementDescription[ \oscPath ];
			var ioType = el.elementDescription[ \ioType ];
			var argTemplate = el.elementDescription[ \argTemplate ];
			var msgIndices, templEnd;
			if ( [\in,\inout].includes( ioType ) and: ( el.elementDescription[ \type ] == \oscMessage) ){
				templEnd = argTemplate.size + 1; // + 1 because argTemplate does not contain the oscpath as the first msg element
				msgIndices = argTemplate.indicesOfEqual( nil ) + 1; // + 1 because argTemplate does not contain the oscpath as the first msg element
				oscFuncDictionary.put( el.key,
					OSCFunc.new( { |msg|
						// clever msg index parsing
						el.rawValueAction_( msg.at( msgIndices) ++ msg.copyToEnd( templEnd ) );
						if(traceRunning) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln; // fix tracing
						}
					}, oscPath, srcDevice, recvPort, argTemplate: argTemplate ); // optional add host/port
				);
			};
		};
	}

	cleanupElementsAndCollectives{
		oscFuncDictionary.do{ |it| it.free };
		oscFuncDictionary = nil;
	}

	// this should work for the simple usecase (not the group yet)
	// from the group: \output, val: [ 0, 0, 0, 0 ]
	send{ |key,val|
		var el, oscPath, outvalues, valIndex;
		if ( destDevice.notNil ){
			el = mktl.elementDescriptionFor( key );
			oscPath = el[\oscPath];
			if ( val.isKindOf( Array ) ){
				outvalues = List.new;
				el[\argTemplate].do{ |it|
					if ( it.isNil ){
						outvalues.add( val.at( valIndex ) ); valIndex = valIndex + 1;
					}{
						outvalues.add( it )
					};
				};
				if ( valIndex < val.size ){ outvalues = outvalues ++ (val.copyToEnd( valIndex ) ) };
				outvalues = outvalues.asArray;
			}{
				outvalues = el[\argTemplate].copy; // we will modify it maybe, so make a copy
				if ( outvalues.includes( nil ) ){
					outvalues.put( outvalues.indexOf( nil ), val );
				}{
					outvalues = outvalues ++ val;
				};
			};
			destDevice.sendMsg( *( [ oscPath ] ++ outvalues ) );
		}
	}

}
