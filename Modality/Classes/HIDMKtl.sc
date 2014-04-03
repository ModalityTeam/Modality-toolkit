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
            this.makeShortName( (dev.productName.asString ++ dev.vendorName.asString ).asString)
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
		sourceDeviceDict.keysValuesDo{ |key,info|
			var serial = info.serialNumber;
			if( serial.isEmpty ) {
				"   HIDMKtl('%');  // % %\n"
				.postf(key, info.vendorName, info.productName )
			} {
				"   HIDMKtl('%', %);  // % %\n"
				.postf(key, serial.asCompileString, info.vendorName, info.productName );

			}
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
        // var dev = this.findSource( devDesc[ thisProcess.platform.name ] );
        var dev = this.findSource( devDesc );
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
			foundSource = HID.findBy( path: uid );
		};
			// make a new one
		if (foundSource.isNil) {
			warn("HIDMKtl:"
			"	No HID source with USB port ID % exists! please check again.".format(uid));
			^nil
		};

        ^super.basicNew(name,devDescName ? this.makeDeviceName( foundSource ) ).initHIDMKtl(uid, foundSource);
	}

    *makeDeviceName{ |hidinfo|
        ^(hidinfo.vendorName.asString ++ "_" ++ hidinfo.productName);
    }

	postRawSpecs { this.class.postRawSpecsOf(srcDevice) }

	explore{
		/*"Using HIDExplorer. (see its Helpfile for Details)\n\n".post;
		"HIDExplorer started. Wiggle all elements of your controller then".postln;
		"\tHIDExplorer.stop;".postln;
		"\tHIDExplorer.openDoc;".postln;
		HIDExplorer.start(this.srcID);*/
		"HIDExplorer.explore is not implemented yet".postln;
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
		var b = "HIDMKtl(%).createDescFromDevice\n".format(name.asCompileString);
		//var c = "or if that doesn't contain enough information you can start exploring the capabilities of it by evaluating\n";
		//var d = "\tHIDMKtl(%).explore\n".format(name.asCompileString);
		warn( [a,b].reduce('++') )
	}

	createDescFromDevice {
		if(srcDevice.notNil){
			HIDExplorer.openDocFromDevice(srcDevice)
		} {
			Error("HIDMKtl#createDescFromDevice - srcDevice is nil. HID probably could not open device").throw
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

	verbose_ {|value=true|
		verbose = value;
	}

	storeArgs { ^[name] }

	printOn { |stream| ^this.storeOn(stream) }
}
