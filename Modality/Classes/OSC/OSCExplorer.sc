
OSCExplorer {

	classvar <funcChain, <allSrcDict;

	*addName { |name, addrItem|
		var candDicts, dict;
			// port? can be multiple
		if (addrItem.isKindOf(Number)) {
			var candDicts = allSrcDict.select { |d| d.addr.port == addrItem };
			candDicts.size.switch(
				0, {},
				1, { dict = candDicts.choose; },
				{
					"OSCExplorer-addName: % candidates for "
					"port % - please specify! :\n".postf(candDicts.size, addrItem);
					candDicts.do { |dict| dict[\addr].postcs; };
					^this
			});
		};

		// key as put by hand in allSrcDict
		if (addrItem.isKindOf(Symbol)) {
			dict = allSrcDict[addrItem]
		} {
			// address as found in dict
			if (addrItem.isKindOf(NetAddr)) {
				dict = allSrcDict.detect { |d| d.addr == addrItem };
			} {
				// addrItem is a hostname
				if (addrItem.isKindOf(String)) {
					dict = allSrcDict.detect { |d| d.addr.ip == addrItem };
				}
			}
		};

		if (dict.notNil) {
			dict.put(\name, name);
			"OSCExplorer-addName: added name % dict for addr %.\n"
			.postf(name,dict[\addr]);
		} {
			"OSCExplorer-addName: no sender found for addrItem %.\n".postf(addrItem);
		};
	}

	*initClass {
		funcChain = FuncChain();
		allSrcDict = ();
	}

	*start {
		thisProcess.removeOSCRecvFunc(this);
		thisProcess.addOSCRecvFunc(this);
	}

	*stop { |force = true|
		if (force or: { funcChain.array.isEmpty }) {
			thisProcess.removeOSCRecvFunc(this);
		}
	}

	*value { |...args| funcChain.value(*args) }

	*getMyIPs {

		var confstr = unixCmdGetStdOut("ifconfig");
		var labelStarts = confstr.findAll("inet");
		var strings = labelStarts.collect { |start|
			confstr.copyRange(start + 5, start + 5 + 20) };
		var cands = strings.collect { |str|
			str.split($ ).select { |st| st.size > 7 }
		}.flatten(1);
		^cands.select(_.every("1234567890.".includes(_)));
	}

	*trace { |bool = true|
		if (bool) {
			this.start;
			"OSCExplorer trace added."
			"\n   args: senderAddress, msgName, time, recvPort, msg.".postln;
			funcChain.add(\postln, { |msg, time, senderAddr, recvPort|
				[senderAddr, msg[0], time.round(0.01), recvPort, msg].postln;
			});
		} {
			funcChain.removeAt(\postln);
			this.stop(false);
		};
	}

	*explore { |bool = true|
		if (bool) {
			this.start;
			funcChain.add(\collect, { |msg, time, senderAddr, recvPort|
				this.collect(msg, time, senderAddr, recvPort);
			});
		} {
			funcChain.removeAt(\collect);
			this.stop(false);
		};
	}

	*collect { |msg, time, senderAddr, recvPort|
		// semi-readable big float of addr_0_port, fast lookup
		//	var numKey = senderAddr.addr.asFloat * 1000000 + senderAddr.port;
		// slightly more expensive to make, but better to read:
		var numKey = (senderAddr.hostname ?? { senderAddr.ip }
			++ "_" ++ senderAddr.port).asSymbol;
		var srcDict = allSrcDict[numKey];
		if (srcDict.isNil) {
			allSrcDict[numKey] = srcDict = (addr: senderAddr, messages: ());
			("OSCProbe - added srcDict:" + numKey + srcDict).postln;
		};

		srcDict.messages.put( msg[0], msg);
	}

	*dictStr { |numKey|
		var srcDict = allSrcDict[numKey];
		var str = "";
		if (srcDict[\name].notNil) {
			str = str ++ "name:" + srcDict[\name] ++"\n";
		};
		str = str ++  "addr: " + srcDict[\addr] /*+ "hash:" + key.asString*/ ++ "\n";
		if (srcDict.notEmpty) {
			srcDict[\messages].keys.asArray.sort.do { |msgKey|
				var msg = srcDict[\messages][msgKey];
				if (msg.size > 0) {
					msg = msg.collect { |x|
						if (x.respondsTo(\round)) { x.round(0.001) } {x}
					};
				};
				str = str ++ ("   msg:" + msg.asCompileString).keep(70) ++ "\n";
			};
		};
		^str;
	}

	*allStr {
		var showStr = "ALL Messages: \n";
		allSrcDict.collect { |dict, key|
			showStr = showStr ++ this.dictStr(key)
		};
		^showStr
	}
}