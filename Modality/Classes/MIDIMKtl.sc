///////// how to make anonymous ones? when would they be used anonymously? /////

// TODO
//   addFunc should conform to super.addFunc.
//	convert all responders to midifuncs
//	test noteOn  off responders, they are not working yet!


MIDIMKtl : MKtl {
	classvar <initialized = false;
	classvar <sourceDeviceDict;         //      ('deviceName': MIDIEndPoint, ... )
	                                    //i.e.  ( 'bcr0': MIDIEndPoint("BCR2000", "Port 1"), ... )
	classvar <destinationDeviceDict;    //      ('deviceName': MIDIEndPoint, ... )
	                                    //i.e.  ( 'bcr0': MIDIEndPoint("BCR2000", "Port 2"), ... )

	// MIDI-specific address identifiers
	var <srcID /*Int*/, <source /*MIDIEndPoint*/;
	var <dstID /*Int*/, <destination /*MIDIEndPoint*/, <midiOut /*MIDIOut*/;

	// an action that is called every time a midi message comes in
	// .value(type, src, chan, num/note, value/vel)
	var <>midiRawAction;


			// optimisation for fast lookup,
			// may go away if everything lives in "elements" of superclass
	var <elementHashDict;  //of type: ('c_ChannelNumber_CCNumber': MKtlElement, ...) i.e. ('c_0_21':a MKtlElement, ... )
	var <hashToElNameDict; //of type: ('c_ChannelNumber_CCNumber':'elementName') i.e. ( 'c_0_108': prB2, ... )
	var <elNameToMidiDescDict;//      ('elementName': [type, channel, midiNote or ccNum, ControlSpec], ... )
	                          //i.e.  ( 'trD1': [ cc, 0, 57, a ControlSpec(0, 127, 'linear', 1, 0, "") ], ... )

	var <responders;

	var <exploreResponders;

	    // open all ports
	*initMIDI {|force= false|

		(initialized && {force.not}).if{^this};

		MIDIIn.connectAll;
		sourceDeviceDict = ();
		destinationDeviceDict = ();

		this.prepareDeviceDicts;

		initialized = true;
	}

		// display all ports in readable fashion,
		// copy/paste-able directly
		// this could also live in /--where?--/
	*find { |post=true|

			// was true, make it false for now while MIDI re-init is broken
		this.initMIDI(false);

		if (MIDIClient.sources.isEmpty) {
			"// MIDIMKtl did not find any sources - you may want to connect some first.".inform;
			^this
		};

		/*
			"\nMIDI sources found by MIDIMKtl.find:".postln;
		"key	uid (USB port ID)	device	name".postln;
		sourceDeviceDict.keysValuesDo({ |key, src|
			"%\t[%]\t\t[%]\t[%]\n".postf(
				key,
				src.uid,
				src.device.asSymbol.asCompileString,
				src.name.asSymbol.asCompileString
			);
		});
		"\nMIDI destinations found by MIDIMKtl.find:".postln;
		"key	uid (USB port ID)	device	name".postln;
		destinationDeviceDict.keysValuesDo({ |key, src|
			"%\t[%]\t\t[%]\t[%]\n".postf(
				key,
				src.uid,
				src.device.asSymbol.asCompileString,
				src.name.asSymbol.asCompileString
			);
		});
			*/
		if ( post ){
			this.postPossible;
		};
		// TODO: what happens to MIDI devs that are only destinations?
	}

	*postPossible{
		"\n// Available MIDIMKtls - you may want to change the names: ".postln;
		sourceDeviceDict.keysValuesDo { |key, src|
			"   MIDIMKtl('%', %, %);  // %\n".postf(
				key,
				src.uid,
				destinationDeviceDict[key].notNil.if({destinationDeviceDict[key].uid},{nil}),
				this.getMIDIdeviceName(src.device)
			);
		};
		"\n-----------------------------------------------------".postln;
	}

	*findSource { |rawDeviceName|
		var devKey;
		this.sourceDeviceDict.keysValuesDo{ |key,endpoint|
			if ( endpoint.name == rawDeviceName ){
				devKey = key;
			};
		};
		^devKey;
	}

	// how to deal with additional arguments (uids...)?
	*newFromDesc{ |name,deviceDescName,devDesc|
		//		var devDesc = this.getDeviceDescription( deviceDesc )
		var devKey = this.findSource( devDesc[ thisProcess.platform.name ] );
		this.sourceDeviceDict.swapKeys( name, devKey );
		^this.new( name, devDescName: deviceDescName );
	}

		// create with a uid, or access by name
	*new { |name, uid, destID, devDescName|
		var foundSource, foundDestination;
		var foundKtl = all[name.asSymbol];

			// access by name
		if (foundKtl.notNil) {
			if (uid.isNil) {
				^foundKtl
			} {
				if (uid == foundKtl.srcID) {
					^foundKtl
				} {
					warn("MIDIMKtl: name % is in use for a different USB port ID!"
					++ 	"	Please pick a different name.".format(name)
					++ 	"	Taken names:" + all.keys.asArray.sort ++ ".\n");
					^nil
				}
			}
		};


		this.initMIDI;
			// make a new source
		foundSource = uid.notNil.if({
			MIDIClient.sources.detect { |src|
				src.uid == uid;
			};
		}, {
			sourceDeviceDict[name.asSymbol];
		});

		if (foundSource.isNil) {
			warn("MIDIMKtl:"
			"	No MIDIIn source with USB port ID % exists! please check again.".format(uid));
			^nil
		};

		// make a new destination
		foundDestination = destID.notNil.if({
			MIDIClient.destinations.detect { |src|
				src.uid == destID;
			};
		}, {
			destinationDeviceDict[name.asSymbol];
		});


		sourceDeviceDict.changeKeyForValue(name, foundSource);
		foundDestination.notNil.if{
			destinationDeviceDict.changeKeyForValue(name, foundDestination);
		};

		[ devDescName, foundSource.device].postln;
		//		^super.basicNew(name, foundSource.device)
		^super.basicNew(name, devDescName ? this.getMIDIdeviceName( foundSource.device ) )
			.initMIDIMKtl(name, foundSource, foundDestination );
	}

	// convenience method to get the right name on linux.
	*getMIDIdeviceName{ |fullDeviceName|
		if ( thisProcess.platform.name == \linux ){
			^fullDeviceName.split( $- ).first;
		}{
			^fullDeviceName;
		};
	}

	*prepareDeviceDicts {
		var prevName = nil, j = 0, order, deviceNames;
		var tempName;

		deviceNames = MIDIClient.sources.collect {|src|
			tempName = this.getMIDIdeviceName( src.device );
			this.makeShortName(tempName);
		};

		if (deviceNames.isEmpty) {
			^this
		};

		order = deviceNames.order;
		deviceNames[order].do {|name, i|
			(prevName == name).if({
				j = j+1;
			},{
				j = 0;
			});
			prevName = name;

			sourceDeviceDict.put((name ++ j).asSymbol, MIDIClient.sources[order[i]])
		};

		// prepare destinationDeviceDict
		j = 0; prevName = nil;
		deviceNames = MIDIClient.destinations.collect{|src|
			tempName = this.getMIDIdeviceName( src.device );
			this.makeShortName(tempName);
		};
		order = deviceNames.order;

		deviceNames[order].do{|name, i|
			(prevName == name).if({
				j = j+1;
			},{
				j = 0;
			});
			prevName = name;

			destinationDeviceDict.put((name ++ j).asSymbol, MIDIClient.destinations[order[i]])
		};

		// put the available midi devices in MKtl's available devices
		allAvailable.put( \midi, List.new );
		sourceDeviceDict.keysDo({ |key|
			allAvailable[\midi].add( key );
		});
	}

	explore{ |mode=true|
		if ( mode ){
			if ( exploreResponders.isNil ){
				exploreResponders = (
					cc: CCResponder({ |src, chan, num, value|
						[ this.name, \control, src, chan, num, value ].postln;
					}, srcID),

					noteon: NoteOnResponder({ |src, chan, note, vel|
						[ this.name, \noteOn, src, chan, note, vel ].postln;
					}, srcID),

					noteoff: NoteOffResponder({ |src, chan, note, vel|
						[ this.name, \noteOff, src, chan, note, vel ].postln;
					}, srcID)
				);
			}{
				exploreResponders.do{ |it| it.add };
			};
		}{
			if ( exploreResponders.notNil ){
				exploreResponders.do{ |it| it.remove };
			};
		};
		exploring = mode;
	}

	initMIDIMKtl { |argName, argSource, argDestination|
		[argName, argSource, argDestination].postln;
		name = argName;

		source = argSource;
		srcID = source.uid;

		// destination is optional
		destination = argDestination;
		destination.notNil.if{
			dstID = destination.uid;
			midiOut = MIDIOut( MIDIClient.destinations.indexOf(destination), dstID );
			if ( thisProcess.platform.name == \linux ){
				midiOut.connect( MIDIClient.destinations.indexOf(destination) )
			};
		};


		all.put(name, this);


		// moved to superclass init
		//	this.loadDeviceDescription(devDescName);

		//this.findDeviceDescription(source.device);

		elementHashDict = ();
		hashToElNameDict = ();
		elNameToMidiDescDict = ();

		//	this.makeElements;
		if ( deviceDescription.notNil ){
			this.prepareElementHashDict;
			this.addResponders;
		}
	}

	makeHashKey{ |descr,elName|
		var hash;
		// TODO: pitchbend, other miditypes, etc.
		hash = descr[\midiType].switch(
			\note, {this.makeNoteKey(descr[\chan], descr[\midiNote]);},

			\cc, {this.makeCCKey(descr[\chan], descr[\ccNum]);},
			{//default:
				"MIDIMKtl:prepareElementHashDict (%): identifier in midiType for item % not known. Please correct.".format(this, elName).error;
				this.dump;
				nil;
			}
		);
		elementHashDict.put(
			hash, elements[elName];
		);
	}
		// plumbing
	prepareElementHashDict {
		if (deviceDescription.notNil) {
			deviceDescription.pairsDo { |elName, descr|
				var hash;

				if ( descr[\out].notNil ){
					// element has a specific description for the output of the element
					descr = MKtl.flattenDescriptionForIO( descr, \out );
					hash = this.makeHashKey( descr, elName );
					elNameToMidiDescDict.put(elName,
						[
							descr[\midiType], descr[\chan],
							descr[\midiType].switch(\note,{descr[\midiNote]},\cc,{descr[\ccNum]}),
							elements[elName].spec
						])
				};
				if ( descr[\in].notNil ){
					// element has a specific description for the input of the element
					descr = MKtl.flattenDescriptionForIO( descr, \in );
					hash = this.makeHashKey( descr, elName );
					hashToElNameDict.put(hash, elName);
				};
				if ( descr[\in].isNil and: descr[\out].isNil ){
					hash = this.makeHashKey( descr, elName );
					if ( elements[elName].ioType == \in  or:  elements[elName].ioType == \inout ){
						hashToElNameDict.put(hash, elName);
					};
					if ( elements[elName].ioType == \out  or:  elements[elName].ioType == \inout ){
						elNameToMidiDescDict.put(elName,
							[
								descr[\midiType], descr[\chan],
								descr[\midiType].switch(\note,{descr[\midiNote]},\cc,{descr[\ccNum]}),
								elements[elName].spec
							])
					};

				};
			}
		}
	}

//	findDeviceDescription { |devicename|
//		var path = deviceDescriptionFolder +/+ devicename ++ ".scd";
//		deviceDescription = try {
//			path.load
//		} {
//			"MIDIMKtl - no deviceSpecs found for %: please make them!\n".postf(devicename);
//			this.class.openTester(this);
//		};
//	}

	addResponders {
		responders = (
			cc: CCResponder({ |src, chan, num, value|
				var hash = this.makeCCKey(chan, num);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\control, src, chan, num, value);
				if (el.isNil) {
					"MIDIMKtl( % ) : cc element found for chan %, ccnum % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiType: \\cc, \\type: \\button, \\chan: %, \\ccNum: %, \\spec: \\midiBut, \\mode: \\push).\n\n"
						.postf(name, chan, num, chan, num);
				} {
					try { el.rawValueAction_(value, false); } {
						"MIDIMKtl( % ) : cc message for chan %, ccnum % failed.\n\n".postf(name, chan, num);
					};
				};
			}, srcID),

			noteon: NoteOnResponder({ |src, chan, note, vel|
				var hash = this.makeNoteKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];
				var global = this[\noteOn];
				//	["noteOn", chan, note, vel, hash].postln;

				midiRawAction.value(\noteOn, src, chan, note, vel);

				// try the global noteOn function first
				if( global.notNil) {
					global.rawValueAction_(note, vel);
				};

				// then try an individual key func as well
				if (el.isNil) {
					"MIDIMKtl( % ) : noteon element found for chan %, ccnum % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiType: \\note, \\type: \\button, \\chan: %, \\midiNote: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, vel);
				} {
					el.rawValueAction_(vel)
				}
			}, srcID),

			noteoff: NoteOffResponder({ |src, chan, note, vel|
				var hash = this.makeNoteKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];
				var global = this[\noteOff];

				//	["noteOff", chan, note, vel, hash].postln;

				midiRawAction.value(\noteOff, src, chan, note, vel);

				// try the global noteOn function first
				if( global.notNil) {
					global.rawValueAction_(note, vel);
				};

				// then try an individual key func as well
				if (el.isNil) {
					"MIDIMKtl( % ) : noteon element found for chan %, ccnum % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiType: \\note, \\type: \\button, \\chan: %, \\midiNote: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, vel);
				}{
					el.rawValueAction_(vel)
				};
			}, srcID)
		);
	}

	send{ |key,val|
	 	elNameToMidiDescDict !? _.at(key) !? { |x|
			var type, ch, num, spec;
			#type, ch, num, spec = x;
	 		switch(type)
	 			{\cc}{ midiOut.control(ch, num, val ) }
	 			{\note}{ /*TODO: check type for noteOn, noteOff, etc*/ }
	 	}
	}

	verbose_ {|value=true|
		value.if({
			elementHashDict.do{|item| item.addFunc(\verbose, { |element|
					[element.source, element.name, element.value].postln;
			})}
		}, {
			elementHashDict.do{|item| item.removeFunc(\verbose)}
		})
	}

		// utilities for fast lookup :
		// as class methods so we can do it without an instance
	*makeCCKey { |chan, cc| ^("c_%_%".format(chan, cc)).asSymbol }
	*ccKeyToChanCtl { |ccKey| ^ccKey.asString.drop(2).split($_).asInteger }
	*makeNoteKey { |chan, note| ^("n_%_%".format(chan, note)).asSymbol }
	*noteKeyToChanNote { |noteKey| ^noteKey.asString.drop(2).split($_).asInteger }

		// as instance methods so we done need to ask this.class
	makeCCKey { |chan, cc| ^("c_%_%".format(chan, cc)).asSymbol }
	ccKeyToChanCtl { |ccKey| ^ccKey.asString.drop(2).split($_).asInteger }
	makeNoteKey { |chan, note| ^("n_%_%".format(chan, note)).asSymbol }
	noteKeyToChanNote { |noteKey| ^noteKey.asString.drop(2).split($_).asInteger }

	storeArgs { ^[name] }
	printOn { |stream| ^this.storeOn(stream) }
}
