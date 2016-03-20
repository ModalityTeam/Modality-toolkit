// // gyrosc iphone/ipad app
// has lots of movement sensors:
// gyro, accel, comp, matrix, rrate, quat, grav, mag, gps
// implemented as example: gyro and accel,
// others can be added later as needed.

/* todo:
* add others movement sensors
*
*/

// for using gyrosc nametag ID concept, see note below.

/*
************* In gyrosc app: ************

// * enter your wifi address, and SC port:
NetAddr.langPort;

// * set nametag to blank!
// -> nametags require renaming the oscpaths
// - example to be made.

// * turn on the controls you want to use.
(only accel and gyro supported here so far)


// * now in SC, check whether OSC messages arrive:
OSCFunc.trace;
OSCFunc.trace(false);


// * analyse incoming date with OSCMon for convenience:
o = OSCMon.new;
o.enable;
o.show;

// which sending addresses?
o.anaDict.msgNamesByAddr.keys.postcs
// which msgNames from where?
o.anaDict.msgNamesByAddr

// the last n messages from all addresses
o.anaDict.messagesByAddr.postcs
o.disable;


// when you are sure you get proper osc data, make an MKtl:

g = MKtl(\gyr, "gyrosc*");
g.gui;
g.trace;
// update with the address seen in OSCMon or OSCFunc.trace:
g.device.updateSrcAddr("192.168.178.53", 60329);




// without a device, fake gyrosc sending from SC itself:
OSCFunc.trace;

n = NetAddr("192.168.178.51", 57120);
n.sendMsg('/gyrosc/gyro', 0.1, 0.2, 0.3);
n.sendMsg('/gyrosc/button', 1, 2.rand, 0.3);

Tdef(\gyrtest, {
	inf.do {
// n.sendMsg('/gyrosc/gyro', 1.0.rand2, 1.0.rand2, 1.0.rand2);
// n.sendMsg('/gyrosc/accel', 1.0.rand2, 1.0.rand2, 1.0.rand2);
		if (0.05.coin) { n.sendMsg('/gyrosc/button', 9.rand, 2.rand); };
		0.1.wait;
	};
}).play;

OSCFunc.trace(false);


// now see if MKtl listens:
g.free; g = MKtl(\gyr, "gyrosc*");
g.gui.parent.alwaysOnTop_(true); g.trace;
// set to this computer's ip address and SC's langPort
g.device.updateSrcAddr("192.168.178.51", 57120);

g.trace(false);
*/

(
deviceName: "gyrosc",
protocol: \osc,
deviceType: \phoneApp,
elementTypes: [\imu, \accelerometer],
status: (
	linux: "unknown",
	osx: "tested from SC only, working. 2016-03-20, adc."
	" subset of sensors only, not receiving OSC from app",
	win: "unknown"),

idInfo: "gyrosc",
netAddrInfo: ( srcPort: 12345, recvPort: 57120 ),

//	gps: lat, long, alt, course, speed, time
//	ipport: ip, port
// receiving: /reorient, /vibrate

specs: (
	gyroAxis: [-pi, pi],
	accelAxis: [-3, 3],
	compass: [0, 360],
	rotMatAxis: \bipolar,
	rotRateAxis:  [-3, 3],
	quaternionAxis: \bipolar,
	gravityAxis:  \bipolar,
	magFieldAxis: [-50, 50],
),

deviceInfo: (
	vendorURI: "http://www.bitshapesoftware.com/instruments/gyrosc/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	longName: "Bit Shape GyrOSC"	
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
	),
	// similar for comp, matrix, rrate, quat, grav, mag, gps
),
	// actually about 7 more messages possible.
	// replace wildcard later with nameTag as set in iphone used.
elementsDesc: (
	elements: [
		(
			key: \accel,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'accelAxis' ),
			elements: [
				(key: \x),
				(key: \y ),
				(key: \z )
			],
		),
		(
			key: \gyro,
			shared: (elementType: 'gyroAxis', ioType: \collectiveIn, \spec: 'gyroAxis' ),
			elements: [
				(key: \pitch),
				(key: \roll),
				(key: \yaw),
			]
		),
		// similar for comp, matrix, rrate, quat, grav, mag, gps

		// buttons (not working yet)
		(
			key: 'bt',
			shared: (
				oscPath: '/gyrosc/button',
				type: 'button',
				ioType: \in,
				spec: \hidBut
			),
			elements: [
				( argTemplate: [ 0 ] ),
				( argTemplate: [ 1 ] ),
				( argTemplate: [ 2 ] ),
				( argTemplate: [ 3 ], mode: \toggle ),
				( argTemplate: [ 4 ], mode: \toggle ),
				( argTemplate: [ 5 ], mode: \toggle ),
				( argTemplate: [ 6 ] ),
				( argTemplate: [ 7 ] ),
				( argTemplate: [ 8 ] )
			]
		)

	]
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
