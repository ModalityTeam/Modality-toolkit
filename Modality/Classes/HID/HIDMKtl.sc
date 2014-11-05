/*

// TODO / TESTS
HIDMKtl.find;

// works:
MKtl('rnnd0');  // ThrustMaster Ferrari Run'N' Drive
MKtl('rnnd0').verbose = true;

MKtl( 'ferrari'); // no deviceDescName given, but still creates it,
// so trying to make it with description fails because of the name being taken:
MKtl.make( 'ferrari', "RunNDrive");

// take out broken MKtl
MKtl.all.removeAt('ferrari');

// proposal for how to decommission devices:
MKtl.remove(\ferrari);
// should remove all responders etc etc
*/

// TODO
//    addFunc should conform to super.addFunc.


HIDMKtl : MKtl {
	classvar <initialized = false;
	classvar <sourceDeviceDict;
	classvar <protocol = \hid;

	var <srcID, <srcDevice;

    // classvar locIDtoKtl;
	// optimisation for fast lookup,
	// may go away of everything lives in the elementsDict
    // var <elemDict;
    // var <lookupDict;
    var <deviceElements;

	*initHID { |force=false|
		(initialized && {force.not}).if{^this};
		HID.findAvailable;

		sourceDeviceDict = IdentityDictionary.new;
		this.prepareDeviceDicts;

		initialized = true;
	}

	*prepareDeviceDicts{
		var prevName = nil, j = 0, order, deviceNames;
		deviceNames = HID.available.collect{|dev,id|
			this.makeShortName( (dev.productName.asString ++ "_" ++ dev.vendorName.asString ).asString)
		}.asSortedArray;
		order = deviceNames.order{ arg a, b; a[1] < b[1] };
		deviceNames[order].do{|name, i|
			(prevName == name[1]).if({
				j = j+1;
			},{
				j = 0;
			});
			prevName = name[1];
			sourceDeviceDict.put((name[1] ++ j).asSymbol, HID.available[ name[0] ])
		};

		// put the available hid devices in MKtl's available devices
		allAvailable.put( \hid, List.new );
		sourceDeviceDict.keysDo({ |key|
			allAvailable[\hid].add( key );
		});
	}
		// open all ports and display them in readable fashion,
		// copy/paste-able directly
	*find { |name, uid, post=true|
		this.initHID( true );

		if ( post ){
			this.postPossible;
		};
	}

	*postPossible{
		"\n// Available HIDMKtls:".postln;
		"// MKtl(autoName);  // hid vendor, product(, serial number)".postln;
		sourceDeviceDict.keysValuesDo{ |key,info|
			var serial = info.serialNumber;
			if( serial.isEmpty ) {
				"    MKtl('%');  // %, %\n"
				.postf(key, info.vendorName, info.productName )
			} {
				"    MKtl('%');  // %, %, %\n"
				.postf(key, info.vendorName, info.productName, serial.asCompileString );
			}
		};
		"\n-----------------------------------------------------".postln;
	}

	*findSource{ |rawDeviceName, rawVendorName|
		var devKey;
		this.sourceDeviceDict.keysValuesDo{ |key,hidinfo|
			if ( rawVendorName.notNil ){
				if ( hidinfo.productName == rawDeviceName and: ( hidinfo.vendorName == rawVendorName ) ){
					devKey = key;
				}
			}{
				if ( hidinfo.productName == rawDeviceName ){
					devKey = key;
				};
				if ( (hidinfo.productName ++ "_" ++ hidinfo.vendorName) == rawDeviceName ){
					devKey = key;
				};
			};
		};
		^devKey;
	}


	// *newWithDesc{ |name, devDesc|
	// var dev = this.sourceDeviceDict.at( name );
	// ^this.new( name, dev.path, devDesc );
// }

	*newFromVirtual{ |name, virtualMKtl|
		// var devDescName = virtualMKtl.usedDeviceDescName;
		// ^this.newWithDesc( name, devDescName );
		/// TODO: should actually copy the contents!
		var dev = this.sourceDeviceDict.at( name );
		^virtualMKtl.as( HIDMKtl ).initHIDMKtl(dev.path, dev);
	}


	*newWithoutDesc{ |name|
		var dev = this.sourceDeviceDict.at( name );
		^this.new( name, dev.path );
	}

/*
	*newFromNameAndDesc{ |name,deviceDescName,devDesc|
		var dev = this.sourceDeviceDict.at( name );
		"TODO: to remove!".warn;
		^this.new( name, dev.path, deviceDescName );
	}

	// how to deal with additional arguments (uids...)?
	*newFromDesc{ |name,deviceDescName,devDesc|
		var devString = devDesc.at( \device );
        var devKey = this.findSource( devString );
		var dev;
		"TODO: to remove!".warn;
		if ( devKey.isNil ){
			^nil;
		};
		dev = this.sourceDeviceDict.at( devKey );
		^this.new( name, dev.path );
	}
*/

    // create with a uid, or access by name
	*new { |name, uid, devDescName|
		var foundSource;
		var foundKtl = all[name.asSymbol];

        // access by name
		if (foundKtl.notNil) {
			if (uid.isNil) {
				^foundKtl
			} {
				if (uid == foundKtl.srcID) { // FIXME: where do I set the srcID?
					^foundKtl
				} {
					warn("HIDMKtl: name % is in use for a different USB port ID!"
					++ 	"	Please pick a different name.".format(name)
					++ 	"	Taken names:" + all.keys.asArray.sort ++ ".\n");
					^nil
				}
			}
		};

		this.initHID;

		if (uid.isNil) {
			foundSource = this.sourceDeviceDict[ name ];
		}{
            //FIXME: uid is this a path?
			foundSource = HID.findBy( path: uid ).asArray.first;
		};
			// make a new one
		if (foundSource.isNil) {
			warn("HIDMKtl:"
			"	No HID source with USB port ID % exists! please check again.".format(uid));
			// ^MKtl.prMakeVirtual(name);
			^MKtl.new(name);
		};

        ^super.basicNew(name,devDescName ? this.makeDeviceName( foundSource ) ).initHIDMKtl(uid, foundSource);
	}

    *makeDeviceName{ |hidinfo|
		// ^(hidinfo.vendorName.asString ++ "_" ++ hidinfo.productName);
		^(hidinfo.productName.asString ++ "_" ++ hidinfo.vendorName);
    }

	postRawSpecs { this.class.postRawSpecsOf(srcDevice) }

	explore{
		/*
		"Using HIDExplorer. (see its Helpfile for Details)\n\n".post;
		"HIDExplorer started. Wiggle all elements of your controller then".postln;
		"\tHIDExplorer.stop;".postln;
		"\tHIDExplorer.openDoc;".postln;
		HIDExplorer.start(this.srcID);
		*/
		^HIDExplorer.start( this.srcDevice );
		// "HIDExplorer.explore is not implemented yet".postln;
	}

	initHIDMKtl { |argUid, argSource|
		srcID = argUid;
        // srcDevice = HID.open(argSource);
        srcDevice = argSource.open;
		all.put(name, this);

        // this.getDeviceElements;
 		this.setHIDActions;
	}

    /*
    getDeviceElements{
        deviceElements = srcDevice.elements;
    }
    */

	warnNoDeviceFileFound { |deviceName|
		var a = "Mktl could not find a device file for device %. You can generate a description file by evaluating\n\t".format(deviceName);
		var b = "HIDMKtl(%).createDescriptionFile".format(name.asCompileString);
		//var c = "or if that doesn't contain enough information you can start exploring the capabilities of it by evaluating\n";
		//var d = "\tHIDMKtl(%).explore\n".format(name.asCompileString);
		warn( [a,b].reduce('++') )
	}

	createDescriptionFile {
		if(srcDevice.notNil){
			HIDExplorer.openDocFromDevice(srcDevice)
		} {
			Error("HIDMKtl#createDescriptionFile - srcDevice is nil. HID probably could not open device").throw
		}
	}

	setHIDActions{
		var newElements = ();

		this.elementsDict.do{ |el|
            var theseElements;

            var elid = el.elementDescription[\hidElementID];
            var page = el.elementDescription[\hidUsagePage];
            var usage = el.elementDescription[\hidUsage];

            // device specs should primarily use usage and usagePage,
            // only in specific instances - where the device has bad firmware use elementid's which will possibly be operating system dependent

            if ( elid.notNil ){ // filter by element id
                // HIDFunc.element( { |v| el.rawValueAction_( v ) }, elid, \devid, devid );
                srcDevice.elements.at( elid ).action = { |v|
					el.rawValueAction_( v );
					if(verbose) {
						"% - % > % | type: %, src:%"
						.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln
					}
				};
            }{  // filter by usage and usagePage
                // HIDFunc.usage( { |v| el.rawValueAction_( v ) }, usage, page, \devid, devid );
                theseElements = srcDevice.findElementWithUsage( usage, page );
                theseElements.do{ |it|
                    it.action = { |v|
						el.rawValueAction_( v );
						if(verbose) {
							"% - % > % | type: %, src:%"
							.format(this.name, el.name, el.value.asStringPrec(3), el.type, el.source).postln
						}
					};
                };
            };
            newElements.put( el.name, el );
		};
		this.replaceElements( newElements );
	}

	send { |key,val|
		var thisMktlElement, thisHIDElement;
		thisMktlElement = this.elementDescriptionFor( key );
		if ( this.notNil ){
			thisHIDElement = srcDevice.findElementWithUsage( thisMktlElement.at( 'hidUsage' ), thisMktlElement.at( 'hidUsagePage' ) ).first;
			if ( thisHIDElement.notNil ){
				thisHIDElement.value = val;
			};
		};
	}
}
