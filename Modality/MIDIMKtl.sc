///////// how to make anonymous ones? when would they be used anonymously? /////

MIDIMKtl : MKtl { 
	
	var <srcID, <source; 
	
			// optimised for fast lookup 
	var <funcDict;
	var <ccKeyToElNameDict;

		// open all ports and display them in readable fashion, 
		// copy/paste-able directly 
	*find { |name, uid| 
		MIDIIn.connectAll;
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

		// access by name, or make if uid is OK	
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
				
		^super.new.init(name, uid, foundSource);
	}
	
	init { |argname, argUid, argSource| 
		name = argname; 
		srcID = argUid;
		source = argSource;
		all.put(name, this);
		
		funcDict = ();
		ccKeyToElNameDict = ();
		
		this.findDevSpecs(source.device); 
		
		// this.makeElements; 
		this.prepareFuncDict;

		this.addResps; 
		
		// what else in init? 
	}
	
	prepareFuncDict { 
		if (devSpecs.notNil) { 
			// works only for scenes ATM;
			devSpecs.keysValuesDo { |elName, descr| 
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
	
	findDevSpecs { |devicename|
		var path = devSpecsFolder +/+ devicename ++ ".scd";
		devSpecs = try { 
			path.load 
		} { 
			"MIDIMKtl - no deviceSpecs found for %: please make them!\n".postf(devicename);
			this.class.openTester(this);
		};
	}
	
	storeArgs { ^[name] }
	
	printOn { |stream| ^this.storeOn(stream) }
	
	openTester {	// breaks responders for now.

		var observedCCs = List[];

		// if not there, make a template text file for them, 
		// and instructions where to save them so they can be found 
		// automatically. 
		this.addResps;
		
			// just sketching - keep track of several of them
		
		responders[\cc].function = { |src, chan, num, value| 
			var oldCC = observedCCs.detect { |el| 
				el.keep(2) == [chan, num] 
			};
			if (oldCC.notNil) { 
				oldCC.put(2, min(value, oldCC[2])); 
				oldCC.put(3, max(value, oldCC[3])); 
			} { 
				observedCCs.add([chan, num, value, value]);
			};
			observedCCs.postln;
		};
	}
	
	endTester { 
		responders[\cc].function = { |src, chan, num, value| 
		
		};
	}
	
	addResps { 
			
		responders = (cc: CCResponder({ |src, chan, num, value| 
				var ccKey = this.makeCCKey(chan, num);
				var elName = ccKeyToElNameDict[ccKey]; 
			
				funcDict[ccKey].value(this, elName, value); 
				
				
			}, srcID), 
		noteon: NoteOnResponder({ |src, chan, note, vel|
				// [chan, note, vel].postln
			}, srcID)
		);
	}

		// utilities for lookup 
	makeCCKey { |chan, cc| ^(chan.asString ++ "_" ++ cc).asSymbol }
	
	ccKeyToChanCtl { |ccKey| ^ccKey.asString.split($_).asInteger }

	makeNoteKey { |chan, note| 
		var key = chan.asString; 
		if (note.notNil) { key = key ++ "_" ++ note };
		^key.asSymbol 
	}

	noteKeyToChanNote { |noteKey| ^noteKey.asString.split($_).asInteger }
	
	addFunc { |elKey, name, func| 
		var ccKey = ccKeyToElNameDict.findKeyForValue(elKey); 
		funcDict[ccKey].add(name, func);
	}

	removeFunc { |elKey, name| 
		var ccKey = ccKeyToElNameDict.findKeyForValue(elKey); 
		funcDict[ccKey].removeAt(name);
	}

/*	
	MIDIMKtl.find;
	MIDIMKtl(\nk1, -616253900);		// lower USB port on my MBP
	
	// give the one of interest a name, and make it
	MIDIMKtl(\nk1, 12345);			// no uid like that
	
	// give the one of interest a name, and make it
	// based on reported name, look up its hardware specs
	MIDIMKtl(\nk1, -616253900);		// lower USB port on my MBP


	MIDIMKtl(\nk1);		// look up again;

	MIDIMKtl(\nk1).devSpecs;
	MIDIMKtl(\nk1).funcDict;

	MIDIMKtl(\nk1).addFunc(\sl1_1, \yubel, { |who, what, howmuch| 
		"YAYAYAY: ".post; [who, what, howmuch].postln;
	});
		// 
	MIDIMKtl(\nk1).removeFunc(\sl1_1, \post);
	


	MIDIMKtl(\nk1).openTester;


	
	
*/

}