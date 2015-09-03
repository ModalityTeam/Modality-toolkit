// TODO: check that we never add identical infos a second time

MKtlLookup {
	classvar <all, <midiAll;

	*initClass {
		all = ();
		midiAll = ();
	}

	*names {
		^all.keys(SortedList).array;
	}

	*allFor { |protocol|
		protocol = (protocol ? MKtlDevice.allProtocols);
		^all.select { |dict|
			(dict.protocol == protocol) or: {
				protocol.asArray.includes(dict.protocol);
			}
		};
	}

	*postInfo {
		"%.all: \n".postf(this);
		all.sortedKeysValuesDo { |devkey, devdict|
			"\t%\n".postf(devkey);
			devdict.sortedKeysValuesDo { |k, v|
				"\t\t%: %\n".postf(k, v)
			};
			"".postln;
		};
	}

	*addAllHID {
		HIDMKtlDevice.devicesToShow.sortedKeysValuesDo { |index, info|
			MKtlLookup.addHID(info, index);
		};
	}

	*addHID { | hidinfo, index |
		var protocol = \hid;
		var lookupName = MKtl.makeLookupName(\hid, index, hidinfo.productName);
		var idInfo = [hidinfo.productName, hidinfo.vendorName].join($_);
		var filename = MKtlDesc.filenameForIDInfo(idInfo);

		var dict = (
			protocol: \hid,
			idInfo: idInfo,
			deviceInfo: hidinfo,
			filename: filename,
			lookupName: lookupName
		);

		if (filename.notNil) {
			MKtlDesc.loadDescs(filename);
			dict.put(\desc, MKtlDesc.at(filename.asSymbol));
		};

		all.put(lookupName, dict);
		^dict
	}

	*addAllMIDI {
		// join the ones with the same idInfo first,
		// and collect all their srcIDs/destIDs:
		MIDIClient.sources.do { |endpoint, index|
			MKtlLookup.addOrMergeMIDI(endpoint, index, \src);
		};
		MIDIClient.destinations.do { |endpoint, index|
			MKtlLookup.addOrMergeMIDI(endpoint, index, \dest);
		};
		// need to know all available devices in the big list first,
		// then can sort out which ones belong together
		midiAll.do { |dev|
			this.midiSplit(dev);
		}
	}

	*addOrMergeMIDI { |endpoint, index, endPointType|
		var infoToMergeTo = MKtlLookup.midiAll.detect { |info|
			info.idInfo == endpoint.device
		};
		// "%: %\n".postf([endpoint, index, endPointType]);
		if (infoToMergeTo.isNil) {
			^MKtlLookup.addMIDI(endpoint, index, endPointType, midiAll);
		};

		if (endPointType == \src) {
			this.merge (infoToMergeTo, \srcDevice, endpoint);
		};
		if (endPointType == \dest) {
			this.merge (infoToMergeTo, \destDevice, endpoint);
		};
	}

	// for devices with multiple ports, for now:
	// merge all ports into one array for src and one for desc.
	// will need to unpack it correctly later:
	// either support multiple ports in MIDIfunc,
	// or merge one MKtl for each port into one mother MKtl

	*merge { |dict, key, newItem|
		var arr = dict[key].asArray;
		if (arr.includesEqual(newItem).not) {
			// no array for single ports
			arr = arr.add(newItem).unbubble;
			dict[key] = arr;
		};
	}

	*addMIDI { |endPoint, index, endPointType = \src, where, lookupName|

		var protocol = \midi;
		var idInfo = endPoint.device;
		var filename = MKtlDesc.filenameForIDInfo(idInfo);
		var dict;
		lookupName = lookupName ?? {
			MKtl.makeLookupName(protocol, index, endPoint.device);
		};

		dict = (
			protocol: protocol,
			idInfo: idInfo,
			filename: filename,
			desc: MKtlDesc.at(filename.asSymbol),
			lookupName: lookupName
		);
		dict.put(\deviceInfo, endPoint);
		if (endPointType == \src) { dict.put(\srcDevice, endPoint) };
		if (endPointType == \dest) { dict.put(\destDevice, endPoint) };

		(where ? all).put(lookupName, dict);

		^dict
	}

	*midiSplit { |info|

		var numSources, numDests, insOutsMatch, doAdvise;
		var numInPorts, numOutPorts, numInDevices, numOutDevices;
		var deviceName, postfix;
		var count = this.allFor(\midi).size;

		numSources = info.srcDevice.asArray.size;
		numDests =  info.destDevice.asArray.size;

		// if single device, exit here!
		if ((numSources <= 2) and: { numDests <= 2 }) {
			all.put(info.lookupName, info);
			^this
		};

		// does info have same number of srcs and dests?
		// -> if yes, assume same order on ins and outs!
		insOutsMatch = numSources == numDests;
		numInPorts = info.srcDevice.as(Set).size;
		numOutPorts = info.srcDevice.as(Set).size;
		numInDevices = numSources / numOutPorts;
		numOutDevices = numDests / numOutPorts;

		info.srcDevice.do { |srcdev, i|
			i = i + 1;
			deviceName = "midi_%_%%"; postfix = "";
			if (numInDevices > 1) { postfix = postfix ++ "_nr_%".format(i) };
			if (numInPorts > 1) { postfix = postfix ++ "_port_%".format(i) };
			// [srcdev, i, postfix].postln;
			deviceName = deviceName.copy
			.format(count + i, info.idInfo.toLower, postfix).asSymbol;
			this.addMIDI(srcdev, count + i, \src, lookupName: deviceName);
			if (insOutsMatch) {
				all[deviceName].destDevice =info.destDevice.asArray[i]
			};
		};
		if (insOutsMatch.not) {
			info.destDevice.do { |destdev, i|
				i = i + 1;
				deviceName = "midi_%_%%"; postfix = "";
				if (numInDevices > 1) { postfix = postfix ++ "_devc_%".format(i) };
				if (numInPorts > 1) { postfix = postfix ++ "_port_%".format(i) };
				// [destdev, i, postfix].postln;
				deviceName = deviceName.copy
				.format(count + i, info.idInfo.toLower, postfix).asSymbol.postcs;
				this.addMIDI(destdev, count + i, \dest, lookupName: deviceName);
			};
		};
	}

	// check if already there before adding
	// should be serialisable to write to file
	*addOSC { |sendAddr, name, replyAddr|

		var protocol = \osc;
		var idInfo = [sendAddr.addr, sendAddr.port].join($_);
			// maybe needed, but makes it hard to avoid duplicates
		// var index = MKtlLookup.all.count { |dict|
		// (dict.protocol == \osc) };
		// var nameAndInfo = if (name.notNil) { [name.asString, idInfo].join($_); };
		// var lookupName = MKtl.makeLookupName(protocol, index, nameAndInfo ? idInfo);
		var lookupName = MKtl.makeLookupName(protocol, name, idInfo);
		var filename = MKtlDesc.filenameForIDInfo(idInfo);

		var dict = (
			name: name,
			protocol: protocol,
			ipAddress: sendAddr.ip,
			srcPort: sendAddr.port,
			destPort: (replyAddr ? sendAddr).port,
		//	deviceInfo: nil,
			filename: filename,
			desc: MKtlDesc.at(filename.asSymbol),
			lookupName: lookupName
		//	lookup: { MKtlLookup.all[lookupName]; }
		);

		all.put(lookupName, dict);
		^dict
	}

	/*
	how to remove a deviceInfo for a given device?
	likely useful for OSC devices
	*/

	*addSerial {

	}

	*findByIDInfo { |idInfo|
		^all.select { |item| item.idInfo == idInfo };
	}
}

