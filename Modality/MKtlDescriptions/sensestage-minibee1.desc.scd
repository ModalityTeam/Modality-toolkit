// sensestage minibee

/*
o = OSCMonitor.new;
o.enable;
// which sending addresses?
o.anaDict.msgNamesByAddr.keys.postcs
// which msgNames from where?
o.anaDict.msgNamesByAddr
// the last n messages from all addresses
o.anaDict.messagesByAddr
o.disable:

// example for making two minibees and distinguishing them by
// ```argTemplate``` only.
// this assumes they send data from the same hive app, i.e sharing a netaddr.

(
// ~beeAddr = NetAddr("192.168.100.105", 54615);
// port nil will listen to messages from all sending ports.
~beeAddr = NetAddr("192.168.100.105", nil);
~bee1 = MKtl(\bee1, "*minibee1");
// update with the address as seen in OSCMonitor or OSCFunc.trace:
~bee1.device.updateSrcAddr(~beeAddr.hostname);

~bee2 = MKtl(\bee2, "*minibee1", false);
// update with the address as seen in OSCMonitor or OSCFunc.trace:
~bee2.device.updateSrcAddr(~beeAddr.hostname);
~bee2.device.source;

// func for faking OSC message from a given NetAddr:
~fakeSendFrom = { |netaddr, msg, recvPort|
	recvPort = recvPort ?? NetAddr.langPort;
	thisProcess.recvOSCmessage(nil, netaddr, recvPort, msg);
};
)

OSCFunc.trace;
~fakeSendFrom.(~beeAddr, ['/minibee/data', 1, 1, 2, 3]);
OSCFunc.trace(false);

~bee1.trace; ~bee2.trace;
// now both bees match
~fakeSendFrom.(~beeAddr, ['/minibee/data', 1, 1, 2, 3]);

// lookup argTemplate ...
~bee1.device.oscFuncDictionary[\data].argTemplate;
// ... and update argTemplate for ~bee2 to number 2:
~bee2.device.oscFuncDictionary[\data].argTemplate.put(0, 2);

// this fake-sends from minibee1 instance 1 (argTemplate 1)
~fakeSendFrom.(~beeAddr, ['/minibee/data', 1, 1, 2, 3]);
// posts: MKtl('bee1') osc accel > [ 0.667, 0.833, 1 ] | type: nil

~fakeSendFrom.(~beeAddr, ['/minibee/data', 2, 1, 2, 3]);
// posts: MKtl('bee2') osc accel > [ 0.667, 0.833, 1 ] | type: nil

// test different argTemplate value - no post
~fakeSendFrom.(~beeAddr, ['/minibee/data', 42, 1, 2, 3]);
// from different address, also no post
~fakeSendFrom.(NetAddr.localAddr, ['/minibee/data', 1, 1, 2, 3]);


// test groupAction - to the collective \data:
~datagrp = ~bee1.collAt(\data);
~datagrp.groupAction = { |grp| [grp.name, grp.value].postln };
~datagrp.doGroupAction;
~datagrp.deviceValueAction_([3,2,1]);
~fakeSendFrom.(~beeAddr, ['/minibee/data', 1, -2, 0, 2]);

*/

(
deviceName: "minibee1",
protocol: \osc,
deviceType: \minibee,
elementTypes: [\accelerometer],
status: (
	linux: "unknown",
	osx: "tested and working, subset of sensors only.",
	win: "unknown"),

netAddrInfo: ( srcPort: nil, ipAddress: "127.0.0.1", recvPort: 57120 ),
idInfo: "minibee1",

specs: (
	gyroAxis: [-3, 3],
	accelAxis: [-3, 3]),

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	// hasScribble: false
),

deviceIOGroups: (
	data: (
		oscPath: '/minibee/data',
		argTemplate: [ 1 ],
		elements: [ [\accel, \x], [\accel, \y], [\accel, \z]],
		ioType: \in
	)
),
elementsDesc: (
	groupName: \accel,
	sharedProperties: (elementType: 'accelAxis', elementType: \accelerationAxis, ioType: \collectiveIn, \spec: 'accelAxis' ),
	elements: [\x, \y, \z ].collect { |key, i|
		key -> ()
	};
)
)

