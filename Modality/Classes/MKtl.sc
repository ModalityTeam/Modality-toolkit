/* honouring Jeff's MKeys by keeping the M for prototyping the new Ktl

MKtl works as follows:

* MKtl.find discovers hardware devices currently available

* MKtlDesc load or make an MKtlDesc for the one that should be opened

*  make MKtlElement from MKtlDesc.elementsDesc in multiple flavors:
- elements      * hierarchical, = MKtlElementGroup
- elementsDict  * flat for fast lookup by element key
- elementsArray * by pairs, needed somewhere?

* makeDevice
- if matching hardware is present, make mktlDevice, and open it
- else this becomes a virtual MKtl which can do everything the
-   real device

*/


MKtl { // abstract class

	classvar <all; 			// holds all instances of MKtl
	classvar <globalSpecs; 	// dict with all default specs used in MKtls
	classvar <>makeLookupNameFunc;

	var <name;
	// an MKtlDesc that has all known information about the hardware device(s)
	// contained in this MKtl.
	var <desc;
	var <specs;

	var <elements;			// an ElementGroup with all elements in hierarchical order
	var <elementsDict; 		// all elements in a single flat dict for fast lookup
	var <elementsArray;

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

		makeLookupNameFunc = { |string|
			(string.asString.toLower.select{|c| c.isAlpha && { c.isVowel.not }}.keep(4)
			++ string.asString.select({|c| c.isDecDigit}))
		}
	}

	*makeLookupName {|string| ^makeLookupNameFunc.(string); }

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

	*addSpec {|key, spec| globalSpecs.put(key, spec.asSpec) }
	addSpec {|key, spec| this.addLocalSpec(key, spec) }
	*getSpec { |key| ^globalSpecs[key] }
	getSpec { |key| ^specs[key] }

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
		desc.postln;

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

		// FIXME : how to count up for multiple devices of same type?
		all.put(name, this);
		specs = ().parent_(globalSpecs);
		elementsDict = ();

		if (argDesc.isKindOf(MKtlDesc).not) {
			inform(this.cs ++ "has no valid description yet, so cannot initialise.");
			^this
		};
		this.makeElements;
		this.makeCollectives;

		// this.openDevice;
	}

		// temp redirect for other classes
	deviceDescriptionArray { ^desc.elementsDesc }

	initialisationMessages {
		^desc.fullDesc[\initialisationMessages];
	}

	/*
	init procedure:

	- make both elements and elementsDict from MKtlDesc.elementsDesc

	- flattenDescription on each element
	- substitute each spec in the element for the real ControlSpec corresponding to it
	-
	*/

	makeElements {

		// addGroupsAsParent really needed?
		MKtlElement.addGroupsAsParent = true;

		elementsArray = [];
		elementsDict = ();

		elements = desc.elementsDesc.traverseCollect({ |desc, deepKeys|
			var deepName = deepKeys.join($_).asSymbol;
			var element = MKtlElement(deepName, desc, this);

			elementsArray = elementsArray ++ [deepName, desc];
			elementsDict.put(deepName, element);
			element;
		}, MKtlDesc.isElementTestFunc);

		MKtlElement.addGroupsAsParent = false;

	}

	makeCollectives {
		if( desc.fullDesc[ \collectives ].notNil ) {
			collectivesDict = ();
			desc.fullDesc[ \collectives ].keysValuesDo({ |key, value|
				collectivesDict[ key ] = MKtlElementCollective( this, key, value );
			})
		};
 	}

	collectiveDescriptionFor { |elname|
		^desc.fullDesc[ \collectives ] !? { |x| desc.fullDesc[ \collectives ][ elname ]; };
	}

	// already filtered for my platform only
	elementNames {
		var arr = [];
		elements.traverseDo({ |el|
			arr = arr.add(el.name);
		}, MKtlDesc.isElementTestFunc);
		^arr;
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

		// new desc, so decommission everything,
	// remake elements from new desc,
	// close mktldevice if there and try to open a new one


	rebuildFrom { |deviceDescriptionNameOrDict| // could be a string/symbol or dictionary
		var newDesc;
		// replace desc if new:
		if (deviceDescriptionNameOrDict.isNil) {
			newDesc = desc;
		} {
			newDesc = MKtlDesc(deviceDescriptionNameOrDict)
		};

		// close old device
		if (mktlDevice.notNil) {
			mktlDevice.close;
			mktlDevice.cleanupElementsAndCollectives;
		};

		this.init(desc);
		// this.changed( \elements );
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
	 	this.prTryOpenDevice( this.name, desc.fullDesc );
	}

	isVirtual { ^mktlDevice.isNil }

	trace { |value=true|
		if (this.isVirtual.not){ mktlDevice.trace( value ) };
		traceRunning = value;
	}

	findAndOpenDevice { |devName| // devName is a shortname
		var newMKtlDevice = MKtlDevice.tryOpenDevice( devName, this );
		if ( newMKtlDevice.isNil ){

			// maybe I gave a funky name, and can find the device from the spec
			devName = MKtlDevice.findDeviceShortNameFromLongName( desc.device );
			if ( devName.notNil ){
				newMKtlDevice = MKtlDevice.tryOpenDevice( devName, this );
			}{
				newMKtlDevice = MKtlDevice.tryOpenDeviceFromDesc(
				name, desc.protocol, desc.device, this );
				devName = name;
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
