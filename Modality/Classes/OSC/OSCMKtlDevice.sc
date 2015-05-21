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
	classvar <sourceDeviceDict;
	classvar <checkIncomingOSCFunction;

	var <srcDevice;

	var <oscFuncDictionary;
	// var <oscOutPathDictionary;

	classvar <initialized = false;

	classvar <>traceFind = false;

	*find { |post=true|
		traceFind = post;
		this.initDevices( true );
		if ( post ){
			fork{
				1.0.wait;
				this.postPossible;
			};
		}
	}

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


	*postPossible{
		if ( initialized ){
			"\n// Available OSCMKtlDevices:".postln;
			"// MKtl(autoName);  // [ host, port ]".postln;
			sourceDeviceDict.keysValuesDo{ |key,addr|
				"    MKtl('%');  // [ %, % ]\n"
				.postf(key, addr.hostname.asCompileString, addr.port.asCompileString )
			};
			"\n-----------------------------------------------------".postln;
		}
	}

	*findSource{ |name,host,port| // does not do anything useful yet...
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

	*deviceNameFromAddr{ |addr|
		// this is not good, needs a proper fix
		^( "host" ++ addr.hash.asDigits.sum ++ "_" ++ addr.port);
	}

	*new { |name, addr, parentMKtl|
		// could have a host/port combination from which messages come?
		if ( addr.isNil ){
			addr = sourceDeviceDict.at( name );
		};
		^super.basicNew( name, this.deviceNameFromAddr( addr ), parentMKtl ).initOSCMKtl( addr );
	}

	initOSCMKtl{ |addr|
		srcDevice = addr;
		this.initElements;
	}

	closeDevice{
		this.cleanupElements;
		srcDevice = nil;
	}

	initElements{
		oscFuncDictionary = IdentityDictionary.new;
		// oscOutPathDictionary = IdentityDictionary.new;
		mktl.elementsDict.do{ |el|
			var oscPath = el.elementDescription[ \oscPath ];
			var ioType = el.elementDescription[ \ioType ];
			var argTemplate = el.elementDescription[ \argTemplate ];
			var valueIndex = el.elementDescription[ \valueAt ];
			var filtering;
			if ( [\in,\inout].includes( ioType ) or: ioType.isNil ){
				oscFuncDictionary.put( el.key,
					OSCFunc.new( { |msg|
						el.rawValueAction_( msg.at( valueIndex ) );
						if(traceRunning) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln;
						}
					}, oscPath, srcDevice, argTemplate: argTemplate ); // optional add host/port
				);
			};
			/*
			if ( [\in,\inout].includes( ioType ) and: ( el.elementDescription[ \type ] == \oscMessage) ){
				// create special MKtlElementGroup from the elements referred to
			}
			*/
		};
	}

	cleanupElements{
		oscFuncDictionary.do{ |it| it.free };
		oscFuncDictionary = nil;
	}

	// this should work for the simple usecase (not the group yet)
	// from the group: \output, val: [ 0, 0, 0, 0 ]
	send{ |key,val|
		var el, oscPath, outvalues, valIndex;
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
		srcDevice.sendMsg( *( [ oscPath ] ++ outvalues ) );
	}

}
