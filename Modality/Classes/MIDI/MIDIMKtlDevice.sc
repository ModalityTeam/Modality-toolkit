MIDIMKtlDevice : MKtlDevice {

	classvar <allMsgTypes = #[ \noteOn, \noteOff, \noteOnOff, \cc, \touch, \polyTouch, \bend, \program ]; // \allNotesOff is not implemented in SC's MIDIIn yet

	// \midiClock, \start, \stop, \continue, \reset are sysrt messages - should maybe just be that?

	// classvar <allMsgTypes = #[ \noteOn, \noteOff, \noteOnOff, \cc, \touch, \polyTouch, \bend, \program, \midiClock, \start, \stop, \continue, \reset ]; // still missing \allNotesOff

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
	// var <>midiRawAction; // this can be done with MIDIFunc.new( { arg ...args; args.postln }, srcID: m.mktlDevice.srcID );


	// optimisation for fast lookup,
	// may go away if everything lives in "elementsDict" of superclass
	var <elementHashDict;  //of type: ('c_ChannelNumber_CCNumber': MKtlElement, ...) i.e. ('c_0_21':a MKtlElement, ... )
	var <hashToElNameDict; //of type: ('c_ChannelNumber_CCNumber':'elementName') i.e. ( 'c_0_108': prB2, ... )
	var <elNameToMidiDescDict;//      ('elementName': [type, channel, midiNote or ccNum, ControlSpec], ... )
	                          //i.e.  ( 'trD1': [ cc, 0, 57, a ControlSpec(0, 127, 'linear', 1, 0, "") ], ... )

	var <responders;
	// var <global; // this functionality can be gotten with: MIDIFunc.new( { arg ...args; args.postln }, msgType: xxx, srcID: m.mktlDevice.srcID );
	var <msgTypes;

	closeDevice{
		destination.notNil.if{
			if ( thisProcess.platform.name == \linux ){
				midiOut.disconnect( MIDIClient.destinations.indexOf(destination) )
			};
			midiOut = nil;
		};
		source = nil;
		destination = nil;
	}

	// open all ports
	*initDevices {|force= false|

		if ( initialized && {force.not} ){ ^this; };

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
		this.initDevices( true );

		if ( MIDIClient.sources.isEmpty and: MIDIClient.destinations.isEmpty ) {
			"// MIDIMKtl did not find any sources or destinations - you may want to connect some first.".inform;
			^this
		};

		if ( post ){
			this.postPossible;
		};
	}

	*postPossible {
		"\n-----------------------------------------------------".postln;
		"\n// Available MIDIMKtls: ".postln;
		"// MKtl(autoName);  // [ midi device, midi port ]".postln;
		sourceDeviceDict.keysValuesDo { |key, src|
			"    MKtl('%');  // [ %, % ] \n".postf(
				key, src.device.asCompileString, src.name.asCompileString
			);
		};
		"\n-----------------------------------------------------".postln;
	}

	*getSourceName{ |shortName|
		var srcName;
		var src = this.sourceDeviceDict.at( shortName );
		if ( src.notNil ){
			srcName = src.device;
		}{
			src = this.destinationDeviceDict.at( shortName );
			if ( src.notNil ){
				srcName = src.device;
			};
		};
		^srcName;
	}

	*findSource { |rawDeviceName, rawPortName| // or destination
		var devKey;
		if ( initialized.not ){ ^nil };
		this.sourceDeviceDict.keysValuesDo{ |key,endpoint|
			if ( endpoint.device == rawDeviceName ){
				if ( rawPortName.isNil ){
					devKey = key;
				}{
					if ( endpoint.name == rawPortName ){
						devKey = key;
					}
				}
			};
		};
		if ( devKey.isNil ){
			this.destinationDeviceDict.keysValuesDo{ |key,endpoint|
				if ( endpoint.device == rawDeviceName ){
					if ( rawPortName.isNil ){
						devKey = key;
					}{
						if ( endpoint.name == rawPortName ){
							devKey = key;
						}
					}
				};
			};
		};
		^devKey;
	}

	*findInDictByNameAndIndex{ |dict, name, index|
		var found = List.new;
		var foundItem;
		index = index ? 0;
		[dict,name,index].postln;
		dict.keysValuesDo{ |key,endpoint|
			if ( endpoint.device == name ){ found.add( endpoint ) };
		};
		foundItem = found.sort( { |a,b| a.name < b.name } ).at( index );
		// returns the MIDI endpoint;
		foundItem.postln;
		^foundItem;
	}

	// create with a uid, or access by name
	// *new { |name, srcUID, destUID, parentMKtl|
	*new { |name, idInfo, parentMKtl|
		var foundSource, foundDestination;
		var deviceName;

		this.initDevices;

		[ name, idInfo, parentMKtl, initialized ].postln;

		if ( idInfo.notNil ){ // use idInfo to open:
			if ( initialized.not ){ ^nil };
			idInfo.isKindOf( String ).postln;
			if ( idInfo.isKindOf( String ) ){
				foundSource = this.findInDictByNameAndIndex( sourceDeviceDict, idInfo );
				foundDestination = this.findInDictByNameAndIndex( destinationDeviceDict, idInfo );
			};
			idInfo.isKindOf( Dictionary ).postln;
			if ( idInfo.isKindOf( Dictionary ) ){
				"looking for source".postln;
				foundSource = this.findInDictByNameAndIndex( sourceDeviceDict, idInfo[\name], idInfo[\sourcePortIndex] );
				foundDestination = this.findInDictByNameAndIndex( destinationDeviceDict, idInfo[\name], idInfo[\destinationPortIndex] );
			};
		}{ // use name to open
			foundSource = sourceDeviceDict[name.asSymbol];
			foundDestination = destinationDeviceDict[name.asSymbol];
		};

		if ( foundSource.isNil and: foundDestination.isNil ){
			warn("MIDIMKtl:"
				"	No MIDIIn source nor destination with idInfo % exists! please check again.".format(idInfo));
			^nil;
		};

		if (foundDestination.isNil) {
			warn("MIDIMKtlDevice:"
				"	No MIDIOut destination with idInfo % exists! please check again.".format(idInfo));
		}{
			destinationDeviceDict.changeKeyForValue(name, foundDestination);
			deviceName = foundDestination.device;
		};

		if (foundSource.isNil) {
			warn("MIDIMKtlDevice:"
				"	No MIDIIn source with idInfo % exists! please check again.".format(idInfo));
		}{
			sourceDeviceDict.changeKeyForValue(name, foundSource);
			deviceName = foundSource.device;
		};

		^super.basicNew(name, deviceName, parentMKtl )
			.initMIDIMKtl(name, foundSource, foundDestination );
	}

	*prepareDeviceDicts {
		var prevName = nil, j = 0, order, deviceNames;
		var tempName;

		deviceNames = MIDIClient.sources.collect {|src|
			tempName = src.device;
			MKtl.makeShortName(tempName);
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
			tempName = src.device;
			MKtl.makeShortName(tempName);
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

	/// ----(((((----- EXPLORING ---------

	exploring{
		^(MIDIExplorer.observedSrcID == srcID );
	}

	explore { |mode=true|
		if ( mode ){
			"Using MIDIExplorer. (see its Helpfile for Details)".postln;
			"".postln;
			"MIDIExplorer started. Wiggle all elements of your controller then".postln;
			"\tMKtl(%).explore(false);\n".postf( name );
			"\tMKtl(%).createDescriptionFile;\n".postf( name );
			MIDIExplorer.start(this.srcID);
		}{
			MIDIExplorer.stop;
			"MIDIExplorer stopped.".postln;
		}
	}

	createDescriptionFile{
		MIDIExplorer.openDoc;
	}

	/// --------- EXPLORING -----)))))---------

	initElements{
		elementHashDict = ();
		hashToElNameDict = ();
		elNameToMidiDescDict = ();

		if ( mktl.deviceDescriptionArray.notNil ){
			this.prepareElementHashDict;
			this.makeRespFuncs;
		}
	}

	// nothing here yet, but needed
	initCollectives{
	}

	initMIDIMKtl { |argName, argSource, argDestination|
		// [argName, argSource, argDestination].postln;
		name = argName;

		source = argSource;
		source.notNil.if { srcID = source.uid };

		// destination is optional
		destination = argDestination;
		destination.notNil.if{
			dstID = destination.uid;
			if ( thisProcess.platform.name == \linux ){
				midiOut = MIDIOut( 0 );
				midiOut.connect( MIDIClient.destinations.indexOf(destination) )
			}{
				midiOut = MIDIOut( MIDIClient.destinations.indexOf(destination), dstID );
			};

			// set latency to zero as we assume to have controllers
			// rather than synths connected to the device.
			midiOut.latency = 0;

		};

		this.initElements;
		this.initCollectives;
		this.sendInitialisationMessages;
	}

	makeHashKey{ |descr,elName|
		var hashs;
		//"makeHashKey : %\n".postf(descr);
		if( descr[\midiMsgType].isNil ) {
			"MIDIMKtlDevice:prepareElementHashDict (%): \\midiMsgType not found. Please add it."
			.format(this, elName).error;
			descr.postln;
		} {
			var noMidiChan = descr[\midiChan].isNil;
			// var isTouch = descr[\midiMsgType] == \touch;
			var noMidiNum = descr[\midiNum].isNil;

			if( noMidiChan ) {
				"MIDIMKtlDevice:prepareElementHashDict (%): \\midiChan not found. Please add it."
				.format(this, elName).error;
				descr.postln;
			};

			/*
			if( isTouch && noMidiNum ) { // Q: touch has no midiNum by default, why enforce it?
				"MIDIMKtlDevice:prepareElementHashDict (%): \\midiNum not found. Please add it."
				.format(this, elName).error;
				descr.postln;
			};
			*/

			/*
			// these are sysrt messages in fact
			if ( [ \midiClock, \start, \stop, \continue, \reset ].includes( descr[ \midiMsgType ] ) ){
				elementHashDict.put(
					descr[ \midiMsgType ], mktl.elementsDict[elName];
				)
			}{
				*/
				// if( noMidiChan.not || ( (isTouch && noMidiNum) ) ){
				if( noMidiChan.not ){
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
						// \allNotesOff, {[this.makeAllNotesOffKey(descr[\midiChan])] }
						);

						hashs.do{ |hash|
							elementHashDict.put(
								hash, mktl.elementsDict[elName];
							)
						};
					} {

						"MIDIMKtlDevice:prepareElementHashDict (%): identifier '%' in midiMsgType for item '%' not known. Please correct."
						.format(this, descr[\midiMsgType], elName).error;
						this.dump;
						nil;
					}
				} {
					"whoever programmed this is stupid, I shouldn't be here...".postln;
					this.dump;
				}
		// }
		};
	}

	// plumbing
	prepareElementHashDict {
		var elementsDict = mktl.elementsDict;

		if ( mktl.deviceDescriptionArray.notNil) {
			mktl.deviceDescriptionArray.pairsDo { |elName, descr|
				var hash;

// when is this used? should this not be ioType always?
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
					if ( (elementsDict[elName].ioType == \in)  or:  (elementsDict[elName].ioType == \inout) ){
						hashToElNameDict.put(hash, elName);
					};
					if ( (elementsDict[elName].ioType == \out)  or:  (elementsDict[elName].ioType == \inout) ){
						elNameToMidiDescDict.put(elName,
							[
								descr[\midiMsgType],
								descr[\midiChan],
								descr[\midiNum],
								elementsDict[elName].spec // ??
							])
					};

				};
			}
		}
	}

	// modularize - only make the ones that are needed?
	// make them only once, methods to activate/deactivate them

	makeCC {
		var typeKey = \cc;
		//"make % func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.cc({ |value, num, chan, src|
				var hash = this.makeCCKey(chan, num);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				// midiRawAction.value(\control, src, chan, num, value);
				// global[typeKey].value(chan, num, value);

				if (el.notNil) {
					el.rawValueAction_(value, false);
					if(traceRunning) {
						"% - % > % | type: cc, ccValue:%, ccNum:%,  midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, num, chan, src).postln
					};
				} {
					if (traceRunning) {
					"MKtl( % ) : cc element found for midiChan %, ccnum % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\cc, \\type: \\button, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiBut, \\mode: \\push).\n\n"
						.postf(name, chan, num, chan, num);
					};
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

				// midiRawAction.value(\noteOn, src, chan, note, vel);
				// global[typeKey].value(chan, note, vel);

				if (el.notNil) {
					el.rawValueAction_(vel);
					if(traceRunning) {
						"% - % > % | type: noteOn, vel:%, midiNote:%,  midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), vel, note, chan, src).postln
					};
				}{
					if (traceRunning) {
					"MKtl( % ) : noteOn element found for midiChan %, note % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\noteOn, \\type: \\pianoKey or \\button, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, note);
					};
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

				// midiRawAction.value(\noteOff, src, chan, note, vel);
				// global[typeKey].value(chan, note, vel);

				if (el.notNil) {
					el.rawValueAction_(vel);
					if(traceRunning) {
						"% - % > % | type: noteOff, vel:%, midiNote:%,  midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), vel, note, chan, src).postln
					};
				} {
					if (traceRunning) {
					"MKtl( % ) : noteOff element found for midiChan %, note % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\noteOff, \\type: \\pianoKey or \\button, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, note);
					};
				};


			}, srcID: srcID).permanent_(true);
		);
	}

	makeTouch {
		var typeKey = \touch;
		var info = MIDIAnalysis.checkForMultiple( mktl.deviceDescriptionArray, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		// "make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.touch({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeTouchKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				// midiRawAction.value(\touch, src, chan, value);
				// global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(traceRunning) {
						"% - % > % | type: touch, midiNum:%, midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					}
				}{
					if (traceRunning) {
					"MKtl( % ) : touch element found for midiChan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\touch, \\type: \\chantouch', \\midiChan: %,"
					"\\spec: \\midiTouch).\n\n"
						.postf(name, chan, chan);
					};
				};


			}, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}

	makePolyTouch {
		//"makePolytouch".postln;
		var typeKey = \polyTouch; //decide on polyTouch vs polytouch : MIDIIn/MIDIOut is inconsistent
		//"make % func\n".postf(typeKey);
		responders.put(typeKey,
			MIDIFunc.polytouch({ |vel, note, chan, src|
				// look for per-key functions
				var hash = this.makePolyTouchKey(chan, note);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				// midiRawAction.value(\polyTouch, src, chan, note, vel);
				// global[typeKey].value(chan, note, vel);

				if (el.notNil) {
					el.rawValueAction_(vel);
					if(traceRunning) {
						"% - % > % | type: polyTouch, vel:%, midiNote:%,  midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), vel, note, chan, src).postln
					};
				}{
					if (traceRunning) {
					"MKtl( % ) : polyTouch element found for midiChan %, note % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\polyTouch, \\type: \\keytouch, \\midiChan: %,"
					"\\midiNum: %, \\spec: \\midiVel).\n\n"
						.postf(name, chan, note, chan, note);
					};
				}

			}, srcID: srcID).permanent_(true);
		);
	}

	// should work, can't test now.
	makeBend {
		var typeKey = \bend;
		var info = MIDIAnalysis.checkForMultiple( mktl.deviceDescriptionArray, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		//"make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.bend({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeBendKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				// midiRawAction.value(\bend, src, chan, value);
				// global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(traceRunning) {
						"% - % > % | type: bend, midiNum:%, midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					};
				}{
					if (traceRunning) {
					"MKtl( % ) : bend element found for midiChan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\bend, \\type: ??', \\midiChan: %,"
					"\\spec: \\midiBend).\n\n"
					.postf(name, chan, chan);
					};
				};


			}, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}


	makeProgram {
		var typeKey = \program;
		var info = MIDIAnalysis.checkForMultiple( mktl.deviceDescriptionArray, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		//"make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.program({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeProgramKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				// midiRawAction.value(\program, src, chan, value);
				// global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(traceRunning) {
						"% - % > % | type: program, midiNum:%, midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					};
				}{
					if (traceRunning) {
					"MKtl( % ) : program element found for midiChan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\program, \\type: ??', \\midiChan: %,"
					"\\spec: \\midiProgram).\n\n"
					.postf(name, chan, chan);
					};
				};


			}, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}

	makeAllNotesOff {
		var typeKey = \allNotesOff;
		var info = MIDIAnalysis.checkForMultiple( mktl.deviceDescriptionArray, typeKey, \midiChan);
		var chan = info[\midiChan];
		var listenChan =if (chan.isKindOf(SimpleNumber)) { chan };

		//"make % func\n".postf(typeKey);

		responders.put(typeKey,
			MIDIFunc.new({ |value, chan, src|
				// look for per-key functions
				var hash = this.makeProgramKey(chan);
				var elName = hashToElNameDict[hash];
				var el = elementHashDict[hash];

				// midiRawAction.value(\allNotesOff, src, chan, value);
				// global[typeKey].value(chan, value);

				if (el.notNil) {
					el.rawValueAction_(value);
					if(traceRunning) {
						"% - % > % | type: allNotesOff, midiNum:%, midiChan:%, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), value, chan, src).postln
					};
				}{
					if (traceRunning) {
					"MKtl( % ) : program element found for midiChan % !\n"
					" - add it to the description file, e.g.: "
					"\\<name>: (\\midiMsgType: \\allNotesOff, \\type: ??', \\midiChan: %,"
					").\n\n"
					.postf(name, chan, chan);
					};
				};


			}, msgType: typeKey, chan: listenChan, srcID: srcID).permanent_(true);
		);
	}


	cleanupElementsAndCollectives{
		responders.do{ |resp|
			// resp.postln;
			resp.free;
		};
		elementHashDict = nil;
		hashToElNameDict = nil;
		elNameToMidiDescDict = nil;
	}

	makeRespFuncs { |msgTypes|
		msgTypes = MIDIAnalysis.checkMsgTypes( mktl.deviceDescriptionArray);
		msgTypes = msgTypes ? allMsgTypes;
		responders = ();
		// global = ();
		msgTypes.do { |msgType|
			switch(msgType,
				\cc, { this.makeCC },
				\noteOn, { this.makeNoteOn },
				\noteOff, { this.makeNoteOff },
				\noteOnOff, { this.makeNoteOn.makeNoteOff },
				\touch, { this.makeTouch },
				\polyTouch, { this.makePolyTouch },
				\bend, { this.makeBend },
				\program, { this.makeProgram },
				// \allNotesOff, { this.makeAllNotesOff },
				// add [ \midiClock, \start, \stop, \continue, \reset ]
			);
		};
	}

	send { |key,val|
	 	elNameToMidiDescDict !? _.at(key) !? { |x|
			var type, ch, num, spec;
			#type, ch, num, spec = x;
	 		switch(type)
			{\cc}{ midiOut.control(ch, num, val ) }
			{\noteOn}{ midiOut.noteOn(ch, num, val ) }
			{\noteOff}{ midiOut.noteOff(ch, num, val ) }
			{\noteOnOff} { midiOut.noteOn(ch, num, val ) }
			{\polyTouch}{ midiOut.polyTouch(ch, num, val) }
			{\bend}{ midiOut.bend(ch, val) }
			{\touch}{ midiOut.touch(ch, val) }
			{\program}{ midiOut.program(ch, val) }
			{\allNotesOff}{ midiOut.allNotesOff(ch) }
			{\midiClock}{ midiOut.midiClock }
			{\start}{ midiOut.start }
			{\stop}{ midiOut.stop }
			{\continue}{ midiOut.continue }
			{\reset}{ midiOut.reset }
			// {\songSelect}{ midiOut.songPtr( song ) } // this one has a really different format
			// {\songPtr}{ midiOut.songPtr( songPtr ) } // this one has a really different format
			// {\smpte}{ midiOut.smpte } // this one has a really different format
//			{\note}{ x.postln /*TODO: check type for noteOn, noteOff, etc*/ }
			{warn("MIDIMKtlDevice: message type % not recognised".format(type))}
	 	}
	}

	sendInitialisationMessages{
		mktl.initialisationMessages.do{ |it|
			midiOut.performList( it[0], it.copyToEnd(1) );
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
	// *makeAllNotesOffKey { |chan| ^("all_%".format(chan)).asSymbol }

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
	// makeAllNotesOffKey { |chan| ^("all_%".format(chan)).asSymbol }

}
