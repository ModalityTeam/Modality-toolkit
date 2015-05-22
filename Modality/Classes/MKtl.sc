/* honouring Jeff's MKeys by keeping the M for prototyping the new Ktl

MKtl works as follows:

* MKtl.find discovers hardware devices currently available

* MKtlDesc is asked to load or make an MKtlDesc for the one that should be opened

* make elements from MKtlDesc elementsDesc in 2 flavors
- hierarchical : elements = MKtlElementGroup
- flat : elementsDict
* makeDevice
- if hardware present make mktlDevice, and open it
- else this is a virtual MKtl

*/


MKtl { // abstract class

	classvar <all; 			// holds all instances of MKtl
	classvar <globalSpecs; 	// dict with all default specs used in MKtls

	var <name;
	// an MKtlDesc that has all known information about the hardware device(s)
	// contained in this MKtl.
	var <desc;
	var <specs;

	var <elements;			// an ElementGroup with all elements in hierarchical order
	var <elementsDict; 		// all elements in a single flat dict for fast lookup

	var <collectivesDict; 	// contains the collectives that are in the device description

	// an array of keys and values with a description of all the elements on the device.
	// generated from the hierarchical description read from the file.
	// used for filling the elementsDict.
	var <flatElementDescList;

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

	/////////// everything related to specs
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

	addSpec {|key, spec|
		this.addLocalSpec(key, spec)
	}

	addLocalSpec {|key, spec|
		var theSpec;

		// is it in MKtl.spec?
		if (spec.isKindOf(Symbol)) {
			theSpec = globalSpecs[spec];
		};
		if (theSpec.isNil) { // no, it's not...
			theSpec = spec.asSpec; // convert spec via standard method
		};

		specs.put(key, theSpec);
	}

	// new returns existing instances that exist in .all,
	// or returns a new empty instance.
	// If no physcal device is present, this becomes a virtual MKtl.

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

		// we found no MKtl, but we have a name or a desc,
		// so we try to make a new MKtl

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

		// now we have a name and hopefully a desc

		^super.newCopyArgs(name).init(desc);
	}

	storeArgs { ^[name] }
	printOn { |stream| this.storeOn(stream) }

	init { |argDesc|
		desc = argDesc;
		if (argDesc.isKindOf(MKtlDesc).not) {
			inform("MKtl: desc is not valid yet.");
		};
		// FIXME : how to count up for multiple devices of same type?
		all.put(name, this);
		specs = ().parent_(globalSpecs);

		elementsDict = ();
	}

		// temp redirect for other classes
	deviceDescriptionArray { ^desc.elementsDesc }

	// new desc, so decommission everything,
	// remake elements from new desc,
	// close mktldevice if there and try to open a new one

	rebuildFrom { |deviceDescriptionNameOrDict| // could be a string/symbol or dictionary
		// var devDescName, devDesc;
		// if ( deviceDescriptionNameOrDict.isNil ){
		// 	#devDesc, devDescName = this.class.findDeviceDesc( shortName: name );
		// 	if ( devDesc.isNil ){
		// 		this.warnNoDeviceDescriptionFileFound( devDescName );
		// 		^this; // don't change anything, early return
		// 	};
		// }{
		// 	if ( deviceDescriptionNameOrDict.isKindOf( Dictionary ) ){
		// 		devDescName = deviceDescriptionNameOrDict.at( \device );
		// 		devDesc = deviceDescriptionNameOrDict;
		// 	}{
		// 		#devDesc, devDescName = this.class.findDeviceDesc( deviceDescriptionNameOrDict );
		// 	};
		// };
		//
		// if ( mktlDevice.notNil ){
		// 	// check whether new device spec mathces protocol
		// 	if ( devDesc.at( \protocol ) != mktlDevice.class.protocol ){
		// 		"WARNING: MKtl(%): protocol % of device description %, does match protocol % of device %. Keeping the device description as it was.\n".postf( name, devDesc.at( \protocol ), devDescName, mktlDevice.class.protocol, mktlDevice.deviceName );
		// 		^this;
		// 	};
		// 	mktlDevice.cleanupElementsAndCollectives;
		// };
		//
		// this.prInitFromDeviceDescription( devDesc, devDescName );
		// if ( mktlDevice.notNil ){
		// 	mktlDevice.initElements;
		// 	mktlDevice.initCollectives;
		// };
		//
		// this.changed( \elements );
	}


	/*
	init procedure:

	- make both elements and elementsDict from MKtlDesc.elementsDesc

	- flattenDescription on each element
	- substitute each spec in the element for the real ControlSpec corresponding to it
	-
	*/


	prInitFromDeviceDescription { |devDesc, devDescName|
		// remake elementsDict;
	//	this.makeElements;
		( "Created MKtl:" + name + "using device description" + desc ).postln;
	}


	prLoadDeviceDescription { |deviceInfo|
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
	// 		deviceInfo[\specs].keysValuesDo {|key, spec|
	// 			this.addLocalSpec(key, spec); //adding locally
	// 		};
	// 	});
	//
	//
	// 	desc.elementsDict = deviceInfo[\description]; // TODO: fix name
	// 	deviceDescriptionArray = this.makeFlatDeviceDescription( desc.elementsDict );
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
	}


	prMakeElementsFunc {
		var isLeaf = { |dict|
			dict.keys.includes( \type ) or:
			dict.values.any({|x| x.size > 1}).not
		};

		var f = { |x, state, stateFuncOnNodes, leafFunc|

			if(x.isKindOf(Dictionary) ){
				if( isLeaf.(x) ) {
					leafFunc.( state , x )
				}{
					MKtlElementGroup(state,
						x.sortedKeysValuesCollect{ |val, key|
							f.(val, stateFuncOnNodes.(state, key), stateFuncOnNodes, leafFunc )
						}
					)
				}
			} {
				if(x.isKindOf(Array) ) {
					MKtlElementGroup(state,
						x.collect{ |val, i|
							if( val.isKindOf( Association ) ) {
								(val.key -> f.(val.value,
									stateFuncOnNodes.(state, val.key),  stateFuncOnNodes, leafFunc )
								)
							} {
								f.(val, stateFuncOnNodes.(state, i),  stateFuncOnNodes, leafFunc )
							};
						}
					);
				} {
					Error("MKtl:prTraverse Illegal data structure in device description.\nGot object % of type %. Only allowed objects are Arrays and Dictionaries".format(x,x.class)).throw
				}
			}

		};
		^f
	}

	makeElements {
		var leafFunc;
		elementsDict = ();
		this.elementNames.do {|key|
			elementsDict[key] = MKtlElement(this, key);
		};
		leafFunc = { |finalKey, x| elementsDict[finalKey.asSymbol] };
		MKtlElement.addGroupsAsParent = true;
		elements = this.prMakeElementsFunc.(desc.elementsDict, "", this.prUnderscorify, leafFunc );
		MKtlElement.addGroupsAsParent = false;
	}

	// needed for fixing elements that are not present for a specific OS
	prReplaceElementsDict { |newElemDict|
		elementsDict = newElemDict;
	}
	// same as underScorify?
	makeElementName { |args|
		var n = args.size;
		^(args[..n-2].collect({ |x| x.asString++"_"}).reduce('++')++args.last).asSymbol
	}

	*prArgToElementKey { |argm|
		//argm is either a symbol, a string or an array
		^switch( argm.class)
		{ Symbol }{ argm }
		{ String }{ argm.asSymbol }
		{ (argm[..(argm.size-2)].inject(
			"",
			{ |a,b| a++b.asString++"_"}).asSymbol ++ argm.last.asString).asSymbol
		}
	}

	// should filter: those for my platform only
	elementNames {
		// if ( elementsDict.isEmpty ){
		// 	^(0, 2 .. deviceDescriptionArray.size - 2).collect (deviceDescriptionArray[_])
		// }{
		// 	^elementsDict.keys.asArray;
		// }
	}

	elementAt { |...args|
		^elements.deepAt(*args)
	}

	at { |index|
		^elements.at( index );
	}

		//////////////// interface to elements:
	deviceValueAt { |elName|
		if (elName.isKindOf(Collection).not) {
			^elementsDict.at(elName).deviceValue;
		};
		^elName.collect { |name| this.deviceValueAt(name) }
	}

	valueAt { |elName|
		if (elName.isKindOf(Collection).not) {
			^elementsDict.at(elName).value;
		};
		^elName.collect { |name| this.valueAt(name) }
	}

	setDeviceValueAt { |elName, val|
		if (elName.isKindOf(Collection).not) {
			^this.at(elName).deviceValue_(val);
		};
		[elName, val].flop.do { |pair|
			elementsDict[pair[0].postcs].deviceValue_(pair[1].postcs)
		};
	}

	setValueAt { |elName, val|
		if (elName.isKindOf(Collection).not) {
			^this.at(elName).value_(val);
		};
		[elName, val].flop.do { |pair|
			elementsDict[pair[0].postcs].value_(pair[1].postcs)
		};
	}

	reset {
		elementsDict.do( _.resetAction )
	}

	// get subsets of elements ---------

	elementsOfType { |type|
		^elementsDict.select { |elem|
			elem.elementDescription[\type] == type
		}
	}

	elementsNotOfType { |type|
		^elementsDict.select { |elem|
			elem.elementDescription[\type] != type
		}
	}

	inputElements {
		^elementsDict.select { |elem|
			[ \in, \inout ].includes( elem.elementDescription[\ioType] ?? \in);
		}
	}

	outputElements {
		^elementsDict.select { |elem|
			[ \out, \inout ].includes( elem.elementDescription[\ioType] ?? \in);
		}
	}

	allElements {
		^elementsDict.asArray
	}

	elementsLabeled { |label|
		var labels;

		^elementsDict.select{|elem|
			labels = elem.elementDescription[\labels];
			labels.notNil.if({
				labels.includes(label)
				}, {
					false
			})
		};
	}

	prMatchedElements { |elementKey|
		if ( Main.versionAtLeast( 3.5 ) ){
			^elementsDict.asArray.select { |elem|
				elem.name.matchOSCAddressPattern(elementKey)
			}
		}{
			^elementsDict.asArray.select{ |elem|
				elementKey.asString.matchRegexp( elem.name.asString )
			};
		}
	}



		// ------ make MKtlDevice and interface with it

	openDevice { |lookAgain=true|

		if ( this.mktlDevice.notNil ){
			"WARNING: Already a device opened for %.\n"
			"Please close it first with %.closeDevice;\n".postf(this, this);
			^this;
		};
		// this may be an issue, only look for appropriate protocol
		MKtlDevice.initHardwareDevices( lookAgain, desc.protocol.bubble );
	// 	this.prTryOpenDevice( this.name, desc.descDict );
	}

	isVirtual { ^mktlDevice.isNil }

	trace { |value=true|
		if (this.isVirtual.not){ mktlDevice.trace( value ) };
		traceRunning = value;
	}

	prTryOpenDevice { |devName| // devName is a shortname
		// var newMKtlDevice;
		//
		// newMKtlDevice = MKtlDevice.tryOpenDevice( devName, this );
		// if ( newMKtlDevice.isNil ){
		// 	// maybe I gave a funky name, and can find the device from the spec
		//
		// 	devName = MKtlDevice.findDeviceShortNameFromLongName( desc.device );
		// 	if ( devName.notNil ){
		// 		newMKtlDevice = MKtlDevice.tryOpenDevice( devName, this );
		// 	}{
		// 		newMKtlDevice = MKtlDevice.tryOpenDeviceFromDesc(
		// 		name, desc.protocol, desc.device, this );
		// 		devName = name;
		// 	};
		// };
		//
		// if ( newMKtlDevice.notNil ){
		// 	// cross reference:
		// 	mktlDevice = newMKtlDevice;
		// 	"Opened device % for MKtl(%)\n".postf( devName, name );
		// }{
		// 	"WARNING: Could not open device for MKtl(%)\n".postf( name );
		// };
	}

	closeDevice {
		if ( mktlDevice.isNil ){ ^this };
		mktlDevice.closeDevice;
	}

	send { |key, val|
		if ( mktlDevice.isNil ){ ^this };
		mktlDevice.send( key, val );
	}

		// observe mktlDevice to create a description file
	explore { |mode=true|
		if ( mktlDevice.isNil ){
			"MKtl(%) has no open device, nothing to explore\n".postf( name );
			^this
		};
		mktlDevice.explore( mode );
	}

	exploring {
		if ( mktlDevice.isNil ){ ^false };
		^mktlDevice.exploring;
	}

	createDescriptionFile {
		if ( mktlDevice.isNil ){
			"MKtl(%) has no open device, cannot create description file\n".postf( name );
			^this
		};
		mktlDevice.createDescriptionFile;
	}

	free {
		this.closeDevice;
		all.removeAt( name );
	}
}
