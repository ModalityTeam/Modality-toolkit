// honouring Jeff's MKeys by keeping the M for prototyping the new Ktl


MKtl : MAbstractKtl { // abstract class
	classvar <deviceDescriptionFolder; //path of MKtlSpecs folder
	classvar <allDevDescs; // an identity dictionary of device descriptions
	classvar <all; // holds all instances of MKtl
	classvar <specs; // ( 'specName': ControlSpec, ...) -> all specs
	classvar <allAvailable; // ( 'midi': List['name1',... ], 'hid': List['name1',... ], ... )


	classvar <exploring = false;

	// tree structure composed of dictionaries and arrays
	// with a description of all the elements on the device.
	// read from an external file.
	var <deviceDescriptionHierarch;

	// an array of keys and values with a description of all the elements on the device.
	// generated from the hierarchical description read from the file.
	var <deviceDescription;

	var <usedDeviceDescName;
	// var <virtual;

	*initClass {
		Class.initClassTree(Spec);
		all = ();
		allAvailable = ();

		specs = ().parent_(Spec.specs);

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
		this.addSpec(\mouseAxis, [0, 1, \lin, 0, 0.5]);

		this.addSpec(\hidBut, [0, 1, \lin, 1, 0]);
		this.addSpec(\hidHat, [0, 1, \lin, 1, 0]);
		this.addSpec(\compass8, [0, 8, \lin, 1, 1]); // probably wrong, check again!

		this.addSpec(\cent1,  [0, 1, \lin, 0, 0.5].asSpec);
		this.addSpec(\cent1inv,  [1, 0, \lin, 0, 0.5].asSpec);

		deviceDescriptionFolder = this.filenameSymbol.asString.dirname.dirname +/+ "MKtlSpecs";
	}

	*find { |protocols|
		if ( Main.versionAtLeast( 3, 7 ) ){
			protocols = protocols ? [\midi,\hid];
		}{
			protocols = protocols ? [\midi];
		};
		protocols.asCollection.do{ |pcol|
			this.matchClass(pcol) !? _.find
		}
	}

	*addSpec {|key, spec|
		specs.put(key, spec.asSpec);
	}

	*makeShortName {|deviceID|
		^(deviceID.asString.toLower.select{|c| c.isAlpha && { c.isVowel.not }}.keep(4)
			++ deviceID.asString.select({|c| c.isDecDigit}))
	}

	*matchClass { |symbol|
		^this.allSubclasses.detect({ |x| x.protocol == symbol })
	}

	*allDescriptions{
		if(MKtl.allDevDescs.isNil){
			MKtl.loadAllDescs
		};
		^this.prShortnamesToDevices;
	}

	*initHardwareDevices{ |force=false|
		//get available devices
		MIDIMKtl.initMIDI( force );
		if ( Main.versionAtLeast( 3, 7 ) ){
			HIDMKtl.initHID( force );
		};
	}


	*getMatchingDescsForShortname{ |shortName|
		var r,t, descName, namesToDescs;
		t = shortName.asString;
		r = t[..(t.size-2)];
		r = r.asSymbol;
		descName = this.allDescriptions.select{ |val,key| key == r; }.collect{ |it| it };
		namesToDescs = IdentityDictionary.new;
		descName.do{ |dname,key| namesToDescs.put( dname , this.allDevDescs.at( dname ) ) };
		^namesToDescs;
	}

	*findDeviceDescFromShortName{ |shortName|
		var devDescFromShortName, deviceDescName, devDesc;
		devDescFromShortName = this.getMatchingDescsForShortname( shortName );
		if ( devDescFromShortName.size == 0 ){
			^[nil,nil];
		};
		if ( devDescFromShortName.size > 1 ){
			// found more than one device description it matches
			"WARNING: multiple devices descriptions found that match %: , using %\n".postf( name, devDescFromShortName.keys.asArray, devDescFromShortName.keys.asArray.first );
		};
		devDescFromShortName = devDescFromShortName.asKeyValuePairs.clump(2).first;
		deviceDescName = devDescFromShortName[0];
		devDesc = devDescFromShortName[1];
		^[devDesc, deviceDescName];
	}

	*findDeviceDesc{ |deviceDescName, shortName|
		var devDesc;
		if ( deviceDescName.isNil ){
			if ( shortName.isNil ){ ^[nil,nil]; };
			#devDesc, deviceDescName = this.findDeviceDescFromShortName( shortName );
		}{
			if ( deviceDescName.isKindOf( Dictionary ) ){
				devDesc = deviceDescName;
			}{
				// look up deviceDescName in allDescriptions
				devDesc = this.getDeviceDescription( deviceDescName );
			}
		};
		^[devDesc, deviceDescName]
	}

	*newFromDeviceDesc{ |devDesc, deviceDescName, name|
		^this.basicNew( name, deviceDescName, devDesc );
	}

	*findDeviceShortNameFromLongName{ |devLongName|
		var devKey, newDevKey;
		if ( devLongName.isKindOf( String ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( devLongName );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
		if (devLongName.isKindOf( Array ) ){
			this.subclasses.do{ |subClass|
				newDevKey = subClass.findSource( *devLongName );
				if ( newDevKey.notNil ){
					devKey = newDevKey;
				};
			};
			^devKey;
		};
	}

	*newFrom{ |otherMKtl|
		^this.newCopyArgs( otherMKtl.verbose, otherMKtl.name, otherMKtl.elementsDict, otherMKtl.elements, otherMKtl.deviceDescriptionHierarch, otherMKtl.deviceDescription, otherMKtl.usedDeviceDescName );
	}

	// new returns existing instances
	// of subclasses that exist in .all,
	// or returns a new empty instance.
	// this is to allow virtual MKtls eventually.
	*new { |name, deviceDescName, lookForNew = false|
		var matchingProtocols, subClass, return;
		var devDescFromShortName, devDesc;
		var newMKtl;
		var newDeviceDescName;
		var isUnknownDevice = false;
		var longDeviceName;

		// --- generate overview of attached and available description if necessary ---
		if ( name.notNil ){
			// we want to know what is attached if we look with a name
			this.initHardwareDevices( lookForNew );
		};
		this.loadAllDescs( lookForNew ); // will look for deviceDescs

		// --- if name is not given, create one ---
		if ( name.isNil ){
			#devDesc, deviceDescName = this.findDeviceDesc( deviceDescName );
			name = this.makeShortName( deviceDescName ).asSymbol;
			newMKtl = this.newFromDeviceDesc( devDesc, deviceDescName, name );
			^newMKtl;
		};

		if ( name.isKindOf( String ) or: name.isKindOf( Array ) ){
			// name is a string, and thus a long device name
			longDeviceName = name;
			// try and find short name from devices
			name = this.findDeviceShortNameFromLongName( longDeviceName );
		};

		// --- name is given, see if it is there in all: ---
		if ( all[name].notNil ){
			// no deviceDescName given, so just return
			if ( deviceDescName.isNil ){
				^all[name];
			};
			// name exists, check if the desired spec matches, if yes, just return
			if ( deviceDescName.isKindOf( Dictionary ).not ){
				if ( deviceDescName == all[name].usedDeviceDescName ){
					^all[name];
				};
				#devDesc, newDeviceDescName = this.findDeviceDesc( deviceDescName );
				if ( devDesc.notNil ){
					all[name].replaceDeviceDesc( devDesc, newDeviceDescName );
					"MKtl( % ) now has device description %\n".postf( name, deviceDescName );
					^all[name];
				}{ // not succesfull, keeping the old
					"WARNING: Could not change deviceDescription! MKtl( % ) still has device description %\n".postf( name, all[name].usedDeviceDescName );
					^all[name];
				};
			};
		}{
			#devDesc, deviceDescName = this.findDeviceDesc( deviceDescName, name );
			if ( devDesc.isNil ){ // name given, but no devDesc found:
				isUnknownDevice = true;
			};

			if( isUnknownDevice.not ){ // create a virtual device first:
				newMKtl = this.newFromDeviceDesc( devDesc, deviceDescName, name );
			};

			// then see if it is attached:
			matchingProtocols = allAvailable.select(_.includes(name)).keys.as(Array);

			if ( matchingProtocols.size == 0 ){
				// not attached, just return the virtual one if it was found:
				^newMKtl;
			};

			if ( matchingProtocols.size > 1 ){ // more than one matching protocol:
				"WARNING: multiple protocol devices not implemented yet, using %\n".postf( matchingProtocols.first );
			};

			// taking the first:
			matchingProtocols = matchingProtocols.first;
			subClass = MKtl.matchClass(matchingProtocols);
			if( subClass.isNil ){
				"WARNING: MKtl: device not found with name %, and no matching device description found\n".postf( name );
				^nil;
			};
			if( subClass.notNil ) {
				if ( isUnknownDevice ){ // no desc found
					newMKtl = subClass.newWithoutDesc( name );
					this.warnNoDeviceFileFound( name );
					^newMKtl;
				};
				// newMKtl: already an MKtl
				newMKtl = subClass.newFromVirtual( name, newMKtl );
				^newMKtl;
			};
		}
	}

	replaceDeviceDesc{ |devDesc, newDeviceDescName| // could be a string/symbol or dictionary
		// should return true or false, and keep old if no new one found, or not matching protocol
		"TODO: to implement!".warn;
		^false;
	}

	openDeviceFor{ |lookAgain=true|
		var matchingProtocols, subClass, newMKtl;
		var shortName = this.class.makeShortName( usedDeviceDescName );
// TODO: this still needs to look for the trailing numbers!!!
		this.initHardwareDevices( lookAgain );
		// look for device
		matchingProtocols = allAvailable.select(_.includes(name)).keys.as(Array);
		// not attached, just return the virtual one if it was found:
		if ( matchingProtocols.size == 0 ){
			^this;
		};
		// more than one matching protocol:
		if ( matchingProtocols.size > 1 ){
			"WARNING: multiple protocol devices not implemented yet, using %\n".postf( matchingProtocols.first );
		};
		// taking the first:
		matchingProtocols = matchingProtocols.first;
		subClass = MKtl.matchClass(matchingProtocols);
		if( subClass.notNil ) {
			// newMKtl: already an MKtl
			newMKtl = subClass.newWithDesc( name, this );
			^newMKtl;
		}{
			"WARNING: MKtl - % - not implemented yet\n".postf( matchingProtocols );
			^this;
		};
	}

	*initDevices{ |force=false|
		//get available devices
		MIDIMKtl.initMIDI( force );
		if ( Main.versionAtLeast( 3, 7 ) ){
			HIDMKtl.initHID( force );
		};
	}

	*oldNew { |name, deviceDescName|
		var devDesc, return;
		"TODO: to remove!".warn;
		if(MKtl.allDevDescs.isNil){
			MKtl.loadAllDescs
		};
		^if ( this.checkName( name, deviceDescName ).not ){
			nil;
		} {
			if (deviceDescName.isNil) {
				(if ( all[name].notNil ){
					//MKtl already exists, return it
					all[name];
				} {
					//get available devices
					MIDIMKtl.initMIDI;
					if ( Main.versionAtLeast( 3, 7 ) ){
						HIDMKtl.initHID;
					};
					// it does not exist yet, but maybe it has a spec that fits?
					// there is no device description, but maybe this was an autogenerated name for a
					// known device, so let's open it
					// look in the allAvailable dict
					return = allAvailable.select(_.includes(name))
					.keys.as(Array)[0];

					if(return.notNil) {
						return = MKtl.matchClass(return);
						if( return.notNil ) {
							return.new( name )
						} {
							nil
						}
					} {
						//no devices matching were found
						//perhaps the device is not connected but the deviceDescName
						//matchs a known device so we create a virtual version with gui
						this.prMakeVirtual(name)
					}
				}) ?? {
					//all else has failed...
					Error("MKtl*new : no deviceDescName was supplied and name doesn't match any shortname for a known device").throw
				}
			} {
				// create an instance of the right subclass based on the protocol given in the device description
				devDesc = this.getDeviceDescription( deviceDescName );
				if ( this.allAvailable[devDesc[ \protocol ]].includes( name ) ){
					// shortName exists in available devices, so open it with the given deviceDescName
					MKtl.matchClass(devDesc[ \protocol ]).newFromNameAndDesc( name, deviceDescName );
				}{
					// either there is a hardware device for the given deviceDescName and it should open that with the given name,
					return = MKtl.matchClass(devDesc[ \protocol ]).newFromDesc( name, deviceDescName, devDesc );
					// or, the given deviceDescName does not match any open hardware device, and we want to fake it
					return.postln;
					if ( return.isNil ){
						"making fake device".postln;
						return = MKtl.make( name, deviceDescName );
					};
					/*
					MKtl.matchClass(devDesc[ \protocol ]) !?
					_.newFromDesc( name, deviceDescName, devDesc ) ?? {
						this.basicNew(name, deviceDescName)
					}
					*/
					return;
				}
			}
		}
	}

	*basicNew { |name, deviceDescName|
		^super.new.init(name, deviceDescName);
	}

	/*
	*make { |name, deviceDescName|
		"TODO: to remove!".warn;
		if (all[name].notNil ) {
			warn("MKtl name '%' is in use already. Please use another name."
				.format(name));
			^nil
		};
		^this.basicNew( name, deviceDescName )
	}

	*fake { |deviceDescName|
		"TODO: to remove!".warn;
		var g = { |i|
			if(MKtl.all.keys.includes("virtual_%_%".format(i, deviceDescName).asSymbol)) {
				g.(i+1)
			} {
				"virtual_%_%".format(i, deviceDescName).asSymbol
			}
		};
		^this.make(g.(0), deviceDescName)
	}
	*/

	warnNoDeviceFileFound { |deviceName|
		warn( "Mktl could not find a device file for device %. Please follow instructions in \"Tutorials/How_to_create_a_description_file\".openHelpFile;
""\n".format(
			deviceName.asCompileString) )
	}

	*prShortnamesToDevices {
		if( MKtl.allDevDescs.isNil ){ MKtl.loadAllDescs };
		^Dictionary.with(*
			MKtl.allDevDescs.getPairs.clump(2)
			.collect({ |xs| (MKtl.makeShortName(xs[1][\device]).asSymbol -> xs[0]) }))
	}

	/*
	init procedure:

	- load description from file into deviceDescription var
	- flattenDescription on each element
	- substitute each spec in the element for the real ControlSpec corresponding to it

	*/

	*basicNew { |name, deviceDescName, devDesc|
		^super.new.init(name, deviceDescName, devDesc);
	}

	init { |argName, deviceDescName, devDesc|
		var deviceInfo;
		name = argName;
		elementsDict = ();
		if (deviceDescName.isNil) {
				warn("no deviceDescription name given!");
		};
		if ( devDesc.isNil ){
			devDesc = this.class.getDeviceDescription( deviceDescName )
		};
		if ( devDesc.notNil ){
			deviceInfo = devDesc.deepCopy;
			if ( deviceInfo.isNil )	{ // no device file found:
				this.warnNoDeviceFileFound( argName );
			}{
				this.loadDeviceDescription( deviceInfo );
			}
		};
		if ( deviceDescription.notNil ){
			usedDeviceDescName = deviceDescName;
			this.makeElements;
			( "Opened device:" + name + "using device description" + deviceDescName ).postln;
		};
		all.put(name, this);
	}

	storeArgs { ^[name] }
	printOn { |stream| this.storeOn(stream) }

	*loadAllDescs { |reload=false, verbose=false|
		if (reload) { allDevDescs = nil }{
			if ( verbose ){
				"Not reloading the MKtl descriptions; to do so, use MKtl.loadAllDescs( true )".inform;
			}
		};
		if ( allDevDescs.isNil ){
			reload = true;
			this.loadMatching("", verbose );
		};
		if ( reload ){
			"MKtl loaded all device descriptions - see them with MKtl.allDescriptions".inform;
		};
	}

	*loadMatching { |name,verbose = false|
		var paths = (deviceDescriptionFolder +/+
			("*" ++ name ++ "*.desc.scd")).pathMatch;
		var descNames = paths.collect{ |x| PathName(x).fileName.split($.)[0]; };
		if ( verbose ){
			"MKtl loadMatching - found: %.\n".postf(descNames);
		};
		paths.do (this.loadSingleDesc(_, verbose));
	}

	*loadSingleDesc { |path, verbose = false|
		// path has been tested to exist already
		var descName = path.basename.split($.)[0];
		var descDict = path.load;
		var isDesc = descDict.isKindOf(Dictionary) and: {
			descDict[\description].notNil };
		if (isDesc.not) {
			"% is not a valid description file.".format(path.basename).warn;
		} {
			allDevDescs = allDevDescs ?? { IdentityDictionary.new };
			allDevDescs.put(descName.asSymbol, descDict);
			if ( verbose ){
				"MKtl: loaded %.".format(path.basename).inform;
			}
		};
		^descDict
	}

	*getDeviceDescription { |devName|
		var devDesc;
		this.loadAllDescs;
		devDesc = allDevDescs.at( devName );
		^devDesc ?? {
			// see if we can find it from the device name:
			allDevDescs
			.as(Array)
			.select{ |desc| desc[\type] != \template }
			.collect{ |desc| this.flattenDescription( desc ) }
			.detect{ |desc| desc[ \device ] == devName }
		}
	}

	loadDeviceDescription { |deviceInfo|
		var deviceFileName;
		var path;

		//"class: % deviceName: % deviceInfo:%".format(deviceName.class, deviceName, deviceInfo).postln;

		deviceDescriptionHierarch = deviceInfo[\description];
		deviceDescription = this.makeFlatDeviceDescription( deviceDescriptionHierarch );

		deviceDescription.pairsDo{ |key,elem|
			this.class.flattenDescription( elem )
		};

		// create specs
		deviceDescription.pairsDo {|key, elem|
			var foundSpec =  specs[elem[\spec]];
			if (foundSpec.isNil) {
				warn("Mktl - in description %, el %, spec for '%' is missing! please add it via:"
					"\nMktl.addSpec( '%', [min, max, warp, step, default]);\n"
					.format(name, key, elem[\spec], elem[\spec])
				);
			};
			elem[\specName] = elem[\spec];
			elem[\spec] = this.class.specs[elem[\specName]];
		};

		deviceInfo[\infoMessage] !? _.postln;
	}

	//traversal function for combinations of dictionaries and arrays
	prTraverse {
		var isLeaf = { |dict|
			dict.values.any({|x| x.size > 1}).not
		};

		var f = { |x, state, stateFuncOnNodes, leafFunc|

			if(x.isKindOf(Dictionary) ){
				if( isLeaf.(x) ) {
					leafFunc.( state , x )
				}{
					x.sortedKeysValuesCollect{ |val, key|
						f.(val, stateFuncOnNodes.(state, key), stateFuncOnNodes, leafFunc )
					}
				}
			} {
				if(x.isKindOf(Array) ) {
					x.collect{ |val, i|
						f.(val, stateFuncOnNodes.(state, i),  stateFuncOnNodes, leafFunc )
					}
				} {
					Error("MKtl:prTraverse Illegal data structure in device description.\nGot object % of type %. Only allowed objects are Arrays and Dictionaries".format(x,x.class)).throw
				}
			}

		};
		^f
	}

	prMakeElementsFunc {
		var isLeaf = { |dict|
			dict.values.any({|x| x.size > 1}).not
		};

		var f = { |x, state, stateFuncOnNodes, leafFunc|

			if(x.isKindOf(Dictionary) ){
				if( isLeaf.(x) ) {
					leafFunc.( state , x )
				}{
					MKtlElementDict(this, state,
						x.sortedKeysValuesCollect{ |val, key|
							f.(val, stateFuncOnNodes.(state, key), stateFuncOnNodes, leafFunc )
						}
					)
				}
			} {
				if(x.isKindOf(Array) ) {
					MKtlElementArray(this, state,
						x.collect{ |val, i|
							f.(val, stateFuncOnNodes.(state, i),  stateFuncOnNodes, leafFunc )
						}
					);
				} {
					Error("MKtl:prTraverse Illegal data structure in device description.\nGot object % of type %. Only allowed objects are Arrays and Dictionaries".format(x,x.class)).throw
				}
			}

		};
		^f
	}

	explore{ |mode=true|
		this.subclassResponsibility(thisMethod)
	}

	prUnderscorify {
		^{ |a,b|
			if(a != "") {
				a++"_"++b.asString
			} {
				b.asString
			}
		};
	}

	makeFlatDeviceDescription { |devDesc|

		var flatDict = ();

		this.prTraverse.(devDesc, "", this.prUnderscorify, { |state, x| flatDict.put(state.asSymbol,  x) } );

		^flatDict.asKeyValuePairs

	}

	*postAllDescriptions {
		(MKtl.deviceDescriptionFolder +/+ "*").pathMatch
		.collect { |path| path.basename.splitext.first }
		.reject(_.beginsWith("_"))
		.do { |path| ("['" ++ path ++"']").postln }
	}

	*flattenDescription { |devDesc|
		// some descriptions may have os specific entries, we flatten those into the dictionary
		var platformDesc = devDesc[ thisProcess.platform.name ];
		if ( platformDesc.notNil ){
			platformDesc.keysValuesDo{ |key,val|
				devDesc.put( key, val );
			}
		};
		^devDesc;
	}

	*flattenDescriptionForIO { |eleDesc,ioType|
		// some descriptions may have ioType specific entries, we flatten those into the dictionary
		var ioDesc = eleDesc[ thisProcess.platform.name ];
		if ( ioDesc.notNil ){
			ioDesc.keysValuesDo{ |key,val|
				eleDesc.put( key, val );
			}
		};
		^eleDesc;
	}


	elementDescriptionFor { |elname|
		^deviceDescription[deviceDescription.indexOf(elname) + 1]
	}

	postDeviceDescription {
		deviceDescription.pairsDo {|a, b| "% : %\n".postf(a, b); }
	}

	makeElements {
		var leafFunc;
		this.elementNames.do{|key|
			elementsDict[key] = MKtlElement(this, key);
		};
		leafFunc = { |finalKey, x| elementsDict[finalKey.asSymbol] };
		MKtlElement.addGroupsAsParent = true;
		elements = this.prMakeElementsFunc.(deviceDescriptionHierarch, "", this.prUnderscorify, leafFunc );
		MKtlElement.addGroupsAsParent = false;

	}

	// needed for fixing elements that are not present for a specific OS
	replaceElements{ |newelements|
		elementsDict = newelements;
	}

	// convenience methods
	defaultValueFor { |elName|
		^this.elementsDict[elName].defaultValue
	}

	makeElementName { |args|
		var n = args.size;
		^(args[..n-2].collect({ |x| x.asString++"_"}).reduce('++')++args.last).asSymbol
	}

	elementAt { |...args|
		^elements.deepAt1(*args)
	}

	at { |index|
		^elements.at( index );
	}

	// should filter: those for my platform only
	elementNames {
		if ( elementsDict.isEmpty ){
			^(0, 2 .. deviceDescription.size - 2).collect (deviceDescription[_])
		}{
			^elementsDict.keys.asArray;
		}
	}

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

	inputElements{
		^elementsDict.select { |elem|
			[ \in, \inout ].includes( elem.elementDescription[\ioType] ?? \in);
		}
	}

	outputElements{
		^elementsDict.select { |elem|
			[ \out, \inout ].includes( elem.elementDescription[\ioType] ?? \in);
		}
	}

	allElements {
		^elementsDict.asArray
	}

}
