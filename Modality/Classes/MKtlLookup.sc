MKtlLookup {
	classvar <all, midiLists;

	*initClass {
		all = ();
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
		^all.keys.asArray.sort;
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
		MIDIClient.sources.do { |endpoint, index|
			MKtlLookup.addMIDI(endpoint, index, \src);
		};
		MIDIClient.destinations.do { |endpoint, index|
			MKtlLookup.addMIDI(endpoint, index, \dest);
		};
	}

	*addMIDI { |endPoint, index, endPointType = \src|
		var protocol = \midi;
		var typeStr = endPointType.asString;
		var prefix = protocol ++ typeStr.put(0, typeStr[0].toUpper);
		var idInfo = endPoint.device;
		var lookupName = MKtl.makeLookupName(prefix, index, endPoint.device);
		var filename = MKtlDesc.filenameForIDInfo(idInfo);

		var dict = (
			protocol: protocol,
			idInfo: idInfo,
			uid: endPoint.uid,
			deviceInfo: endPoint,
			filename: filename,
			desc: MKtlDesc.at(filename.asSymbol),
			lookupName: lookupName
		//	lookup: { MKtlLookup.midiAt(endPointType, index); }
		);
		all.put(lookupName, dict);
		^dict
	}

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
			sendAddr: sendAddr,
			replyAddr: replyAddr,
			idInfo: idInfo,
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

