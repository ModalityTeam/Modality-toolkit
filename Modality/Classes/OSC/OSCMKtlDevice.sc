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
	var <oscOutPathDictionary;

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
		oscOutPathDictionary = IdentityDictionary.new;
		mktl.elementsDict.do{ |el|
			var oscPath = el.elementDescription[ \oscPath ];
			var ioType = el.elementDescription[ \ioType ];
			var argTemplate = el.elementDescription[ \argTemplate ];
			var valueIndex = el.elementDescription[ \valueAt ];
			// var filterAt = el.elementDescription[ \filterAt ];
			// var match = el.elementDescription[ \match ];
			var filtering;
			if ( [\in,\inout].includes( ioType ) or: ioType.isNil ){
				/*
				if ( filterAt.size != match.size ){
					"WARNING: Element %, with tag % has different sizes for filterAt (%) and match (%)\n".postf( el.key, tag, filterAt, match );
				};
				filtering = [
					el.elementDescription[ \filterAt ] + 1,
					el.elementDescription[ \match ]
				].flop;
				*/
				oscFuncDictionary.put( el.key,
					OSCFunc.new( { |msg|
						/*
						var matching = true;
						filtering.do{ |f|
							if ( msg.at( f[0] ) != f[1] ){ matching = false };
						};
						if ( matching ){
						*/
						el.rawValueAction_( msg.at( valueIndex ) );
						if(traceRunning) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln;
						}
						//};
					}, oscPath, srcDevice, argTemplate: argTemplate ); // optional add host/port
				);
			};
			if ( [ \out, \inout ].includes( ioType ) ) {
				if ( oscOutPathDictionary.at( oscPath ).isNil ){
					oscOutPathDictionary.put( oscPath.asSymbol,
						el.elementDescription[ \valueDefaults ]
					);
				};
				oscOutPathDictionary.at( oscPath ).put( valueIndex, el.name );
			};
		};
	}

	cleanupElements{
		oscFuncDictionary.do{ |it| it.free };
		oscFuncDictionary = nil;
		oscOutPathDictionary = nil;
	}

	// does not take care yet of multidimensional output messages
	send{ |key,val|
		var el, oscPath, values;
		el = mktl.elementDescriptionFor( key );
		oscPath = el.oscPath;
		values = oscOutPathDictionary.at( oscPath );
		values = values.collect{ |it|
			it.postcs;
			if ( it.isKindOf( Symbol ) ){
				mktl.rawValueAt( it );
			}{
				it;
			}
		};
		srcDevice.sendMsg( *( [ el.oscPath ] ++ values ) );
	}
}
