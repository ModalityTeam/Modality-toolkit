MIDIMKtl : MKtl { 
	
	var <srcID, <source; 

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
					^foundKtl
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
		
		this.findDevSpecs(source.device);

		// what else in init? 
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
	
	openTester {
		// if not there, make a template text file for them, 
		// and instructions where to save them so they can be found 
		// automatically. 
		this.addResps;
	}
	
	addResps { 
		var recentCCs = List[];
			
		responders = (cc: CCResponder({ |src, chan, num, value|
				[chan, num, value].postln;
				
				recentCCs.add([chan, num, value]).postln;
			}, srcID), 
		noteon: NoteOnResponder({ |src, chan, note, vel|
				[chan, note, vel].postln
			}, srcID)
		);
	}

/*	
	MIDIMKtl.find;
	
	// give the one of interest a name, and make it
	MIDIMKtl(\nk1, 12345);			// no uid like that
	
	// give the one of interest a name, and make it
	// based on reported name, look up its hardware specs
	MIDIMKtl(\nk1, -616253900);		// lower USB port on my MBP


	MIDIMKtl(\nk1);		// look up again;

	MIDIMKtl(\nk1).openTester

*/ 

}