// // gyrosc iphone/ipad app
// has lots of movement sensors:
// gyro, accel, comp, matrix, rrate, quat, grav, mag, gps
// implemented as example: gyro and accel,
// others can be added later as needed.

// for using gyrosc nametag ID concept, see note below.

/*
o = OSCMonitor.new;
o.enable;
// which sending addresses?
o.anaDict.msgNamesByAddr.keys.postcs
// which msgNames from where?
o.anaDict.msgNamesByAddr
// the last n messages from all addresses
o.anaDict.messagesByAddr.postcs
o.disable;

// or rawer:
OSCFunc.trace;
OSCFunc.trace(false);


g = MKtl(\gyr, "gyrosc*");
// update with the address seen in OSCMonitor or OSCFunc.trace:
g.mktlDevice.updateSrcAddr("192.168.178.53", 60329);

g.trace;
g.trace(false);
[ /gyrosc/ipport, 192.168.178.53, 6449 ]
*/

(
deviceName: "gyrosc",
protocol: \osc,
deviceType: \phoneApp,
elementTypes: [\imu, \accelerometer],
status: (
	linux: "unknown",
	osx: "tested and working, subset of sensors only.",
	win: "unknown"),

idInfo: ( srcPort: 12345, ipAddress: "1.2.3.4", recvPort: 57120 ),

specs: (
	gyroAxis: [-3, 3],
	accelAxis: [-3, 3]
),

deviceInfo: (
	vendorURI: "http://www.bitshapesoftware.com/instruments/gyrosc/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	// hasScribble: false
),

collectives: (
	gyro: (
		oscPath: '/gyrosc/gyro',
		elements: [[\gyro, \pitch], [\gyro, \roll], [\gyro, \yaw]],
		ioType: \in
	),
	accel: (
		oscPath: '/gyrosc/accel',
		elements: [ [\accel, \x], [\accel, \y], [\accel, \z]],
		ioType: \in
	)
	// similar for comp, matrix, rrate, quat, grav, mag, gps
),
	// actually about 7 more messages possible.
	// replace wildcard later with nameTag as set in iphone used.
description: (
	\accel: (
		\x: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
		\y: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
		\z: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' )
	),
	\gyro: (
		\pitch: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'gyroAxis' ),
		\roll: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'gyroAxis' ),
		\yaw: (type: 'accelAxis', ioType: \collectiveIn, \spec: 'gyroAxis' )
	)
	// similar for comp, matrix, rrate, quat, grav, mag, gps
)
)

///////////////
// gyrosc provision for nametagging is tricky to integrate in MKtl / OSC:
// gyrosc identifies the phone it runs on by replacing an asterisk
// in all control element message names, so that:
// // 'gyrosc/*/gyro' becomes e.g. 'gyrosc/mytag/gyro'
//
// This would require modifying the desc by replacing the '*' in all oscpaths,
// or creating custom inverse matching responders that match for the
// inserted nametag inside the response func.
// To be done later if really needed.
