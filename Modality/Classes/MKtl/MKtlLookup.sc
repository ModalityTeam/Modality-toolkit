
MKtlLookup {
	classvar <all, <midiAll;

	classvar orderedInfoKeys =
	#[\idInfo, \protocol, \lookupName, \filename, \deviceInfo, \srcDevice, \destDevice];

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
			var extraInfoKeys;
			"\ % : \n".postf(devkey.cs);

			extraInfoKeys = devdict.keys(Array).removeAll(orderedInfoKeys);
			(orderedInfoKeys ++ extraInfoKeys.sort).do { |k|
				"\t  %  %\n".postf((k.asString ++ ":").padRight(10), devdict[k].cs)
			};
			"   ---".postln;
		};
	}

	*addAllHID {
		HIDMKtlDevice.devicesToShow.sortedKeysValuesDo { |index, info|
			MKtlLookup.addHID(info, index);
		};
		this.checkHIDForMultiples;
	}

	*checkHIDForMultiples {

		var multiIndexDict = ();
		MKtlLookup.allFor(\hid).sortedKeysValuesDo { |key, descinfo|
			var idKey = descinfo.idInfo.asSymbol;
			multiIndexDict.put (idKey,
				multiIndexDict.at(idKey).asArray.add(descinfo)
			)
		};

		multiIndexDict.sortedKeysValuesDo { |idkey, descsarray|
			if (descsarray.size > 1) {
				"multiple devices found for %.\n".postf(idkey.cs);
				descsarray.do { |desc, i|
					desc.put(\multiIndex, i);
				};
			};
		}
	}

	*addHID { | hidinfo, index |
		var protocol = \hid;
		var lookupName = MKtl.makeLookupName(\hid, index, hidinfo.productName);
		var idInfo = [hidinfo.productName, hidinfo.vendorName].join($_);

		var dict = (
			protocol: \hid,
			idInfo: idInfo,
			deviceInfo: hidinfo,
			lookupName: lookupName
		);

		this.addFilenamesAndDescs(dict, idInfo);

		all.put(lookupName, dict);
		^dict
	}

	*addFilenamesAndDescs { |dict, idInfo|
		var filenames = MKtlDesc.filenamesForIDInfo(idInfo);
		var descs = MKtlDesc.loadDescs(filenames);
		//	"idInfo: %\n".postf(idInfo); "filenames: %\n".postf(filenames);

		dict.put(\filenames, filenames);
		dict.put(\descs, descs);

		if (filenames.size < 2) {
			dict.put(\filename, filenames[0]);
			dict.put(\desc, MKtlDesc.at(filenames[0]));
		};
	}

	*addAllMIDI {
		// clear first to avoid buildup
		MKtlLookup.allFor(\midi).keysDo { |key| MKtlLookup.all.removeAt(key) };

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
			this.splitMIDI(dev);
		}
	}

	*addOrMergeMIDI { |endpoint, index, endPointType|
		var infoToMergeTo = MKtlLookup.midiAll.detect { |info|
			info.idInfo == endpoint.device
		};
		// "%: %\n".postf([endpoint, index, endPointType]);
		if (infoToMergeTo.isNil) {
			^MKtlLookup.addMIDI(endpoint, midiAll.size, endPointType, midiAll);
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
			// "\n\nmerge: % into dict: %\n\n".postf(arr, dict);
			dict[key] = arr;
		};
	}

	*addMIDI { |endPoint, index, endPointType = \src, where, lookupName, idInfo|

		var protocol = \midi;
		var deviceName = endPoint.device;
		var dict;

		lookupName = lookupName ?? {
			MKtl.makeLookupName(protocol, index, deviceName);
		};

		dict = (
			protocol: protocol,
			deviceName: deviceName,
			idInfo: idInfo ? deviceName,
			lookupName: lookupName,
			deviceInfo: endPoint
		);

		if (endPointType == \src) { dict.put(\srcDevice, endPoint) };
		if (endPointType == \dest) { dict.put(\destDevice, endPoint) };

		this.addFilenamesAndDescs(dict, dict.idInfo);

		(where ? all).put(lookupName, dict);

		^dict
	}

	*splitMIDI { |info|

		var numSources, numDests, insOutsMatch;
		var numInPorts, numOutPorts, numInDevices, numOutDevices;
		var deviceName, deviceLookupName, postfix;
		var count = this.allFor(\midi).size;

		numSources = info.srcDevice.asArray.size;
		numDests =  info.destDevice.asArray.size;

		// if single device, exit here!
		if ((numSources < 2) and: { numDests < 2 }) {
		//	"\n%: single midi device -> to all: %\n\n".postf(thisMethod, info.idInfo.cs);
			all.put(info.lookupName, info);
			^this
		};

		// from here on we have multiple ins and/or outs

		// does info have same number of srcs and dests?
		// -> if yes, assume same order on ins and outs!
		insOutsMatch = (numSources == numDests);
		numInPorts = info.srcDevice.asArray.collectAs(_.name, Set).size;
		numOutPorts = info.destDevice.asArray.collectAs(_.name, Set).size;
		numInDevices = numSources / numInPorts;
		numOutDevices = numDests / numOutPorts;

		// either multiple devices, or multiple ports, or both...
		// "%: either multiple devices, or multiple ports, or both:".postln;
		// "%: numInPorts: %, numOutPorts: %, numInDevs: %, numOutDevs: %\n"
		// .postf(info.lookupName, numInPorts, numOutPorts, numInDevices, numOutDevices);

		info.srcDevice.do { |srcdev, index|
			var index1 = index + 1;
			var idInfo = (deviceName: info.deviceName);
			var matchingOut;
			idInfo.srcPortIndex = index;
			deviceLookupName = "midi_%_%%"; postfix = "";
			if (numInDevices > 1) { postfix = postfix ++ "_nr_%".format(index1) };
			if (numInPorts > 1) { postfix = postfix ++ "_port_%".format(index1) };
			// [srcdev, index1, postfix].postln;
			deviceLookupName = deviceLookupName.copy
			.format(count + index1, info.idInfo.toLower, postfix)
			.collect { |char| if (char.isAlphaNum, char, $_) }
			.asSymbol;

			this.addMIDI(srcdev, count + index1, \src,
				lookupName: deviceLookupName, idInfo: idInfo);

			// always match 0 to 0, 1 to 1, etc
			matchingOut = info.destDevice.asArray[index];
			if (matchingOut.notNil) {
				all[deviceLookupName].destDevice = matchingOut;
				idInfo.destPortIndex = index;
			};

			// "\n%: added from multiport midi device : %, idInfo: %.\n\n"
			// .postf(thisMethod, deviceLookupName, idInfo);
		};

		// just in case this ever happens:
		// more outs than ins, so independent outs left over
		// was: if (insOutsMatch.not) { ... }
		if (numOutPorts > numInPorts) {
			info.destDevice.do { |destdev, index|
				var index1 = index + 1;
				var idInfo = (
					deviceName: info.deviceName,
					destPortIndex: index
				);
				deviceLookupName = "midi_%_%%"; postfix = "";
				if (numOutDevices > 1) { postfix = postfix ++ "_devc_%".format(index1) };
				if (numOutPorts > 1) { postfix = postfix ++ "_port_%".format(index1) };
				// [destdev, index1, postfix].postln;
				deviceLookupName = deviceLookupName.copy
				.format(count + index1, info.idInfo.toLower, postfix)
				.collect { |char| if (char.isAlphaNum, char, $_) }
				.asSymbol;
				"destdev: %, count: %, lookupName: %, idInfo: %\n"
				.postf(destdev, count + index1, deviceLookupName, idInfo);
				this.addMIDI(destdev, count + index1, \dest,
					lookupName: deviceLookupName, idInfo: idInfo);
			};
		};
	}

	// check if already there before adding
	// should be serialisable to write to file
	*addOSC { |sendAddr, deviceName, replyAddr, mktl|

		var protocol = \osc;
		var filenames, filename, count, netInfo, lookupName, dict;

		var foundByAddrData = MKtlLookup.all.select { |infodict|
			(infodict[\sendAddr] == deviceName)
			and: {
				(infodict[\sendAddr] == sendAddr)
				and: { (infodict[\replyAddr] == replyAddr)
			} }
		};
		if (foundByAddrData.size > 0) {
			if (foundByAddrData.size == 1) {
				^this
			};
			"%: found multiple matching infos: %\n"
			.postf(thisMethod,  foundByAddrData.cs)
		};

		count = MKtlLookup.all.count { |dict| (dict.protocol == \osc) };
		netInfo = [sendAddr.ip, sendAddr.port].join($_);
		lookupName = MKtl.makeLookupName(protocol ++ count, deviceName, netInfo);

		filenames = MKtlDesc.filenamesForIDInfo(deviceName);
		if (filenames.size == 1) {
			filename = filenames.first;
		};

		dict = (
			deviceName: deviceName,
			protocol: protocol,
			idInfo: deviceName,
			sendAddr: sendAddr,
			replyAddr: replyAddr,
			ipAddress: sendAddr.ip,
			srcPort: sendAddr.port,
			destPort: (replyAddr ? sendAddr).port,
			filenames: filenames,
			filename: filename,
			lookupName: lookupName,
			mktl: mktl,
			desc: if (mktl.notNil) { mktl.desc }
		);

		all.put(lookupName, dict);
	}

	/*
	how to remove a deviceInfo for a given device?
	maybe useful for OSC devices
	*/

	*findByIDInfo { |inIdInfo|
		var matches = true, matching, ordered;

		var inIdDict;
		if (inIdInfo.isNil) {
			"%: inIdInfo is nil!\n".postf(thisMethod);
			^[]
		};
		if (inIdInfo.isKindOf(String)) {
			inIdDict = (deviceName: inIdInfo);
		} {
			inIdDict = inIdInfo
		};

		matching = all.select { |hereInfo|
			var hereIdInfo, hereIdDict, matches = true;

			hereIdInfo = hereInfo[\idInfo];
			if (hereIdInfo.isKindOf(String)) {
				hereIdDict = (deviceName: hereIdInfo);
			} {
				hereIdDict = hereIdInfo;
			};

			inIdDict.keysValuesDo { |key, value|
				var hereIDval = hereIdDict[key];
				// [key, value, hereIDval].postcs;
				matches = matches and:
				((value == hereIDval) or: hereIDval.isNil)
			};
			matches
		};
		ordered = [];
		matching.sortedKeysValuesDo { |key, cand, i|
			cand.put(\multiIndex, i);
			ordered = ordered.add(cand);
		};
		^ordered
	}
}

