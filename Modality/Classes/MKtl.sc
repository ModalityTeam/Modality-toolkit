// honouring Jeff's MKeys by keeping the M for prototyping the new Ktl

// TODO: rename Meta_MKtl:specs to globalSpecs
// TODO: rename MKtl.localSpecs to specs

MKtl { // abstract class

	classvar <all; 			// holds all instances of MKtl
	classvar <globalSpecs; 	// dict with all default specs used in MKtls

	var <name;
	// an MKtlDesc that has all known information about the hardware device(s)
	// contained in this MKtl.
	var <desc;
	var <specs;

	var <elementsDict; 		// all elements in a single flat dict for fast lookup
	var <elements;			// an ElementGroup with all elements in hierarchical order

	var <collectivesDict; 	// contains the collectives that are in the device description


	// an array of keys and values with a description of all the elements on the device.
	// generated from the hierarchical description read from the file.
	// used for filling the elementsDict.
	var <flatElementList;

	var <mktlDevice; // interface to the connected device(s).

	var <traceRunning = false;

	*initClass {
		Class.initClassTree(Spec);
		all = ();
		globalSpecs = ().parent_(Spec.specs);
		this.prAddDefaultSpecs();
	}

	*find { |protocols|
		MKtlDevice.find( protocols );
	}

	/////////// specs
	*prAddDefaultSpecs {
				// general
		this.addSpec(\cent255, [0, 255, \lin, 1, 128]);
		this.addSpec(\cent255inv, [255, 0, \lin, 1, 128]);
		this.addSpec(\lin255,  [0, 255, \lin, 1, 0]);
		this.addSpec(\cent1,  [0, 1, \lin, 0, 0.5]);
		this.addSpec(\lin1inv,  [1, 0, \lin, 0, 1]);

		// MIDI
		this.addSpec(\midiNote, [0, 127, \lin, 1, 0]);
		this.addSpec(\midiCC, [0, 127, \lin, 1, 0]);
		this.addSpec(\midiVel, [0, 127, \lin, 1, 0]);
		this.addSpec(\midiBut, [0, 127, \lin, 127, 0]);
		this.addSpec(\midiTouch, [0, 127, \lin, 1, 0]);
		this.addSpec(\midiBend, [0, 16383, \lin, 1, 8192]);

		// HID
		this.addSpec(\mouseAxis, [0.4,0.6, \lin, 0, 0.5]);
		this.addSpec(\mouseWheel, [0.4,0.6, \lin, 0, 0.5]);

		// this.addSpec(\hidBut, [0, 1, \lin, 1, 0]);
		// this.addSpec(\hidHat, [0, 1, \lin, 1, 0]);
		// // these are often wrong, check for device.
		// this.addSpec(\compass8, [0, 8, \lin, 1, 1]);

		this.addSpec(\cent1,  [0, 1, \lin, 0, 0.5].asSpec);
		this.addSpec(\cent1inv,  [1, 0, \lin, 0, 0.5].asSpec);

	}

	*addSpec {|key, spec|
		globalSpecs.put(key, spec.asSpec);
	}

	// addSpec {|key, spec|
	// 	this.addLocalSpec(key, spec)
	// }
	//
	// addLocalSpec {|key, spec|
	// 	var theSpec;
	//
	// 	// is it in MKtl.spec?
	// 	if (spec.isKindOf(Symbol)) {
	// 		theSpec = globalSpecs[spec];
	// 	};
	// 	if (theSpec.isNil) { // no, it's not...
	// 		theSpec = spec.asSpec; // convert spec via standard method
	// 	};
	//
	// 	specs.put(key, theSpec);
	// }

	// new returns existing instances
	// of subclasses that exist in .all,
	// or returns a new empty instance.
	// this is to allow virtual MKtls eventually.
	*new { |name, desc, lookForNew = false|
		var res;
		if (name.isNil) {
			if (desc.isNil) {
				"MKtl: can't make one without a name.".inform;
				^nil;
			};
		};

		res = this.all[name];

		// dont change
		if ( res.notNil ){
			if (desc.isNil) { ^res };
			// found an MKtl by name, and there is a new desc
			"MKtl: to change the description,"
			"use MKtl(%).rebuildFrom(<desc>)".inform;
			^res
		};

		// we found nothing, so we make a new MKtl
		MKtlDevice.initHardwareDevices( lookForNew );

		desc = MKtlDesc(desc);

		if (name.isNil and: { desc.notNil }) {
			// last chance: infer missing name from desc?
			try { name = (desc.shortName ++ 0).asSymbol };
			if (name.isNil) {
				"MKtl could not infer name from desc, so we give up.".postln;
				^nil
			}
		};
		// we have a name and hopefully a desc

		^super.newCopyArgs(name).init(desc);
	}

	storeArgs { ^[name] }
	printOn { |stream| this.storeOn(stream) }

	init { |argDesc|
		desc = argDesc;
		if (argDesc.isKindOf(MKtlDesc).not) {
			inform("MKtl: desc may not work yet.");
		};
		// FIXME : how to count up for multiple devices of same type?
		all.put(name, this);
	}

	findDescForName { |devShortName|
		// later - find the desc for a given shortName of a device
	}


	trace { |value=true|
		if ( mktlDevice.notNil ){ mktlDevice.trace( value ); };
		traceRunning = value;
	}

	prTryOpenDevice { |devName,devDesc| // devName is a shortname
		var newMKtlDevice;

		newMKtlDevice = MKtlDevice.tryOpenDevice( devName, this );
		if ( newMKtlDevice.isNil ){
			// maybe I gave a funky name, and can find the device from the spec
			if ( devDesc.notNil ){
				devName = MKtlDevice.findDeviceShortNameFromLongName( devDesc.at( \device ) );
				if ( devName.notNil ){
					newMKtlDevice = MKtlDevice.tryOpenDevice( devName, this );
				}{
					newMKtlDevice = MKtlDevice.tryOpenDeviceFromDesc(
						name, devDesc.at(\protocol), devDesc.at(\device), this );
					devName = name;
				};
			};
		};

		if ( newMKtlDevice.notNil ){
			// cross reference:
			mktlDevice = newMKtlDevice;
			"Opened device % for MKtl(%)\n".postf( devName, name );
		}{
			"WARNING: Could not open device for MKtl(%)\n".postf( name );
		};
	}
	//
	// rebuildFrom { |deviceDescriptionNameOrDict| // could be a string/symbol or dictionary
	// 	var devDescName, devDesc;
	// 	if ( deviceDescriptionNameOrDict.isNil ){
	// 		#devDesc, devDescName = this.class.findDeviceDesc( shortName: name );
	// 		if ( devDesc.isNil ){
	// 			this.warnNoDeviceDescriptionFileFound( devDescName );
	// 			^this; // don't change anything, early return
	// 		};
	// 	}{
	// 		if ( deviceDescriptionNameOrDict.isKindOf( Dictionary ) ){
	// 			devDescName = deviceDescriptionNameOrDict.at( \device );
	// 			devDesc = deviceDescriptionNameOrDict;
	// 		}{
	// 			#devDesc, devDescName = this.class.findDeviceDesc( deviceDescriptionNameOrDict );
	// 		};
	// 	};
	//
	// 	if ( mktlDevice.notNil ){
	// 		// check whether new device spec mathces protocol
	// 		if ( devDesc.at( \protocol ) != mktlDevice.class.protocol ){
	// 			"WARNING: MKtl(%): protocol % of device description %, does match protocol % of device %. Keeping the device description as it was.\n".postf( name, devDesc.at( \protocol ), devDescName, mktlDevice.class.protocol, mktlDevice.deviceName );
	// 			^this;
	// 		};
	// 		mktlDevice.cleanupElementsAndCollectives;
	// 	};
	//
	// 	this.prInitFromDeviceDescription( devDesc, devDescName );
	// 	if ( mktlDevice.notNil ){
	// 		mktlDevice.initElements;
	// 		mktlDevice.initCollectives;
	// 	};
	//
	// 	this.changed( \elements );
	// }
	//
	// closeDevice {
	// 	if ( mktlDevice.notNil ){
	// 		mktlDevice.closeDevice;
	// 	};
	// 	mktlDevice = nil;
	// }
	//
	//
	//
	//
	// checkWhetherDeviceIsThere { |deviceName|
	// 	var shortDeviceName, devDesc;
	//
	// 	if ( deviceName.notNil ){
	// 		if ( deviceName.isKindOf( Symbol ) ){
	// 			shortDeviceName = deviceName;
	// 		}{
	// 			shortDeviceName = MKtlDevice.findDeviceShortNameFromLongName( deviceName );
	// 		}
	// 	}{
	// 		devDesc = MKtl.getDeviceDescription( deviceDescriptionName );
	// 		if ( devDesc.notNil ){
	// 			deviceName = devDesc.at( \device );
	// 			shortDeviceName = MKtlDevice.findDeviceShortNameFromLongName( deviceName );
	// 		};
	// 	};
	// 	^[shortDeviceName, deviceName, devDesc]
	// }
	//
	// free {
	// 	this.closeDevice;
	// 	all.removeAt( name );
	// }
	//
	// openDevice { |deviceName, devDesc, lookAgain=true|
	// 	var shortName, foundDevDesc, protocol;
	//
	// 	if ( this.mktlDevice.notNil ){
	// 		"WARNING: Already a device opened for MKtl(%). Close it first with MKtl(%).closeDevice;\n".postf(name,name);
	// 		^this;
	// 	};
	//
	// 	#shortName, deviceName, foundDevDesc = this.checkWhetherDeviceIsThere( deviceName );
	// 	if ( shortName.isNil ){
	// 		foundDevDesc = this.class.getDeviceDescription(deviceDescriptionName);
	// 		if ( foundDevDesc.notNil ){
	// 			protocol = foundDevDesc.at( \protocol );
	// 			MKtlDevice.initHardwareDevices( lookAgain, protocol.bubble ); // this may be an issue, only look for appropriate protocol
	// 			#shortName, deviceName, foundDevDesc = this.checkWhetherDeviceIsThere( deviceName );
	// 		};
	// 	};
	//
	// 	// [deviceName, shortName ].postln;
	// 	this.prTryOpenDevice( shortName, foundDevDesc ? devDesc );
	// }
	//
	// /*
	// init procedure:
	//
	// - load description from file into deviceDescription var
	// - flattenDescription on each element
	// - substitute each spec in the element for the real ControlSpec corresponding to it
	//
	// */
	//
	// prInitFromDeviceDescription { |devDesc, devDescName|
	// 	var deviceInfo;
	// 	elementsDict = ();
	// 	deviceInfo = devDesc.deepCopy;
	// 	if ( deviceInfo.isNil )	{ // no device file found:
	// 		this.warnNoDeviceDescriptionFileFound( name );
	// 	}{
	// 		this.prLoadDeviceDescription( deviceInfo );
	// 		deviceInfoDict = deviceInfo.deepCopy;
	//
	// 		// remove description as it is stored in deviceDescriptionHierarch
	// 		deviceInfoDict[\description] = nil;
	// 	};
	// 	if ( deviceDescriptionArray.notNil ){
	// 		deviceDescriptionName = devDescName;
	// 		this.makeElements;
	// 		( "Created MKtl:" + name + "using device description"
	// 		+ deviceDescriptionName ).postln;
	// 	};
	// }
	//
	// storeArgs { ^[name] }
	// printOn { |stream| this.storeOn(stream) }
	//
	// prLoadDeviceDescription { |deviceInfo|
	// 	var deviceFileName;
	// 	var path;
	//
	// 	//"class: % deviceName: % deviceInfo:%".format(deviceName.class, deviceName, deviceInfo).postln;
	//
	// 	localSpecs = ();
	// 	localSpecs.parent = specs;
	//
	// 	// load specs from description file to specs
	// 	deviceInfo[\specs].notNil.if({
	// 		deviceInfo[\specs].postln;
	// 		deviceInfo[\specs].keysValuesDo{|key, spec|
	// 			this.addLocalSpec(key, spec); //adding locally
	// 		};
	// 	});
	//
	//
	// 	deviceDescriptionHierarch = deviceInfo[\description]; // TODO: fix name
	// 	deviceDescriptionArray = this.makeFlatDeviceDescription( deviceDescriptionHierarch );
	//
	// 	deviceDescriptionArray.pairsDo{ |key,elem|
	// 		this.class.flattenDescription( elem )
	// 	};
	//
	// 	// assign specs to elements,
	// 	deviceDescriptionArray.pairsDo {|key, elem|
	// 		var foundSpec;
	// 		var specKey = elem[\spec];
	//
	// 		foundSpec = localSpecs[specKey]; // implicitely looks in global spec, too
	//
	// 		if (foundSpec.isNil) {
	// 			warn("Mktl - in description %, el %, spec for '%' is missing! please add it to the description file."
	// 				.format(name, key, specKey, specKey)
	// 			);
	// 		};
	// 		elem[\specName] = specKey;
	// 		elem[\spec] = foundSpec;
	// 	};
	//
	// 	deviceInfo[\infoMessage] !? _.postln;
	// }
	//
	// //traversal function for combinations of dictionaries and arrays
	// prTraverse {
	// 	var isLeaf = { |dict|
	// 		dict.keys.includes( \type ) or:
	// 		dict.values.any({|x| (x.size > 1) }).not;
	// 	};
	//
	// 	var f = { |x, state, stateFuncOnNodes, leafFunc|
	//
	// 		if(x.isKindOf(Dictionary) ){
	// 			if( isLeaf.(x) ) {
	// 				leafFunc.( state , x )
	// 			}{
	// 				x.sortedKeysValuesCollect{ |val, key|
	// 					f.(val, stateFuncOnNodes.(state, key), stateFuncOnNodes, leafFunc )
	// 				}
	// 			}
	// 		} {
	// 			if(x.isKindOf(Array) ) {
	// 				if( x.first.isKindOf( Association ) ) {
	// 					f.(IdentityDictionary.with( *x ), state, stateFuncOnNodes, leafFunc );
	// 				} {
	// 					x.collect{ |val, i|
	// 						f.(val, stateFuncOnNodes.(state, i),  stateFuncOnNodes, leafFunc )
	// 					}
	// 				}
	// 			} {
	// 				Error("MKtl:prTraverse Illegal data structure in device description.\nGot object % of type %. Only allowed objects are Arrays and Dictionaries".format(x,x.class)).throw
	// 			}
	// 		}
	//
	// 	};
	// 	^f
	// }
	//
	// prMakeElementsFunc {
	// 	var isLeaf = { |dict|
	// 		dict.keys.includes( \type ) or:
	// 		dict.values.any({|x| x.size > 1}).not
	// 	};
	//
	// 	var f = { |x, state, stateFuncOnNodes, leafFunc|
	//
	// 		if(x.isKindOf(Dictionary) ){
	// 			if( isLeaf.(x) ) {
	// 				leafFunc.( state , x )
	// 			}{
	// 				MKtlElementGroup(state,
	// 					x.sortedKeysValuesCollect{ |val, key|
	// 						f.(val, stateFuncOnNodes.(state, key), stateFuncOnNodes, leafFunc )
	// 					}
	// 				)
	// 			}
	// 		} {
	// 			if(x.isKindOf(Array) ) {
	// 				MKtlElementGroup(state,
	// 					x.collect{ |val, i|
	// 						if( val.isKindOf( Association ) ) {
	// 							(val.key -> f.(val.value,
	// 								stateFuncOnNodes.(state, val.key),  stateFuncOnNodes, leafFunc )
	// 							)
	// 						} {
	// 							f.(val, stateFuncOnNodes.(state, i),  stateFuncOnNodes, leafFunc )
	// 						};
	// 					}
	// 				);
	// 			} {
	// 				Error("MKtl:prTraverse Illegal data structure in device description.\nGot object % of type %. Only allowed objects are Arrays and Dictionaries".format(x,x.class)).throw
	// 			}
	// 		}
	//
	// 	};
	// 	^f
	// }
	//
	// exploring {
	// 	if ( mktlDevice.isNil ){ ^false };
	// 	^mktlDevice.exploring;
	// }
	//
	// explore { |mode=true|
	// 	if ( mktlDevice.notNil ){
	// 		mktlDevice.explore( mode );
	// 	}{
	// 		"MKtl(%) has no open device, nothing to explore\n".postf( name );
	// 	};
	// }
	//
	// createDescriptionFile {
	// 	if ( mktlDevice.notNil ){
	// 		mktlDevice.createDescriptionFile;
	// 	}{
	// 		"MKtl(%) has no open device, cannot create description file\n".postf( name );
	// 	};
	// }
	//
	//
	// prUnderscorify {
	// 	^{ |a,b|
	// 		if(a != "") {
	// 			a++"_"++b.asString
	// 		} {
	// 			b.asString
	// 		}
	// 	};
	// }
	//
	// makeFlatDeviceDescription { |devDesc|
	//
	// 	var flatDict = ();
	//
	// 	this.prTraverse.(devDesc, "", this.prUnderscorify, { |state, x| flatDict.put(state.asSymbol,  x) } );
	//
	// 	^flatDict.asKeyValuePairs
	//
	// }
	//
	// *flattenDescription { |devDesc|
	// 	// some descriptions may have os specific entries, we flatten those into the dictionary
	// 	var platformDesc = devDesc[ thisProcess.platform.name ];
	// 	if ( platformDesc.notNil ){
	// 		platformDesc.keysValuesDo{ |key,val|
	// 			devDesc.put( key, val );
	// 		}
	// 	};
	// 	^devDesc;
	// }
	//
	// *flattenDescriptionForIO { |eleDesc,ioType|
	// 	// some descriptions may have ioType specific entries, we flatten those into the dictionary
	// 	var ioDesc = eleDesc[ thisProcess.platform.name ];
	// 	if ( ioDesc.notNil ){
	// 		ioDesc.keysValuesDo{ |key,val|
	// 			eleDesc.put( key, val );
	// 		}
	// 	};
	// 	^eleDesc;
	// }
	//
	// elementDescriptionFor { |elname|
	// 	^deviceDescriptionArray[deviceDescriptionArray.indexOf(elname) + 1]
	// }
	//
	// postDeviceDescription {
	// 	deviceDescriptionArray.pairsDo {|a, b| "% : %\n".postf(a, b); }
	// }
	//
	// makeElements {
	// 	var leafFunc;
	// 	this.elementNames.do{|key|
	// 		elementsDict[key] = MKtlElement(this, key);
	// 	};
	// 	leafFunc = { |finalKey, x| elementsDict[finalKey.asSymbol] };
	// 	MKtlElement.addGroupsAsParent = true;
	// 	elements = this.prMakeElementsFunc.(deviceDescriptionHierarch, "", this.prUnderscorify, leafFunc );
	// 	MKtlElement.addGroupsAsParent = false;
	//
	// }
	//
	// // needed for fixing elements that are not present for a specific OS
	// replaceElements { |newelements|
	// 	elementsDict = newelements;
	// }
	//
	// makeElementName { |args|
	// 	var n = args.size;
	// 	^(args[..n-2].collect({ |x| x.asString++"_"}).reduce('++')++args.last).asSymbol
	// }
	//
	// elementAt { |...args|
	// 	^elements.deepAt(*args)
	// }
	//
	// at { |index|
	// 	^elements.at( index );
	// }
	//
	// // should filter: those for my platform only
	// elementNames {
	// 	if ( elementsDict.isEmpty ){
	// 		^(0, 2 .. deviceDescriptionArray.size - 2).collect (deviceDescriptionArray[_])
	// 	}{
	// 		^elementsDict.keys.asArray;
	// 	}
	// }
	//
	// elementsOfType { |type|
	// 	^elementsDict.select { |elem|
	// 		elem.elementDescription[\type] == type
	// 	}
	// }
	//
	// elementsNotOfType { |type|
	// 	^elementsDict.select { |elem|
	// 		elem.elementDescription[\type] != type
	// 	}
	// }
	//
	// inputElements{
	// 	^elementsDict.select { |elem|
	// 		[ \in, \inout ].includes( elem.elementDescription[\ioType] ?? \in);
	// 	}
	// }
	//
	// outputElements{
	// 	^elementsDict.select { |elem|
	// 		[ \out, \inout ].includes( elem.elementDescription[\ioType] ?? \in);
	// 	}
	// }
	//
	// allElements {
	// 	^elementsDict.asArray
	// }
	//
	// elementsLabeled { |label|
	// 	var labels;
	//
	// 	^elementsDict.select{|elem|
	// 		labels = elem.elementDescription[\labels];
	// 		labels.notNil.if({
	// 			labels.includes(\red)
	// 			}, {
	// 				false
	// 		})
	// 	};
	// }
	//
	//
	// // from MAbstractKtl:
	//
	// prMatchedElements { |elementKey|
	// 	if ( Main.versionAtLeast( 3.5 ) ){
	// 		^elementsDict.asArray.select{ |elem| elem.name.matchOSCAddressPattern(elementKey) }
	// 	}{
	// 		^elementsDict.asArray.select{ |elem| elementKey.asString.matchRegexp( elem.name.asString ) };
	// 	}
	// }
	//
	// prMatchDo{ |match, elementKey, func|
	// 	if( match ) {
	// 		//match only works on dev versions at the moment.
	// 		this.prMatchedElements(elementKey).do{ |element|
	// 			func.value(element)
	// 		}
	// 	} {
	// 		func.value(elementsDict[elementKey])
	// 	}
	// }
	//
	// removeAllFromElems {
	// 	elementsDict.do( _.reset )
	// }
	//
	// printElementNames{
	// 	(
	// 		"\nElements available for %:\n".format(this.name)
	// 		++ elementsDict.keys.as(Array).sort
	// 		.collect{ |s| s.asString.padRight(14) }
	// 		.clump(4)
	// 		.collect{ |xs| xs.reduce('++') ++ "\n" }
	// 		.reduce('++')
	// 		++ "\n"
	// 	).postln
	// }
	//
	// /*
	// recordRawValue { |key,value|
	// //		recordFunc.value( key, value );
	// }
	// */
	//
	// rawValueAt { |elName|
	// 	if (elName.isKindOf(Collection).not) {
	// 		^elementsDict.at(elName).rawValue;
	// 	};
	// 	^elName.collect { |name| this.rawValueAt(name) }
	// }
	//
	// valueAt { |elName|
	// 	if (elName.isKindOf(Collection).not) {
	// 		^elementsDict.at(elName).value;
	// 	};
	// 	^elName.collect { |name| this.valueAt(name) }
	// }
	//
	// setRawValueAt { |elName, val|
	// 	if (elName.isKindOf(Collection).not) {
	// 		^this.at(elName).rawValue_(val);
	// 	};
	// 	[elName, val].flop.do { |pair|
	// 		elementsDict[pair[0].postcs].rawValue_(pair[1].postcs)
	// 	};
	// }
	//
	// setValueAt { |elName, val|
	// 	if (elName.isKindOf(Collection).not) {
	// 		^this.at(elName).value_(val);
	// 	};
	// 	[elName, val].flop.do { |pair|
	// 		elementsDict[pair[0].postcs].value_(pair[1].postcs)
	// 	};
	// }
	//
	// reset {
	// 	elementsDict.do( _.resetAction )
	// }
	//
	// *prArgToElementKey { |argm|
	// 	//argm is either a symbol, a string or an array
	// 	^switch( argm.class)
	// 	{ Symbol }{ argm }
	// 	{ String }{ argm.asSymbol }
	// 	{ (argm[..(argm.size-2)].inject(
	// 		"",
	// 		{ |a,b| a++b.asString++"_"}).asSymbol ++ argm.last.asString).asSymbol
	// 	}
	// }
	//
	// send { |key, val|
	// 	if ( mktlDevice.notNil ){
	// 		mktlDevice.send( key, val );
	// 	}
	// }
}
