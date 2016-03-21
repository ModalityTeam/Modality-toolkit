
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

	*find { |post = (verbose)|
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

	*initDevices { |force=false| // force has no real meaning here
		var postables = MKtlLookup.allFor(\osc);
		if (force or: initialized.not) {
			initialized = true;
			if (verbose and: { postables.size == 0 }) {
				"\n\n// OSCMKtlDevice: No known sending addresses so far.\n"
				"// To detect OSC devices by hand, use OSCMon: ".postln;
				"o = OSCMon.new.enable.show;".postln;
				^this
			};
		};
	}

	enable { oscFuncDictionary.do(_.enable); }
	disable { oscFuncDictionary.do(_.disable); }

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

	*new { |name, devInfo, parentMKtl, multiIndex|

		devInfo = devInfo ?? { parentMKtl.desc; };
		if (devInfo.isNil) {
			inform("OSCMKtlDevice.new: cannot make new one without info or parent.");
			^nil
		};

		^super.basicNew( name, name, parentMKtl );
	}

	init { |desc|
		desc = desc ?? { mktl.desc };
		this.initOSCMKtl( desc.fullDesc[\netAddrInfo] ).initElements;
	}

	initOSCMKtl { |info|
		var ipAddr =  info !? { info.at( \ipAddress ) } ? "127.0.0.1";
		var srcPort = info !? { info.at( \srcPort ) };
		var dstPort = info !? { info.at( \destPort ) } ? srcPort ? NetAddr.langPort;

		source = NetAddr.new( ipAddr, srcPort );
		destination = NetAddr( ipAddr, dstPort);
		recvPort = srcPort;

		this.initCollectives;

		// must do by hand for OSC
		this.addToLookup;
	}

	addToLookup {
		MKtlLookup.all.select { |info| info.mktl == this.mktl }
		.keysDo { |key| MKtlLookup.all.removeAt(key) };
		MKtlLookup.addOSC(source, mktl.desc.idInfo, destination, this.mktl);
	}

	// source is used in all OSCFuncs, so sticking in new ip/port
	// values will redirect OSCfuncs to the new address data
	updateSrcAddr { |hostname, port|
		if (hostname.notNil) { source.hostname = hostname };
		if (port.notNil) { source.port = port };
		recvPort = port;
		oscFuncDictionary.do(_.free);
		this.initCollectives;
		this.addToLookup;
	}

	updateDestAddr { |hostname, port|
		if (hostname.notNil) { destination.hostname = hostname };
		if (port.notNil) { destination.port = port };
		this.addToLookup;
	}

	closeDevice {
		var itemsToRemove;
		this.cleanupElementsAndCollectives;
		source = nil;
		destination = nil;
		recvPort = nil;
		itemsToRemove = MKtlLookup.all.select { |info|
			info.mktl == this.mktl };
		itemsToRemove.keysValuesDo { |key|
			MKtlLookup.all.removeAt(key);
		};
	}

	postTrace { |el|
		"% osc % > % | type: %".format(mktl, el.name,
			el.value.round(0.001), el.type).postln;
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
							if(traceRunning) { this.postTrace(el) };
						}, oscPath, source, recvPort, argTemplate, dispatcher )
						.permanent_( true );
					);
				}{
					dispatcher = this.class.messageSizeDispatcher;
					if ( el.type == \trigger ){
						// trigger osc func
						oscFuncDictionary.put( el.name,
							OSCFunc.new( { |msg|
								// send a default value of 1
								el.deviceValueAction_( 1 );
								if(traceRunning) { this.postTrace(el) };
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
								if(traceRunning) { this.postTrace(el) };
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
		mktl.collectivesDict.do { |coll|
			var collDesc = coll.elemDesc;
			var oscPath = collDesc[ \oscPath ];
			var ioType = collDesc[ \ioType ];
			var argTemplate = collDesc[ \argTemplate ];
			var valueIndices = collDesc[ \valueAt ];
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
				if ( oscFuncDictionary.at( coll.name ).notNil ){
					oscFuncDictionary.at( coll.name ).free };

				oscFuncDictionary.put( coll.name,
					OSCFunc.new( { |msg|
						// "clever" msg index parsing
						var valueMsg;
						if ( msgIndices.notNil ){
							valueMsg = msg.at( msgIndices).asArray
								++ msg.copyToEnd( templEnd );
						}{
							 valueMsg = msg.copyToEnd( templEnd );
						};

						coll.deviceValueAction_( valueMsg );
						if(traceRunning) { this.postTrace(coll) };

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
		var elDesc, oscPath, outvalues,valIndex;

			// dont send if no destination
		if ( destination.isNil ) {
			^this;
		};

			// prepare outmessage value for a collective - array of values to send
		if ( val.isKindOf( Array ) ){
			elDesc = mktl.collectiveDescriptionFor( key );
			valIndex = 0;
			if (elDesc.isNil) {
				"%: no collective for % found.\n".postf(key, thisMethod);
				^this
			};

			oscPath = elDesc[\oscPath];
			outvalues = List.new;
			elDesc[\argTemplate].do { |it|
				if ( it.isNil ) {
					outvalues.add( val.at( valIndex ) ); valIndex = valIndex + 1;
				}{
					outvalues.add( it )
				};
			};
			if ( valIndex < val.size ) {
				outvalues = outvalues ++ (val.copyToEnd( valIndex ) ) };
			outvalues = outvalues.asArray;
		} {
			// prepare outmessage for value of a single element:
			elDesc = mktl.dictAt( key ).elemDesc;
			oscPath = elDesc[\oscPath];
			// we may modify it, so copy
			outvalues = elDesc[\argTemplate].copy;
			if ( outvalues.notNil and: { outvalues.includes( nil ) } ){
				outvalues.put( outvalues.indexOf( nil ), val );
			}{
				outvalues = outvalues ++ val;
			};
		};
		// and send
		destination.sendMsg(oscPath, *outvalues);
	}

	sendSpecialMessage { |messages|
		if (destination.notNil) {
			messages.do { |msg| destination.sendMsg(msg.postln) }
		};
	}
}
