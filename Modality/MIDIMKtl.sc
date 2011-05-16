///////// how to make anonymous ones? when would they be used anonymously? /////

// TODO
//    addFunc should conform to super.addFunc.
//		but


MIDIMKtl : MKtl { 
	classvar <initialized = false;
	
	var <srcID, <source; 
	
			// optimisation for fast lookup, 
			// may go away of everything lives in the elements
	var <funcDict;
	var <ccKeyToElNameDict;

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
		
		foundSource = MIDIClient.sources.detect { |src|
			src.uid == uid;
		}; 

			// make a new one		
		if (foundSource.isNil) { 
			warn("MIDIMKtl:" 
			"	No MIDIIn source with USB port ID % exists! please check again.".format(uid));
			^nil
		};
				
		^super.basicNew.init.initMIDI(name, uid, foundSource);
	}
	
	initMIDI { |argName, argUid, argSource|
		name = argName; 
		srcID = argUid;
		source = argSource;
		all.put(name, this);
		
		funcDict = ();
		ccKeyToElNameDict = ();
		
		this.findDeviceDescription(source.device); 
		
		// this.makeElements; 
		this.prepareFuncDict;

		this.addResponders; 
	}

		// interface methods
	addFunc { |elementKey, funcName, function| 
		//	 |elementKey, funcName, function, addAction=\addToTail, target|
		//super.addFunc(...);

		var ccKey = ccKeyToElNameDict.findKeyForValue(elementKey);
		funcDict[ccKey].addLast(funcName, function);
	}

	removeFunc { |elKey, name| 
		var ccKey = ccKeyToElNameDict.findKeyForValue(elKey); 
		funcDict[ccKey].removeAt(name);
	}

		// convenience methods
	defaultElementValue { |elName| 
		^deviceDescription[elName].spec.default
	}

	postDescription { deviceDescription.printcsAll; }
	
	elNames { 
		^(0, 2 .. deviceDescription.size - 2).collect (deviceDescription[_])
	}


		// plumbing	
	prepareFuncDict { 
		if (deviceDescription.notNil) { 
			// works only for scenes ATM;
			deviceDescription.pairsDo { |elName, descr| 
				var ccKey = this.makeCCKey(descr[\chan], descr[\ccNum]);
				descr.put(\ccKey, ccKey); // just in case ... 
				
				funcDict.put(
					ccKey, FuncChain([\post, { |ktl, elName, value| 
						[ktl, elName, value].postln;
					}])
				);
				ccKeyToElNameDict.put(ccKey, elName);
			}
		}
	}
	
	findDeviceDescription { |devicename|
		var path = deviceDescriptionFolder +/+ devicename ++ ".scd";
		deviceDescription = try { 
			path.load 
		} { 
			"MIDIMKtl - no deviceSpecs found for %: please make them!\n".postf(devicename);
			this.class.openTester(this);
		};
	}

	addResponders { 	
		responders = (
			cc: CCResponder({ |src, chan, num, value| 
				var ccKey = this.makeCCKey(chan, num);
				var elName = ccKeyToElNameDict[ccKey]; 
				funcDict[ccKey].value(this, elName, value); 
			}, srcID), 
			
			noteon: NoteOnResponder({ |src, chan, note, vel|
				[chan, note, vel].postln
//				var noteKey = this.makeNoteKey(chan, note);
//				var elName = ccKeyToElNameDict[ccKey];
//				funcDict[ccKey].value(this, elName, value); 
			}, srcID), 
			
			noteon: NoteOffResponder({ |src, chan, note, vel|
				[chan, note, vel].postln
			}, srcID)
		);
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

