/* honouring Jeff's MKeys by keeping the M for prototyping the new Ktl

MKtl works as follows:

* MKtl.find discovers hardware devices currently available

* MKtlDesc load or make an MKtlDesc for the one that should be opened

*  make MKtlElement from MKtlDesc.elementsDesc in multiple flavors:
- elements      * hierarchical, = MKtlElementGroup
- elementsDict  * flat for fast access by element key
// - elementsArray * by pairs, needed somewhere?

* makeDevice
- if matching hardware is present, make mktlDevice, and open it
- else this becomes a virtual MKtl which can do everything the
-   real device

*/


MKtl { // abstract class

	classvar <all; 			// holds all instances of MKtl
	classvar <globalSpecs; 	// dict with all default specs used in MKtls

	var <name;
	// an MKtlDesc that has all known information about the hardware device(s)
	// contained in this MKtl.
	var <desc;
	var <specs;

	var <elements;			// all elements in ElementGroup in hierarchical order
	var <elementsDict; 		// all elements in a single flat dict for fast access

	var <collectivesDict; 	// has the collectives (combined elements and groups)
	// from the device description

	var <mktlDevice; // interface to the connected device(s).

	var <traceRunning = false;
	var <lookupName, <lookupInfo;

	*initClass {
		Class.initClassTree(Spec);
		all = ();
		globalSpecs = ().parent_(Spec.specs);
		this.prAddDefaultSpecs();
	}

	*find { |protocols|
		MKtlDevice.find( protocols, false);
		MKtl.postPossible(protocols);
	}

	*postPossible { |protocols|
		"\n-----------------------------------------------------".postln;
		MKtlDevice.subFor(protocols).do(_.postPossible);
		"\n-----------------------------------------------------".postln;
	}

	// prefix is typically protocol
	*makeLookupName {|prefix, id, prodName|
		prodName = prodName.asString.collect { |c|
			if (c.isAlphaNum, c.toLower, $_);
		};
		while { prodName.contains("__") } {
			prodName = prodName.replace("__", "_");
		};
		^"%_%_%".format(prefix, id, prodName).asSymbol
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
		this.addSpec(\midiProgram, [0, 127, \lin, 1, 0]);
		this.addSpec(\midiBend, [0, 16383, \lin, 1, 8192]);
		// HID
		this.addSpec(\mouseAxis, [0.4,0.6, \lin, 0, 0.5]);
		this.addSpec(\mouseWheel, [0.4,0.6, \lin, 0, 0.5]);

		this.addSpec(\hidBut, [0, 1, \lin, 1, 0]);
		this.addSpec(\hidHat, [0, 1, \lin, 1, 0]);
		// // these are often wrong, check for device.
		// this.addSpec(\compass8, [0, 8, \lin, 1, 1]);

		this.addSpec(\cent1,  [0, 1, \lin, 0, 0.5].asSpec);
		this.addSpec(\cent1inv,  [1, 0, \lin, 0, 0.5].asSpec);

	}

	// interface for specs
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

	// interface to MKtlDesc:

	*descFolders { ^MKtlDesc.descFolders }
	*openDescFolder { |index = 0| MKtlDesc.openFolder(index) }
	*postLoadableDescs { MKtlDesc.postLoadable }
	*postLoadedDescs { MKtlDesc.postLoaded }

	*loadDescsMatching { |filename, folderIndex |
		^MKtlDesc.loadDescs(filename, folderIndex);
	}

	// creation:
	// new returns existing instances that exist in .all,
	// or returns a new empty instance.
	// If no physcal device is present, this becomes a virtual MKtl.

	*new { |name, lookupNameOrDesc, lookForNew = false |
		var res, lookupName, lookupInfo, descName, newMKtlDesc, protocol;

		if (name.isNil) {
			"%: please specify name.".format(this).inform;
			^nil;
		};

		res = this.all[name];

		if (res.isNil and: { lookupNameOrDesc.isNil }) {
			"%(%): not instantiated yet.\n"
			"Please specify lookupName or desc filename.".format(this, name).inform;
			^nil;
		};

		// we found an MKtl, and we do not rebuild from *new,
		// so this is usually just access
		if (res.notNil) {
			res.checkIdentical(lookupNameOrDesc);
			^res
		};

		// prepare for several options:
		// symbol -> lookupName,
		// string -> filename,
		// desc -> desc,
		// dict -> make desc from dict

		lookupNameOrDesc.class.switch(
			Symbol, {
				MKtlDevice.initHardwareDevices;
				lookupName = lookupNameOrDesc;
				lookupInfo = MKtlLookup.all[lookupName];
				if (lookupInfo.notNil) {
					protocol = lookupInfo.protocol;
					newMKtlDesc = lookupInfo.desc ?? {
						MKtlDesc(lookupInfo.filename);
					};
				};
			},
			// filename
			String, {
				descName = lookupNameOrDesc;
				newMKtlDesc = MKtlDesc(descName);
				protocol = newMKtlDesc.protocol;
				MKtlDevice.initHardwareDevices(false, protocol);
			},
			MKtlDesc, { newMKtlDesc = lookupNameOrDesc },
			{
				//  or is it a dictionary we can make a desc from
				if (MKtlDesc.isValidDescDict(lookupNameOrDesc)) {
					lookupNameOrDesc.put(\filename, name);
					newMKtlDesc = MKtlDesc.fromDict(lookupNameOrDesc);
					protocol = newMKtlDesc.protocol;
				};
			}
		);

		// "lookupName: %, descName: %, lookupInfo: %\n".postf(lookupName, descName, lookupInfo);
		// "proto: %, newDesc: %\n".postf(protocol, newMKtlDesc);

		// else try to make a desc from lookup info:

		if (MKtl.descIsFaulty(newMKtlDesc)) {
			inform("%(%): could not find a valid desc,\n"
				"trying to derive from hardware...".format(this, name));
		};

		// now we have a name and a good enough desc
		^super.newCopyArgs(name).init(newMKtlDesc, lookupName, lookupInfo, lookForNew );
	}

	checkIdentical { |lookupNameOrDesc|
		var newLookupInfo;
		if (lookupNameOrDesc.isNil) { ^true };
		if (lookupNameOrDesc.isKindOf(String)
			and: { this.desc.notNil
				and: { this.desc.fullDesc.filename == lookupNameOrDesc } }) {
			^true
		} {
			inform("%: To change my desc,"
				"use %.rebuild(<desc>);".format(this, this));
			^false
		};


		if (lookupNameOrDesc.isKindOf(Symbol)) {
			newLookupInfo = MKtlLookup.all.at(lookupNameOrDesc);
			if (newLookupInfo.isNil) {
				// no lookupInfo found, so ignored.
				^false
			};

			if (this.desc.notNil and: { this.desc.idInfo == lookupInfo.idInfo }) {
				// yes, identical, so ignored
				^true
			} {
				inform("// %: If you want to change the desc,"
				" use %.rebuild( _newdesc_ );".format(this, this));
				^false
			};
		};
	}

	// interface to desc:

	*descIsFaulty { |argDesc|
		^argDesc.isKindOf(MKtlDesc).not or:
		{ argDesc.fullDesc.isNil }
	}

	name_ { |inname|
		if (inname.notNil) {
			all.removeAt(name);
			name = inname.asSymbol;
			all.put(name, this);
		}
	}

	storeArgs { ^[name] }
	printOn { |stream| this.storeOn(stream) }

	init { |argDesc, argLookupName, argLookupInfo, lookForNew = false|
		var specsFromDesc;

		desc = argDesc;
		lookupName = argLookupName;
		lookupInfo = argLookupInfo;

		all.put(name, this);

		specsFromDesc = desc.fullDesc[\specs];
		specs = ();
		if (specsFromDesc.notNil) {
			specsFromDesc.keysValuesDo { |key, val|
				specsFromDesc.put(key, val.asSpec);
			};
			specsFromDesc.parent_(globalSpecs);
			specs.parent_(specsFromDesc);
		} {
			specs.parent_(globalSpecs);
		};

		elementsDict = ();

		if (desc.isNil) {
			inform(
				"%:init - no desc given, cannot\n"
				"open device or make elements and collectives.".format(this)
			);
			^this
		};

		this.makeElements;
		this.makeCollectives;
		this.openDevice( lookForNew );
	}

	updateLookupInfo { |newInfo|
		lookupInfo = newInfo;
		lookupName = lookupInfo.lookupName;
	}

	initialisationMessages {
		if ( desc.isNil or: { desc.fullDesc.isNil }) { ^nil };
		^desc.fullDesc[\initialisationMessages];
	}


	/*
	init procedure:

	- make both elements and elementsDict from MKtlDesc.elementsDesc

	- flattenDescription on each element
	- substitute each spec in the element for the real ControlSpec corresponding to it
	- elements
	*/

	makeElements {

		elementsDict = ();

		// array of dicts of arrays
		elements = desc.elementsDesc.traverseCollect(
			doAtLeaf: { |desc, deepKeys|
				var deepName = deepKeys.join($_).asSymbol;
				var element = MKtlElement(deepName, desc, this);
				elementsDict.put(deepName, element);
			element; },
			isLeaf: MKtlDesc.isElementTestFunc
		);

		// elements.keys.postcs;
		MKtlElement.addGroupsAsParent = true;

		if (elements.notEmpty) {
			this.wrapCollElemsInGroups(elements);
		};
		elements = MKtlElementGroup(this.name, elements);

		MKtlElement.addGroupsAsParent = false;
	}

	wrapCollElemsInGroups { |elemOrColl|
	//	"\n *** wrapCollElemsInGroups: ***".postln;

		if (elemOrColl.isNil) { ^elemOrColl };

		if (elemOrColl.isKindOf(MKtlElement)) {
			^elemOrColl
		};

		elemOrColl.valuesKeysDo { |elem, keyIndex, i|
			var changedElem;
			if (elem.isKindOf(Collection)) {
				this.wrapCollElemsInGroups(elem);
				changedElem = MKtlElementGroup(keyIndex, elem);
				if (elemOrColl.isAssociationArray) {
					elemOrColl.put(i, keyIndex -> changedElem);
				} {
					elemOrColl.put(keyIndex, changedElem);
				};
			};
		};
	//	"*** wrapCollElemsInGroups: ***\n".postln;
	}

	makeCollectives {
		if( desc.fullDesc[ \collectives ].notNil ) {
			collectivesDict = ();
			desc.fullDesc[ \collectives ].keysValuesDo({ |key, value|
				collectivesDict[ key ] =
				MKtlElementCollective( this, key, value );
			})
		};
 	}

	collectiveDescriptionFor { |elname|
		^desc.fullDesc[ \collectives ] !?
		{ desc.fullDesc[ \collectives ][ elname ]; };
	}

	// already filtered for my platform only
	elementNames {
		^elementsDict.keys(SortedList).array;
	}

	postElements {
		var postOne = { |elemOrGroup, index, depth = 0|
			if (elemOrGroup.isKindOf(MKtlElementGroup)) {
				depth.do { $\t.post; };
				"Group: ".post; elemOrGroup.name.postln;
				elemOrGroup.do({ |item, i| postOne.value(item, i, depth + 1) });
			} {
				depth.do { $\t.post; };
				elemOrGroup.name.postln;
			};
		};
		"/////// % .postElements : //////\n".postf(this);
		postOne.value(elements);
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
			elementsDict[pair[0]].deviceValue_(pair[1])
		};
	}

	setValueAt { |elName, val|
		if (elName.isKindOf(Collection).not) {
			^this.at(elName).value_(val);
		};
		[elName, val].flop.do { |pair|
			elementsDict[pair[0]].value_(pair[1])
		};
	}

	reset {
		elementsDict.do( _.resetAction )
	}

	// get subsets of elements ---------

	elementsOfType { |type|
		^elementsDict.select { |elem|
			elem.elemDesc[\type] == type
		}
	}

	elementsNotOfType { |type|
		^elementsDict.select { |elem|
			elem.elemDesc[\type] != type
		}
	}

	inputElements {
		^elementsDict.select { |elem|
			[ \in, \inout ].includes( elem.elemDesc[\ioType] ?? \in);
		}
	}

	outputElements {
		^elementsDict.select { |elem|
			[ \out, \inout ].includes( elem.elemDesc[\ioType] ?? \in);
		}
	}

	// allElements { // unneeded
	// 	^elementsDict.asArray
	// }

	elementsLabeled { |label|
		var labels;

		^elementsDict.select {|elem|
			labels = elem.elemDesc[\labels];
			labels.notNil.if({
				labels.includes(label)
				}, {
					false
			})
		};
	}

	prMatchedElements { |elementKey|
		if ( Main.versionAtLeast( 3.5 ) ){
			^elementsDict.select { |elem|
				elem.name.matchOSCAddressPattern(elementKey)
			}.asArray
		}{
			^elementsDict.select { |elem|
				elementKey.asString.matchRegexp( elem.name.asString )
			}.asArray;
		}
	}

		// new desc, so decommission everything,
	// remake elements from new desc,
	// close mktldevice if there and try to open a new one


	rebuild { |descNameOrDict| // could be a string/symbol or dictionary
		var newDesc;
		// always replace desc,
		// if none given, rebuild from existing:
		if (descNameOrDict.isNil) {
			newDesc = desc;
		} {
			if (descNameOrDict.isKindOf(String)) {
				newDesc = MKtlDesc(descNameOrDict);
			};
			if (descNameOrDict.isKindOf(Dictionary)) {
				descNameOrDict.put(\filename, name);
				newDesc = MKtlDesc.fromDict(descNameOrDict);
			};
		};

		// close old device
		if (mktlDevice.notNil) {
			mktlDevice.closeDevice;
			mktlDevice.cleanupElementsAndCollectives;
			mktlDevice = nil;
		};
		desc = newDesc;
		this.init(desc);
		this.changed( \elements );
	}



		// ------ make MKtlDevice and interface with it

	openDevice { |lookAgain=true|
		var protocol;
		if ( this.mktlDevice.notNil ) {
			"%: Device already opened.\n"
			"Please close it first with %.closeDevice;\n"
			.format(this, this).warn;

			^this;
		};

		// this may be an issue, only look for appropriate protocol
		protocol = desc !? { desc.protocol };
		MKtlDevice.initHardwareDevices( lookAgain, protocol);

		mktlDevice = MKtlDevice.open( this.name, this );
		if(this.hasDevice.not) {
			inform("%.openDevice: remaining virtual.".format(this));
		}
	}

	hasDevice {
		^mktlDevice.notNil
	}

	trace { |value=true|
		this.hasDevice;
		if ( this.hasDevice ){ mktlDevice.trace( value ) };
		traceRunning = value;
	}

	closeDevice {
		if ( mktlDevice.isNil ){ ^this };
		mktlDevice.closeDevice;
	}

	specialMessageNames { ^desc.specialMessageNames }
	sendSpecialMessage { |name|
		^mktlDevice.sendSpecialMessage(name);
	}

	send { |key, val|
		if ( mktlDevice.isNil ){ ^this };
		mktlDevice.send( key, val );
	}

		// observe mktlDevice to create a description file
	explore { |mode=true|
		if ( mktlDevice.isNil ){
			"% is virtual, nothing to explore\n"
			.format( this ).inform;

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
			"% is virtual, cannot create description file\n"
			.format( this ).inform;

			^this
		};
		mktlDevice.createDescriptionFile;
	}

	free {
		this.closeDevice;
		all.removeAt( name );
	}
}
