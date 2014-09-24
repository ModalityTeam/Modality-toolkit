/***

** Questions :

-- OLD: how to make anonymous ones? when would MKtls ever be used anonymously?

** TODO
*
*   test noteOn noteOff responders, they are not working yet!

***/

MIDIMKtl : MKtl {

	classvar <allMsgTypes = #[ \noteOn, \noteOff, \noteOnOff, \cc, \touch, \polyTouch, \bend, \program ];

	classvar <protocol = \midi;
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
			// may go away if everything lives in "elementsDict" of superclass
	var <elementHashDict;  //of type: ('c_ChannelNumber_CCNumber': MKtlElement, ...) i.e. ('c_0_21':a MKtlElement, ... )
	var <hashToElNameDict; //of type: ('c_ChannelNumber_CCNumber':'elementName') i.e. ( 'c_0_108': prB2, ... )
	var <elNameToMidiDescDict;//      ('elementName': [type, channel, midiNote or ccNum, ControlSpec], ... )
	                          //i.e.  ( 'trD1': [ cc, 0, 57, a ControlSpec(0, 127, 'linear', 1, 0, "") ], ... )

	var <responders;
	var <global;
	var <msgTypes;

	    // open all ports
	*initMIDI {|force= false|

		(initialized && {force.not}).if{^this};

		// workaround for inconsistent behaviour between linux and osx
		if ( MIDIClient.initialized and: (thisProcess.platform.name == \linux) ){
			MIDIClient.disposeClient;
			MIDIClient.init;
		};
		if ( thisProcess.platform.name == \osx and: Main.versionAtMost( 3,6 ) ){
			"next time you recompile the language, reboot the interpreter instead to get MIDI working again.".warn;
		};
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

		this.initMIDI( true );

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

	*postPossible {
		"\n// Available MIDIMKtls: ".postln;
		"// MKtl(autoName);    // make with own name and descName".postln;
		sourceDeviceDict.keysValuesDo { |key, src|
			"    MKtl('%');  // MKtl.make('nameMe', \"%\");\n".postf(
				key, this.getMIDIdeviceName(src.device)
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
			^MKtl.prMakeVirtual(name)
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

	explore {
		"Using MIDIExplorer. (see its Helpfile for Details)".postln;
		"".postln;
		"MIDIExplorer started. Wiggle all elements of your controller then".postln;
		"\tMIDIExplorer.stop;".postln;
		"\tMIDIExplorer.openDoc;".postln;
		MIDIExplorer.start(this.srcID);
	}

	initMIDIMKtl { |argName, argSource, argDestination|
		//[argName, argSource, argDestination].postln;
		name = argName;

		source = argSource;
		source.notNil.if { srcID = source.uid };

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
		var hashs;
		//"makeHashKey : %\n".postf(descr);
		if( descr[\midiMsgType].isNil ) {
			"MIDIMKtl:prepareElementHashDict (%): \\midiMsgType not found. Please add it."
			.format(this, elName).error;
			descr.postln;
		} {
			// TODO: pitchbend, other miditypes, etc.
			var noMidiChan = descr[\midiChan].isNil;
			var isTouch = descr[\midiMsgType] == \touch;
			var noMidiNum = descr[\midiNum].isNil;

			if( noMidiChan ) {
				"MIDIMKtl:prepareElementHashDict (%): \\midiChan not found. Please add it."
				.format(this, elName).error;
				descr.postln;
			};

			if( isTouch && noMidiNum ) {
				"MIDIMKtl:prepareElementHashDict (%): \\midiNum not found. Please add it."
				.format(this, elName).error;
				descr.postln;
			};

			if( noMidiChan.not || ( (isTouch && noMidiNum) ) ){
				if( allMsgTypes.includes( descr[\midiMsgType] ) ) {

					hashs = descr[\midiMsgType].switch(
						\noteOn, {[this.makeNoteOnKey(descr[\midiChan], descr[\midiNum])]},
						\noteOff, {[this.makeNoteOffKey(descr[\midiChan], descr[\midiNum])]},
						\noteOnOff, {
							[
								this.makeNoteOnKey(descr[\midiChan], descr[\midiNum]),
								this.makeNoteOffKey(descr[\midiChan], descr[\midiNum])
							]
						},
						\cc, {[this.makeCCKey(descr[\midiChan], descr[\midiNum])]},
						\touch, {[this.makeTouchKey(descr[\midiChan])] },
						\polyTouch, {[this.makePolyTouchKey(descr[\midiChan],descr[\midiNum])] },
						\bend, {[this.makeBendKey(descr[\midiChan])] },
						\program, {[this.makeProgramKey(descr[\midiChan])] }

					);

					hashs.do{ |hash|
						elementHashDict.put(
							hash, elementsDict[elName];
						)
					};
				} {
					"MIDIMKtl:prepareElementHashDict (%): identifier '%' in midiMsgType for item '%' not known. Please correct."
					.format(this, descr[\midiMsgType], elName).error;
					this.dump;
					nil;
				}
			} {
				"whoever programmed this is stupid, I shouldn't be here...".postln;
				this.dump;
			}
		};

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
							descr[\midiMsgType],
							descr[\midiChan],
							descr[\midiNum],
							elementsDict[elName].spec
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
					if ( elementsDict[elName].ioType == \in  or:  elementsDict[elName].ioType == \inout ){
						hashToElNameDict.put(hash, elName);
					};
					if ( elementsDict[elName].ioType == \out  or:  elementsDict[elName].ioType == \inout ){
						elNameToMidiDescDict.put(elName,
							[
								descr[\midiMsgType],
								descr[\midiChan],
								descr[\midiNum],
								elementsDict[elName].spec
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
		//"make % func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.cc({ |value, num, chan, src|
				var hash = this.makeCCKey(chan, num);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\control, src, chan, num, value);
				global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value, false);
					if(verbose) {
						"% - % > % | type: cc, ccValue:%, ccNum:%,  chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, num, chan, src).postln
					};
				} {
					"MIDIMKtl( % ) : cc element found for chan %, ccnum % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\cc, \\type: \\button, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiBut, \\mode: \\push).\n\n"
						.postf(name, chan, num, chan, num);
				}

			}, srcID: srcID).permanent_(true);
		);
	}

	makeNoteOn {
		var typeKey = \noteOn;
		//"make % func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.noteOn({ |vel, note, chan, src|
				// look for per-key functions
				var hash = this.makeNoteOnKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\noteOn, src, chan, note, vel);
				global[typeKey].value(chan, note, vel);

				if (el.notNil) {
					el.rawValueAction_(vel);
					if(verbose) {
						"% - % > % | type: noteOn, vel:%, midiNote:%,  chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), vel, note, chan, src).postln
					};
				}{
					"MIDIMKtl( % ) : noteOn element found for chan %, note % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\noteOn, \\type: \\pianoKey or \\button, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, note);
				}

			}, srcID: srcID).permanent_(true);
		);
	}

	makeNoteOff {
		var typeKey = \noteOff;
		//"make % func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.noteOff({ |vel, note, chan, src|
				// look for per-key functions
				var hash = this.makeNoteOffKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\noteOff, src, chan, note, vel);
				global[typeKey].value(chan, note, vel);

				if (el.notNil) {
					el.rawValueAction_(vel);
					if(verbose) {
						"% - % > % | type: noteOff, vel:%, midiNote:%,  chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), vel, note, chan, src).postln
					};
				} {
					"MIDIMKtl( % ) : noteOff element found for chan %, note % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\noteOff, \\type: \\pianoKey or \\button, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, note);
				};


			}, srcID: srcID).permanent_(true);
		);
	}

	makeTouch {
		var typeKey = \touch;
		var info = MIDIAnalysis.checkForMultiple(deviceDescription, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		"make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.touch({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeTouchKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\touch, src, chan, value);
				global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(verbose) {
						"% - % > % | type: touch, midiNum:%, chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					}
				}{
					"MIDIMKtl( % ) : touch element found for chan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\touch, \\type: \\chantouch', \\midiChan: %,"
					"\\spec: \\midiTouch).\n\n"
						.postf(name, chan, chan);
				};


			}, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}

	makePolyTouch {
		//"makePolytouch".postln;
		var typeKey = \polyTouch; //decide on polyTouch vs polytouch
		//"make % func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.polytouch({ |vel, note, chan, src|
				// look for per-key functions
				var hash = this.makePolyTouchKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\polyTouch, src, chan, note, vel);
				global[typeKey].value(chan, note, vel);

				if (el.notNil) {
					el.rawValueAction_(vel);
					if(verbose) {
						"% - % > % | type: polyTouch, vel:%, midiNote:%,  chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), vel, note, chan, src).postln
					};
				}{
					"MIDIMKtl( % ) : polyTouch element found for chan %, note % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\polyTouch, \\type: \\keytouch, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, note);
				}

			}, srcID: srcID).permanent_(true);
		);
	}

	// should work, can't test now.
	makeBend {
		var typeKey = \bend;
		var info = MIDIAnalysis.checkForMultiple(deviceDescription, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		//"make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.bend({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeBendKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\bend, src, chan, value);
				global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(verbose) {
						"% - % > % | type: bend, midiNum:%, chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					};
				}{
					"MIDIMKtl( % ) : bend element found for chan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\bend, \\type: ??', \\midiChan: %,"
					"\\spec: \\midiBend).\n\n"
					.postf(name, chan, chan);
				};


			}, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}

	makeProgram {
		var typeKey = \program;
		var info = MIDIAnalysis.checkForMultiple(deviceDescription, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		//"make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.program({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeProgramKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				midiRawAction.value(\program, src, chan, value);
				global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(verbose) {
						"% - % > % | type: program, midiNum:%, chan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					};
				}{
					"MIDIMKtl( % ) : program element found for chan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\program, \\type: ??', \\midiChan: %,"
					"\\spec: \\midiProgram).\n\n"
					.postf(name, chan, chan);
				};


			}, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}

	makeRespFuncs { |msgTypes|
		msgTypes = MIDIAnalysis.checkMsgTypes(deviceDescription);
		msgTypes = msgTypes ? allMsgTypes;
		responders = ();
		global = ();
		msgTypes.do { |msgType|
			switch(msgType,
				\cc, { this.makeCC },
				\noteOn, { this.makeNoteOn },
				\noteOff, { this.makeNoteOff },
				\noteOnOff, { this.makeNoteOn.makeNoteOff },
				\touch, { this.makeTouch },
				\polyTouch, { this.makePolyTouch },
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

		// utilities for fast lookup :
		// as class methods so we can do it without an instance
	*makeCCKey { |chan, cc| ^("c_%_%".format(chan, cc)).asSymbol }
	*ccKeyToChanCtl { |ccKey| ^ccKey.asString.drop(2).split($_).asInteger }
	*makeNoteOnKey { |chan, note| ^("non_%_%".format(chan, note)).asSymbol }
	*makeNoteOffKey { |chan, note| ^("nof_%_%".format(chan, note)).asSymbol }
	*makePolyTouchKey { |chan, note| ^("pt_%_%".format(chan, note)).asSymbol }
    *noteKeyToChanNote { |noteKey| ^noteKey.asString.drop(2).split($_).asInteger }

	*makeTouchKey { |chan| ^("t_%".format(chan)).asSymbol }
	*makeBendKey { |chan| ^("b_%".format(chan)).asSymbol }
	*makeProgramKey { |chan| ^("p_%".format(chan)).asSymbol }

	// as instance methods so we done need to ask this.class
	makeCCKey { |chan, cc| ^("c_%_%".format(chan, cc)).asSymbol }
	ccKeyToChanCtl { |ccKey| ^ccKey.asString.drop(2).split($_).asInteger }
	makeNoteOnKey { |chan, note| ^("non_%_%".format(chan, note)).asSymbol }
	makeNoteOffKey { |chan, note| ^("nof_%_%".format(chan, note)).asSymbol }
	makePolyTouchKey { |chan, note| ^("pt_%_%".format(chan, note)).asSymbol }
	noteKeyToChanNote { |noteKey| ^noteKey.asString.drop(2).split($_).asInteger }

	makeTouchKey { |chan| ^("t_%".format(chan)).asSymbol }
	makeBendKey { |chan| ^("b_%".format(chan)).asSymbol }
	makeProgramKey { |chan| ^("p_%".format(chan)).asSymbol }

}
