/*
HIDMKtl.find;

HIDMKtl('ferrari', 102760448);  // Run'N' Drive

HIDMKtl( 'ferrari', "usb-0000:00:1d.0-1.2/input0"); // Run 'N' Drive on Linux

HIDMKtl('ferrari').srcDevice.slots

HIDMKtl('ferrari').postRawSpecs

HIDMKtl('ferrari').postSpecs

*/
// TODO
//    addFunc should conform to super.addFunc.


HIDMKtl : MKtl { 
	
	var <srcID, <srcDevice; 
	
			// optimisation for fast lookup, 
			// may go away of everything lives in the elements
	var <elemDict;
	var <lookupDict;

		// open all ports and display them in readable fashion, 
		// copy/paste-able directly 
	*find { |name, uid| 
		
		GeneralHID.buildDeviceList; 

		"\n///////// HIDMKtl.find - - - HID sources found: /////// ".postln;
		"	index	locID (USB port ID)	device name         vendor  product".postln;
		GeneralHID.deviceList.do { |pair, i| 
			var rawdev, info; 
			#rawdev, info = pair;
			("\t" ++ i).post;
			("\t\t[" ++ info.physical ++ "]").post;
			("\t\t[" ++ info.name.asSymbol.asCompileString ++ "]").post;
			("    " ++ info.vendor + info.product).postln;
		};
			
		"\n//	Possible	HIDMKtls - just give them unique names: ".postln;
		GeneralHID.deviceList.do { |pair| 
			var rawdev, info; 
			#rawdev, info = pair;
			"		HIDMKtl('?', %);  // %\n".postf(info.physical, info.name);
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
					warn("HIDMKtl: name % is in use for a different USB port ID!"
					++ 	"	Please pick a different name.".format(name) 
					++ 	"	Taken names:" + all.keys.asArray.sort ++ ".\n");
					^nil
				}
			}
		};
		
		foundSource = GeneralHID.findBy( locID: uid );

			// make a new one		
		if (foundSource.isNil) { 
			warn("HIDMKtl:" 
			"	No HID source with USB port ID % exists! please check again.".format(uid));
			^nil
		};
				
		^super.basicNew.initHID(name, uid, foundSource);
	}
	
	postRawSpecs { this.class.postRawSpecsOf(srcDevice) }
	
	*postRawSpecsOf { |dev| 
		"HIDMKtl - the reported properties of device: %\n".postf(dev.info.name);
		"	index, type, usage, cookie, min, max, ioType, usagePage, usageType.\n\t".postln;
		
		dev.elements.do { |ele, i|
			("" + i + "\t").post; [ele.type, ele.usage, ele.cookie, ele.min, ele.max, ele.ioType, ele.usagePage, ele.usageType].postln;
		}
	}
	
	initHID { |argName, argUid, argSource|
		name = argName; 
		srcID = argUid;
		srcDevice = GeneralHID.open(argSource);
		all.put(name, this);
		
		elemDict = ();
		lookupDict = ();
		
		this.findDevSpecs(srcDevice.info.name.postln); 
		
//		// this.makeElements; 
//		this.prepareFuncDict;
//
//		this.addResponders; 
	}

//		// interface methods
//	addFunc { |elementKey, funcName, function| 
//		//	 |elementKey, funcName, function, addAction=\addToTail, target|
//		//super.addFunc(...);
//
//		var ccKey = ccKeyToElNameDict.findKeyForValue(elementKey);
//		funcDict[ccKey].addLast(funcName, function);
//	}
//
//	removeFunc { |elKey, name| 
//		var ccKey = ccKeyToElNameDict.findKeyForValue(elKey); 
//		funcDict[ccKey].removeAt(name);
//	}
//
//		// convenience methods
//	defaultElementValue { |elName| 
//		^devSpecs[elName].spec.default
//	}

//	postSpecs { devSpecs.printcsAll; }
//	
//	elNames { 
//		^(0, 2 .. devSpecs.size - 2).collect (devSpecs[_])
//	}
//
//
//		// plumbing	
//	prepareFuncDict { 
//		if (devSpecs.notNil) { 
//			// works only for scenes ATM;
//			devSpecs.pairsDo { |elName, descr| 
//				var ccKey = this.makeCCKey(descr[\chan], descr[\ccNum]);
//				descr.put(\ccKey, ccKey); // just in case ... 
//				
//				funcDict.put(
//					ccKey, FuncChain([\post, { |ktl, elName, value| 
//						[ktl, elName, value].postln;
//					}])
//				);
//				ccKeyToElNameDict.put(ccKey, elName);
//			}
//		}
//	}
//	
//
//	addResponders { 	
//		responders = (
//			cc: CCResponder({ |src, chan, num, value| 
//				var ccKey = this.makeCCKey(chan, num);
//				var elName = ccKeyToElNameDict[ccKey]; 
//				funcDict[ccKey].value(this, elName, value); 
//			}, srcID), 
//			
//			noteon: NoteOnResponder({ |src, chan, note, vel|
//				// [chan, note, vel].postln
//			}, srcID)
//		);
//	}
//
		
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
//			observedCCs.postln;
//		};
//	}
//	
//	endTester { 
//		responders[\cc].function = { |src, chan, num, value| 
//		
//		};
//	}	
	

//		// utilities for lookup 
//	makeCCKey { |chan, cc| ^(chan.asString ++ "_" ++ cc).asSymbol }
//	
//	ccKeyToChanCtl { |ccKey| ^ccKey.asString.split($_).asInteger }
//
//	makeNoteKey { |chan, note| 
//		var key = chan.asString; 
//		if (note.notNil) { key = key ++ "_" ++ note };
//		^key.asSymbol 
//	}
//
//	noteKeyToChanNote { |noteKey| ^noteKey.asString.split($_).asInteger }
	
	storeArgs { ^[name] }
	
	printOn { |stream| ^this.storeOn(stream) }
}

/*

	
*/

