// TODO:
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
	classvar inversePatternDispatcher;
	classvar messageSizeDispatcher;

	var <source;  // receiving OSC from this NetAddr
	var <destination; // sending OSC to this NetAddr
	var <recvPort; // port on which we need to listen

	var <oscFuncDictionary;

	classvar < initialized = false; // always true

	*inversePatternDispatcher {
		if ( inversePatternDispatcher.isNil ){
			inversePatternDispatcher = OSCMessageInversePatternDispatcher.new;
		};
		^inversePatternDispatcher;
	}

	*messageSizeDispatcher {
		if ( messageSizeDispatcher.isNil ){
			messageSizeDispatcher = OSCMessageAndArgsSizeDispatcher.new;
		};
		^messageSizeDispatcher;
	}

	*find { |post=(verbose)|
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

	*addFoundToAllAvailable { |key|
	allAvailable.at( \osc ).add( key );
	}

	*addToAllAvailable {
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
		var postables = MKtlLookup.allFor(\osc);
		initialized = true;
		if (verbose and: { postables.size == 0 }) {
			"// OSCMKtlDevice: No known sending addresses so far.\n"
			"// To detect OSC devices by hand, use OSCMon: ".postln;
			"o = OSCMon.new.enable.show;".postln;
			^this
		};
	}

	*deinitDevices { } // doesn't do anything, but needs to be there

	*postPossible {
		var postables = MKtlLookup.allFor(\osc);
		"\n// Available OSCMKtlDevices:".postln;
		"// MKtl(name);  // [ host, port ]".postln;
		postables.sortedKeysValuesDo { |key, addr|
			"    MKtl('%'); // [ %, % ]\n"
			.postf(key, addr.hostname.cs, addr.port.cs )
		};
	}

	*new { |name, devInfo, parentMKtl|

		devInfo = devInfo ?? { parentMKtl.desc; };
		if (devInfo.isNil) {
			inform("OSCMKtlDevice.new: cannot make new one without info or parent.");
			^nil
		};

		^super.basicNew( name, name, parentMKtl );
	}

	init { |desc|
		desc = desc ?? { mktl.desc };
		this.initOSCMKtl( desc.idInfo ).initElements;
	}

	initOSCMKtl { |idInfo|
		if ( idInfo.at( \ipAddress ).notNil ) {
			source = NetAddr.new( idInfo.at( \ipAddress ), idInfo.at( \srcPort ) );
			if ( idInfo.at( \destPort ).notNil ){
				destination = NetAddr.new( idInfo.at( \ipAddress ), idInfo.at( \destPort ) );
			}{ // assume destination port is same as srcPort
				destination = NetAddr.new( idInfo.at( \ipAddress ), idInfo.at( \srcPort ) );
			};
		}{
			if ( idInfo.at( \destPort ).notNil ){
				destination = NetAddr.new( "127.0.0.1", idInfo.at( \destPort ) );
			}{ // assume destination port is same as srcPort
				destination = NetAddr.new( "127.0.0.1", idInfo.at( \srcPort ) );
			};
		};
		recvPort = idInfo.at( \recvPort );

		this.initCollectives;
	}


	closeDevice {
		this.cleanupElementsAndCollectives;
		source = nil;
		destination = nil;
		recvPort = nil;
		// should this remove from sourceDictionary too?
	}

	initElements {

		if ( oscFuncDictionary.isNil ){
			oscFuncDictionary = IdentityDictionary.new;
		};
		mktl.elementsDict.do { |el|
			var oscPath = el.elemDesc[ \oscPath ];
			var ioType = el.elemDesc[ \ioType ];
			var argTemplate = el.elemDesc[ \argTemplate ];
			var valueIndex = el.elemDesc[ \valueAt ];
			var dispatcher;
			if ( [\in,\inout].includes( ioType ) or: ioType.isNil ){

				if ( oscFuncDictionary.at( el.name ).notNil ){
					oscFuncDictionary.at( el.name ).free
				};

				if ( oscPath.asString.includes( $* ) ){ // pattern matching
					dispatcher = this.class.inversePatternDispatcher;
					valueIndex = oscPath.asString.split( $/ ).indexOfEqual( "*" );
					oscFuncDictionary.put( el.name,
						OSCFunc.new( { |msg|
							if ( valueIndex.notNil ){
								el.deviceValueAction_( msg[0].asString.split($/).at( valueIndex ) );
							};
							if(traceRunning) {
								"% - % > % | type: %, src:%"
								.format(this.name, el.name, el.value.asStringPrec(3),
									el.type, el.source).postln;
							}
						}, oscPath, source, recvPort, argTemplate, dispatcher )
						.permanent_( true );
					);
				}{
					dispatcher = this.class.messageSizeDispatcher;
					if ( el.type == \trigger ){
						// trigger osc func
						oscFuncDictionary.put( el.name,
							OSCFunc.new( { |msg|
								el.deviceValueAction_( 1 ); // send a default value of 1
								if(traceRunning) {
									"% - % > % | type: %, src:%"
									.format(this.name, el.name, el.value.asStringPrec(3),
										el.type, el.source).postln;
								}
							}, oscPath, source, recvPort, argTemplate, dispatcher )
							.permanent_( true );
						);
					}{
						// normal osc matching
						oscFuncDictionary.put( el.name,
							OSCFunc.new( { |msg|
								if ( valueIndex.notNil ){
									el.deviceValueAction_( msg.at( valueIndex ) );
								}{
									el.deviceValueAction_( msg.last );
								};
								if(traceRunning) {
									"% - % > % | type: %, src:%"
									.format(this.name, el.name, el.value.asStringPrec(3),
										el.type, el.source).postln;
								}
							}, oscPath, source, recvPort, argTemplate, dispatcher )
							.permanent_( true );
						);
					};
				}
			};
		};
	}

	initCollectives {
		if ( oscFuncDictionary.isNil ){
			oscFuncDictionary = IdentityDictionary.new;
		};
		mktl.collectivesDict.do { |el|
			var oscPath = el.elemDesc[ \oscPath ];
			var ioType = el.elemDesc[ \ioType ];
			var argTemplate = el.elemDesc[ \argTemplate ];
			var valueIndices = el.elemDesc[ \valueAt ];
			var msgIndices, templEnd;
			var dispatcher = this.class.messageSizeDispatcher;

			if ( [\in,\inout].includes( ioType ) and: ( oscPath.notNil) ){

				if ( valueIndices.notNil ){
					msgIndices = valueIndices;
					templEnd = valueIndices.maxItem + 1;
				}{
					if ( argTemplate.notNil ){
						// + 1 because argTemplate does not contain the oscpath as the first msg element
						templEnd = argTemplate.size + 1;
						msgIndices = argTemplate.indicesOfEqual( nil );
						// + 1 because argTemplate does not contain the oscpath as the first msg element
						if ( msgIndices.notNil) { msgIndices = msgIndices + 1; };

					}{
						templEnd = 1;
					};
				};
				if ( oscFuncDictionary.at( el.name ).notNil ){
					oscFuncDictionary.at( el.name ).free };

				oscFuncDictionary.put( el.name,
					OSCFunc.new( { |msg|
						// clever msg index parsing
						if ( msgIndices.notNil ){
							el.deviceValueAction_(
								msg.at( msgIndices) ++ msg.copyToEnd( templEnd )
							);
						}{
							el.deviceValueAction_( msg.copyToEnd( templEnd ) );
						};
						if(traceRunning) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name,
								el.value.collect { |it|
									it.asStringPrec(3) },
								el.type, el.source).postln;
						}
					}, oscPath, source, recvPort, argTemplate, dispatcher )
					.permanent_( true );
				);
			};
		};
	}

	cleanupElementsAndCollectives {
		oscFuncDictionary.do { |it| it.free };
		oscFuncDictionary = nil;
	}

	// this should work for the simple usecase (not the group yet)
	// from the group: \output, val: [ 0, 0, 0, 0 ]
	send { |key, val|
		var el, oscPath, outvalues,valIndex;
		if ( destination.notNil ) {
			if ( val.isKindOf( Array ) ){
				el = mktl.collectiveDescriptionFor( key );
				valIndex = 0;
				oscPath = el[\oscPath];
				outvalues = List.new;
				el[\argTemplate].do { |it|
					if ( it.isNil ) {
						outvalues.add( val.at( valIndex ) ); valIndex = valIndex + 1;
					}{
						outvalues.add( it )
					};
				};
				if ( valIndex < val.size ) { outvalues = outvalues ++ (val.copyToEnd( valIndex ) ) };
				outvalues = outvalues.asArray;
			} {
				// FIXME!
				// el = mktl.elemDescFor( key );
				el = mktl.desc.elementsDesc.at( key );
				oscPath = el[\oscPath];
				outvalues = el[\argTemplate].copy; // we will modify it maybe, so make a copy
				if ( outvalues.includes( nil ) ){
					outvalues.put( outvalues.indexOf( nil ), val );
				}{
					outvalues = outvalues ++ val;
				};
			};
			destination.sendMsg( *( [ oscPath ] ++ outvalues ) );
		}
	}
}
