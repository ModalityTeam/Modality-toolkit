OSCMessageInversePatternDispatcher : OSCMessageAndArgsSizeDispatcher {

	value {|msg, time, addr, recvPort|
		var pattern;
		pattern = msg[0];
		active.keysValuesDo({|key, func|
			if(pattern.matchOSCAddressPattern(key), {func.value(msg, time, addr, recvPort);});
		})
	}

	typeKey { ^('OSC inverse pattern').asSymbol }

}
