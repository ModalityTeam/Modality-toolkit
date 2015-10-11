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


g = MKtl(\mini1, "minibee1");
// update with the address seen in OSCMonitor or OSCFunc.trace:
g.mktlDevice.updateSrcAddr("192.168.100.105", 54615);

g.trace;
g.trace(false);
*/

(
deviceName: "minibee1",
protocol: \osc,
deviceType: \gyroPlus,
elementTypes: [\accelerometer],
status: (
	linux: "unknown",
	osx: "tested and working, subset of sensors only.",
	win: "unknown"),

netAddrInfo: ( srcPort: 12345, ipAddress: "1.2.3.4", recvPort: 57120 ),
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

collectives: (
	accel: (
		oscPath: '/minibee/data',
		argTemplate: [ 1 ],
		elements: [ [\accel, \x], [\accel, \y], [\accel, \z]],
		ioType: \in
	)
),
description: (
	\accel: (
		\x: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
		\y: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
		\z: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' )
	)
)
)

