// TODO: check that we never add identical infos a second time

MKtlLookup {
	classvar <all, midiLists;

	*initClass {
		all = ();
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

	*midiAt { |endPointType, index|
		var list = (src: MIDIClient.sources,
			dest: MIDIClient.destinations)[endPointType];
		^if (list.notNil) { list[index] };
	}

	*addAllHID {
		HIDMKtlDevice.devicesToShow.sortedKeysValuesDo { |index, info|
			MKtlLookup.addHID(info, index); };
	}

	*allFor { |protocol|
		protocol = (protocol ? MKtlDevice.allProtocols);
		^all.select { |dict|
			(dict.protocol == protocol) or: {
				protocol.asArray.includes(dict.protocol);
			}
		};
	}

	*names {
		^all.keys(SortedList).array;
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
		// join the ones that belong together first,
		// and give them proper in/out srcIDs:
		MIDIClient.sources.do { |endpoint, index|
			MKtlLookup.addOrMergeMIDI(endpoint, index, \src);
		};
		MIDIClient.destinations.do { |endpoint, index|
			MKtlLookup.addOrMergeMIDI(endpoint, index, \dest);
		};
	}

	*addOrMergeMIDI { |endpoint, index, endPointType|
		var infoToMergeTo = MKtlLookup.allFor(\midi).detect { |info|
			info.idInfo == endpoint.device
		};
		if (infoToMergeTo.isNil) {
			^MKtlLookup.addMIDI(endpoint, index, \src);
		};

		this.merge (infoToMergeTo, \deviceInfo, endpoint);
		if (endPointType == \src) {
			this.merge (infoToMergeTo, \srcDevice, endpoint);
		};
		if (endPointType == \dest) {
			this.merge (infoToMergeTo, \destDevice, endpoint);
		};
	}
	// for devices with multiple ports:
	// merge all ports into one array for src and one for desc
	// need to unpack it correctly later
	// either support multiple ports in MIDIfunc,
	// merge one MKtl for each port into one mother MKtl
	*merge { |dict, key, newItem|
		var arr = dict[key].asArray;
		if (arr.includesEqual(newItem).not) {
			"%: adding item %, uid: % \n"
			.postf(thisMethod, newItem, newItem.uid);
			arr = arr.add(newItem);
			dict[key] = arr;
		};
	}

	*addMIDI { |endPoint, index, endPointType = \src|

		var protocol = \midi;
		var idInfo = endPoint.device;
		var filename = MKtlDesc.filenameForIDInfo(idInfo);
		var lookupName = MKtl.makeLookupName(protocol, index, endPoint.device);

		var dict = (
			protocol: protocol,
			idInfo: idInfo,
			filename: filename,
			desc: MKtlDesc.at(filename.asSymbol),
			lookupName: lookupName
		//	lookup: { MKtlLookup.midiAt(endPointType, index); }
		);
		dict.put(\deviceInfo, endPoint);
		if (endPointType == \src) { dict.put(\srcDevice, endPoint) };
		if (endPointType == \dest) { dict.put(\destDevice, endPoint) };

		all.put(lookupName, dict);

		^dict
	}

	// check if already there before adding
	// should be serialisable to write to file
	*addOSC { |sendAddr, name, replyAddr|

		var protocol = \osc;
		var index = MKtlLookup.all.count(_.protocol == \osc);
		var idInfo = [sendAddr.addr, sendAddr.port].join($_);
		var nameAndInfo = if (name.notNil) { [name.asString, idInfo].join($_); };
		var lookupName = MKtl.makeLookupName(protocol, index, nameAndInfo ? idInfo);
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

	*addSerial {

	}

	*findByIDInfo { |idInfo|
		^all.select { |item| item.idInfo == idInfo };
	}
}

