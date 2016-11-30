/* honouring Jeff's MKeys by keeping the M for prototyping the new Ktl

MKtl works as follows:

* MKtl.find discovers hardware devices currently available

* MKtlDesc loads or makes an MKtlDesc for the one that should be opened

*  make MKtlElement from MKtlDesc.elementsDesc in multiple flavors:
- elementGroup      * hierarchical, = MKtlElementGroup
- elementsDict  * flat for fast access by element key

* make MKtl.device
- if matching hardware is present, make device, and open it
- else this becomes a virtual MKtl which does all the real device does

*/


MKtl { // abstract class

	classvar <all; 			// holds all instances of MKtl
	classvar <globalSpecs; 	// dict with all default specs used in MKtls

	var <name;
	// an MKtlDesc that has all known information about the hardware device(s)
	// contained in this MKtl.
	var <desc;
	var <specs;

	var <elementGroup;			// all elements in ElementGroup in hierarchical order
	var <elementsDict; 		// all elements in a single dict for fast access
	var <namedDict;

	var <collectivesDict; 	// has the collectives (combined elements and groups)
	// from the device description

	var <device; // interface to the connected device(s).

	var <traceRunning = false;
	// used to find its info in MKtlLookup:
	var <lookupName, <lookupInfo;

	*protocols   { ^MKtlDevice.allProtocols }
	*deviceTypes { ^MKtlDevice.deviceTypes }
	*elementTypesUsed { ^MKtlElement.elementTypesUsed }

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
		this.addSpec(\cent1023,  [0, 1023, \lin, 1, 512]);
		this.addSpec(\cent1,  [0, 1, \lin, 0, 0.5]);
		this.addSpec(\lin1inv,  [1, 0, \lin, 0, 1]);
		this.addSpec(\lin1,  [0, 1, \lin, 0, 1]);
		this.addSpec(\but,  [0, 1, \lin, 1, 0]);
		this.addSpec(\trigger,  [0, 1, \lin, 1, 1]);

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

	*new { |name, lookupNameOrDesc, lookForNew = false, multiIndex |
		var res, lookupName, lookupInfo, descName, newMKtlDesc, protocol;

		if (name.isNil) {
			"%: please specify name.".format(thisMethod).inform;
			^nil;
		};

		res = this.all[name];

		if (res.isNil and: { lookupNameOrDesc.isNil }) {
			"%(%): not instantiated yet.\n"
			"Please specify lookupName or desc filename."
				.format(this, name.cs).inform;
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
				lookupName = lookupNameOrDesc;
				lookupInfo = MKtlLookup.all[lookupName];
				if (lookupInfo.isNil) {
					MKtlDevice.initHardwareDevices;
					lookupInfo = MKtlLookup.all[lookupName];
					if (lookupInfo.isNil) {
						"%: could not find device for key %,"
						" cannot create MKtl(%)!\n"
						.postf(thisMethod, lookupNameOrDesc, name);
						^nil
					}
				};
				if (lookupInfo.notNil) {
					protocol = lookupInfo.protocol;
					newMKtlDesc = lookupInfo.desc ?? {
						lookupInfo.filename !? {
							MKtlDesc(lookupInfo.filename);
						};
					};
				};
			},
			// filename
			String, {
				descName = lookupNameOrDesc;
				newMKtlDesc = MKtlDesc(descName);
				if (newMKtlDesc.isKindOf(MKtlDesc).not) {
					"% : newMKtlDesc is nil, cannot make MKtl named %.\n"
					.postf(thisMethod, name.cs);
					^nil
				};
				protocol = newMKtlDesc.protocol;
				MKtlDevice.initHardwareDevices(false, protocol);
			},
			MKtlDesc, { newMKtlDesc = lookupNameOrDesc },
			{
				//  or is it a dictionary we can make a desc from?
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
			inform("MKtl( % ) - desc not valid: %."
				.format(name.cs, newMKtlDesc)
			);
		};

		// assume that now we have a name
		// and hopefully a good enough desc
		^super.newCopyArgs(name)
		.init(newMKtlDesc, lookupName, lookupInfo,
			lookForNew, multiIndex );
	}

	checkIdentical { |lookupNameOrDesc|
		var newLookupInfo;
		if (lookupNameOrDesc.isNil) { ^true };
		if (lookupNameOrDesc.isKindOf(String)
			and: { this.desc.notNil
				and: { this.desc.fullDesc.filename
					== lookupNameOrDesc }
		}) {
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

			if (this.desc.notNil and: {
				this.desc.idInfo == lookupInfo.idInfo
			}) {
				// yes, identical, so ignored
				^true
			} {
				inform("%: To change my desc,"
					"use %.rebuild(<desc>);".format(this, this));
				^false
			};
		};
	}

	// interface to desc:
	// could be a more precise integrity test
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

	init { |argDesc, argLookupName, argLookupInfo, lookForNew = false, multiIndex|
		var specsFromDesc;

		desc = argDesc;
		lookupName = argLookupName;
		lookupInfo = argLookupInfo;

		if(desc.notNil and: { desc.fullDesc.notNil }) {
			specsFromDesc = desc.fullDesc[\specs];
		};

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

		// only put in all if everything worked
		all.put(name, this);

		this.finishInit(lookForNew, multiIndex); // and finalise init
	}

	finishInit { |lookForNew, multiIndex|
		if (desc.isNil) {
			"%: no desc given, cannot create elements..."
				.format(thisMethod).inform;
			// "// Maybe you want to explore this device with:\n"
			// "%.explore;\n".postf(this);
		} {
			namedDict = ();
			this.makeElements;
			this.makeCollectives;
		};
		this.openDevice( lookForNew, multiIndex );
	}

	addNamed { |name, group|
		namedDict.put(name, group);
	}

	updateLookupInfo { |newInfo|
		lookupInfo = newInfo;
		lookupName = lookupInfo.lookupName;
	}

	enable { |sync = true|
		device !? {
			device.enable;
			if (sync) { this.sync }
		}
	}

	sync {
		// if MKtl has outputs back to the device,
		// this sends values out to adjust motor faders, lights etc
		elementsDict.do { |el| el.value_(el.value); }
	}

	disable { device !? { device.disable } }

	// safety fallback for renamed elements -> elementGroup
	elements {
		this.deprecated(thisMethod, Document.findMethod(\elementGroup));
		^elementGroup
	}
	mktlDevice {
		this.deprecated(thisMethod, Document.findMethod(\device));
		^device
	}

	makeElements {
		MKtlElementGroup.addGroupsAsParent = true;
		elementsDict = ();
		elementGroup = MKtlElementGroup.fromDesc(desc.elementsDesc, this);
		MKtlElementGroup.addGroupsAsParent = false;
	}

	makeCollectives {
		collectivesDict = ();
		if( desc.fullDesc[ \collectives ].notNil ) {
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
		"/////// % .postElements : //////\n".postf(this);
		elementGroup.postElements;
	}

	elementAt { |...args|
		^this.elAt(*args)
	}

	collAt { |...args|
		^collectivesDict.deepAt2(*args)
	}

	dictAt { |key| ^elementsDict[key] }

	elAt { |...args|
		^elementGroup.deepAt2(*args)
		?? { namedDict.deepAt2(*args) }
	}

	at { |index|
		^elementGroup.at( index );
	}

	// this is intended to overwrite other pages
	// with the same names in namedDict.
	toFront { |...pageNames|
		elementGroup.elAt(*pageNames).do { |grp|
			this.addNamed (grp.keyInGroup, grp);
		}
	}

	//////////////// interface to elementGroup:
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
			^this.elementsDict[elName].value_(val);
		};
		[elName, val].flop.do { |pair|
			elementsDict[pair[0]].value_(pair[1])
		};
	}

	// interface for presets - uses direct element names only
	getKeysValues { |keys|
		keys = keys ?? { elementsDict.keys(SortedList) };
		^keys.collect { |key| [key, elementsDict[key].value] };
	}

	setKeysValues { |pairs|
		pairs.do { |pair|
			var elem = elementsDict[pair[0]];
			if (elem.notNil) { elem.value_(pair[1]) };
		};
	}

	setKVAction { |pairs|
		pairs.do { |pair|
			var elem = elementsDict[pair[0]];
			if (elem.notNil) { elem.valueAction_(pair[1]) };
		};
	}
	// N/P/Tdef style
	set { |...args|
		args.pairsDo { |elemKey, val|
			var elem = elementsDict[elemKey];
			if (elem.notNil) { elem.value_(val) };
		}
	}

	setAction { |...args|
		args.pairsDo { |elemKey, val|
			var elem = elementsDict[elemKey];
			if (elem.notNil) { elem.valueAction_(val) };
		}
	}


	resetActions {
		elementsDict.do( _.resetAction )
	}
	resetAction {
		"% - please use resetActions.\n".postf(thisMethod);
		this.resetActions;
	}
	reset {
		"% - please use resetActions.\n".postf(thisMethod);
		this.resetActions;
	}


	// get subsets of elements ---------

	elementsOfType { |type|
		^elementsDict.select { |elem|
			elem.elemDesc[\elementType] == type
		}
	}

	elementsNotOfType { |type|
		^elementsDict.select { |elem|
			elem.elemDesc[\elementType] != type
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
	// close mktldevice if there,
	// and try to open a new one
	rebuild { |descNameOrDict, lookAgain, multiIndex| // could be a string/symbol or dictionary
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

		this.closeDevice;

		desc = newDesc;
		this.init(desc, lookForNew: lookAgain, multiIndex: multiIndex);
		this.changed( \elementGroup );
	}



	// ------ make MKtlDevice and interface with it

	openDevice { |lookAgain=true, multiIndex|
		var protocol, foundMatchingDesc;
		if ( this.hasDevice ) {
			"%: Device already opened.\n"
			"Please close it first with %.closeDevice;\n"
			.format(this, this).warn;

			^this;
		};

		// this may be an issue, only look for appropriate protocol
		protocol = desc !? { desc.protocol };
		MKtlDevice.initHardwareDevices( lookAgain, protocol);

		device = MKtlDevice.open( this.name, this, multiIndex );

		if(this.hasDevice.not) {
			inform("%: remaining virtual.".format(thisMethod));
		} {
			// if no desc file, try to match with generic desc
			// this only works for HID:
			// - MIDI does no spec reporting,
			// OSC does not register devices
			if (this.desc.isNil) {
				if (device.source.notNil) {
					if (device.source.isKindOf(HID)) {
						foundMatchingDesc = MKtlDesc.findGenericForHID(device.source);
					};
				};
				if (foundMatchingDesc.notNil) {
					"\nNow adapting desc % : \n\n".postf(foundMatchingDesc.name.cs);
					this.adaptDesc(foundMatchingDesc.name);
				}
			};
			// and if we still have no desc:
			if (this.desc.isNil) {
				"// % : opened device without desc file. \n"
				"// Maybe you want to explore this device?\n".postf(this);
				"%.explore;\n\n".postf(this);
			};
		}
	}

	// for midi - attach MIDI hardware thru idInfo from an MIDI interface port
	openDeviceVia { |idInfo, lookAgain=true, multiIndex|
		if (idInfo.notNil) {
			"%: replacing idInfo: % with: % to openDevice.\n"
			.postf(this, desc.idInfo.cs, idInfo.cs);
			this.desc.fullDesc.put(\idInfo, idInfo);
			this.rebuild(lookAgain: lookAgain, multiIndex: multiIndex);
		};
	}

	// we have the device already, but no desc;
	// we assume we can use a desc like "generic-mouse"
	adaptDesc { |descName|
		var idInfo, genericDesc, newDesc;
		if (device.isNil) {
			warn("% : adaptDesc: no device yet, so cannot adapt desc.".format(this));
			^this
		};
		idInfo = this.device.deviceName;
		genericDesc = MKtlDesc(descName);
		if (genericDesc.isNil) {
			warn("% : adaptDesc: no desc found for %.".format(this, genericDesc));
			^this
		};
		newDesc = genericDesc.deepCopy.idInfo_(idInfo);
		this.rebuild(newDesc);
	}

	hasDevice {
		^device.notNil
	}

	trace { |bool = true|
		if ( this.hasDevice ){ device.trace( bool ) };
		traceRunning = bool;
	}

	closeDevice {
		if ( device.isNil ){ ^this };
		// revisit to make sure this method does not close
		// the lowest-level device when other MKtls share it.
		device.closeDevice;
		device = nil;
	}

	specialMessageNames { ^desc.specialMessageNames }

	specialMessages {
		if ( desc.isNil or: { desc.fullDesc.isNil }) { ^nil };
		^desc.fullDesc[\specialMessages];
	}

	sendSpecialMessage { |name|
		var message = this.specialMessages[name];
		^device.sendSpecialMessage(message);
	}

	send { |key, val|
		if ( device.isNil ){ ^this };
		device.send( key, val );
	}

	// observe device to create a description file
	explore { |bool = true|
		if ( device.isNil ){
			"% is virtual, nothing to explore\n"
			.format( this ).inform;

			^this
		};
		device.explore( bool );
	}

	exploring {
		if ( device.isNil ){ ^false };
		^device.exploring;
	}

	createDescriptionFile {
		if ( device.isNil ){
			"% is virtual, cannot create description file\n"
			.format( this ).inform;

			^this
		};
		device.createDescriptionFile;
	}

	free {
		this.resetActions;
		this.closeDevice;
		elementGroup = elementsDict = nil;
		all.removeAt( name );
	}
}
