/*
HIDMKtl.find;

HIDMKtl('ferrari', 102760448);  // Run'N' Drive

HIDMKtl( 'ferrari', "usb-0000:00:1d.0-1.2/input0"); // Run 'N' Drive on Linux

HIDMKtl('ferrari').srcDevice.slots

*/
// TODO
//    addFunc should conform to super.addFunc.


HIDMKtl : MKtl {
	classvar <initialized = false; 
	classvar <sourceDeviceDict;

	
	var <srcID, <srcDevice; 
	
			// optimisation for fast lookup, 
			// may go away of everything lives in the elements
	var <elemDict;
	var <lookupDict;

	*initHID { |force=false|
		(initialized && {force.not}).if{^this};
		GeneralHID.buildDeviceList;
		sourceDeviceDict = ();

		this.prepareDeviceDicts;

		GeneralHID.startEventLoop;
		
		initialized = true;
	}

	*prepareDeviceDicts{
		var prevName = nil, j = 0, order, deviceNames;

		deviceNames = GeneralHID.deviceList.collect{|dev,id|
			if ( dev[1].name != "could not open device" ){
				[this.makeShortName(dev[1].name.asString),id];
			}
		}.reject{ |it| it.isNil };
		order = deviceNames.order{ arg a, b; a[0] < b[0] };
		deviceNames[order].do{|name, i|
			(prevName == name[0]).if({
				j = j+1;
			},{
				j = 0;
			});
			prevName = name[0];
			sourceDeviceDict.put((name[0] ++ j).asSymbol, GeneralHID.deviceList[ name[1] ])
		};

		// put the available midi devices in MKtl's available devices
		allAvailable.put( \hid, List.new );
		sourceDeviceDict.keysDo({ |key|
			allAvailable[\hid].add( key );
		});
	}
		// open all ports and display them in readable fashion, 
		// copy/paste-able directly 
	*find { |name, uid, post=true| 
		this.initHID( true );

		/*
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
		*/
		if ( post ){
			this.postPossible;
		};
	}

	*postPossible{
		"\n// Available	HIDMKtls - just give them unique names: ".postln;
		sourceDeviceDict.keysValuesDo{ |key,pair| 
			var rawdev, info; 
			#rawdev, info = pair;
			"   HIDMKtl('%', %);  // %\n".postf(key, info.physical.asCompileString, info.name);
		};
		"\n-----------------------------------------------------".postln;
	}

	*findSource{ |rawDeviceName|
		/*
		var devices = GeneralHID.deviceList.detect{ |pair|
			var dev, info; #dev, info = pair;
			(info.name == rawDeviceName)
		};
		^devices;
		*/
		var devKey;
		this.sourceDeviceDict.keysValuesDo{ |key,pair|
			//	pair[1].postln;
			if ( pair[1].name.asString == rawDeviceName ){
				devKey = key;
			};
		};
		^devKey;
	}

	// how to deal with additional arguments (uids...)?
	*newFromDesc{ |name,deviceDescName,devDesc|
		//		var devDesc = this.getDeviceDescription( deviceDesc )
		var dev = this.findSource( devDesc[ thisProcess.platform.name ] );
		dev.postln;
		^this.new( name, dev );
	}

		// create with a uid, or access by name	
	*new { |name, uid, devDescName| 
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

		if (uid.isNil) { 
			foundSource = this.sourceDeviceDict[ name ];
		}{
			foundSource = GeneralHID.findBy( locID: uid );
		};
			// make a new one		
		if (foundSource.isNil) { 
			warn("HIDMKtl:" 
			"	No HID source with USB port ID % exists! please check again.".format(uid));
			^nil
		};
				
		^super.basicNew(name,devDescName ? foundSource[1].name.asString ).initHIDMKtl(uid, foundSource);
	}
	
	postRawSpecs { this.class.postRawSpecsOf(srcDevice) }
	
	// is this cross platform? Doesn't seem like!
	*postRawSpecsOf { |dev| 
		"HIDMKtl - the reported properties of device: %\n".postf(dev.info.name);
		"	index, type, usage, cookie, min, max, ioType, usagePage, usageType.\n\t".postln;
		
		dev.elements.do { |ele, i|
			("" + i + "\t").post; [ele.type, ele.usage, ele.cookie, ele.min, ele.max, ele.ioType, ele.usagePage, ele.usageType].postln;
		}
	}
	
	initHIDMKtl { |argUid, argSource|
		srcID = argUid;
		srcDevice = GeneralHID.open(argSource);
		all.put(name, this);
		
		elemDict = ();
		lookupDict = ();

		this.setGeneralHIDActions;
		
		//		this.getDeviceDescription(  )
		//		this.findDevSpecs(srcDevice.info.name.postln); 
		
//		// this.makeElements; 
		//		this.prepareFuncDict;
//
//		this.addResponders; 
	}

	setGeneralHIDActions{
		var newElements = (); // make a new list of elements, so we only have the ones that are present for the OS

		this.elements.do{ |el|
			var slot = el.elementDescription[\slot]; // linux
			var cookie = el.elementDescription[\cookie]; // osx
			
			// on linux:
			if ( slot.notNil ){
				srcDevice.slots[ slot[0] ][ slot[1] ].action = { |v| el.rawValueAction_( v.value ) };
				newElements.put( el.name, el );
			};
			// on osx:
			if ( cookie.notNil ){
				elemDict.put(  cookie, el );
			//	srcDevice.dump;
				srcDevice.device.slots.at( cookie ).action = { |slot| this.elemDict[ cookie ].rawValueAction_( slot.rawValue ) };
				//	srcDevice.hidDeviceAction = { |ck,val| this.elemDict[ ck ].rawValueAction_( val ) };
				newElements.put( el.name, el );
			}
		};
		this.replaceElements( newElements );
	}

	/*
	prepareFuncDict { 
		if (devSpecs.notNil) { 
			// works only for scenes ATM;
			devSpecs.pairsDo { |elName, descr| 
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
	*/

	verbose_ {|value=true|
		value.if({
			elements.do{|item| item.addFunc(\verbose, { |element| 
					[element.source, element.name, element.value].postln;
			})}
		}, {
			elements.do{|item| item.removeFunc(\verbose)}
		})
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
//	defaultValueFor { |elName| 
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

