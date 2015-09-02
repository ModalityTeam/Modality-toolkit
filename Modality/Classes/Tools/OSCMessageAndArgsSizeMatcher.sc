OSCMessageAndArgsSizeDispatcher : OSCMessageDispatcher {

	wrapFunc {|funcProxy|
		var func, srcID, recvPort, argTemplate;
		func = funcProxy.func;
		srcID = funcProxy.srcID;
		recvPort = funcProxy.recvPort;
		argTemplate = funcProxy.argTemplate;
		// "wrapping function".postln;
		if(argTemplate.notNil, { func = OSCArgsAndSizeMatcher(argTemplate, func)});
		^case(
			{ srcID.notNil && recvPort.notNil }, { OSCFuncBothMessageMatcher(srcID, recvPort, func) },
			{ srcID.notNil }, { OSCFuncAddrMessageMatcher(srcID, func) },
			{ recvPort.notNil }, { OSCFuncRecvPortMessageMatcher(recvPort, func) },
			{ func }
		);
	}

	typeKey { ^('OSC matched size').asSymbol }

}

OSCArgsAndSizeMatcher : AbstractMessageMatcher {
	var argTemplate;

	*new{|argTemplate, func| ^super.new.init(argTemplate, func) }

	init {|argArgTemplate, argFunc| argTemplate = argArgTemplate.asArray; func = argFunc; }

	value {|testMsg, time, addr, recvPort|
		if ( (testMsg.size - 1) < argTemplate.size, { ^this } ); // check that the size is right
		testMsg[1..].do({|item, i|
			if(argTemplate[i].matchItem(item).not, { ^this } );
		});
		func.value(testMsg, time, addr, recvPort)
	}
}
