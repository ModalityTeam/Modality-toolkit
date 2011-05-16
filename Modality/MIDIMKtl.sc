///////// how to make anonymous ones? when would they be used anonymously? /////

// TODO
//    addFunc should conform to super.addFunc.
//		but


MIDIMKtl : MKtl { 
	classvar <initialized = false;
	
	// MIDI-specific address identifiers 
	var <srcID, <source; 
	
			// optimisation for fast lookup, 
			// may go away if everything lives in "elements" of superclass
	var <funcDict;
	var <hashToElNameDict;

		// open all ports 
	*initMIDI{|force= false|
		(initialized.not || {force}).if({
			MIDIIn.connectAll;
			initialized = true;
		})
	}
	
		// display all ports in readable fashion, 
		// copy/paste-able directly 
	*find { |name, uid| 
		this.initMIDI(true);
		"\n///////// MIDIMKtl.find - - - MIDI sources found: /////// ".postln;
		"	index	uid (USB port ID)	device	name".postln;
		MIDIClient.sources.do({ |src,i|
			("\t" ++ i).post;
			("\t\t[" ++ src.uid ++ "]").post;
			("\t\t[" ++ src.device.asSymbol.asCompileString ++ "]").post;
			("\t[" ++ src.name.asSymbol.asCompileString ++ "]").postln;
		});	
		"\n//	Possible	MIDIMKtls - just give them good names: ".postln;
		MIDIClient.sources.do { |src| 
			"		MIDIMKtl('???', %);  // %\n".postf(src.uid, src.device);
		};
		"\n///////".postln;
	}

		// create with a uid, or access by name	
	*new { |name, uid| 
		var foundSource;
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
		
			// make a new source
		this.initMIDI;
		foundSource = MIDIClient.sources.detect { |src|
			src.uid == uid;
		}; 

		if (foundSource.isNil) { 
			warn("MIDIMKtl:" 
			"	No MIDIIn source with USB port ID % exists! please check again.".format(uid));
			^nil
		};
				
		^super.basicNew.init.initMIDIMKtl(name, uid, foundSource);
	}
	
	initMIDIMKtl { |argName, argUid, argSource|
		name = argName; 
		srcID = argUid;
		source = argSource;
		all.put(name, this);
		
		funcDict = ();
		hashToElNameDict = ();
		
		this.findDeviceDescription(source.device); 
		
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
	

		// utilities for lookup 
	makeCCKey { |chan, cc| ^(chan.asString ++ "_" ++ cc).asSymbol }
	ccKeyToChanCtl { |ccKey| ^ccKey.asString.split($_).asInteger }

	makeNoteKey { |chan, note| 
		var key = chan.asString; 
		if (note.notNil) { key = key ++ "_" ++ note };
		^key.asSymbol 
	}
	noteKeyToChanNote { |noteKey| ^noteKey.asString.split($_).asInteger }
	
	storeArgs { ^[name] }
	
	printOn { |stream| ^this.storeOn(stream) }
}

/*

	
*/

