// // minibee generic

/*
o = OSCMonitor.new;
o.enable;
// which sending addresses?
o.anaDict.msgNamesByAddr.keys.postcs
// which msgNames from where?
o.anaDict.msgNamesByAddr
// the last n messages from all addresses
o.anaDict.messagesByAddr

// or rawer:
OSCFunc.trace;
OSCFunc.trace(false);


g = MKtl(\mini2xp, "*minibee2-xpee");
// update with the address seen in OSCMonitor or OSCFunc.trace:
g.mktlDevice.updateSrcAddr("192.168.100.105", 40474);

g.trace;
g.trace(false);
*/

(
deviceName: "minibee2-xpee",
protocol: \osc,
deviceType: \gyroPlus,
elementTypes: [\accelerometer],
status: (
	linux: "unknown",
	osx: "tested and working, subset of sensors only.",
	win: "unknown"),

idInfo: ( srcPort: 12345, ipAddress: "1.2.3.4", recvPort: 57120 ),

specs: (
	ins: [0, 1],
	accelAxis: [-3, 3]),

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	// hasScribble: false
),

collectives: (
	data: (
		oscPath: '/minibee/data',
		argTemplate: [ 2 ],
		elements: [ [\in, 0], [\in, 1], [\in, 2], [\in, 3], [\accel, \x], [\accel, \y], [\accel, \z]],
		ioType: \in
	)
),
description: (
	\accel: (
		\x: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
		\y: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
		\z: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' )
	),
	\in: 4.collect{|i|
		(type: 'bender', ioType: \collectiveIn, \spec: 'ins' )
	}


)
)

