///////// how to make anonymous ones? when would they be used anonymously? /////

// TODO
//    addFunc should conform to super.addFunc.
//		but


MIDIMKtl : MKtl { 
	classvar <initialized = false;
	classvar <sourceDeviceDict;
	classvar <destinationDeviceDict;
	
	// MIDI-specific address identifiers 
	var <srcID, <source; 
	var <dstID, <destination; 
	
			// optimisation for fast lookup, 
			// may go away if everything lives in "elements" of superclass
	var <funcDict;
	var <hashToElNameDict;

		// open all ports 
	*initMIDI{|force= false|

		(initialized && {force.not}).if{^this};
		
		
		MIDIIn.connectAll;
		sourceDeviceDict = ();
		destinationDeviceDict = ();

		this.prepareDeviceDicts;

		
		
		
		initialized = true;
	}
	
		// display all ports in readable fashion, 
		// copy/paste-able directly 
		// this could also live in 
	*find { |name, uid| 
		this.initMIDI(true);

		if (MIDIClient.sources.isEmpty) { 
			"// MIDIMKtl did not find any sources - you may want to connect some first.".inform;
			^this 
		};

		"/*\nMIDI sources found by MIDIMKtl.find:".postln;
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


		"*/\n\n// Available MIDIMKtls (you may want to change the names) */".postln;
		sourceDeviceDict.keysValuesDo { |key, src| 
			"MIDIMKtl('%', %, %);  // %\n".postf(
				key, 
				src.uid, 
				destinationDeviceDict[key].notNil.if({destinationDeviceDict[key].uid},{nil}),
				src.device
			);
		};
		"\n".postln;
	}

		// create with a uid, or access by name	
	*new { |name, uid, destID| 
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
		
		this.reassignKeyOfDict(name, foundSource, sourceDeviceDict);
		foundDestination.notNil.if{
			this.reassignKeyOfDict(name, foundDestination, destinationDeviceDict);
		};
		
		^super.basicNew(name, foundSource.device)
			.initMIDIMKtl(name, foundSource, foundDestination);
	}
	
	*prepareDeviceDicts{
		var prevName = nil, j = 0, order, deviceNames;

		deviceNames = MIDIClient.sources.collect{|src|
			this.makeShortName(src.device);
		};
		order = deviceNames.order;
		deviceNames[order].do{|name, i|
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
			this.makeShortName(src.device);
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
	}

	*reassignKeyOfDict{|name, source, dict|
		var oldName, otherSource;
		
		// find name clashes in dict and swap keys if there are. Otherwise "rename" key.
		oldName = dict.findKeyForValue(source);
		otherSource = dict[name];
		
		dict[oldName] = otherSource;
		dict[name] = source;


		oldName = dict.findKeyForValue(source);
		otherSource = dict[name];
		
		dict[oldName] = otherSource;
		dict[name] = source;
		
	}
	
	initMIDIMKtl { |argName, argSource, argDestination|
		name = argName; 
		
		source = argSource;
		srcID = source.uid;
		
		// destination is optional
		destination = argDestination;
		destination.notNil.if{
			dstID = destination.uid;
		};
		
		all.put(name, this);
		
		funcDict = ();
		hashToElNameDict = ();
			// moved to superclass init
	//	this.loadDeviceDescription(source.device); 
		
		this.makeElements; 
		this.prepareFuncDict;

		this.addResponders; 
	}

		// interface methods
//	addFunc { |elementKey, funcName, function| 
//		//	 |elementKey, funcName, function, addAction=\addToTail, target|
//		//super.addFunc(...);
//
//		var hash = hashToElNameDict.findKeyForValue(elementKey);
//		funcDict[hash].addLast(funcName, function);
//	}

		// plumbing	
	prepareFuncDict { 
		if (deviceDescription.notNil) { 
			deviceDescription.pairsDo { |elName, descr|
				var hash;
				
				hash = descr[\midiType].switch(
					\note, {this.makeNoteKey(descr[\chan], descr[\midiNote]);},
				
					\cc, {this.makeCCKey(descr[\chan], descr[\ccNum]);},
					{//default:
						"MIDIMKtl:prepareFuncDict (%): identifier in midiType for item % not known. Please correct.".format(this, elName).error; 
						this.dump; 
						^this;
					}
				);

				//descr.put(\hash, hash); // just in case ... 
				
				funcDict.put(
					hash, elements[elName].funcChain;
				);
				hashToElNameDict.put(hash, elName);
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
				funcDict[hash].value(this, elName, value); 
			}, srcID), 
			
			noteon: NoteOnResponder({ |src, chan, note, vel|
				var hash = this.makeNoteKey(chan, note);
				var elName = hashToElNameDict[hash];
				//	["noteOn", chan, note, vel, hash].postln;
				funcDict[hash].value(this, elName, vel); 
			}, srcID), 
			
			noteoff: NoteOffResponder({ |src, chan, note, vel|
				var hash = this.makeNoteKey(chan, note);
				var elName = hashToElNameDict[hash];
				//	["noteOff", chan, note, vel, hash].postln;
				funcDict[hash].value(this, elName, vel); 
			}, srcID)
		);
	}

	verbose_ {|value=true|
		value.if({
			funcDict.do{|item| item.addFirst(\verbose, { |ktl, elName, value| 
					[ktl, elName, value].postln;
			})}
		}, {
			funcDict.do{|item| item.removeAt(\verbose)}
		})
	}
		
//	openTester {	// breaks responders for now.
//
//		var observedCCs = List[];
//
//		// if not there, make a template text file for them, 
//		// and instructions where to save them so they can be found 
//		// automatically. 
//		this.addResponders;
//		
//			// just sketching - keep track of several of them
//		
//		responders[\cc].function = { |src, chan, num, value| 
//			var oldCC = observedCCs.detect { |el| 
//				el.keep(2) == [chan, num] 
//			};
//			if (oldCC.notNil) { 
//				oldCC.put(2, min(value, oldCC[2])); 
//				oldCC.put(3, max(value, oldCC[3])); 
//			} { 
//				observedCCs.add([chan, num, value, value]);
//			};
//			[chan, num].postln;
//			//observedCCs.postln;
//		};
//	}
//	
//	endTester { 
//		responders[\cc].function = { |src, chan, num, value| 
//		
//		};
//	}	
	

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
