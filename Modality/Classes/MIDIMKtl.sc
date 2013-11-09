///////// how to make anonymous ones? when would they be used anonymously? /////

// TODO
//   addFunc should conform to super.addFunc.
//	convert all responders to midifuncs
//	test noteOn  off responders, they are not working yet!


MIDIMKtl : MKtl {

	classvar <allMsgTypes = #[ \noteOn, \noteOff, \cc, \touch, \polytouch, \bend, \program ];

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

	var <exploreFuncs;

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

	explore { |flag=true|
		"Using MIDIExplorer - see \n MIDIExplorer.openHelpFile;".postln;
		MIDIExplorer.start(this.srcID);
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

		elementHashDict = ();
		hashToElNameDict = ();
		elNameToMidiDescDict = ();

		if ( deviceDescription.notNil ){
			this.prepareElementHashDict;
			this.makeRespFuncs;
		}
	}

	makeHashKey{ |descr,elName|
		var hash;
		// TODO: pitchbend, other miditypes, etc.
		hash = descr[\midiType].switch(
			\noteOn, {this.makeNoteOnKey(descr[\chan], descr[\midiNote]);},
			\noteOff, {this.makeNoteOffKey(descr[\chan], descr[\midiNote]);},

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
		// modularize - only make the ones that are needed?
		// make them only once, methods to activate/deactivate them
		//

	makeCC {
		var typeKey = \cc;
		"make %func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.cc({ |value, num, chan, src|
				var hash = this.makeCCKey(chan, num);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\control, src, chan, num, value);

				if(verbose) {
				 	[MIDIMKtl, \control, value, num, chan, src].postln;
				};
				if (el.notNil) {
					el.rawValueAction_(value, false);
				} {
					"MIDIMKtl( % ) : cc element found for chan %, ccnum % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiType: \\cc, \\type: \\button, \\chan: %,"
					"\\ccNum: %, \\spec: \\midiBut, \\mode: \\push).\n\n"
						.postf(name, chan, num, chan, num);				};
			}, srcID: srcID)
		);
	}

	makeNoteOn {
		var typeKey = \noteOn;
		"make %func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.noteOn({ |vel, note, chan, src|
				// look for per-key functions
				var hash = this.makeNoteOnKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\noteOn, src, chan, note, vel);

				if(verbose) {
				 	[MIDIMKtl, \noteOn, vel, note, chan, src].postln;
				};

				"global note action here? how?".postln;

				if (el.notNil) {
					"per-note element found.".postln;
					el.rawValueAction_(vel);

				};
			}, srcID: srcID)
		);
	}

	makeNoteOff {
		var typeKey = \noteOff;
		"make %func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.noteOff({ |vel, note, chan, src|
				// look for per-key functions
				var hash = this.makeNoteOffKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\noteOn, src, chan, note, vel);

				if(verbose) {
				 	[MIDIMKtl, \noteOff, vel, note, chan, src].postln;
				};

				"global note action here? how?".postln;

				if (el.notNil) {
					"per-note element found.".postln;
					el.rawValueAction_(vel);

				};
			}, srcID: srcID)
		);
	}

	makeTouch {
		var typeKey = \touch;
		"make %func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.touch({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeTouchKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\touch, src, chan, value);

				if(verbose) {
				 	[MIDIMKtl, \touch, value, chan, src].postln;
				};

				if (el.notNil) {
					"per-note element found.".postln;
					el.rawValueAction_(value);

				};
			}, srcID: srcID)
		);
	}

	makePolytouch {
		"makePolytouch".postln;

	}

	makeBend {
		"makeBend".postln;
	}

	makeProgram {
		"makeProgram".postln;
	}

	makeRespFuncs { |msgTypes|
		msgTypes = msgTypes ? allMsgTypes;
		responders = ();
		msgTypes.postcs.do { |msgType|
			switch(msgType,
				\cc, { this.makeCC },
				\noteOn, { this.makeNoteOn },
				\noteOff, { this.makeNoteOff },
				\noteOnOff, { this.makeNoteOn.makeNoteOff },
				\touch, { this.makeTouch },
				\polytouch, { this.makePolytouch },
				\bend, { this.makeBend },
				\program, { this.makeProgram }
			);
		};
	}

	send { |key,val|
	 	elNameToMidiDescDict !? _.at(key) !? { |x|
			var type, ch, num, spec;
			#type, ch, num, spec = x;
	 		switch(type)
	 			{\cc}{ midiOut.control(ch, num, val ) }
	 			{\note}{ /*TODO: check type for noteOn, noteOff, etc*/ }
	 	}
	}

		// not working like this anymore (relied onFuncChain)
		// replace with a special verbose action
	verbose_ {|value=true|

//		value.if({
//			elementHashDict.do{|item| item.addFunc(\verbose, { |element|
//					[element.source, element.name, element.value].postln;
//			})}
//		}, {
//			elementHashDict.do{|item| item.removeFunc(\verbose)}
//		})
	}

		// utilities for fast lookup :
		// as class methods so we can do it without an instance
	*makeCCKey { |chan, cc| ^("c_%_%".format(chan, cc)).asSymbol }
	*ccKeyToChanCtl { |ccKey| ^ccKey.asString.drop(2).split($_).asInteger }
	*makeNoteOnKey { |chan, note| ^("non_%_%".format(chan, note)).asSymbol }
	*makeNoteOffKey { |chan, note| ^("nof_%_%".format(chan, note)).asSymbol }
	*makePolytouchKey { |chan, note| ^("pt_%_%".format(chan, note)).asSymbol }
    *noteKeyToChanNote { |noteKey| ^noteKey.asString.drop(2).split($_).asInteger }

	*makeTouchKey { |chan| ^("t_%".format(chan)).asSymbol }
	*makeBendKey { |chan| ^("b_%".format(chan)).asSymbol }
	*makeProgramKey { |chan| ^("p_%".format(chan)).asSymbol }

	// as instance methods so we done need to ask this.class
	makeCCKey { |chan, cc| ^("c_%_%".format(chan, cc)).asSymbol }
	ccKeyToChanCtl { |ccKey| ^ccKey.asString.drop(2).split($_).asInteger }
	makeNoteOnKey { |chan, note| ^("non_%_%".format(chan, note)).asSymbol }
	makeNoteOffKey { |chan, note| ^("nof_%_%".format(chan, note)).asSymbol }
	makePolytouchKey { |chan, note| ^("pt_%_%".format(chan, note)).asSymbol }
	noteKeyToChanNote { |noteKey| ^noteKey.asString.drop(2).split($_).asInteger }

	makeTouchKey { |chan| ^("t_%".format(chan)).asSymbol }
	makeBendKey { |chan| ^("b_%".format(chan)).asSymbol }
	makeProgramKey { |chan| ^("p_%".format(chan)).asSymbol }

	storeArgs { ^[name] }
	printOn { |stream| ^this.storeOn(stream) }
}