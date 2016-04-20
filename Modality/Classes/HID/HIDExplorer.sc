HIDExplorer {

    classvar <allMsgTypes = #[ \elid, \usage ];

	classvar <resps;
	classvar <results;
	classvar <observeDict;
	classvar <>verbose = true;
	classvar <observedSrcDev;

    classvar <exploreFunction;

	classvar <specMap;

	*trace { |flag = true| verbose = flag }

	*initClass {
		specMap = (
			\Button: \hidBut
		);

        exploreFunction = { |devid, thisdevice, elid, page, usage, value, mappedvalue|
			this.updateRange( elid, page, usage, value )
		};
	}

	*start { |srcDev|
		if ( srcDev.notNil ){
			srcDev.debug_( true );
			observedSrcDev = srcDev;
		}{
			HID.debug_( true );
		}
	}

	*stop { |srcDev|
		srcDev = srcDev ? observedSrcDev;
		if ( srcDev.notNil ){
			srcDev.debug_( false );
		}{
			HID.debug_( false );
			// observedSrcDev = nil; // is this a good idea?
		}
	}

	*prepareObserve {
		observeDict = ();
		allMsgTypes.do(observeDict.put(_, Dictionary()));
	}

	*openDoc {
		Document("edit and save me", this.compileFromObservation );
	}

    *openDocFromDevice { |dev|
        Document("edit and save me", this.compileFromDevice( dev ) );
	}

    *detectDuplicateElements { |elements|
        var elementUsageDict = IdentityDictionary.new;
        var duplicates = IdentityDictionary.new;
        var uniques = IdentityDictionary.new;
        var usagePageKey;

        elements.sortedKeysValuesDo { |elid,ele|
            usagePageKey = ( ele.usage.asString ++ "_" ++ ele.usagePage ).asSymbol;
            if ( elementUsageDict.at( usagePageKey ).notNil ){
                // this one already appeared, it's a double!!
                duplicates.put( elid, ele );
            }{
                uniques.put( elid, ele );
                elementUsageDict.put( usagePageKey, ele );
            }
        };
        ^[uniques, duplicates];
    }

    *compileFromDevice { |dev|
		var str = "(\n";
        var elements = dev.elements;

		var inElements, outElements, featureElements;
		var idInfo = dev.info.productName.asString
		   ++ "_" ++ dev.info.vendorName.asString;

		// header
		str = str ++ "idInfo: \"" ++ idInfo ++ "\",\n";
		str = str ++ "protocol: 'hid',\n";
		str = str ++ "deviceName: \"" ++ idInfo ++ "\",\n";
		str = str ++
"deviceType: '___',
elementTypes: [],
status: (
	linux: \"unknown\",
	osx: \"unknown\",
	win: \"unknown\"
),

// hardwarePages: [1, 2, 3, 4],

// deviceInfo: (
// vendorURI: 'http://company.com/products/this',
// manualURI: 'http://company.com/products/this/manual.pdf',
	// description: ,
	// features: [],
	// notes: ,
	// hasScribble: false
// ),
";
		str = str ++ "elementsDesc: (\n";
		str = str ++ "	elements: [\n";

        /// todo: check the device elements whether any duplicate usages occur,
		/// and if so, then we need to filter by element id
        /// could infer type from the control
        /// could infer name from the control -> suggest a name

        /// FIXME: ignore constant fields!

		inElements = elements.select { |v| v.ioType == 1 };
		str = str + this.stringFor(inElements, 'in', "input elements");

		outElements = elements.select { |v| v.ioType == 1 };
		str = str + this.stringFor(outElements, 'out', "output elements");

		// featureElements = elements.select { |v| v.ioType == 1 };
		// str = str + this.stringFor(outElements, 'feature', "feature report");

		str = str + "\t]";
		str = str + "\n)\n);";

		^str;
    }

	*stringFor { |elems, ioType, title|
		var uniques, duplicates, str = "";
		#uniques, duplicates = this.detectDuplicateElements(elems);

		if ( uniques.size + duplicates.size > 0 ) {
			str = str + "\n\n\t\t// --------- % ----------".format(title);
		};

		uniques.sortedKeysValuesDo { |key, elem|
			var specName = specMap[elem.pageName.asSymbol]
			?? { "_%_".format(elem.usageName) };
			str = str + "\n\t\t( key: '_%_', 'hidUsage': %, 'hidUsagePage': %, "
			"'elementType': '%', 'ioType': '%', 'spec': '%' ),"
			.format(elem.usageName, elem.usage, elem.usagePage, elem.pageName,
				ioType, specName );
		};
		duplicates.sortedKeysValuesDo { |key, elem|
			var specName = specMap[elem.pageName.asSymbol]
			?? { "_%_".format(elem.usageName) };
			str = str + "\n\t\t( key: '_%_%_', 'hidElementID': %, "
			"'elementType': '%', 'ioType': '%', 'spec': '%' ),"
			.format(elem.usageName, key, key, elem.pageName, ioType, specName );
		};

		^str
	}

	*compileFromObservation { |includeSpecs = false|

		var num, chan;

		var str = "[";

		if (observeDict[\elid].notEmpty) {
			str = str + "\n// ------ element ids -------------";
			observeDict[\elid].sortedKeysValuesDo { |key, val|
				#num, chan = key.split($_).collect(_.asInteger);
				str = str + "\n'<element name %>': ('hidElementID': %, 'elementType': '<type>'),"
					.format(key, val);
			};
		};

		if (observeDict[\usage].notEmpty) {
			str = str + "\n\n// --------- usage ids ----------";
			observeDict[\usage].sortedKeysValuesDo { |key, val|
				#num, chan = key.split($_).collect(_.asInteger);
				str = str + "\n'<element name %>': ('hidUsage': %, 'hidUsagePage': %, , 'elementType': '<type>' ),"
				.format(key, val.usage, val.hidUsagePage ); /// could infer type from the control
			};
		};

		str = str + "\n];";

		^str;
	}

	*updateRange { |elid, page, usage, hidElem|
        var hash, range;
        var msgDict = observeDict[\elid];
		var val = hidElem.value;

        if (verbose) { [elid, page, usage, val].postcs; } { ".".post; };
        if (0.1.coin) { observeDict.collect(_.size).sum.postln };

		/*
		hash = "%_%_%".format(elid, page, usage).postln;
        range = msgDict[hash];
        range.isNil.if{
			msgDict[hash] = [val, val];
		} {
			msgDict[hash] = [min(range[0], val), max(range[1], val)]
		}
		*/
	}
}

/// buttons:
// generally: mode: push , spec: hidBut

// hatswitch: mode: center, spec: hidHat

// x,y : mode: center, spec: cent1
